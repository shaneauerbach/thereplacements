# Engineer Context

Project-specific knowledge for the Engineer agent. **Customize this file for your project.**

## Tech Stack

<!-- Update with your actual tech stack -->

- **Language:** Python 3.11+ / TypeScript / etc.
- **Framework:** FastAPI / Next.js / etc.
- **Database:** PostgreSQL / MongoDB / etc.
- **Testing:** pytest / Jest / etc.
- **CI/CD:** GitHub Actions

## Project Structure

<!-- Update with your actual project structure -->

```
src/
├── api/          # API endpoints
├── models/       # Data models
├── services/     # Business logic
└── utils/        # Helpers
tests/
├── unit/         # Unit tests
└── integration/  # Integration tests
```

## Key Patterns

<!-- Document important patterns used in your codebase -->

### Example: Error Handling
```python
# Use custom exceptions
raise NotFoundError(f"User {user_id} not found")

# Don't use generic exceptions
raise Exception("User not found")  # Bad
```

### Example: Async Patterns
```python
# Use async for I/O
async def fetch_data():
    async with httpx.AsyncClient() as client:
        return await client.get(url)
```

## Current Focus

<!-- Update as priorities change -->

- Current milestone: [Milestone name]
- Current priority: [What's most important right now]

## Important Files

<!-- List files that are frequently modified or important to understand -->

- `src/config.py` - Configuration management
- `src/api/routes.py` - API route definitions
- `tests/conftest.py` - Test fixtures

## Known Issues / Tech Debt

<!-- Track known issues the engineer should be aware of -->

- [ ] Example: Need to refactor authentication module
- [ ] Example: Test coverage is low in src/services/
