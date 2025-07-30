#!/bin/sh

echo "Starting two-servers application..."

# Install dependencies if not present
if [ ! -d "express-server/node_modules" ]; then
    echo "Installing Express dependencies..."
    cd express-server && npm install --production && cd ..
fi

if [ ! -d "nextjs-app/node_modules" ]; then
    echo "Installing Next.js dependencies..."
    cd nextjs-app && npm install && cd ..
fi

# Build Next.js if needed
if [ ! -d "nextjs-app/.next" ]; then
    echo "Building Next.js app..."
    cd nextjs-app && npm run build && cd ..
fi

# Install PM2 if not available
if ! command -v pm2 > /dev/null; then
    echo "Installing PM2..."
    npm install -g pm2
fi

# Start with PM2
echo "Starting services with PM2..."
pm2 start ecosystem.config.js

# For Render.com, we need one process to stay in foreground
# Start nginx in foreground
echo "Starting nginx in foreground..."
nginx -g 'daemon off;'