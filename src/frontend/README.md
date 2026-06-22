# Frontend - React Todo App

This folder contains the React single-page application used by the serverless Todo project.

## Local Run

```bash
npm ci
cp .env.example .env
npm start
```

Set the backend API URL in `.env`:

```env
REACT_APP_API_URL=https://your-api-id.execute-api.us-west-2.amazonaws.com
```

## Build

```bash
npm run build
```

The production build is deployed to S3 and served through CloudFront.
