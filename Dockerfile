# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application (without env vars - will be injected at runtime)
RUN npm run build

# Production stage
FROM node:20-alpine

WORKDIR /app

# Install serve globally
RUN npm install -g serve

# Copy built app
COPY --from=builder /app/dist ./dist

# Copy environment injection script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Expose port 8080
EXPOSE 8080

# Use custom entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

# Start serve
CMD ["serve", "-s", "dist", "-l", "8080"]
