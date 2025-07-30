#!/bin/sh

echo "Building the application for Render.com..."

# Install dependencies for both servers
echo "Installing Express dependencies..."
cd express-server && npm ci --production && cd ..

echo "Installing Next.js dependencies..."
cd nextjs-app && npm ci && cd ..

# Build Next.js
echo "Building Next.js app..."
cd nextjs-app && npm run build && cd ..

echo "Build completed!"