---
tags:
  - temporal_io
---

---
[[Temporal.io Basics]]
[[Temporal.io Deep Dive]]

---
## PART I: What is Temporal.io?

### The Layman Explanation

**Temporal is:** A platform that lets you write **long-running, fault-tolerant workflows** as if they were simple functions.

**Imagine you're writing code like this:**

````python
def process_order(order_id):
    charge_credit_card(order_id)      # Takes 2 seconds
    ship_package(order_id)             # Takes 3 days
    send_confirmation_email(order_id)  # Takes 1 second

**Problem with normal code:**
- What if your server crashes during `ship_package()`?
- What if `charge_credit_card()` succeeds but `ship_package()` fails?
- How do you retry after 3 days when the process is still running?

**Traditional solutions:**
- Message queues (Kafka, RabbitMQ) → You manually track state
- Cron jobs → You write custom retry logic
- State machines (Airflow, AWS Step Functions) → Verbose YAML configs

**Temporal's solution:**
Write the code exactly as shown above. Temporal handles:
- ✅ Persistence (survives crashes)
- ✅ Retries (automatic with configurable backoff)
- ✅ State management (knows where you are in the workflow)
- ✅ Time (can sleep for days, weeks, months)
- ✅ Visibility (see all running workflows in real-time)

---

### Technical Architecture

┌─────────────────────────────────────────────────────────────┐
│                    TEMPORAL ARCHITECTURE                    │
└─────────────────────────────────────────────────────────────┘

┌────────────────────────────────────────────────────────────┐
│                    YOUR APPLICATION                        │
│  ┌──────────────┐          ┌──────────────┐                │
│  │  WORKFLOWS   │          │  ACTIVITIES  │                │
│  │              │          │              │                │
│  │ (Business    │   calls  │ (Actual work:│                │
│  │  logic,      │────────> │  API calls,  │                │
│  │  orchestrate)│          │  DB queries) │                │
│  └──────────────┘          └──────────────┘                │
│         │                         │                        │
│         │ SDK                     │ SDK                    │
│         ▼                         ▼                        │
└────────────────────────────────────────────────────────────┘
         │                         │
         └─────────────┬───────────┘
                       │
                       ▼
┌────────────────────────────────────────────────────────────┐
│                   TEMPORAL SERVER                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   FRONTEND   │  │   HISTORY    │  │   MATCHING   │      │
│  │              │  │              │  │              │      │
│  │ (API entry)  │  │ (State mgmt) │  │ (Task queue) │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└────────────────────────────────────────────────────────────┘
                       │
                       ▼
┌────────────────────────────────────────────────────────────┐
│                    PERSISTENCE                             │
│  ┌──────────────┐          ┌──────────────┐                │
│  │  PostgreSQL  │          │  Cassandra   │                │
│  │  (or MySQL)  │    or    │  (for scale) │                │
│  └──────────────┘          └──────────────┘                │
└────────────────────────────────────────────────────────────┘

---

### Core Concepts

#### **1. Workflows (The Orchestrator)**

**Definition:** Durable functions that coordinate activities

**Key Properties:**
- **Deterministic**: Same inputs → same outputs (required for replay)
- **Durable**: Execution state is persisted automatically
- **Fault-tolerant**: Can resume from where it left off after crashes

**Mental Model:**
A workflow is like a conductor:
- Doesn't play instruments (doesn't do actual work)
- Just coordinates musicians (activities)
- Remembers the entire performance (durable state)
```


#### Example (conceptual):

````python
@workflow.defn
class MLOpsPipeline:
    @workflow.run
    async def run(self, config: PipelineConfig):
        # This entire function is durable
        # If server crashes, it resumes from last checkpoint
        
        # Step 1: Ingest data (activity)
        data_path = await workflow.execute_activity(
            ingest_data,
            args=[config.data_source],
            start_to_close_timeout=timedelta(minutes=30)
        )
        
        # Step 2: Preprocess (activity)
        processed_path = await workflow.execute_activity(
            preprocess_data,
            args=[data_path],
            start_to_close_timeout=timedelta(hours=1)
        )
        
        # Step 3: Train (activity)
        model_path = await workflow.execute_activity(
            train_model,
            args=[processed_path],
            start_to_close_timeout=timedelta(hours=24),
            retry_policy=RetryPolicy(
                maximum_attempts=3,
                backoff_coefficient=2.0
            )
        )
        
        return model_path
```

