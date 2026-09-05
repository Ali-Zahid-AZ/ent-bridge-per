# External-Agent Availability

This is the one canonical project-local status manifest. It records bounded eligibility observations only; it is not a roster, handle registry, reachability result, review verdict, or convergence record. The current rows below reflect Ali's fresh availability confirmation.

# Instructions from Ali 
- Fallback mechanism: Ping GLM, if it is un-available, ping Ox-Alpha, if it is also un-available use Luna MAX. 
- Session IDs are present in: 

```json
{
  "schema_version": 1,
  "project_key": "",
  "canonical_repository_root": "/home/az/GitHub-Repositories/cchem-mlip-1-order-parameter-probing-MACE-MP-0",
  "manifest_status": "current",
  "last_verified_at": "2026-08-22T02:35:59+05:00",
  "expires_at": "2026-08-24T00:00:00+05:00",
  "agents": [
    {
      "seat": "GLM",
      "role_ref": "agent_roles.md#fallback-chain-glm-review-slot",
      "provider": "OpenCode",
      "transport": "OpenCode CLI",
      "status": "available",
      "reason_code": "fresh_observation",
      "reason": "Ali confirmed GLM available and the bounded hello succeeded; substantive review remains pending.",
      "fallback_ref": "agent_roles.md#fallback-chain-glm-review-slot"
    },
    {
      "seat": "Grok",
      "role_ref": "agent_roles.md#fallback-chain-glm-review-slot",
      "provider": "Grok",
      "transport": "Grok CLI",
      "status": "not available",
      "reason_code": "session_limit",
      "reason": "Ali verified: Grok usage limits reached",
      "fallback_ref": "agent_roles.md#fallback-chain-glm-review-slot"
    },
    {
      "seat": "OX-Alpha",
      "role_ref": "agent_roles.md#fallback-chain-glm-review-slot",
      "provider": "OpenCode",
      "transport": "OpenCode CLI",
      "status": "not_available",
      "reason_code": "fresh_observation",
      "reason": "Ali confirmed OX-Alpha available for the current bounded review; hello and substantive transport remain pending.",
      "fallback_ref": "agent_roles.md#fallback-chain-glm-review-slot"
    },
    {
      "seat": "DeepSeek",
      "role_ref": "agent_roles.md#fallback-chain-glm-review-slot",
      "provider": "OpenCode",
      "transport": "OpenCode CLI",
      "status": "not_available",
      "reason_code": "retired",
      "reason": "DeepSeek is retired by the live agent_roles.md and is not eligible for current work.",
      "fallback_ref": "agent_roles.md#fallback-chain-glm-review-slot"
    }
  ]
}
```
