---
tags:
  - systemsltd
  - enterprise-software-delivery
  - enterprise_llms
  - software-arcihitecture
  - llmops
  - career
status: planned
agent: Sol - OpenAI
---

---
```table-of-contents
```
---
### References

> [!check] .
>
>**[Obsidian Links]** 
>`$= dv.list([...new Map(dv.current().file.outlinks.filter(l => l.path.endsWith(".md")).map(l => [l.path, l])).values()])`
>
>---
>
> **[External Links]** 
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\((https?:\/\/[^\s)]+)\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](" + m[2] + ")"); } dv.list([...new Set(links)])`
>
>---
>
> **[Directory Links]** 
> `$= const content = await dv.io.load(dv.current().file.path); const regex = /\[(.*?)\]\(<(file:\/\/\/.*?)>\)/g; const links = []; let m; while (m = regex.exec(content)) { links.push("[" + m[1] + "](<" + m[2] + ">)"); } dv.list([...new Set(links)])`
>
>---
> 
> **[Back Links]** 
> `$= dv.list([...new Map(dv.current().file.inlinks.map(l => [l.path, l])).values()])`
>
>---
> **[Document Tags]**
> 
>  `$= [...new Set(dv.current().file.tags)].join(" | ")`


---
### Primitives

- [[Enterprise-Software-Delivery-First-Principles-and-Delivery-Learning]]
- [[SystemsLTD-AVP-to-VP-Impact-Ledger]]
- [[Systems-LTD-Telecom-Architecture-Assessment]]
- [[Systems-LTD-AI-Architect]]


> - `Project Truth-State Reconstruction`
> 	- before changing a project: 
> 		- establish what was sold 
> 		- what was approved  
> 		- what changed 
> 		- what is being built 
> 		- what evidence exists 
> 		- what will actually be delivered 
> 		- whether the client will accept it

>- `Current Approved Baseline`
>	  - the authoritative current commitment after the original commercial baseline  
>	  - every subsequently approved change are reconciled

> - `Evidence Before Opinion` 
> 	- if somebody says a project is:  
> 		- healthy 
> 		- delayed 
> 		- blocked 
> 		- tested 
> 		- observable 
> 		- ready 
> 	- ask what evidence establishes that state

> - `Lifecycle Position Is Stage-Aware*` 
> 	- a project is not necessarily in one lifecycle stage 
> 	- different releases + workstreams + integrations + components ➝ can occupy different stages simultaneously 
- **Authority ≠ Responsibility** ➝ map both who is responsible for work and who is actually allowed to approve, change, accept, stop, escalate, or commit.
- **Promise → Production** ➝ the job of delivery is to preserve traceability from commercial promise to technical reality to client acceptance to stable operations.
- **Diagnose Before Prescribing** ➝ understand the project system, people, history, constraints, and evidence before introducing standards or redesigning anything.
- **Do Not Confuse Symptoms With Causes** ➝ a weak implementation can be caused by competence, but also by unclear requirements, scope churn, missing dependencies, unrealistic estimates, unavailable infrastructure, bad handover, or architectural decisions made upstream.

---
### 1. Purpose

> [!warning] The objective of the `first` month at Systems Limited is ➝ `not to arrive and immediately start changing things`

> [!hint] `The objective is to build an accurate mental model` of
> 
> 1. **Organization**  
> 	- who reports to whom 
> 	- who owns what 
> 	- who has decision authority 
> 	- who controls staffing/resources 
> 	- who owns the client relationship
> 2. **Portfolio/Projects**
>    - what was sold, what the client expects, where delivery currently stands, what is blocked, and whether the current trajectory can satisfy the promise;
> 3. **the technical systems** — architecture, ownership, dependencies, technology choices, environments, observability, validation, release, deployment, and operational readiness;
> 4. **the delivery system itself** — how Systems turns a promise into a production system, where information is lost, where change enters, how decisions are recorded, and where recurring bottlenecks appear;
> 5. **the people** — what each lead/engineer owns, what they understand well, where judgment is strong, where capability is concentrated, and where the system around them is making delivery harder than it needs to be.

> [!danger] `North Star for Month 1` ➝ Reconstruct the `truth-state` of the projects under personal visibility before trying to prescribe solutions

This is the operational application of [[Enterprise-Software-Delivery-First-Principles-and-Delivery-Learning]]. That note defines delivery as converting **what was sold** into a **working + accepted + production system** that delivers the **promised business outcome**, and frames delivery as the bridge:

> **commercial promise → technical reality → client acceptance → stable operations**

The first month therefore needs to answer one overarching question for each material engagement:

> **Are we actually on a defensible path from what was promised to what will be accepted and operated in production?**

---
### 2. Governing Delivery Model

The lifecycle reference model is:

