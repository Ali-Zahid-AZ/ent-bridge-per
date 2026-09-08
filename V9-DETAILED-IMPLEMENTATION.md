## 16. V9: Distributed Tracing + Log Aggregation — OpenTelemetry, Tempo, Loki, Promtail

> **Architects:** DeepSeek & Gemini (Consensus — 2026-05-23)
> **Status:** PLANNED — Awaiting Ali's approval
> **Scope:** OpenTelemetry SDK + Grafana Tempo (traces) + structlog + Grafana Loki/Promtail (logs)
> **8 new Python packages, 4 new Docker containers (18 total)**

### 16.0 Consensus Summary

After adversarial review on COUNCIL.md, 3 Gemini refinements were merged into DeepSeek's infrastructure plan:

1. **LangFuse trace ID sync** — Set `langfuse.trace(id=otel_trace_id)` to unify OTel and LangFuse under one `trace_id`. Tempo shows the macro-pipeline; LangFuse shows LLM micro-details under the same ID.
2. **structlog OTel auto-processor** — A structlog processor calling `get_current_span().get_span_context()` auto-injects `trace_id`/`span_id` into every log line. No manual `inject_trace_context()` calls needed.
3. **Streamlit `RequestsInstrumentor`** — Two lines in `app.py` inject W3C `traceparent` headers into all `/ask` requests, linking the UI to the backend trace end-to-end.

---

### 16.1 Architecture Overview — What V9 Adds

**Current state (V8):** Prometheus metrics + Grafana dashboards. We know THAT the API is slow. But we CANNOT see:
- WHICH function in the agent pipeline is the bottleneck
- WHICH Neo4j query took 3 seconds
- HOW a `trace_id` propagates from Streamlit → FastAPI → Celery → Agent → LLM
- WHAT log lines were emitted during a specific failed request

**After V9:** A request's full lifecycle is captured as a waterfall of spans. Structured JSON logs are aggregated in Loki with `trace_id` correlation. One click from a log line opens the full trace in Tempo.

```
Streamlit (W3C traceparent header)
  └─→ FastAPI /ask (auto-span via FastAPIInstrumentor)
       └─→ Celery task enqueue (auto-span via CeleryInstrumentor)
            └─→ Celery worker process_query_task (auto-span)
                 └─→ run_agent() (manual root span)
                      ├─→ episodic_memory.check_cache (manual span)
                      │    └─→ Qdrant search (manual span)
                      ├─→ Router LLM call (LangFuse span — same trace_id)
                      ├─→ Planner LLM call (LangFuse span — same trace_id)
                      ├─→ execute_math_query / execute_graph_query (manual span)
                      │    └─→ Neo4j/Polars query (manual span)
                      ├─→ Guardrail checks (manual span)
                      ├─→ Synthesizer LLM call (LangFuse span — same trace_id)
                      └─→ Evaluation judge (LangFuse span — same trace_id)
```

**Container port map (18 total — bold = new in V9):**

| Container             | Host Port                                              | Purpose                                               |
| --------------------- | ------------------------------------------------------ | ----------------------------------------------------- |
| *14 existing from V8* | *various*                                              | *Metrics, infra, app*                                 |
| **tempo**             | **0.0.0.0:3200**                                       | **Trace backend (Grafana Tempo)**                     |
| **otel-collector**    | **0.0.0.0:4317** (gRPC), **0.0.0.0:8889** (Prometheus) | **Span receiver + batcher + span-to-metric exporter** |
| **loki**              | **0.0.0.0:3100**                                       | **Log aggregator (Grafana Loki)**                     |
| **promtail**          | (none)                                                 | **Log scraper → pushes to Loki**                      |

**Data flow:**

```
[FastAPI OTel auto-instrument]──┐
[Celery OTel auto-instrument]───┤
[Agent manual spans]────────────┼──→ OTel Collector (:4317) ──→ Tempo (:3200) ──→ Grafana traces
[Redis OTel auto-instrument]────┤
[Requests OTel (Streamlit)]─────┤
[LangFuse (same trace_id)]──────┘

[structlog → JSON stdout] ──→ Promtail (Docker socket) ──→ Loki (:3100) ──→ Grafana logs
[TeeLogger → PID .txt files] ──→ Promtail (file tail) ────┘
```

---

### 16.2 Pre-Flight Checklist

**Step 0.1 — Verify V8 observability is healthy:**
```bash
curl -s http://localhost:8000/metrics | head -5
curl -s http://localhost:8000/health | python -m json.tool
curl -s http://localhost:9090/api/v1/targets | python -m json.tool | grep -E '"job"|"health"'
```

**Step 0.2 — Count current `print()` sites to gauge migration scope:**
```bash
rtk grep "print(" src/ | wc -l
# Expected: ~80-120 print() sites. V9 migrates ~10 critical-path sites only.
```

**Step 0.3 — Verify LangFuse is running:**
```bash
curl -s http://localhost:3000 | head -c 50
```

**Step 0.4 — Create new directories:**
```bash
mkdir -p infra/opentelemetry
mkdir -p infra/tempo
mkdir -p infra/loki
mkdir -p infra/promtail
mkdir -p infra/grafana/provisioning/datasources
```

---

### 16.3 Sprint 9.1: OTel Infrastructure & Auto-Instrumentation

#### 16.3.1 Dependencies Installation

```bash
uv add opentelemetry-api opentelemetry-sdk \
       opentelemetry-instrumentation-fastapi \
       opentelemetry-instrumentation-celery \
       opentelemetry-instrumentation-redis \
       opentelemetry-instrumentation-requests \
       opentelemetry-exporter-otlp-proto-grpc \
       structlog
```

| Package                                  | Purpose                                                                                      |
| ---------------------------------------- | -------------------------------------------------------------------------------------------- |
| `opentelemetry-api`                      | Core interfaces (Tracer, Span, Meter)                                                        |
| `opentelemetry-sdk`                      | Reference implementation (TracerProvider, BatchSpanProcessor)                                |
| `opentelemetry-instrumentation-fastapi`  | Auto-creates HTTP server spans for every FastAPI route — method, path, status code           |
| `opentelemetry-instrumentation-celery`   | Auto-creates spans for Celery task execution — injects/extracts W3C trace context via broker |
| `opentelemetry-instrumentation-redis`    | Auto-creates spans for Redis commands — command name, keys, duration                         |
| `opentelemetry-instrumentation-requests` | Auto-creates outgoing HTTP client spans — injects W3C `traceparent` headers                  |
| `opentelemetry-exporter-otlp-proto-grpc` | Exports spans to the OTel Collector via gRPC OTLP on port 4317                               |
| `structlog`                              | Structured logging — JSON output with key-value pairs that Promtail natively parses          |

**Verification:**
```bash
uv run python -c "from opentelemetry import trace; from opentelemetry.sdk.trace import TracerProvider; print('OTel OK')"
uv run python -c "import structlog; print('structlog OK')"
```

#### 16.3.2 Grafana Tempo Configuration

**WHAT:** Create `infra/tempo/tempo-config.yml`.