**What makes this powerful:**
- If `train_model` crashes after 12 hours, Temporal retries from that point
- The workflow itself never loses state
- You can query workflow status any time

---

#### **2. Activities (The Workers)**

**Definition:** Individual units of work (the actual computation)

**Key Properties:**
- **Non-deterministic**: Can call APIs, write to DB, train models
- **Idempotent**: Should be safe to retry
- **Stateless**: Don't maintain state (workflow does that)

**Mental Model:**

Activities are the musicians:
- Do the actual work (play notes)
- Can fail and be retried
- Workflow (conductor) coordinates them
````
```

#### Example (conceptual):

````python
@activity.defn
async def train_model(data_path: str) -> str:
    """
    This is an activity - it does actual work
    Can call external services, use GPUs, etc.
    """
    
    # Load data
    train_loader = load_data(data_path)
    
    # Train model (this could take hours)
    model = LiverTumorDetector()
    for epoch in range(100):
        train_epoch(model, train_loader)
        
        # Heartbeat to Temporal (proves we're still alive)
        activity.heartbeat(f"Epoch {epoch}/100")
    
    # Save model
    model_path = save_model(model)
    
    return model_path

**Heartbeats:** Prove the activity is still alive (important for long-running tasks)

---

#### **3. Task Queues**

**Definition:** Named queues where workflows/activities are dispatched

**Mental Model:**

Task queues are like specialized job boards:
- "gpu-training" queue → Only workers with GPUs listen here
- "data-ingestion" queue → Workers with S3 access listen here
- "deployment" queue → Production deployment workers listen here


**Why this matters:**
- Route GPU-heavy work to GPU workers
- Route data work to workers with data access
- Scale different types of workers independently

---

#### **4. Workers**

**Definition:** Processes that execute workflows and activities

**Architecture:**

┌────────────────────────────────────────┐
│           WORKER PROCESS               │
│  ┌──────────────────────────────────┐  │
│  │  Polls task queue                │  │
│  │  "gpu-training"                  │  │
│  │                                  │  │
│  │  When task arrives:              │  │
│  │  1. Execute activity             │  │
│  │  2. Send heartbeats              │  │
│  │  3. Return result                │  │
│  └──────────────────────────────────┘  │
└────────────────────────────────────────┘
````

You can run:

- 1 worker on your laptop (development)
- 100 workers in Kubernetes (production)

Temporal handles load balancing automatically.

---
### Key Features That Make Temporal Special

#### 1. Automatic Retries

```python
# You write this:
result = await workflow.execute_activity(
    train_model,
    retry_policy=RetryPolicy(
        maximum_attempts=3,
        backoff_coefficient=2.0  # 1s, 2s, 4s
    )
)

# Temporal handles:
# - Attempt 1 fails → wait 1s → retry
# - Attempt 2 fails → wait 2s → retry
# - Attempt 3 fails → wait 4s → retry
# - All failed → workflow gets error
```

No manual retry logic needed.

---
#### 2. Durable Timers


````python
# Sleep for 3 days (server can crash, doesn't matter)
await asyncio.sleep(timedelta(days=3))

# Continue execution exactly where you left off
send_reminder_email()
```

**Traditional approach:**
- Write to database: "Wake me up in 3 days"
- Set up cron job to check database
- Hope your server survives

**Temporal approach:**
- Just `await asyncio.sleep()`
- Temporal guarantees it wakes you up

---

#### **3. Event History (Time Travel)**