> `Shape` → `Handover` → `Discover` → `Design` → `Mobilize` → `Develop` → `Build` → `Validate` → `Ready` → `Go Live` → `Stabilize` → `Operate`

Or, at a more primitive level:

> `Promise` → `uncertainty reduction` → `system definition` → `executable decomposition` → `construction` → `evidence` → `controlled transition` → `stable ownership`

The lifecycle note makes another important point: delivery is continuously moving several things through the organization at once:

- **information** — what is known, unknown, assumed, discovered, and changed;
- **requirements** — what the client needs and what the system must prove;
- **risk** — technical, commercial, operational, legal, security, organizational;
- **authority** — who may decide, approve, change, accept, stop, or escalate;
- **responsibility** — who owns each workstream, dependency, defect, release, or outcome;
- **money** — what was sold, what is billable, what creates value, and what consumes delivery budget;
- **evidence** — what demonstrates that the system satisfies the requirement;
- **state** — where the solution currently sits between promise and stable operation.

> [!quote] The lifecycle stages are not merely sequential boxes. They are **checkpoints in a continuous transformation of risk + knowledge + evidence + ownership**.

This means the first-month review should not ask only **"what stage is the project in?"** It should ask:

- Which stage is each major workstream/release/component in?
- What should be true at this stage?
- What evidence shows that it is true?
- What unresolved risk is being carried into the next stage?
- Who owns that risk?
- Who has authority to accept it?

---
### 3. First Days — Entry Sequence

#### 3.1 Day 1: Administrative / Operating Access

First complete the administrative work required to become functional inside Systems.

Likely categories include:

- HR/onboarding formalities;
- identity, email, badge, communication tools;
- laptop/device and security setup;
- VPN, source-control, project-management, document, and collaboration access appropriate to my role;
- approved note-taking/storage tooling;
- internal policies relevant to client/project data;
- organizational directories and basic reporting structure.

The purpose is simple: **remove administrative friction before attempting to understand delivery**.

> [!warning] This personal Obsidian note stores the **framework only**. Actual Systems/client confidential information must remain inside whatever company-approved device, repository, note system, and storage boundary Systems authorizes.

---
### 3.2 Align With Saad Before Deep-Diving

Before independently interrogating projects, establish my operating boundary with Saad.

Questions to resolve:

- Which projects/accounts does he want me to understand first?
- What does he expect from me during the first month?
- Which engagements are healthy, sensitive, strategically important, escalated, or commercially important?
- What responsibilities are explicitly mine now?
- What is currently advisory versus decision authority?
- Which decisions may I make independently?
- Which decisions should be aligned with him first?
- Who owns the client relationship for each account?
- Who owns delivery?
- Who owns commercial commitments?
- Who controls staffing/resource allocation?
- Which existing relationships or sensitivities should I understand before intervening?
- What would make him say after one month: **"Ali understands the terrain"**?

The goal is not to ask Saad to explain every project. It is to establish **scope + authority + priorities + political context** so that subsequent project conversations occur inside the correct mandate.

---
### 3.3 Meet the Project Leads

Saad will likely introduce the project/delivery/technical leads. The initial posture should be:

> **"Walk me through this engagement from the beginning. What did we sell, where are we now, what is going well, and what worries you?"**

Do **not** begin with a checklist interrogation.

The rubric in this note stays in the head/notes. The lead should experience the conversation as if we are trying to **understand their project**, not a new AVP arriving with an inspection clipboard.

Initial conversation sequence:

1. Let the lead tell the project story in their own causal order.
2. Identify the important claims, changes, risks, and commitments.
3. Ask for the authoritative artifacts behind those claims.
4. Deep-dive only where the story and evidence diverge or where material risk exists.
5. Meet component/workstream owners after understanding the project-level context.
6. Do not diagnose an engineer before reconstructing the upstream requirement/architecture/decision context that shaped their work.

---
### 4. Map 1 — Administrative / Authority Map

The formal org chart is necessary but insufficient.

For the relevant part of Systems, map:

```text
Person ──reports_to──────────────> Person
Person ──owns_portfolio──────────> Account / Capability
Person ──owns_client_relation────> Client
Person ──owns_delivery───────────> Project
Person ──approves_architecture───> Architecture / Decision
Person ──controls_staffing───────> Team / Resource
Person ──can_change_scope────────> Commitment
Person ──can_accept_risk─────────> Risk
Person ──can_commit_timeline─────> Milestone
Person ──can_release─────────────> Release
```

For each important responsibility, distinguish:

- **formal reporting line**;
- **actual operational influence**;
- **decision authority**;
- **execution responsibility**;
- **escalation path**.

Questions:

- Who reports to whom?
- Which VP/AVP/Director/lead owns which account or capability?
- Who owns presales?
- Who owns delivery after sale?
- Who owns solution architecture?
- Who owns project/program management?
- Who controls staffing?
- Who can approve a scope/timeline change?
- Who can accept delivery risk?
- Who represents Systems to the client when there is an escalation?
- Who must be in the room for a material technical/commercial decision?

