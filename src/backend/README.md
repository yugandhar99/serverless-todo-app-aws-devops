# Backend - Serverless Todo API

This folder contains Node.js Lambda handlers for the Todo CRUD API.

## Functions

| File | API Route | Purpose |
|---|---|---|
| `list.mjs` | `GET /todos` | List todo items |
| `create.mjs` | `POST /todos` | Create todo item |
| `get.mjs` | `GET /todos/{id}` | Get todo by ID |
| `update.mjs` | `PUT /todos/{id}` | Update todo item |
| `delete.mjs` | `DELETE /todos/{id}` | Delete todo item |

## Improvements

- JSON API responses
- Request validation
- 404 handling for missing items
- Conditional DynamoDB writes/deletes
- Structured CloudWatch-friendly logs
- CORS headers controlled by environment variable
- Node.js built-in test runner

## Local Validation

```bash
npm ci
npm run validate
```
