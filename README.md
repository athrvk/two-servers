# Two Servers POC

A proof-of-concept project demonstrating how to run two Node.js servers (Express.js and Next.js) in a single Docker container with nginx as a reverse proxy, suitable for deployment on Render.com.

## Architecture

- **nginx** (port 80) - Reverse proxy that routes requests
- **Express.js** (port 3001) - API server handling `/api/*` routes
- **Next.js** (port 3000) - Frontend application serving the main UI
- **PM2** - Process manager to handle multiple Node.js processes

## Project Structure

```
├── express-server/     # Express.js API server
├── nextjs-app/         # Next.js frontend application  
├── nginx/              # nginx configuration
├── docker/             # Docker-related files
├── Dockerfile          # Multi-stage Docker build
└── docker-compose.yml  # Local development
```

## Local Development

1. Install dependencies for both servers:
```bash
npm run install:all
```

2. Run servers individually for development:
```bash
# Terminal 1 - Express API server
npm run dev:express

# Terminal 2 - Next.js frontend
npm run dev:nextjs
```

## Docker Deployment

Build and run the complete setup:

```bash
# Build the Docker image
npm run docker:build

# Run the container
npm run docker:run
```

Or use docker-compose:

```bash
docker-compose up --build
```

The application will be available at `http://localhost`

## Render.com Deployment

1. Connect your GitHub repository to Render.com
2. Create a new Web Service
3. Use the following settings:
   - **Build Command**: `npm run build` (optional, Docker handles the build)
   - **Start Command**: Not needed (Docker handles startup)
   - **Port**: 80

The Dockerfile is optimized for production deployment and follows Render.com requirements.

## API Endpoints

- `GET /api/health` - Health check endpoint
- `GET /api/users` - Get list of users
- `POST /api/users` - Create a new user

## Features

- Single container deployment
- nginx reverse proxy routing
- Production-ready Docker build
- PM2 process management
- Health check endpoints
- Render.com compatible