> [!hint]
> The useful map is not just **"who is senior?"** It is **"who can make which state transition happen?"**

---
### 5. Map 2 — Project / Client Truth-State Reconstruction

For every material project, reconstruct the causal chain:

```text
WHAT PROBLEM / OUTCOME WAS THE CLIENT BUYING?
                    │
                    ▼
             WHAT WAS SOLD?
                    │
                    ▼
          WHAT WAS FORMALLY AGREED?
                    │
                    ▼
       WHAT WAS DISCOVERED AFTER SALE?
                    │
                    ▼
          WHAT CHANGED AND WHY?
                    │
                    ▼
       WHAT IS THE CURRENT APPROVED BASELINE?
                    │
                    ▼
            WHAT DID WE DESIGN?
                    │
                    ▼
        WHAT ARE WE ACTUALLY BUILDING?
                    │
                    ▼
       WHAT EVIDENCE SHOWS CURRENT STATE?
                    │
                    ▼
         WHAT WILL ACTUALLY BE DELIVERED?
                    │
                    ▼
        WILL THE CLIENT ACCEPT THAT THING?
                    │
                    ▼
       CAN IT BE SAFELY RELEASED / DEPLOYED?
                    │
                    ▼
        CAN IT BE STABLY OWNED IN PRODUCTION?
```

This is the core of the first month.

---
### 6. Project Review Rubric

#### 6.1 What Was Promised to the Client?

Start from the authoritative commercial and technical baseline.

Ask for whatever Systems uses as the binding/source-of-truth artifacts, for example:

- signed SOW;
- proposal / order form / contract / technical annex;
- approved solution description;
- product description;
- explicit deliverables;
- assumptions;
- exclusions;
- dependencies/client responsibilities;
- acceptance expectations/criteria;
- committed milestones/timeline;
- approved project plan.

Questions:

- What exact business problem was the client buying us to solve?
- What business outcome made the engagement valuable?
- What did Systems explicitly commit to deliver?
- What was described as an estimate/hypothesis versus a contractual commitment?
- What assumptions make the promise valid?
- What was explicitly excluded?
- What is the client's responsibility?
- What does the client currently believe it will receive?
- What objective evidence will allow the client to say **"yes, this is what we bought"**?

> [!danger]
> Preserve the discipline from [[Enterprise-Software-Delivery-First-Principles-and-Delivery-Learning]]:
> 
> **Never allow a value hypothesis to silently mutate into a contractual guarantee.**

A proposed benefit, target, estimate, aspiration, and binding commitment are different things. I need to know which one each important number or claim actually is.

---
#### 6.2 Establish the Current Approved Baseline

The original proposal is not necessarily the current truth.

Use this model:

```text
Original commercial / technical baseline
                +
Discovery outcomes
                +
Approved client changes
                +
Approved technical changes
                +
Approved schedule / milestone changes
                =
CURRENT APPROVED BASELINE
```

Questions:

- What changed after sale?
- Which changes were formally approved?
- Which were informally discussed but never approved?
- Which commitments may have entered via meetings/emails without being reflected in the project baseline?
- Is the current architecture aligned to the **current approved baseline**, not merely the original proposal?
- Is the project plan also aligned to the same baseline?
- Does the client share the same baseline understanding?

If delivery, architecture, sales, and client are each operating from a different mental baseline, the project is already carrying structural risk.

---
#### 6.3 Where Are We in the Software Delivery Lifecycle?

Use [[Enterprise-Software-Delivery-First-Principles-and-Delivery-Learning]] as the reference rubric:

1. Presales / Solution Shaping
2. Sales-to-Delivery Handover / Kickoff
3. Discovery & Requirements
4. Solution Architecture & Detailed Design
5. Planning & Mobilization
6. Develop
7. Build / Continuous Integration
8. Test & Validate
9. Release Readiness
10. Deploy / Cutover / Go-Live
11. Hypercare / Stabilization
12. Handover / Acceptance / Operations

Do **not** force an entire project into one stage if reality is more granular.

Example:

```text
Core platform            → Develop / Build
Integration A            → Test & Validate
Integration B            → Discovery
Release 1                → Release Readiness
Release 2                → Planning & Mobilization
```

For every material workstream/release:

- Where is it now?
- What evidence proves that state?
- What had to be true to enter this stage?
- What must become true before exiting it?
- What unresolved risk is being carried forward?
- Who owns that risk?
- What is the next milestone/gate?

---
#### 6.4 Are We Going to Meet the Deadlines?

Do not ask for a confidence adjective alone. Ask for the causal basis of schedule confidence.

Questions:

