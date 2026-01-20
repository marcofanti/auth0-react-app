# Docker Deployment Guide

## Quick Start

### Option 1: Using Docker Compose (Recommended)

1. Make sure your `.env` file has the Auth0 credentials:
```bash
VITE_AUTH0_DOMAIN=your-domain.auth0.com
VITE_AUTH0_CLIENT_ID=your-client-id
```

2. Build and run:
```bash
docker-compose up --build
```

3. Open http://localhost:8080

### Option 2: Using Docker Commands

1. Build the image:
```bash
docker build -t auth0-react-app .
```

2. Run the container with environment variables:
```bash
docker run -p 8080:8080 \
  -e VITE_AUTH0_DOMAIN=your-domain.auth0.com \
  -e VITE_AUTH0_CLIENT_ID=your-client-id \
  auth0-react-app
```

3. Open http://localhost:8080

## Stopping the Container

### Docker Compose:
```bash
docker-compose down
```

### Docker:
```bash
docker ps  # Find the container ID
docker stop <container-id>
```

## Rebuilding After Code Changes

### Docker Compose:
```bash
docker-compose up --build
```

### Docker:
```bash
docker build -t auth0-react-app .
docker run -p 8080:8080 \
  -e VITE_AUTH0_DOMAIN=your-domain.auth0.com \
  -e VITE_AUTH0_CLIENT_ID=your-client-id \
  auth0-react-app
```

## Auth0 Configuration

Make sure your Auth0 application has the following URLs configured:

- **Allowed Callback URLs**: `http://localhost:8080`
- **Allowed Logout URLs**: `http://localhost:8080`
- **Allowed Web Origins**: `http://localhost:8080`

## Troubleshooting

**Blank page:**
- Check container logs: `docker logs <container-id>` or `docker-compose logs`
- Verify environment variables are set correctly
- Check Auth0 callback URLs include http://localhost:8080

**Port already in use:**
```bash
# Find what's using port 8080
lsof -i :8080

# Kill the process
kill <PID>

# Or use a different port
docker run -p 3000:8080 ...
```

**Container won't start:**
```bash
# Check logs
docker logs <container-id>

# Or with compose
docker-compose logs
```
