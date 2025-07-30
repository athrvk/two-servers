#!/bin/sh

echo "Starting two-servers application..."

# Start Express server with PM2
echo "Starting Express API server..."
cd /app/express-server
PORT=3001 pm2 start server.js --name "express-api" --no-daemon &

# Start Next.js server with PM2  
echo "Starting Next.js frontend..."
cd /app/nextjs-app
PORT=3000 pm2 pm2 start npm --name "nextjs-app" --no-daemon  --  start &

# Wait a bit for servers to start
sleep 5

# Start nginx in foreground (this will keep the container running)
echo "Starting nginx..."
echo "All services started. Application available on port 80"
echo "Express API: localhost:3001"
echo "Next.js App: localhost:3000" 
echo "nginx Proxy: localhost:80"

exec nginx -g 'daemon off;'