- What is the committed deadline/milestone?
- What is the current forecast?
- What is the critical path?
- Which dependencies can move the critical path?
- Which workstreams are ahead/behind?
- What evidence supports the remaining-effort estimate?
- What work is blocked?
- How long has it been blocked?
- Who owns unblocking it?
- Does the client own any dependency?
- Are environment/access/data approvals on the path?
- Have scope changes been incorporated into the schedule?
- Have resource changes been incorporated into the schedule?
- Are we using optimistic dates that no longer correspond to current scope?

If we are not likely to meet the deadline:

> **What is the bottleneck?**

Potential classes to distinguish:

- competence / technical capability;
- insufficient people;
- wrong people / skill mismatch;
- unavailable resource;
- client dependency;
- third-party/vendor dependency;
- missing environment/access;
- data availability/quality;
- unclear requirement;
- architecture problem;
- scope growth/change churn;
- unrealistic original estimate;
- governance/approval bottleneck;
- testing/quality bottleneck;
- deployment/security constraint;
- unresolved decision ownership.

Then ask:

- Is the problem actually solvable?
- What would make it solvable?
- Who has authority to provide that thing?
- What is the time/cost/scope consequence?
- Has the consequence been communicated to the client and internal stakeholders?

---
#### 6.5 How Do We Know It Is an Issue?

This is a key primitive.

Whenever somebody says:

- "performance is bad";
- "the API is unstable";
- "the model is inaccurate";
- "the team is blocked";
- "the integration is slow";
- "the client keeps changing requirements";
- "the build is unreliable";
- "production is healthy";

ask:

> **How do we know? Show me the evidence.**

Possible evidence:

- dashboards/metrics;
- traces/logs;
- error rates;
- latency distributions;
- test results;
- defect history;
- build failures;
- requirement/change logs;
- dependency status;
- client decisions/minutes;
- tickets;
- code/architecture evidence;
- operational incidents.

Use an epistemic status where useful:

- **Verified** — directly supported by current evidence;
- **Reported** — stated by a responsible person but not yet independently checked;
- **Inferred** — reasoned from partial evidence;
- **Unknown** — insufficient evidence.

The purpose is not distrust. It is to avoid making executive decisions from ambiguous state.

---
#### 6.6 Is Observability Baked In?

Observability must be **stage-aware**.

At architecture/design stage, I may not expect a live dashboard yet, but I should expect an observability design:

- what signals matter;
- logs/metrics/traces/events;
- failure modes that must become visible;
- service/model/data/business indicators;
- alerting expectations;
- ownership;
- retention/audit requirements;
- correlation/traceability strategy.

At development/build/test stages, I should increasingly expect implemented telemetry and evidence.

At release/production stages, ask directly:

- Show me the dashboards.
- Show me the alerts.
- Show me how we identify a failing component.
- Show me how we trace a user/client request through the system.
- Show me operational/error/business indicators where relevant.
- Who is watching these signals?
- What thresholds trigger action?
- Where are runbooks linked?

If observability is absent:

> **Why is it absent, and how will we know whether the system works or fails once deployed?**

---
#### 6.7 Do We Have Milestones / Checkpoints?

For each project/release/workstream:

- What are the milestones?
- Which milestones are client-facing?
- Which are internal engineering gates?
- What is the definition of done for each?
- What evidence demonstrates completion?
- Who owns each milestone?
- Who approves/signs it off?
- What dependency must exist before the milestone can be reached?
- What happens if it slips?
- Does a slipped milestone affect the final commitment?
- Is the client receiving small demonstrable increments/updates rather than discovering the real system only at the end?

If milestones do not exist:

> **Why not, and how are we controlling uncertainty and client expectation without checkpoints?**

---
#### 6.8 Does the Architecture Conform to the Promise?

Architecture must be traceable to the current approved baseline.

Questions:

- Which requirement/commitment does each major component satisfy?
- Are all promised capabilities represented in the architecture?
- Are there components that exist without a clear requirement/rationale?
- Are client constraints reflected?
- Are security/privacy/governance constraints reflected?
- Are integrations/data flows/API/event boundaries explicit?
- Is observability designed?
- Is resilience/failure handling designed?
- Is deployment topology designed?
- Are operational support constraints considered?
- Are assumptions explicit?
- Are important architecture decisions recorded?
- Has the architecture changed after client additions?
- Which version of the architecture corresponds to the current approved baseline?

The key question:

> **If we implement this architecture correctly, does it produce the thing we actually promised?**

---
#### 6.9 Which Team Member Owns Which Part of the Architecture?

Map ownership down to useful operational granularity.

For each component/workstream:

- technical owner;
- delivery owner;
- reviewer/approver;
- dependencies;
- current status;
- risks/blockers;
- next evidence/milestone.

Then meet the actual owner.

Use the same framework, but from their local perspective:

- What is your requirement?
- What are you building?
- What decisions did you make and why?
- What dependencies do you have?
- What currently worries you?
- How do you know the component is working?
- What evidence is available?
- What changes have occurred?
- What would break if the input/constraint/requirement changed?

