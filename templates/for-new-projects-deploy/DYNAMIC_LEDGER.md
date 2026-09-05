>---
# DYNAMIC EXECUTION LADDER: Instruction
>---

> [!warning] ACTIVE WORK: execute top-to-bottom

> [!info] TAGS 
> The following tags would be applied to every thing noted down in this document, depending on the status of the task.  
> 1. `[PENDING]`
> 2. `[IN_PROGRESS]`
> 3. `[BLOCKED]`
> 4. `[DONE]`

> [!warning] ENTRY FORMAT 
> - ALL entries here will be put down with a time stamp, the tag and a brief describing the task. 
> - Format: `### [YYYY-MM-DD HH:mm:SS PKT] | [TASK]| [Brief Topic]`

> [!info] AGENT_CHANGES.md 
> Remains the default ledger for noting down comprehensively detailed changes made to the code base and every work done by the agents. 

> [!warning] WRITE PROTOCOL: per global Canvas Write Protocol
> 1. Acquire current PKT time via time MCP (`time_get_current_time`, timezone `Asia/Karachi`).
> 2. Re-read top 5 entries, verify no chronological inversion.
> 3. Append newest-at-top below this line using assertion-gated python splice (count==1).
> 4. Sign entry with agent name + role. Never sed -i or stale-temp-copy. 

> [!danger] ARCHIVED DYNAMIC_LEDGER.md 
> - Present in `docs/documentation/dynamic-ledger/markdown/`.
> - **SHOULD** be consulted to assess if an issue has been solved before or not + for cohesiveness.

> [!danger] It is STRICTLY PROHIBITED to write above this line. Start text from under this line