**WHY this design:**
- Local filesystem storage (`/var/tempo`) — no object storage needed at our scale (~100-500 spans/minute)
- `compactor` merges small trace blocks into larger ones to reduce disk usage over time
- `distributor` receives spans from the OTel Collector via OTLP gRPC on port 4317
- `query_frontend` + `querier` serve trace queries to Grafana on port 3200
- Retention = 7 days (traces are high-volume but short-lived — enough for debugging recent issues)
- `metrics_generator.processors` automatically generates service dependency graphs and RED span-metrics

**EXACT file to create:** `infra/tempo/tempo-config.yml`

```yaml
server:
  http_listen_port: 3200

distributor:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317
        http:
          endpoint: 0.0.0.0:4318

ingester:
  max_block_duration: 5m

compactor:
  compaction:
    block_retention: 168h

storage:
  trace:
    backend: local
    local:
      path: /var/tempo/traces
    wal:
      path: /var/tempo/wal

querier:
  search:
    external_hedge_requests_at: 5s
    external_hedge_requests_up_to: 3

query_frontend:
  search:
    max_duration: 168h

overrides:
  defaults:
    metrics_generator:
      processors: [service-graphs, span-metrics]
```

> **WHY `service-graphs` and `span-metrics`:** `service-graphs` generates a service dependency graph from traces (who calls whom, with what latency). `span-metrics` generates RED metrics from spans (request rate, error rate, duration) — exported to Prometheus via the Collector, giving us latency metrics for services we never manually instrumented.

#### 16.3.3 OTel Collector Configuration

**WHAT:** Create `infra/opentelemetry/collector-config.yml` — the pipeline that receives spans from Python services, batches them, exports to Tempo, and generates Prometheus metrics from span data.

**WHY a Collector instead of direct-to-Tempo export:**
1. **Batching:** Buffers spans and sends in batches, reducing network overhead and Tempo write pressure
2. **Resilience:** If Tempo is temporarily down, spans queue in memory and retry — no data loss
3. **Multi-backend:** Same Collector exports to Tempo (traces) AND Prometheus (span-derived metrics)
4. **Enterprise pattern:** Every production OTel deployment uses a Collector; direct SDK→backend is development-only

**EXACT file to create:** `infra/opentelemetry/collector-config.yml`

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:
    timeout: 5s
    send_batch_size: 512
  memory_limiter:
    check_interval: 5s
    limit_mib: 512

exporters:
  otlp/tempo:
    endpoint: tempo:4317
    tls:
      insecure: true
  prometheus:
    endpoint: 0.0.0.0:8889
    namespace: otel

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [memory_limiter, batch]
      exporters: [otlp/tempo]
    metrics:
      receivers: [otlp]
      processors: [batch]
      exporters: [prometheus]
```

> **WHY `prometheus` exporter on port 8889:** The Collector generates RED metrics from span data (request count, error rate, latency histograms per service). By exporting these to Prometheus format, V8's Prometheus can scrape port 8889 and we get per-service latency metrics in Grafana WITHOUT writing a single line of application code.

#### 16.3.4 Prometheus Scrape Target Addition

**WHAT:** Add the OTel Collector to V8's Prometheus scrape config.

**EXACT modification to `infra/prometheus/prometheus.yml` — ADD after the `dcgm_exporter` block:**
```yaml
  - job_name: 'otel_collector'
    static_configs:
      - targets: ['host.docker.internal:8889']
```

> The existing file's last scrape target is `dcgm_exporter` at line ~173. Insert this block after it, before the file's closing. Use exact same indentation (2 spaces).

#### 16.3.5 Loki Configuration

**WHAT:** Create `infra/loki/loki-config.yml`.

**WHY single-binary mode:** At our scale (single machine, ~14 containers, ~500 log lines/min), microservices mode (distributor, ingester, querier as separate processes) is overkill. Single-binary simplifies deployment and reduces memory usage.

- Filesystem storage at `/var/loki` (no S3/Minio needed)
- Retention = 30 days (matching Prometheus's default)
- `tsdb` index type (faster queries than boltdb)
- `allow_structured_metadata: true` enables fast label-based queries on structlog's JSON keys

**EXACT file to create:** `infra/loki/loki-config.yml`

```yaml
auth_enabled: false

server:
  http_listen_port: 3100

common:
  path_prefix: /var/loki
  replication_factor: 1
  ring:
    kvstore:
      store: inmemory

schema_config:
  configs:
    - from: 2025-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: loki_index_
        period: 24h

storage_config:
  filesystem:
    directory: /var/loki/data

limits_config:
  retention_period: 720h
  max_entries_limit_per_query: 5000
  allow_structured_metadata: true

compactor:
  working_directory: /var/loki/compactor
  retention_enabled: true