> [!warning]
> Do not label a person as a competence problem before checking whether the person was given a stable requirement, correct context, appropriate architecture, adequate resources, available dependencies, and realistic timeline.

The project system can create bad engineering outcomes even when the engineer is capable.

---
## 6.10 Is the End Product What We Promised?

This must remain visible throughout delivery.

Ask:

- What exact product/system/capability will be handed to the client?
- What does the latest demonstrable build currently do?
- What remains incomplete?
- What known gap exists between current implementation and commitment?
- Which acceptance criteria are already satisfied?
- Which are not?
- Is anything technically "done" but operationally unusable?
- Is anything implemented that the client never asked for while promised functionality remains incomplete?
- Could I trace every major commitment to implementation + evidence + acceptance?

A technically impressive artifact is not a successful delivery if it cannot be deployed, accepted, operated, supported, or shown to satisfy the promise.

---
## 6.11 Client Meetings, Decisions, and Commitment History

Do not use raw meeting count as a quality metric. Multiple client meetings can be entirely normal.

Instead reconstruct what happened across the meetings.

Questions:

- What were the major client meetings/workshops?
- What decisions came out of them?
- What new information was discovered?
- What commitments were made?
- What changes were requested?
- What risks were raised?
- What remains unresolved?
- Are there contradictory decisions across meetings?
- Were commitments added verbally that never entered formal scope/change control?
- Does the client currently believe the same thing the delivery team believes?

Evidence may include, where appropriate and authorized:

- formal minutes;
- action/decision logs;
- client emails;
- approved meeting notes;
- internal project notes relevant to delivery decisions.

The objective is **decision/commitment traceability**, not collecting gossip or unnecessary commentary.

---
## 6.12 New Client Demands / Change History

For each material change:

- What did the client ask for?
- When did they ask?
- Why?
- Which project stage/workstream state were we in at that time?
- Was the request accepted, rejected, deferred, or reframed?
- Who approved the decision?
- Was a formal change request/change order required?
- Was timeline impact assessed?
- Was commercial impact assessed?
- Was resource impact assessed?
- Was architecture impact assessed?
- Did acceptance criteria change?
- Was the project plan re-baselined?
- Did the client receive an updated milestone/final-delivery expectation?
- Who owns the added work?
- What is its current progress?

If architecture changed:

> **Show me the before/after or the decision record explaining the change.**

A late feature can be small in UI terms but enormous in architectural consequences. Change must therefore be understood causally, not merely listed.

---
## 6.13 Show Me the Tech Stack — Why This Stack?

For each material technology choice:

- What requirement/constraint made this technology suitable?
- What alternatives were considered?
- Why was this option chosen over them?
- Was the decision driven by client standard, Systems capability, licensing, cost, scale, latency, security, sovereignty, compatibility, team skill, supportability, or something else?
- Are there lock-in consequences?
- Can the team operate/support it?
- Does the client permit it?
- Is it overpowered/underpowered for the problem?
- Is the technology choice still valid after requirements changed?

The desired answer is not:

> "Because this is what we always use."

The desired state is **decision + rationale + constraint + trade-off**.

---
## 6.14 Testing / Quality / Evidence

A project does not become correct because implementation is complete.

Ask what evidence exists against the actual requirements:

- unit tests;
- integration tests;
- system/SIT testing;
- regression testing;
- security testing;
- performance/load testing;
- resilience/failure testing;
- data quality/AI-model evaluation where relevant;
- UAT;
- acceptance evidence;
- defect status;
- traceability from requirement → implementation → test/evidence.

Questions:

- What must this system prove?
- Which test/evidence proves each important requirement?
- What is still unproven?
- Which known defects are accepted?
- Who has authority to accept them?

---
## 6.15 What Is the Release Plan?

Release readiness is not the same thing as "code complete."

The reference lifecycle defines Release Readiness as deciding whether the system is genuinely safe to release.

Check:

- required sign-offs;
- unresolved/known defects;
- explicit risk acceptance;
- rollback capability;
- monitoring/observability;
- alerts;
- runbooks;
- support ownership;
- training;
- access/permissions;
- security/governance readiness;
- environment readiness;
- release artifact/version identity;
- dependencies;
- operational readiness;
- client readiness where applicable.

Question:

> **What evidence would allow the authorized person to say "this release is safe enough to move toward production"?**

---
## 6.16 What Is the Deployment / Cutover Plan?

The deployment plan should explain how an **approved release** becomes a **verified production state**.

Check:

- target environment/topology;
- deployment mechanism;
- infrastructure/configuration changes;
- data migration;
- secrets/access;
- integration activation;
- traffic cutover;
- feature flags where applicable;
- smoke/health checks;
- production verification;
- rollback trigger;
- rollback mechanism;
- owner for each cutover step;
- communication/escalation plan;
- post-deploy monitoring window.

