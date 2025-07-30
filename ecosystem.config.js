module.exports = {
  apps: [
    {
      name: 'express-api',
      script: './express-server/server.js',
      env: {
        PORT: 3001,
        NODE_ENV: 'production'
      }
    },
    {
      name: 'nextjs-app',
      script: './nextjs-app/server.js',
      env: {
        PORT: 3000,
        NODE_ENV: 'production'
      }
    }
  ]
};