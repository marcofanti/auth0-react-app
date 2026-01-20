#!/bin/bash

# Auth0 React App - Docker Startup Script

echo "=================================="
echo "Auth0 React Banking Demo"
echo "=================================="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo ""
    echo "Please create a .env file with the following variables:"
    echo "  VITE_AUTH0_DOMAIN=your-domain.auth0.com"
    echo "  VITE_AUTH0_CLIENT_ID=your-client-id"
    echo ""
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running!"
    echo ""
    echo "Please start Docker and try again."
    echo ""
    exit 1
fi

# Check if docker-compose is available
if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null 2>&1; then
    COMPOSE_CMD="docker compose"
else
    echo "❌ Error: docker-compose not found!"
    echo ""
    echo "Please install Docker Compose and try again."
    echo ""
    exit 1
fi

# Stop any existing containers
echo "🧹 Stopping any existing containers..."
$COMPOSE_CMD down 2>/dev/null

# Build and start the container
echo ""
echo "🔨 Building Docker image..."
echo ""

$COMPOSE_CMD up --build

# Note: The script will stay running until you press Ctrl+C
# When you stop it, the container will be stopped automatically