Ask:

> **If the live system deviates from expectations during cutover, who decides whether to continue, pause, or roll back — and on what evidence?**

---
### 6.17 Hypercare / Stabilization / Operations — If Applicable

For projects already live or close to live:

- What incidents have occurred?
- What unforeseen edge cases emerged?
- What has been tuned?
- What production indicators establish stability?
- What is the incident/support process?
- What are SLAs/SLOs where applicable?
- Are runbooks complete?
- Are dashboards usable by the operational owner?
- Has knowledge transfer occurred?
- Does the receiving operational organization have access and capability?
- Has formal client/operational acceptance occurred?

The end-state is not merely **"deployed"**.

It is:

> **stable + supportable + understood + owned + accepted**.

---
### 7. Cross-Cutting Disciplines to Check at Every Stage

The lifecycle reference explicitly treats the following as cross-cutting rather than late-stage additions.

### 7.1 Governance & Security

Across the lifecycle, understand:

- identity/access boundaries;
- privacy/data handling;
- client and regulatory constraints;
- approval boundaries;
- auditability;
- security review status;
- secrets/key handling;
- risk acceptance authority;
- model/AI governance where relevant.

Do not wait for release week to discover a requirement that should have shaped architecture months earlier.

## 7.2 Quality & Verification

Quality should accumulate through delivery:

- reviews;
- tests;
- evidence;
- acceptance criteria;
- traceability;
- observability.

The question is always:

> **What evidence should exist by this stage, and does it?**

## 7.3 Continuous Feedback

For systems already in testing/production:

- what is production/test behaviour teaching us?
- what incidents or user behaviour should feed back into Discovery/Design/Development?
- are lessons being converted into decisions, backlog, tests, or architecture changes?

---
# 8. Evidence Pack to Request Per Project — Stage Appropriate

Do not ask every team for every artifact indiscriminately. Request what is relevant to the project's actual stage and risk.

Possible artifacts:

### Commercial / Promise
- signed proposal/SOW/contract/technical annex;
- deliverables;
- assumptions/exclusions;
- acceptance terms;
- original milestones;
- approved project plan.

### Requirements / Discovery
- requirements/specification;
- discovery notes;
- backlog/user stories/use cases;
- non-functional requirements;
- acceptance criteria;
- client dependencies.

### Architecture
- HLD/LLD;
- component/data/integration/deployment diagrams;
- ADRs/decision logs;
- security design;
- observability design;
- resilience/failure model.

### Planning / Delivery
- milestone plan;
- workstreams/owners;
- RAID log;
- dependency map;
- resource plan;
- critical-path/schedule view;
- RACI/ownership map if used.

### Change / Client Decisions
- change requests/change orders;
- decision log;
- relevant meeting minutes;
- action logs;
- re-baselined project plan;
- revised architecture.

### Engineering / Build
- repositories;
- CI/build pipeline;
- artifact/versioning scheme;
- quality/security checks;
- environment information;
- deployment automation.

### Validation
- test plan;
- test results;
- defect status;
- performance/security/resilience evidence;
- UAT evidence.

### Release / Deployment / Operations
- release checklist;
- sign-offs;
- known-defect/risk acceptance;
- deployment/cutover plan;
- rollback plan;
- runbooks;
- dashboards/alerts;
- support model;
- hypercare plan;
- acceptance/handover records.

---
# 9. Human / Political Operating Method

The quality of the map depends on people telling me the truth. Therefore **how I ask matters**.

## 9.1 Do Not Arrive as an Auditor

Instead of:

> "Why did you do this wrong?"

Use:

> "Walk me through what the requirement was and what constraints you had when this decision was made."

Instead of:

> "Why are you late?"

Use:

> "What changed between the original plan and the current forecast? Which dependency is driving the difference?"

Instead of:

> "Why don't you have observability?"

Use:

> "How are you currently determining whether this component is healthy or failing? What telemetry exists today, and what is still planned?"

The objective is to reconstruct causes, not trigger defensive storytelling.

## 9.2 Do Not Correct Everything While Diagnosing

Unless an immediate material client/security/production risk requires intervention:

- observe;
- ask;
- verify;
- record;
- compare across projects;
- identify recurring classes of problems;
- then decide what should change.

The first-month map should help distinguish:

- one-off local mistakes;
- capability gaps;
- process gaps;
- governance gaps;
- commercial-to-delivery handover gaps;
- architecture gaps;
- dependency/resource problems;
- systemic repeated failure modes.

Only after that should standards be introduced.

## 9.3 Preserve Team Dignity

Never use a first-month diagnosis to publicly embarrass an engineer/lead.

If a component is poor, reconstruct:

```text
Requirement
   ↓
Handover / context
   ↓
Architecture / decision
   ↓
Plan / estimate / dependencies
   ↓
Engineer implementation
   ↓
Review / validation
```

The fault may originate anywhere in that chain.

---
# 10. First-Month Timeline

## Week 1 — Terrain + Authority + Portfolio Story

### Objective
Become operational and construct the first map of the territory.

### Actions
- Complete administrative onboarding.
- Align expectations, scope, authority, and priorities with Saad.
- Map formal organizational/reporting structure relevant to my work.
- Identify project/account/client owners.
- Meet project leads.
- Ask each lead for the project story from sale to current state.
- Identify authoritative commercial/project baseline artifacts.
- Establish high-level lifecycle/workstream state.
- Record major known risks, dependencies, client commitments, and unresolved questions.

### Output
- preliminary **Authority Map**;
- preliminary **Project Portfolio Map**;
- list of projects requiring deeper Week-2 reconstruction;
- explicit unknowns rather than guessed answers.

---
## Week 2 — Project Truth-State Deep Dives

### Objective
Move from narrative understanding to evidence-backed project state.

### Actions
For priority projects:

- reconstruct what was sold;
- establish current approved baseline;
- map lifecycle state by workstream/release;
- inspect milestones/deadline confidence;
- inspect major risks/dependencies/bottlenecks;
- verify issue claims against evidence;
- inspect architecture and traceability to promise;
- map ownership to components/workstreams;
- meet the relevant owners;
- reconstruct client change/decision history;
- inspect observability appropriate to lifecycle stage;
- inspect test/release/deployment/operations state where applicable.

### Output
- evidence-backed **Project Truth Sheet** per priority engagement;
- architecture/ownership map;
- risk/dependency map;
- unresolved evidence gaps;
- initial distinction between local and systemic problems.

---
## Week 3 — Cross-Project Pattern Recognition + Team Capability

### Objective
Stop seeing projects as isolated stories and identify repeated delivery patterns.

### Look for
- repeated sales-to-delivery handover gaps;
- recurring unclear requirements;
- scope/change-management problems;
- weak architecture traceability;
- repeated observability gaps;
- recurring dependency failures;
- testing/evidence weaknesses;
- release/deployment weaknesses;
- recurring technology choices without rationale;
- resource/skill concentrations;
- repeated classes of rework;
- places where one person is a single point of knowledge/authority;
- strong teams/patterns that should be preserved and reused.

### Team capability questions
- Who reliably understands end-to-end delivery?
- Who has strong architecture judgment?
- Who understands clients/business outcomes?
- Who is technically deep in which areas?
- Who self-corrects before senior review?
- Where is competence concentrated?
- Which apparent skill gaps are actually environment/process problems?

### Output
- **Delivery Pattern Map**;
- preliminary **Capability Map**;
- candidate recurring failure modes;
- candidate reusable good practices;
- evidence for what should be standardized later — not yet automatic standardization.

---
## Week 4 — Synthesis + Alignment + Next Operating Plan

### Objective
Convert the first month of observation into a defensible model and prioritized next actions.

### Review with Saad
Bring a concise synthesis rather than a data dump:

1. What I now understand about the portfolio.
2. Which projects are genuinely healthy and why.
3. Which projects carry material delivery/client/commercial risk and why.
4. Which risks are local versus systemic.
5. Which bottlenecks require management/resource/technical/client action.
6. Which assumptions remain unverified.
7. Which decision-authority gaps create delay/confusion.
8. Which team capabilities are strong.
9. Which capability gaps materially affect delivery.
10. Which one or two interventions appear highest leverage for the next 30–90 days.

### Output
- reconciled **Systems/Authority Map**;
- project portfolio truth map;
- prioritized risk/dependency view;
- capability/ownership map;
- recurring delivery patterns;
- first candidate standards/assets/interventions;
- 60–90 day operating hypothesis.

---
# 11. Standard Per-Project Truth Sheet

Use a compact structure after the deep dive so portfolio comparison becomes possible.

## Project: `<name>`

### Client / Outcome
- Client:
- Business problem:
- Promised business outcome:
- Client relationship owner:

### Promise Baseline
- Authoritative source artifacts:
- Deliverables:
- Assumptions:
- Exclusions:
- Acceptance criteria:
- Original milestone/deadline:

### Current Approved Baseline
- Approved changes:
- Current deliverables:
- Current milestone/deadline:
- Current acceptance criteria:
- Baseline confidence:

### Lifecycle State
| Workstream / Release | Current stage | Evidence | Next gate | Owner | Risk |
|---|---|---|---|---|---|
|  |  |  |  |  |  |

### Architecture
- Current architecture version:
- Major components:
- Major dependencies:
- Observability state:
- Security/governance state:
- Architecture-to-promise gaps:

### Ownership
- Delivery owner:
- Technical/architecture owner:
- Component/workstream owners:
- Decision authorities:

