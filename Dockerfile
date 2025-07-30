FROM node:18-alpine AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Install dependencies for both servers
COPY express-server/package*.json ./express-server/
COPY nextjs-app/package*.json ./nextjs-app/

RUN cd express-server && npm ci --only=production
RUN cd nextjs-app && npm ci --only=production

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/express-server/node_modules ./express-server/node_modules
COPY --from=deps /app/nextjs-app/node_modules ./nextjs-app/node_modules
COPY express-server ./express-server
COPY nextjs-app ./nextjs-app

# Build Next.js app
RUN cd nextjs-app && npm run build

# Production image, copy all the files and run next
FROM nginx:alpine AS runner
WORKDIR /app

# Install Node.js and PM2
RUN apk add --no-cache nodejs npm
RUN npm install -g pm2

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy built applications
COPY --from=builder /app/express-server ./express-server
COPY --from=deps /app/express-server/node_modules ./express-server/node_modules

COPY --from=builder --chown=nextjs:nodejs /app/nextjs-app/.next/standalone ./nextjs-app/
COPY --from=builder --chown=nextjs:nodejs /app/nextjs-app/.next/static ./nextjs-app/.next/static
COPY --from=builder --chown=nextjs:nodejs /app/nextjs-app/public ./nextjs-app/public

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy startup script
COPY docker/start.sh ./start.sh
RUN chmod +x ./start.sh

EXPOSE 80

CMD ["./start.sh"]