Every workflow execution has a complete history:
```
Workflow: liver-tumor-training-12345

EVENT 1  | 2026-01-19 10:00:00 | WorkflowExecutionStarted
EVENT 2  | 2026-01-19 10:00:01 | ActivityScheduled: ingest_data
EVENT 3  | 2026-01-19 10:00:45 | ActivityCompleted: ingest_data
EVENT 4  | 2026-01-19 10:00:46 | ActivityScheduled: preprocess_data
EVENT 5  | 2026-01-19 10:01:30 | ActivityCompleted: preprocess_data
EVENT 6  | 2026-01-19 10:01:31 | ActivityScheduled: train_model
EVENT 7  | 2026-01-19 11:30:15 | ActivityFailed: train_model (NaN loss)
EVENT 8  | 2026-01-19 11:30:16 | ActivityRetryScheduled: train_model (attempt 2)
EVENT 9  | 2026-01-19 13:00:42 | ActivityCompleted: train_model
EVENT 10 | 2026-01-19 13:00:43 | WorkflowExecutionCompleted
````

**You can:**

- Query this history at any time
- Replay the workflow to debug
- Understand exactly what happened

---
#### 4. Versioning

**Problem:** You deploy a new version of your workflow while old ones are still running

**Temporal's solution:**

```python
@workflow.defn
class MLOpsPipeline:
    @workflow.run
    async def run(self, config):
        # Check version
        version = workflow.get_version("training-logic", 
                                       min_supported=1, 
                                       max_supported=2)
        
        if version == 1:
            # Old training logic
            model = train_v1(data)
        else:
            # New training logic
            model = train_v2(data)
```

Old workflows continue with old code, new workflows use new code.

---
#### 5. Signals & Queries

**Signals:** Send messages to running workflows


```python
# In workflow:
@workflow.signal
async def adjust_learning_rate(self, new_lr: float):
    self.learning_rate = new_lr

# From outside:
workflow_handle.signal("adjust_learning_rate", 0.0001)
```

**Use case:** Adjust training hyperparameters mid-run
**Queries:** Ask workflow about its state

```python
# In workflow:
@workflow.query
def get_current_epoch(self) -> int:
    return self.current_epoch

# From outside:
current_epoch = workflow_handle.query("get_current_epoch")
```

**Use case:** Dashboard showing training progress

---
### Temporal vs. Alternatives

|**Feature**|**Temporal**|**Airflow**|**AWS Step Functions**|**Prefect**|
|---|---|---|---|---|
|**Language**|Python, Go, Java, TypeScript|Python|JSON (state machine)|Python|
|**Durable execution**|✅ Built-in|❌ Manual|✅ Built-in|✅ Built-in|
|**Long-running (days/weeks)**|✅ Native|⚠️ With workarounds|⚠️ Limited (1 year max)|✅ Yes|
|**Retries**|✅ Automatic|⚠️ Manual config|✅ Automatic|✅ Automatic|
|**Versioning**|✅ Built-in|❌ Manual|❌ Manual|⚠️ Limited|
|**Time travel debugging**|✅ Full history|❌ No|⚠️ Limited|⚠️ Limited|
|**Self-hosted**|✅ Yes|✅ Yes|❌ Cloud only|✅ Yes|
|**Complexity**|Medium|High|Low|Low|
|**Best for**|Durable workflows|Batch jobs, ETL|AWS-native apps|Data pipelines|

---
### When to Use Temporal

✅ **Use Temporal when:**
- Workflows run for hours/days/weeks
- Failure tolerance is critical (can't lose state)
- You need complex retry logic
- You want visibility into execution history
- Multiple services need coordination

✅ **Perfect for your MLOps pipeline because:**
- Training takes hours (durable execution needed)
- Failures are common (need automatic retries)
- Want to adjust hyperparameters mid-training (signals)
- Need audit trail for regulatory compliance (event history)

❌ **Don't use Temporal for:**
- Simple request/response APIs (overkill)
- Ultra-low latency requirements (< 100ms)
- Stateless batch jobs that never fail (simpler tools work)

---
### Industry Adoption

**Companies using Temporal in production:**
- **Netflix:** Content encoding pipelines
- **Stripe:** Payment processing workflows
- **Snap:** Infrastructure automation
- **Coinbase:** Financial transaction workflows
- **Datadog:** Internal tooling orchestration

**Why they chose it:**
- **Netflix:** "We can't lose encoding jobs mid-processing"
- **Stripe:** "Financial transactions must be exactly-once"
- **Snap:** "We need complex retry logic without writing it manually"

---
