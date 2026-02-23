# QA Audit Report

| | |
|---|---|
| **Application** | [AUDIT_TARGET] |
| **Report ID** | [REPORT_FILENAME] |
| **Date** | [DATE] |
| **Time** | [TIME] |
| **Input provided** | [live-url / local-code / screenshots / design-spec / mixed] |
| **Agents run** | User Tester · Design Auditor · UX/UI Auditor |
| **Iteration passes** | [NUMBER] |

---

## Executive Summary

[2–4 paragraphs written in plain language for a non-technical stakeholder. Cover: overall quality impression, the most important issues that need to be addressed, and any standout strengths. Be direct and honest. Do not use technical jargon.]

---

## Issue Summary

| Severity | Count |
|----------|------:|
| Critical | [N] |
| High | [N] |
| Normal | [N] |
| Suggestions | [N] |
| **Total** | **[N]** |

---

## Critical Issues

> Issues that block core functionality, risk data loss, or represent fundamental failures. Must be resolved before release.

### [CRIT-001] [Issue Title]

| | |
|---|---|
| **Found by** | [agent name(s)] |
| **Category** | [category] |
| **Location** | [specific location in the app] |

**Description**
[Full description of the issue]

**Evidence**
[What was observed — screenshot reference, exact behavior, computed values]

**Steps to Reproduce**
1. [Step]
2. [Step]
3. [Observe]

**Recommendation**
[Specific, actionable fix]

---

## High Priority Issues

> Significant failures that meaningfully degrade the user experience. Should be resolved before or immediately after release.

### [HIGH-001] [Issue Title]

| | |
|---|---|
| **Found by** | [agent name(s)] |
| **Category** | [category] |
| **Location** | [specific location] |

**Description**
[Full description]

**Evidence**
[What was observed]

**Recommendation**
[Specific fix]

---

## Normal Issues

> Notable issues that reduce quality but do not block primary flows. Address in the next sprint.

### [NORM-001] [Issue Title]

| | |
|---|---|
| **Found by** | [agent name(s)] |
| **Category** | [category] |
| **Location** | [specific location] |

**Description**
[Full description]

**Evidence**
[What was observed]

**Recommendation**
[Specific fix]

---

## Suggestions

> Improvement opportunities that would enhance or streamline the experience. Prioritize based on effort vs. impact.

### [SUGG-001] [Issue Title]

| | |
|---|---|
| **Found by** | [agent name(s)] |
| **Category** | [category] |
| **Location** | [specific location] |

**Description**
[Full description]

**Recommendation**
[Specific improvement]

---

## Positive Observations

> Aspects of the application that are well-implemented. Noted for team recognition and as patterns to replicate.

- [Observation]
- [Observation]

---

## Audit Coverage

### What Was Audited
[Description of what input was provided and what the agents were able to examine — viewports tested, pages visited, interactions tested]

### Limitations
[Areas that could not be fully audited — auth-gated content, no live URL, specific features not accessible, etc.]

### Recommended Follow-up
[Suggestions for additional testing — e.g., "Screen reader accessibility audit", "Performance audit with Lighthouse", "Cross-browser testing on Firefox and Safari", "Authenticated user flow testing"]

---

## Appendix: Raw Agent Findings

*Complete structured JSON output from each agent before synthesis and deduplication.*

<details>
<summary>User Tester — Raw JSON</summary>

```json
[USER_TESTER_JSON]
```

</details>

<details>
<summary>Design Auditor — Raw JSON</summary>

```json
[DESIGN_AUDITOR_JSON]
```

</details>

<details>
<summary>UX/UI Auditor — Raw JSON</summary>

```json
[UX_AUDITOR_JSON]
```

</details>
