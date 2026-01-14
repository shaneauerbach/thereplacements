# QA Context

Project-specific testing knowledge. **Customize this file for your project.**

## Testing Stack

<!-- Update with your actual testing tools -->

- **Framework:** pytest / Jest / etc.
- **Coverage:** pytest-cov / c8 / etc.
- **Mocking:** unittest.mock / jest.mock / etc.
- **Fixtures:** conftest.py / setupTests.js / etc.

## Test Structure

<!-- Update with your actual test structure -->

```
tests/
├── conftest.py       # Shared fixtures
├── unit/             # Unit tests
│   ├── test_models.py
│   └── test_services.py
├── integration/      # Integration tests
│   └── test_api.py
└── fixtures/         # Test data
    └── sample_data.json
```

## Key Testing Patterns

<!-- Document testing patterns used in your codebase -->

### Example: Async Test Pattern
```python
@pytest.mark.asyncio
async def test_fetch_data():
    result = await fetch_data()
    assert result is not None
```

### Example: Mocking External APIs
```python
@pytest.fixture
def mock_api(mocker):
    return mocker.patch('src.client.api_call', return_value={'status': 'ok'})
```

## Test Coverage Goals

<!-- Set your coverage targets -->

- Overall: 80%+
- Core business logic: 90%+
- API endpoints: 85%+

## Known Test Issues

<!-- Track flaky tests or test debt -->

- [ ] Example: `test_concurrent_access` is occasionally flaky
- [ ] Example: Need more integration tests for auth flow

## Security Testing Focus

<!-- List areas requiring security attention -->

- Authentication flows
- API input validation
- File upload handling
- SQL/NoSQL queries
