#!/bin/sh
set -e  # Exit on any error

echo "Starting two-servers application..."

# Start Express server with PM2
echo "Starting Express API server..."
cd /app/express-server
PORT=3001 HOST=0.0.0.0 pm2 start npm --name "express-api" --no-daemon -- start &
EXPRESS_PID=$!

# Start Next.js server with PM2  
echo "Starting Next.js frontend..."
cd /app/nextjs-app
PORT=3000 HOST=0.0.0.0 pm2 start npm --name "nextjs-app" --no-daemon -- start &
NEXTJS_PID=$!

# Wait for servers to start
echo "Waiting for services to start..."
sleep 10

# Check if services are running
echo "Checking service status..."
pm2 list

# Test connectivity (optional - comment out if causing issues)
echo "Testing services..."
curl -f http://127.0.0.1:3001/api/health > /dev/null 2>&1 && echo "✓ Express API is responding" || echo "⚠ Express API not responding"
curl -f http://127.0.0.1:3000/ > /dev/null 2>&1 && echo "✓ Next.js app is responding" || echo "⚠ Next.js app not responding"

# Start nginx in foreground (this will keep the container running)
echo "Starting nginx..."
echo "All services started. Application available on port 80"
echo "Express API: localhost:3001"
echo "Next.js App: localhost:3000" 
echo "nginx Proxy: localhost:80"

exec nginx -g 'daemon off;'