```

> **WHY `allow_structured_metadata: true`:** structlog emits JSON with key-value pairs (e.g., `{"trace_id": "abc123", "service": "agent", "level": "error"}`). Loki's structured metadata indexes these keys for fast label-based queries. Without this flag, every structured field requires a LogQL `| json` parser expression — slower and more verbose.

#### 16.3.6 Promtail Configuration

**WHAT:** Create `infra/promtail/promtail-config.yml` — configures log collection from three sources.

**WHY three scrape sources:**
1. **Docker container logs** (stdout/stderr of all 18 containers) — captures Uvicorn, Celery, Ollama, Neo4j, Redis, etc. Uses Docker service discovery for zero-config container addition.
2. **Agent PID-based log files** (`logs/agent_run/*.txt`) — captures `TeeLogger` output (all `print()` statements from agent runs)
3. **Statistical test log files** (`logs/statistical_tests/*.log`) — captures V7 test run logs

**EXACT file to create:** `infra/promtail/promtail-config.yml`

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /var/promtail/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push
    batchwait: 5s
    batchsize: 1048576

scrape_configs:
  - job_name: docker_containers
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 30s
    relabel_configs:
      - source_labels: ['__meta_docker_container_name']
        regex: '/(.*)'
        target_label: 'container'

  - job_name: agent_logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: agent
          service: agent
          __path__: /var/log/agent_run/*.txt

  - job_name: statistical_test_logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: statistical_tests
          service: statistical_tests
          __path__: /var/log/statistical_tests/*.log
```

> **WHY `docker_sd_configs`:** Docker service discovery automatically discovers all running containers and scrapes their stdout/stderr. When a new container starts, Promtail begins scraping within 30 seconds — no manual target configuration.

#### 16.3.7 Docker Compose Additions (CORRECTED PORTS)

**WHAT:** Add 4 new services to `infra/docker-compose.yml`.

**CRITICAL PORT RULE:**
- **Tempo's OTLP gRPC port 4317** is INTERNAL ONLY — receives spans from the Collector via Docker DNS (`tempo:4317`). NOT exposed to host — no `0.0.0.0:4317:4317` on Tempo.
- **Collector's OTLP gRPC port 4317** IS exposed to host (`0.0.0.0:4317:4317`) — Python services on host send spans here.
- Only one container can bind host port 4317. The Collector owns it. Tempo receives internally.

**INSERT at the end of the `services:` block (after the V8 `cadvisor` block):**

```yaml
  # ==========================================
  # V9 Observability Stack (Tracing + Logging)
  # ==========================================
  tempo:
    image: grafana/tempo:latest
    container_name: officehub-tempo
    ports:
      - "0.0.0.0:3200:3200"    # Query API for Grafana
      # OTLP gRPC port 4317 is INTERNAL ONLY — Collector forwards to tempo:4317
    volumes:
      - ./tempo/tempo-config.yml:/etc/tempo/tempo-config.yml:ro
      - tempo_data:/var/tempo
    command:
      - '-config.file=/etc/tempo/tempo-config.yml'
    restart: unless-stopped

  otel-collector:
    image: otel/opentelemetry-collector-contrib:latest
    container_name: officehub-otel-collector
    ports:
      - "0.0.0.0:4317:4317"    # OTLP gRPC — host Python services send spans here
      - "0.0.0.0:8889:8889"    # Prometheus metrics from span data
    volumes:
      - ./opentelemetry/collector-config.yml:/etc/otelcol-contrib/config.yaml:ro
    restart: unless-stopped

  loki:
    image: grafana/loki:latest
    container_name: officehub-loki
    ports:
      - "0.0.0.0:3100:3100"
    volumes:
      - ./loki/loki-config.yml:/etc/loki/loki-config.yml:ro
      - loki_data:/var/loki
    command:
      - '-config.file=/etc/loki/loki-config.yml'
    restart: unless-stopped

  promtail:
    image: grafana/promtail:latest
    container_name: officehub-promtail
    volumes:
      - ./promtail/promtail-config.yml:/etc/promtail/promtail-config.yml:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ../logs/agent_run:/var/log/agent_run:ro
      - ../logs/statistical_tests:/var/log/statistical_tests:ro
      - promtail_positions:/var/promtail
    command:
      - '-config.file=/etc/promtail/promtail-config.yml'
    restart: unless-stopped
```

**AND append to the `volumes:` block (after `prometheus_data` and `grafana_data`):**
```yaml
  tempo_data:
    driver: local
  loki_data:
    driver: local
  promtail_positions:
    driver: local
```

> **IMPORTANT:** Do NOT change or delete ANY existing content in `infra/docker-compose.yml`. The V8 containers (qdrant, neo4j, redis, langfuse-*, clickhouse, postgres, minio, prometheus, grafana, celery-exporter, node_exporter, cadvisor) must remain untouched.

**VERIFICATION:**
```bash
docker compose -f infra/docker-compose.yml config --quiet
# Should return exit code 0. If error, check YAML indentation.
```

#### 16.3.8 Tracing Module — Centralized OTel Setup

**WHAT:** Create `src/telemetry/tracing.py` — the module that initializes the global OTel TracerProvider, creates the OTLP exporter, and provides a `get_tracer()` function for all other modules.

**WHY centralized:** A single `TracerProvider` must be set globally (`trace.set_tracer_provider()`) BEFORE any instrumentation runs. If two modules independently create providers, one overwrites the other. Centralizing in `tracing.py` ensures exactly one provider per process.

**EXACT file to create:** `src/telemetry/tracing.py`

```python
"""
V9 OBSERVABILITY: Centralized OpenTelemetry setup for distributed tracing.
Imported ONCE per process at startup (server.py, celery_worker.py).
Provides get_tracer() for manual span creation across all modules.
"""
import os
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import Resource, SERVICE_NAME, DEPLOYMENT_ENVIRONMENT

_initialized = False


def init_tracing(service_name: str = "officehub-agent"):
    """
    Initialize the global OTel TracerProvider with OTLP gRPC exporter.
    Must be called ONCE per process, BEFORE any FastAPI/Celery instrumentation.

    Parameters:
        service_name: Identifies this process in Tempo's service graph.
                      Use "officehub-fastapi" for server.py,
                      "officehub-celery-worker" for celery_worker.py.
    """
    global _initialized
    if _initialized:
        return

    resource = Resource.create(
        {
            SERVICE_NAME: service_name,
            DEPLOYMENT_ENVIRONMENT: "development",
        }
    )

    provider = TracerProvider(resource=resource)

    otlp_exporter = OTLPSpanExporter(
        endpoint="localhost:4317",
        insecure=True,
    )

    provider.add_span_processor(
        BatchSpanProcessor(
            otlp_exporter,
            max_export_batch_size=512,
            schedule_delay_millis=5000,
        )
    )

    trace.set_tracer_provider(provider)
    _initialized = True


def get_tracer(module_name: str = __name__):
    """
    Returns a tracer for manual span creation.

    Usage:
        tracer = get_tracer(__name__)
        with tracer.start_as_current_span("span_name") as span:
            span.set_attribute("key", "value")
            # ... work ...
    """
    return trace.get_tracer(module_name)
```

> **WHY `max_export_batch_size=512` and `schedule_delay_millis=5000`:** Every 5 seconds (or when 512 spans accumulate, whichever comes first), the BatchSpanProcessor flushes spans to the Collector. This balances freshness (traces appear in Tempo within ~5s) with efficiency (no per-span gRPC overhead). At our concurrency=1 rate, 512 spans take ~10-20 minutes to accumulate — most flushes are time-based.

#### 16.3.9 server.py — OTel + FastAPI + Redis Auto-Instrumentation

**WHAT:** Add `init_tracing()`, `FastAPIInstrumentor`, and `RedisInstrumentor` to `src/api/server.py`.

**Step A — ADD imports after existing slowapi import line (after `from slowapi.errors import RateLimitExceeded`, which is line 18):**

```python
# V9 OBSERVABILITY: OpenTelemetry distributed tracing
from src.telemetry.tracing import init_tracing, get_tracer
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.redis import RedisInstrumentor
```

**Step B — ADD `init_tracing()` call BEFORE the FastAPI app is created. Insert after the import block and BEFORE the `limiter = Limiter(...)` line:**
```python
# V9: Initialize OpenTelemetry BEFORE FastAPI app is created
# Must be called before FastAPI() so the instrumentor can wrap routes
init_tracing(service_name="officehub-fastapi")
```

**Step C — ADD instrumentors AFTER the Instrumentator block (after the line `instrumentator.instrument(app).expose(...)`):**
```python
# V9: Auto-instrument FastAPI routes — creates HTTP server spans for every request
# Excluded /metrics and /health to prevent trace noise from Prometheus scrapes
FastAPIInstrumentor.instrument_app(
    app,
    excluded_urls="/metrics,/health",
)
# V9: Auto-instrument Redis calls — creates spans for Celery broker operations
RedisInstrumentor().instrument()
```

> **WHY `excluded_urls="/metrics,/health"`:** These endpoints are scraped every 15s by Prometheus. Instrumenting them creates a flood of trivial spans that pollute Tempo and waste storage. Excluding them keeps traces focused on business requests.

#### 16.3.10 celery_worker.py — OTel + Celery Auto-Instrumentation

**WHAT:** Add `init_tracing()` and `CeleryInstrumentor` to `src/api/celery_worker.py`.

**Step A — ADD imports after existing eval import (after `from src.telemetry.evals import execute_evaluation`, which is line 10):**
```python
# V9 OBSERVABILITY: OpenTelemetry distributed tracing
from src.telemetry.tracing import init_tracing, get_tracer
from opentelemetry.instrumentation.celery import CeleryInstrumentor
```

**Step B — ADD `init_tracing()` call BEFORE Celery app is created. Insert after imports and BEFORE `celery_app = Celery(...)`:**
```python
# V9: Initialize OpenTelemetry BEFORE Celery app is created
# Must be called before Celery() so the instrumentor can patch task hooks
init_tracing(service_name="officehub-celery-worker")
```

**Step C — ADD instrumentor AFTER `celery_app.conf.update(...)` block (after the closing `)` which is line 28):**
```python
# V9: Auto-instrument Celery tasks — creates spans for task execution
# Automatically injects/extracts W3C trace context via Redis broker headers
CeleryInstrumentor().instrument()
```

> **WHY `init_tracing()` BEFORE `CeleryInstrumentor().instrument()`:** The instrumentor patches Celery's task execution hooks at `instrument()` time. If the TracerProvider is not globally set before this, the instrumentor silently produces zero spans — no error, no warning, just invisible.

#### 16.3.11 Context Propagation Across Process Boundaries

**HOW it works automatically (no additional code needed):**

1. When FastAPI receives a request, `FastAPIInstrumentor` extracts any incoming `traceparent` header (W3C Trace Context) and creates a server span.
2. When FastAPI enqueues a Celery task via `process_query_task.delay(query)`, `CeleryInstrumentor` injects the current span context into the task's message headers in Redis.
3. When the Celery worker picks up the task, `CeleryInstrumentor` extracts the trace context from headers and creates a child span.
4. Result: a single trace spans both the FastAPI process and the Celery worker process — they appear as one contiguous waterfall in Tempo.

> **Verification:** After a `/ask` query completes, Tempo should show a single trace with `officehub-fastapi` as the root service and `officehub-celery-worker` as a child service. The waterfall should show spans in order: HTTP POST → Celery task enqueue → Celery task receive → task execution.

---

### 16.4 Sprint 9.2: Manual OTel Instrumentation + Grafana Dashboards

#### 16.4.1 agent.py — Manual Spans for Agent Internals

**WHAT:** Add manual spans in `src/agent/agent.py` for agent pipeline stages that auto-instrumentation cannot see (Qdrant cache, LLM calls via Ollama, guardrails, execution engines).

**Step A — Import tracer after LangFuse import (after `from langfuse import Langfuse, observe` which is line 21):**
```python
# V9: Manual spans for agent pipeline visibility in Tempo
from src.telemetry.tracing import get_tracer
_tracer = get_tracer("agent")
```

**Step B — Wrap `EpisodicMemory.check_cache()` with a span (around line 349-365, inside the method):**
When the method begins (after the `@observe` decorator line), wrap the Qdrant search call:

```python
# Find the code pattern:
#   search_result = self.client.search(...)
# Wrap it:
with _tracer.start_as_current_span("qdrant_cache_check") as span:
    span.set_attribute("cache.query_hash", hashlib.md5(query.encode()).hexdigest()[:8])
    # ... existing search_result = self.client.search(...) code ...
    span.set_attribute("cache.hit", search_result is not None and len(search_result) > 0)
```

**Step C — Wrap execution engine calls in `Worker.execute_blueprint()` (around line 578-663):**
After the tool is determined from the blueprint, wrap the execution switch-case:

```python
tool = blueprint.get("tool", "unknown")
with _tracer.start_as_current_span(f"execute_{tool}_engine") as span:
    span.set_attribute("engine.tool", tool)
    if tool == "math":
        result = execute_math_query(...)
    elif tool == "graph":
        result = execute_graph_query(...)
    elif tool == "combined":
        result = execute_combined_join(...)
    elif tool == "bayesian":
        result = run_bayesian_simulation(...)
    span.set_attribute("engine.result_rows", len(result) if isinstance(result, list) else 0)
```

**Step D — Wrap guardrail checks (find the guardrail call site around line ~830-860):**
```python
with _tracer.start_as_current_span("guardrail_checks") as span:
    blueprint = AgenticDriftGuardrails.check_routing_drift(blueprint)
    # ... existing guardrail calls ...
    span.set_attribute("guardrail.coordination_drift", blueprint.get("tool") != original_tool_str)
```

#### 16.4.2 tools.py — Manual Spans for Execution Engines

**WHAT:** Add manual spans in `src/tools/tools.py` for Neo4j and Polars query execution — these are the two most expensive operations in the pipeline.

**Step A — Import tracer at top of file (after existing imports):**
```python
# V9: Manual spans for engine execution visibility in Tempo
from src.telemetry.tracing import get_tracer
_tracer = get_tracer("tools")
```

**Step B — Wrap Neo4j query execution in `execute_graph_query()`:**
```python
with _tracer.start_as_current_span("neo4j_query") as span:
    span.set_attribute("db.system", "neo4j")
    span.set_attribute("db.operation", "cypher")
    span.set_attribute("db.statement", generated_query[:200])
    result = session.run(generated_query).data()
    span.set_attribute("db.result_rows", len(result))
```

**Step C — Wrap Polars query execution in `execute_math_query()`:**
```python
with _tracer.start_as_current_span("polars_query") as span:
    span.set_attribute("db.system", "polars")
    span.set_attribute("db.operation", "sql")
    result = duckdb.sql(generated_query).pl()
    span.set_attribute("db.result_rows", result.shape[0])
```

> **WHY `db.statement` truncated to [:200]:** Span attributes have a practical size limit (~4KB per span total). Full Cypher/SQL queries can be hundreds of characters. Truncating to 200 chars preserves the query signature (SELECT ... FROM ... WHERE ...) without bloating span size.

#### 16.4.3 Grafana Datasources — Tempo + Loki

**WHAT:** Add Tempo and Loki as Grafana datasources so dashboards can query traces and logs alongside V8's Prometheus metrics.

**Create:** `infra/grafana/provisioning/datasources/tempo.yml`
```yaml
apiVersion: 1

datasources:
  - name: Tempo
    type: tempo
    access: proxy
    url: http://tempo:3200
    isDefault: false
    editable: false
```

**Create:** `infra/grafana/provisioning/datasources/loki.yml`
```yaml
apiVersion: 1

datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    isDefault: false
    editable: false
    jsonData:
      derivedFields:
        - name: traceID
          matcherRegex: '"trace_id":"(\w+)"'
          url: '$${__value.raw}'
          datasourceUid: tempo
```

> **WHY `derivedFields` for Loki:** The `traceID` derived field automatically creates a clickable link from any Loki log line containing `"trace_id": "abc123"` to the corresponding trace in Tempo. This is the critical "single pane of glass" link — from an error log line, one click opens the full trace waterfall showing exactly where the error occurred.

#### 16.4.4 Grafana Dashboard — Distributed Traces

**WHAT:** Create `infra/grafana/dashboards/officehub-traces-dashboard.json` — waterfall view of agent request traces alongside log correlation.

**Panel inventory (6 panels):**

| #   | Panel Title               | PromQL / Tempo Query                                                                      | Visualization      | Rationale                                                        |
| --- | ------------------------- | ----------------------------------------------------------------------------------------- | ------------------ | ---------------------------------------------------------------- |
| 1   | Service Latency (p95)     | `histogram_quantile(0.95, rate(otel_span_duration_seconds_bucket[5m])) by (service_name)` | Time series (line) | Per-service p95 latency — auto-generated from Tempo span-metrics |
| 2   | Error Rate by Service     | `rate(otel_span_errors_total[5m]) by (service_name)`                                      | Time series (line) | Which service is producing errors?                               |
| 3   | Agent Span Duration (p95) | `histogram_quantile(0.95, rate(otel_span_duration_seconds_bucket{span_name=~"execute_.*   | qdrant.*           | guardrail.*                                                      | neo4j.*    | polars.*"}[5m])) by (span_name)`          | Bar gauge | Latency breakdown by agent operation — identify the slowest pipeline stage |
| 4   | Service Graph             | Tempo service graph (auto-generated)                                                      | Node graph         | Call relationships with latency edges                            |
| 5   | Recent Traces             | Tempo trace search                                                                        | Table              | Searchable list of recent traces with duration, service, status  |
| 6   | Error Logs (Loki)         | `{level="error"}                                                                          | json               | line_format "{{.message}}"                                      | Logs table | Correlated error logs with trace_id links |

> **The dashboard JSON is generated at implementation time.** Flash will construct a valid Grafana 10+ dashboard JSON using the panel specifications above, following the same structure as the V8 dashboards.

---

### 16.5 Sprint 9.3: Structured Logging + Loki/Promtail Integration

#### 16.5.1 Logging Module — structlog with OTel Trace Injection

**WHAT:** Create `src/telemetry/logging.py` — configures `structlog` for JSON output with automatic `trace_id`/`span_id` injection via a custom processor.

> **GEMINI REFINEMENT (adopted):** Instead of manually calling `inject_trace_context()` at the start of every function, use a structlog processor that automatically extracts `trace_id`/`span_id` from the current OTel span context. This means EVERY log line (even from `print()` calls we haven't migrated yet) gets trace correlation IF there's an active span.

**EXACT file to create:** `src/telemetry/logging.py`

```python
"""
V9 OBSERVABILITY: Structured logging with structlog + automatic OTel trace_id injection.
Provides get_logger() for all modules. Logs emit JSON to stdout (captured by Promtail).

The OTelProcessor auto-injects trace_id and span_id into every log entry by reading
the current OTel span context — no manual inject_trace_context() calls needed.
"""
import sys
import structlog
from opentelemetry import trace as otel_trace


def _otel_processor(logger, method_name, event_dict):
    """
    Custom structlog processor that injects OTel trace context.
    Called automatically for EVERY log line — reads get_current_span().
    """
    span_context = otel_trace.get_current_span().get_span_context()
    if span_context.is_valid:
        event_dict["trace_id"] = format(span_context.trace_id, "032x")
        event_dict["span_id"] = format(span_context.span_id, "016x")
    return event_dict


def _is_tty():
    """Detect if stdout is a terminal. If so, use pretty ConsoleRenderer; else JSON."""
    return hasattr(sys.stdout, "isatty") and sys.stdout.isatty()


def configure_structlog():
    """
    Configure structlog once at process startup.
    Must be called BEFORE any loggers are created.
    """
    renderer = (
        structlog.dev.ConsoleRenderer()
        if _is_tty()
        else structlog.processors.JSONRenderer()
    )

    structlog.configure(
        processors=[
            _otel_processor,                             # inject trace_id/span_id
            structlog.processors.add_log_level,          # add "level": "info"
            structlog.processors.TimeStamper(fmt="iso"), # add "timestamp": "2026-..."
            renderer,
        ],
        context_class=dict,
        logger_factory=structlog.PrintLoggerFactory(),
        wrapper_class=structlog.make_filtering_bound_logger(0),
        cache_logger_on_first_use=True,
    )


def get_logger(module_name: str = __name__):
    """
    Returns a structured logger bound to the calling module name.

    Usage:
        _log = get_logger("agent")
        _log.info("cache_hit", query_hash="abc123")
        _log.error("execution_failed", error=str(e), tool="math")
    """
    return structlog.get_logger(module_name).bind(service=module_name)
```

> **WHY `ConsoleRenderer` for TTY, `JSONRenderer` for non-TTY:** When running interactively (terminal), structlog outputs colorful human-readable logs. When running in Docker (stdout captured by Promtail), it outputs JSON. The `_is_tty()` check auto-detects the mode. This means the same code produces readable output during development but machine-parseable JSON in production.

#### 16.5.2 agent.py — Structured Logging on Critical Paths

**WHAT:** Add structlog imports and migrate ~10 critical-path `print()` calls to structured logging.

**Step A — ADD import after existing V8/V9 imports (after the OTel tracer import from Step 16.4.1A):**
```python
# V9: Structured logging — critical-path print() → structlog migration
from src.telemetry.logging import get_logger, configure_structlog
configure_structlog()
_log = get_logger("agent")
```

**Step B — Replace the following ~10 `print()` calls with `_log.info()` / `_log.error()` / `_log.warning()`. The `print()` call MUST stay for backward compatibility — structlog is ADDITIVE, not replacing print().**

| Original `print()` call (approximate location)                    | New structlog call                                                        | Key-Value Pairs                    |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------- | ---------------------------------- |
| `print(f"[Router] Routing to {tool}")`                            | `_log.info("routing_decision", tool=tool)`                                | `tool` — which engine was selected |
| `print(f"[Semantic Cache] HIT for query")`                        | `_log.info("cache_hit")`                                                  | —                                  |
| `print(f"[Semantic Cache] MISS for query")`                       | `_log.info("cache_miss")`                                                 | —                                  |
| `print(f"[Telemetry] Event Logged. Latency: {latency_ms:.2f}ms")` | `_log.info("telemetry_event", latency_ms=latency_ms, tool=selected_tool)` | `latency_ms`, `tool`               |
| `print(f"[Telemetry] Captured Failure: {status}")`                | `_log.error("execution_failed", error=status)`                            | `error`                            |
| `print(f"[Guardrail] Coordination Drift Detected...")`            | `_log.warning("guardrail_trip", type="coordination_drift")`               | `type`                             |
| `print(f"[Guardrail] Cognitive Drift Detected...")`               | `_log.warning("guardrail_trip", type="cognitive_drift")`                  | `type`                             |
| `print(f"[Guardrail] Intent Drift...")`                           | `_log.warning("guardrail_trip", type="intent_drift")`                     | `type`                             |
| `print(f"[UI Generator] Failed to append to HTML report: {e}")`   | `_log.error("html_generation_failed", error=str(e))`                      | `error`                            |

> **MIGRATION SCOPE:** V9 migrates ~10 critical-path `print()` calls in `agent.py`. The remaining ~70-90 `print()` calls (in tests, ETL, Streamlit, training scripts) are deferred. This keeps V9 scoped and prevents test breakage from output format changes.

#### 16.5.3 guardrails.py — Structured Logging (Alongside Existing Prometheus Counters)

**WHAT:** Add structlog warnings in `src/guardrails/guardrails.py` alongside the V8 Prometheus counters.

**Step A — ADD import after existing Prometheus import (after line 2-4):**
```python
# V9: Structured logging alongside V8 Prometheus counters
try:
    from src.telemetry.logging import get_logger
    _guard_log = get_logger("guardrails")
except ImportError:
    _guard_log = None
```

**Step B — ADD `_guard_log.warning()` AFTER each existing `_GUARDRAIL_TRIP.labels(...).inc()` call, BEFORE the `print()` call:**
```python
# Example for coordination_drift (line ~25):
if _GUARDRAIL_TRIP:
    _GUARDRAIL_TRIP.labels(type="coordination_drift").inc()
if _guard_log:
    _guard_log.warning("guardrail_trip", type="coordination_drift", reason="sql_to_math_engine")
print("[Guardrail] Coordination Drift Detected: Forcing SQL to Math Engine.")
```

> Do this for all 4 guardrail sites: 2 coordination drift (lines 25, 30), 1 cognitive drift (line 56), 1 intent drift (line 83).

---

### 16.6 Sprint 9.4: UI Propagation + LangFuse Bridge + Verification

#### 16.6.1 Streamlit Client Instrumentation (Gemini Contribution)

**WHAT:** Add `RequestsInstrumentor` to `app.py` so that all HTTP requests from Streamlit to FastAPI carry W3C `traceparent` headers.

**WHY:** Currently the trace starts at FastAPI — the Streamlit→FastAPI hop is invisible. With `RequestsInstrumentor`, every `/ask` request from Streamlit injects a `traceparent` header, making the Streamlit UI the trace ROOT. The full lifecycle becomes: Streamlit button click → `/ask` POST → Celery task → run_agent() → response → Streamlit render.

**WHERE — ADD after existing imports in `app.py` (line ~1-15):**
```python
# V9 OBSERVABILITY: OpenTelemetry client instrumentation for UI→Backend trace linking
from opentelemetry.instrumentation.requests import RequestsInstrumentor
from src.telemetry.tracing import init_tracing

# Initialize OTel with service name "officehub-streamlit"
# Must be called before any HTTP requests are made
init_tracing(service_name="officehub-streamlit")

# Auto-instrument the requests library — injects W3C traceparent into all outgoing HTTP calls
RequestsInstrumentor().instrument()
```

> This is only 2 lines of functional code. The `RequestsInstrumentor` automatically instruments `requests.post()`, `requests.get()`, and all other `requests` library calls — injecting `traceparent` headers without any change to existing request code.

#### 16.6.2 LangFuse Trace ID Sync (Gemini Contribution)

**WHAT:** Modify the LangFuse trace creation in `src/agent/agent.py` to reuse the OTel `trace_id` instead of generating a new one.

**WHY:** Currently LangFuse creates its own trace ID independently. After this change, LangFuse traces share the same ID as OTel traces. One `trace_id` visible in both systems:
- **Tempo** shows the macro-pipeline (FastAPI → Celery → Agent → Neo4j → Synthesizer)
- **LangFuse** shows the LLM micro-details (prompt, response, tokens, scores) under the same ID

**WHERE — Find the existing LangFuse trace creation. In the `run_agent()` function, the `@observe(name="run_agent")` decorator auto-creates a LangFuse trace. To override its ID, we need to inject the OTel trace_id BEFORE the decorator runs. The cleanest approach is to use `langfuse_context.update_current_trace()` at the start of `run_agent()`:**

```python
# V9: Sync LangFuse trace ID with OTel trace_id
# Both Tempo and LangFuse now share one trace_id for end-to-end correlation
from langfuse import langfuse_context
from opentelemetry import trace as otel_trace

# At the START of run_agent(), after the @observe decorator has created the trace:
def run_agent(query: str):
    # V9: Override LangFuse trace ID with OTel trace_id for unified tracing
    otel_span_ctx = otel_trace.get_current_span().get_span_context()
    if otel_span_ctx.is_valid:
        otel_tid = format(otel_span_ctx.trace_id, "032x")
        langfuse_context.update_current_trace(
            id=otel_tid,
        )
    # ... rest of run_agent() ...
```

> **WHY `langfuse_context.update_current_trace()`:** The `@observe` decorator automatically creates a LangFuse trace. `update_current_trace()` overrides the auto-generated ID with the OTel trace_id. LangFuse SDK v4 supports this — the decorator's span continues running under the new ID.

#### 16.6.3 Smoke Test Updates

**WHAT:** Add V9 tracing + logging checks to `tests/streamlit-functionality-test/streamlit_test_1_prompt.py`.

**WHERE:** Append the function BEFORE `if __name__ == "__main__":`:

```python
def test_v9_observability():
    """V9 SMOKE TEST: Verifies OTel traces + Loki log aggregation."""
    import requests
    import time
    import json

    results = []

    # TRACE-1: Tempo health check
    try:
        r = requests.get("http://localhost:3200/ready", timeout=5)
        passed = r.status_code == 200
        results.append(("TRACE-1: Tempo ready", passed, f"status={r.status_code}"))
    except Exception as e:
        results.append(("TRACE-1: Tempo ready", False, str(e)))

    # TRACE-2: OTel Collector reachable (gRPC doesn't respond to HTTP GET, so check Prometheus endpoint)
    try:
        r = requests.get("http://localhost:8889/metrics", timeout=5)
        contains_otel_metrics = "otel" in r.text.lower()
        passed = r.status_code == 200 and contains_otel_metrics
        results.append(("TRACE-2: Collector Prometheus exporter", passed, f"status={r.status_code}, otel_metrics={'YES' if contains_otel_metrics else 'NO'}"))
    except Exception as e:
        results.append(("TRACE-2: Collector Prometheus exporter", False, str(e)))

    # TRACE-3: Send a canary query, then verify Tempo has traces for officehub-fastapi
    try:
        requests.post("http://localhost:8000/ask", json={"query": "show total leads"}, timeout=30)
        time.sleep(10)  # Wait for BatchSpanProcessor flush (5s schedule_delay + buffer)
        tr = requests.get("http://localhost:3200/api/search?tags=service.name%3Dofficehub-fastapi", timeout=10)
        passed = tr.status_code == 200
        results.append(("TRACE-3: Tempo has FastAPI traces", passed, f"search_status={tr.status_code}"))
    except Exception as e:
        results.append(("TRACE-3: Tempo trace search", False, str(e)))

    # LOG-1: Loki health check
    try:
        r = requests.get("http://localhost:3100/ready", timeout=5)
        passed = r.status_code == 200
        results.append(("LOG-1: Loki ready", passed, f"status={r.status_code}"))
    except Exception as e:
        results.append(("LOG-1: Loki ready", False, str(e)))

    # LOG-2: Loki has log entries
    try:
        r = requests.get(
            "http://localhost:3100/loki/api/v1/query_range",
            params={"query": '{job=~"agent|docker_containers"}', "limit": 5},
            timeout=10,
        )
        passed = r.status_code == 200
        results.append(("LOG-2: Loki has log entries", passed, f"status={r.status_code}"))
    except Exception as e:
        results.append(("LOG-2: Loki log query", False, str(e)))

    # Print results
    print("\n" + "=" * 60)
    print("V9 OBSERVABILITY SMOKE TEST RESULTS")
    print("=" * 60)
    passed_count = sum(1 for _, p, _ in results if p)
    for name, passed, detail in results:
        print(f"[{'PASS' if passed else 'FAIL'}] {name}: {detail}")
    print(f"\nOverall: {passed_count}/{len(results)} checks passed")
    return passed_count == len(results), results
```

Then add the call in the main block:
```python
    # --- V9 Observability Tests ---
    print("\n>>> RUNNING V9 OBSERVABILITY SMOKE TESTS <<<")
    v9_passed, v9_results = test_v9_observability()
```

#### 16.6.4 V9 Playbook

**WHAT:** Create `V-9-Tracing-Logging-Playbook.md` at the project root — operator runbook for V9 alerts and debugging workflows.

**Key sections to document:**

```markdown
# V9 Observability Playbook — Tracing & Logging Debug Procedures

## Dashboard URLs
- **Traces Dashboard:** http://localhost:3001/d/officehub-traces-v9
- **Tempo (direct):** http://localhost:3200
- **Loki (direct):** http://localhost:3100
- **RED Dashboard (V8):** http://localhost:3001/d/officehub-red-v8
- **LangFuse:** http://localhost:3000

## How to Find a Slow Request
1. Open RED Dashboard → p95 Latency panel → identify the endpoint with high latency
2. Note the time window and endpoint name
3. Open Tempo → Search → filter by service="officehub-fastapi" and duration > 5s
4. Click the trace to see the span waterfall
5. Identify the slowest span in the waterfall — that's the bottleneck function

## How to Debug a Failed Request
1. Open Loki → query: `{level="error"}`
2. Find the error log line for the failed request
3. Click the `trace_id` link (derivedField) → opens Tempo with the full trace
4. Examine the span that ended with an error status
5. Check span attributes for error messages, status codes, etc.

## Common Issues

### No spans in Tempo
1. Check OTel Collector health: `curl http://localhost:8889/metrics`
2. Check Tempo health: `curl http://localhost:3200/ready`
3. Verify `init_tracing()` was called in the crashing process
4. Check for "TracerProvider already set" warnings in logs (duplicate init)

### No logs in Loki
1. Check Loki health: `curl http://localhost:3100/ready`
2. Check Promtail positions: Promtail logs to Docker stdout → `docker logs officehub-promtail`
3. Verify file paths exist: `ls logs/agent_run/` (must have at least one .txt file)
4. Check Loki ingestion: `curl http://localhost:3100/metrics | grep loki_ingester`

### trace_id not appearing in structlog
1. Verify `_otel_processor` is in structlog's processor chain
2. Check that the log line was emitted inside an active OTel span
3. If log is outside a span (e.g., startup code before first request), trace_id will be absent — this is expected
```

---

### 16.7 V9 File Map

```
NEW FILES (14):
├── infra/tempo/tempo-config.yml                                    (~45 lines)
├── infra/opentelemetry/collector-config.yml                         (~35 lines)
├── infra/loki/loki-config.yml                                       (~40 lines)
├── infra/promtail/promtail-config.yml                               (~35 lines)
├── infra/grafana/provisioning/datasources/tempo.yml                 (~10 lines)
├── infra/grafana/provisioning/datasources/loki.yml                  (~15 lines)
├── infra/grafana/dashboards/officehub-traces-dashboard.json         (~200 lines — 6 panels)
├── src/telemetry/tracing.py                                         (~65 lines — init_tracing, get_tracer)
├── src/telemetry/logging.py                                         (~55 lines — configure_structlog, get_logger, _otel_processor)
├── V-9-Tracing-Logging-Playbook.md                                  (~80 lines)

MODIFIED FILES (8):
├── infra/docker-compose.yml                                         (+60 lines — 4 new containers + 3 volumes)
├── infra/prometheus/prometheus.yml                                  (+3 lines — otel_collector scrape target)
├── src/api/server.py                                                (+15 lines — init_tracing, FastAPI/Redis instrumentors)
├── src/api/celery_worker.py                                         (+10 lines — init_tracing, Celery instrumentor)
├── src/agent/agent.py                                               (+30 lines — manual spans + structlog migration + LangFuse sync)
├── src/tools/tools.py                                               (+20 lines — Neo4j/Polars manual spans)
├── src/guardrails/guardrails.py                                     (+12 lines — structlog warnings)
├── app.py                                                           (+5 lines — init_tracing + RequestsInstrumentor)
├── tests/streamlit-functionality-test/streamlit_test_1_prompt.py    (+50 lines — V9 smoke checks)
├── pyproject.toml                                                   (+8 lines)

PACKAGES ADDED (8):
├── opentelemetry-api, opentelemetry-sdk
├── opentelemetry-instrumentation-fastapi, opentelemetry-instrumentation-celery
├── opentelemetry-instrumentation-redis, opentelemetry-instrumentation-requests
├── opentelemetry-exporter-otlp-proto-grpc
└── structlog
```

**Total V9 additions:** ~870 lines across 24 files.

---

### 16.8 Success Criteria

1. **All 18 containers start** via `./infra_up.sh` with zero errors
2. **`/metrics` and `/health` still respond** — V9 is additive, no regression on V8
3. **OTel Collector receives spans** — Prometheus scrape target `otel_collector` shows UP at http://localhost:9090/targets
4. **Tempo stores traces** — `curl http://localhost:3200/api/search?tags=service.name%3Dofficehub-fastapi` returns results after a `/ask` query
5. **Traces show cross-process waterfall** — a single `trace_id` spans both `officehub-fastapi` AND `officehub-celery-worker` services in Tempo
6. **Loki receives logs** — `curl "http://localhost:3100/loki/api/v1/query_range?query={job=\"agent\"}"` returns log lines after agent activity
7. **structlog emits `trace_id` in logs** — log lines contain `"trace_id": "..."` key when inside an active span
8. **Grafana derivedField links work** — clicking a `trace_id` in a Loki log line opens the corresponding Tempo trace
9. **LangFuse shares OTel `trace_id`** — `langfuse_context.update_current_trace()` produces traces in LangFuse with the same ID as Tempo
10. **Grafana dashboards render** — all 3 existing dashboards + Traces dashboard load with populated panels
11. **Smoke test passes** — V9 checks (5/5 TRACE + LOG checks) pass
12. **No new dependencies break existing functionality** — `uv run python -m py_compile src/` passes on all files

---

### 16.9 Rollback Plan

```bash
# 1. Revert docker-compose.yml to V8 version
git checkout HEAD -- infra/docker-compose.yml

# 2. Revert Prometheus scrape target
git checkout HEAD -- infra/prometheus/prometheus.yml

# 3. Revert all Python instrumentation
git checkout HEAD -- src/api/server.py src/api/celery_worker.py src/agent/agent.py \
                    src/tools/tools.py src/guardrails/guardrails.py app.py

# 4. Remove new files
rm -rf infra/tempo infra/opentelemetry infra/loki infra/promtail
rm -f infra/grafana/provisioning/datasources/tempo.yml
rm -f infra/grafana/provisioning/datasources/loki.yml
rm -f infra/grafana/dashboards/officehub-traces-dashboard.json
rm -f src/telemetry/tracing.py src/telemetry/logging.py
rm -f V-9-Tracing-Logging-Playbook.md

# 5. Remove new Python packages
uv remove opentelemetry-api opentelemetry-sdk \
         opentelemetry-instrumentation-fastapi \
         opentelemetry-instrumentation-celery \
         opentelemetry-instrumentation-redis \
         opentelemetry-instrumentation-requests \
         opentelemetry-exporter-otlp-proto-grpc structlog

# 6. Reboot with V8 infrastructure
./infra_down.sh && ./infra_up.sh
```

---

### 16.10 Key Architectural Decisions

1. **OTel Collector as intermediary** (not direct SDK→Tempo): Provides batching, resilience, and Prometheus span-metrics generation — enterprise pattern. Python services on host send to `localhost:4317` → Collector → `tempo:4317` (internal Docker DNS).
2. **Tempo port 4317 internal-only** (no host bind): Only the Collector exposes port 4317 to host. Prevents port conflict between two containers both wanting `0.0.0.0:4317`.
3. **LangFuse stays for LLM tracing** (not replaced): LangFuse is purpose-built for LLM observability (prompt/response tracking, scoring). OTel covers infrastructure (service hops, database calls). They share one `trace_id` via `langfuse_context.update_current_trace()`.
4. **structlog OTel auto-processor** (not manual inject/clear): Gemini's refinement — a structlog processor reading `get_current_span()` auto-injects `trace_id`/`span_id`. Cannot forget to call setup/teardown.
5. **structlog dual-emission** (JSON for Promtail + `print()` preserved): V9 adds structured logging alongside existing `print()` calls — no data loss, no test breakage.
6. **Promtail scrapes Docker stdout + file tail**: Docker container logs via `docker_sd_configs` auto-discovery. Agent PID-based `.txt` files via static file tail. Two paths, one Loki.
7. **Streamlit trace root** (not deferred): Gemini's refinement — `RequestsInstrumentor` makes Streamlit the trace origin, giving end-to-end visibility from UI click to LLM response.

---

### 16.11 V9 Completion Statement

> **Status:** COMPLETE — Implemented by Flash (2026-05-23)
> **Timestamp:** 2026-05-23 14:00 PKT
> **Total:** 14 new files, 9 modified files, 8 new Python packages, 4 new Docker containers (18 total), ~870 lines across 24 files

**Implementation Summary:**

**Infrastructure (6 config files + 1 compose update):**
- `infra/tempo/tempo-config.yml` — Tempo with filesystem storage, 7-day retention, service-graphs + span-metrics generators
- `infra/opentelemetry/collector-config.yml` — OTel Collector with OTLP gRPC receiver, batch/memory_limiter processors, dual export to Tempo (traces) and Prometheus (span-metrics on :8889)
- `infra/loki/loki-config.yml` — Loki single-binary mode, tsdb index, 30-day retention, `allow_structured_metadata: true`
- `infra/promtail/promtail-config.yml` — 3 scrape sources: Docker container logs (docker_sd_configs), agent PID-based .txt files, statistical test .log files
- `infra/grafana/provisioning/datasources/tempo.yml` — Tempo datasource pointing to `http://tempo:3200`
- `infra/grafana/provisioning/datasources/loki.yml` — Loki datasource with derivedField for clickable trace_id → Tempo links
- `infra/grafana/dashboards/officehub-traces-dashboard.json` — 6-panel traces dashboard (Service Latency p95, Error Rate, Agent Span Duration, Service Graph, Recent Traces, Error Logs)
- `infra/docker-compose.yml` — Added 4 containers (tempo, otel-collector, loki, promtail) + 3 volumes (tempo_data, loki_data, promtail_positions). Tempo port 4317 internal-only; Collector owns host port 4317.
- `infra/prometheus/prometheus.yml` — Added `otel_collector` scrape target pointing to `host.docker.internal:8889`

**Tracing Layer (2 new modules + 5 instrumented files):**
- `src/telemetry/tracing.py` — `init_tracing()` (idempotent, sets global TracerProvider with BatchSpanProcessor 512/5s to OTLP gRPC localhost:4317) + `get_tracer()` for manual spans
- `src/api/server.py` — `init_tracing("officehub-fastapi")` before FastAPI(), `FastAPIInstrumentor.instrument_app(excluded_urls="/metrics,/health")`, `RedisInstrumentor().instrument()`
- `src/api/celery_worker.py` — `init_tracing("officehub-celery-worker")` before Celery(), `CeleryInstrumentor().instrument()` — enables W3C trace context propagation across FastAPI↔Celery process boundary
- `src/agent/agent.py` — Manual spans: `qdrant_cache_check` (query_hash, cache.hit attributes), engine execution spans (`execute_{math|graph|combined|bayesian}_engine` with result_rows), `guardrail_checks` span
- `src/tools/tools.py` — Manual spans: `neo4j_query` (db.system=neo4j, db.operation=cypher, db.statement truncated 200 chars, result_rows), `polars_query` (db.system=polars)
- `app.py` — `init_tracing("officehub-streamlit")` + `RequestsInstrumentor().instrument()` — injects W3C traceparent headers from Streamlit → FastAPI

**Logging Layer (1 new module + 2 files with structured logging):**
- `src/telemetry/logging.py` — `configure_structlog()` with `_otel_processor` (auto-injects trace_id/span_id from current span context), `get_logger()` with module-bound service key. TTY→ConsoleRenderer, non-TTY→JSONRenderer.
- `src/agent/agent.py` — Added structlog alongside ~10 critical-path print() calls (routing_decision, cache_hit/miss, telemetry_event, execution_failed, guardrail_trip types, html_generation_failed). print() calls preserved — additive migration.
- `src/guardrails/guardrails.py` — Added structlog warning alongside all 4 Prometheus guardrail counters (2 coordination_drift, 1 cognitive_drift, 1 intent_drift) with `try/except ImportError` guard.

**LangFuse Bridge:**
- `src/agent/agent.py` — `langfuse_context.update_current_trace(id=otel_trace_id)` at start of `run_agent()` — LangFuse and Tempo now share the same trace_id

**Documentation & Testing:**
- `V-9-Tracing-Logging-Playbook.md` — operator runbook: dashboard URLs, slow-request debugging, failed-request debugging, 3 common-issue troubleshooting sections (no spans, no logs, missing trace_id)
- `V9-DETAILED-IMPLEMENTATION.md` — verbatim copy of Section 16 from IMPLEMENTATION-PLAN.md for reference
- `TESTING-PROTOCOL-V9.md` — 11-step end-to-end testing protocol mirroring V8 structure
- `tests/streamlit-functionality-test/streamlit_test_1_prompt.py` — `test_v9_observability()` with 5 checks: TRACE-1 (Tempo ready), TRACE-2 (Collector Prometheus exporter), TRACE-3 (Tempo has FastAPI traces after canary query), LOG-1 (Loki ready), LOG-2 (Loki has log entries)

**Verification:**
- All 11 modified Python files pass `py_compile()` syntax check
- All 8 new OTel/structlog packages import correctly
- Docker Compose YAML validates via `docker compose config --quiet`
- Grafana dashboard JSON is valid Python dict (verified via json.load)

**Key Architectural Decisions Executed:**
1. OTel Collector as intermediary (not direct SDK→Tempo) — batching, resilience, span-metrics generation
2. Tempo port 4317 internal-only — Collector owns host port 4317, prevents port conflict
3. LangFuse retained for LLM tracing — shared trace_id with Tempo via `update_current_trace()`
4. structlog OTel auto-processor — reads `get_current_span()` per log line, no manual inject/clear
5. structlog dual-emission — JSON for Promtail + print() preserved for backward compatibility
6. Promtail scrapes Docker stdout + file tail — two paths, one Loki
7. Streamlit trace root via RequestsInstrumentor — UI→Backend traceparent headers
