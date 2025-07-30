# Two Servers POC

A proof-of-concept project demonstrating how to run two Node.js servers (Express.js and Next.js) in a single container with nginx as a reverse proxy, suitable for deployment on Render.com.

![Working Application](https://github.com/user-attachments/assets/e6fec870-c893-4411-bc4f-dc1fda5cc705)

## Architecture

- **Proxy Server** (port 80/8080) - Routes requests to appropriate services
- **Express.js** (port 3001) - API server handling `/api/*` routes  
- **Next.js** (port 3000) - Frontend application serving the main UI
- **All services** run in a single deployment using Node.js child processes

## Project Structure

```
├── express-server/     # Express.js API server
├── nextjs-app/         # Next.js frontend application  
├── nginx/              # nginx configuration (for Docker)
├── docker/             # Docker-related files
├── render-server.js    # Proxy server for Render.com
├── Dockerfile          # Multi-stage Docker build
├── render.yaml         # Render.com deployment config
└── docker-compose.yml  # Local development
```

## API Endpoints

- `GET /api/health` - Health check endpoint
- `GET /api/users` - Get list of users
- `POST /api/users` - Create a new user
- `GET /health` - Proxy health check

## Local Development

1. Install dependencies for both servers:
```bash
npm run install:all
```

2. Build the Next.js application:
```bash
npm run build
```

3. Run the complete setup with proxy:
```bash
npm run start:render
```

The application will be available at `http://localhost:8080`

### Individual Development

Run servers individually for development:
```bash
# Terminal 1 - Express API server
npm run dev:express

# Terminal 2 - Next.js frontend  
npm run dev:nextjs
```

## Render.com Deployment

### Option 1: Using render.yaml (Recommended)

1. Connect your GitHub repository to Render.com
2. The `render.yaml` file will automatically configure the service
3. Render will use the build and start commands defined in the config

### Option 2: Manual Setup

1. Create a new Web Service on Render.com
2. Connect your GitHub repository
3. Use these settings:
   - **Build Command**: `./build.sh`
   - **Start Command**: `npm run start:render`
   - **Port**: Will be automatically assigned by Render

### Environment Variables

The application automatically uses Render's `PORT` environment variable.

## Docker Deployment

Build and run with Docker:

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

## How It Works

1. **Render.com Compatibility**: Since Render.com only allows one exposed port, we use a Node.js proxy server (`render-server.js`) that:
   - Starts both Express and Next.js servers as child processes
   - Routes `/api/*` requests to the Express server (port 3001)
   - Routes all other requests to the Next.js server (port 3000)
   - Exposes everything through a single port

2. **Docker Alternative**: For other deployment platforms, the included Docker setup uses nginx as a reverse proxy with PM2 process management.

3. **Development**: Individual servers can be run separately for easier development and debugging.

## Features

- ✅ Single deployment compatible with Render.com
- ✅ Express.js API server with CORS support
- ✅ Next.js frontend with API integration
- ✅ Reverse proxy routing (nginx for Docker, Node.js for Render)
- ✅ Health check endpoints
- ✅ Production-ready builds
- ✅ Process management and cleanup
- ✅ Environment-specific configurations