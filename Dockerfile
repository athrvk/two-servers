FROM nginx:alpine

# Install Node.js and npm
RUN apk add --no-cache nodejs npm

# Install PM2 globally
RUN npm install -g pm2

# Set working directory
WORKDIR /app

# Copy application files
COPY express-server ./express-server
COPY nextjs-app ./nextjs-app

# Install dependencies and build
RUN cd express-server && npm install --production
RUN cd nextjs-app && npm install && npm run build

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy startup script
COPY docker/start.sh ./start.sh
RUN chmod +x ./start.sh

# Create user for Next.js
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Set ownership for nextjs files
RUN chown -R nextjs:nodejs ./nextjs-app

ENV NODE_ENV=production

EXPOSE 80

CMD ["./start.sh"]