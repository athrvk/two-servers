const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const { spawn } = require('child_process');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 80;

console.log('Starting two-servers application...');

// Start Express API server
console.log('Starting Express API server...');
const expressServer = spawn('node', ['server.js'], {
  cwd: path.join(__dirname, 'express-server'),
  env: { ...process.env, PORT: 3001 },
  stdio: 'inherit'
});

// Start Next.js server
console.log('Starting Next.js server...');
const nextjsServer = spawn('npm', ['start'], {
  cwd: path.join(__dirname, 'nextjs-app'),
  env: { ...process.env, PORT: 3000 },
  stdio: 'inherit'
});

// Wait a moment for servers to start
setTimeout(() => {
  console.log('Setting up proxy routes...');
  
  // Proxy API requests to Express server
  app.use('/api', createProxyMiddleware({
    target: 'http://localhost:3001',
    changeOrigin: true,
    logLevel: 'info'
  }));

  // Health check endpoint
  app.get('/health', (req, res) => {
    res.status(200).send('healthy');
  });

  // Proxy all other requests to Next.js server
  app.use('/', createProxyMiddleware({
    target: 'http://localhost:3000',
    changeOrigin: true,
    logLevel: 'info'
  }));

  app.listen(PORT, () => {
    console.log(`Proxy server running on port ${PORT}`);
    console.log(`Express API: localhost:3001`);
    console.log(`Next.js App: localhost:3000`);
    console.log(`Proxy: localhost:${PORT}`);
  });
}, 5000);

// Handle process cleanup
process.on('SIGTERM', () => {
  console.log('Shutting down servers...');
  expressServer.kill();
  nextjsServer.kill();
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('Shutting down servers...');
  expressServer.kill();
  nextjsServer.kill();
  process.exit(0);
});