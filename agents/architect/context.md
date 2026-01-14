# Architect Context

Project-specific architectural knowledge. **Customize this file for your project.**

## System Architecture

<!-- High-level architecture description -->

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Client    │────►│     API     │────►│  Database   │
└─────────────┘     └─────────────┘     └─────────────┘
```

## Tech Stack Decisions

<!-- Document why certain technologies were chosen -->

| Component | Choice | Rationale |
|-----------|--------|-----------|
| Language | [e.g., Python] | [Why] |
| Framework | [e.g., FastAPI] | [Why] |
| Database | [e.g., PostgreSQL] | [Why] |

## Key Patterns

<!-- Document established patterns -->

### API Design
- RESTful endpoints
- [Other patterns]

### Error Handling
- [How errors are handled]

### Authentication
- [Auth approach]

## Architectural Principles

<!-- Guiding principles for decisions -->

1. **Simplicity first** - Choose the simplest solution that works
2. **Explicit over implicit** - Make dependencies clear
3. **Testability** - Design for easy testing

## ADR Index

<!-- Link to ADRs as they're created -->

| # | Title | Status | Date |
|---|-------|--------|------|
| 1 | [Example: Database choice] | Accepted | YYYY-MM-DD |

## Known Constraints

<!-- Document system constraints -->

- [Constraint 1]
- [Constraint 2]

## Future Considerations

<!-- Things to think about for future scaling -->

- [ ] [Consideration 1]
- [ ] [Consideration 2]
