# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Install serve to run the static site
RUN npm install -g serve

# Copy built assets from builder
COPY --from=builder /app/dist ./dist

# Copy environment injection script
COPY inject-env.sh /app/inject-env.sh
RUN chmod +x /app/inject-env.sh

# Expose port 8080 for Cloud Run
EXPOSE 8080

# Use injection script as entrypoint
ENTRYPOINT ["/app/inject-env.sh"]

# Serve the built app on port 8080
CMD ["serve", "-s", "dist", "-l", "8080"]