### Timeline
- Current forecast:
- Critical path:
- Blockers:
- Client dependencies:
- Resource dependencies:
- Confidence / evidence:

### Change History
- Material changes:
- Approval state:
- Timeline impact:
- Architecture impact:
- Resource impact:

### Quality / Evidence
- Validation state:
- Known defects:
- UAT/acceptance state:
- Evidence gaps:

### Release / Deployment / Operations
- Release readiness:
- Deployment/cutover readiness:
- Rollback readiness:
- Runbooks/support:
- Hypercare/operations state:

### Top Risks
1. 
2. 
3. 

### Unknowns
- 

### Immediate Human Action Required
- 

---
# 12. Red Flags Worth Investigating

A red flag is not automatically a failure; it is a prompt for deeper causal investigation.

- No authoritative artifact showing what was sold.
- Client and delivery team describe different expected products.
- Work started without clear acceptance criteria.
- Architecture cannot be traced to requirements/commitments.
- Significant client change entered implementation without explicit baseline/timeline consequence.
- Critical dependency has no owner.
- Deadline confidence exists without a credible remaining-work/critical-path basis.
- Major issue is asserted but cannot be demonstrated with evidence.
- Observability is absent from design/implementation.
- Multiple client commitments exist only in scattered meeting/email history.
- Technology choices have no articulated rationale.
- Known defects/risk are being carried without explicit owner/acceptance.
- Release plan is effectively "deploy when code is done."
- Deployment plan has no explicit rollback/verification criteria.
- Operations/support owner is expected to inherit a system without knowledge/access/runbooks.
- One person is the only holder of critical technical or client knowledge.
- Engineers repeatedly rework because upstream requirements/architecture change informally.

---
# 13. What I Must Not Do in Month 1

- Do not arrive with a pre-written transformation program and force reality into it.
- Do not redesign architecture before understanding the promise, history, constraints, and current baseline.
- Do not judge engineers from outputs without examining upstream causes.
- Do not confuse a confident narrative with evidence.
- Do not equate meeting count with dysfunction.
- Do not treat every missing artifact as incompetence before understanding the local delivery model.
- Do not introduce ten standards at once.
- Do not create political debris by publicly assigning blame.
- Do not casually make new commitments to clients before understanding authority and commercial consequences.
- Do not move Systems/client confidential data into the personal Obsidian/GitHub vault.

---
# 14. End-of-Month Success Criteria

At the end of the first month, I should be able to answer — with evidence, not mood:

### Organization
- Who reports to whom?
- Who owns the major accounts/projects?
- Who controls staffing/resources?
- Who has authority over scope, architecture, timeline, release, risk, and client commitments?

### Project Truth
- What did each priority client buy?
- What is the current approved baseline?
- Where is each major workstream in the lifecycle?
- What evidence supports the reported state?
- Are current timelines defensible?
- What are the critical bottlenecks/dependencies?
- Is current architecture aligned with current commitments?
- Who owns each major part?
- What material changes occurred and were they correctly incorporated?
- Will the end product match the promise?
- Is release/deployment/operational readiness being built appropriately for the current stage?

### People / Capability
- Where is the team strong?
- Where are genuine skill/judgment gaps?
- Where are apparent skill gaps actually process/resource/context problems?
- Where are single points of dependency?
- Which leads/engineers can carry larger responsibility?

### Delivery System
- What failure modes recur across projects?
- Which good practices recur and should be protected/reused?
- What one or two improvements would create the highest leverage next?

> [!success] **Month-1 Definition of Done**
> 
> I do not need to have fixed Systems in one month.
> 
> I need to have built a sufficiently accurate map that the **next intervention is based on reality**.

---
# 15. Connection to the AVP → VP Impact Ledger

This first-month plan is the **operational starting point** for [[SystemsLTD-AVP-to-VP-Impact-Ledger]].

The ledger asks whether difficult engagements can eventually be placed under my responsibility and reliably land, whether I build leadership depth, whether I create reusable capability, and whether senior/client trust expands.

The first prerequisite to all of those is **understanding the real system before changing it**.

Month 1 therefore establishes the baseline from which future evidence can be measured:

- what project state existed when I arrived;
- what risks/dependencies were already present;
- what team capability already existed;
- what standards/processes already worked;
- what recurring failure modes were observed;
- what scope/authority I actually held;
- which interventions subsequently changed outcomes.

Without this baseline, later impact can easily be confused with memory or attribution bias.

---
# 16. Long-Horizon Reminder

The first month is not the time to prove that I already know the answers.

It is the time to build the map.

> **Promise → truth-state → evidence → causes → ownership → intervention → outcome**

And the operating loop remains:

> **learn the primitives → deconstruct → reconstruct → build the mental model → apply → observe mismatch → refine → reapply**

The quality of the later marathon depends on the accuracy of the first map.

---
