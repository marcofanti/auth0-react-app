#!/bin/bash

# Auth0 React App - Development Server Startup Script

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

# Check if node_modules exists
if [ ! -d node_modules ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo ""
fi

# Start the development server
echo "🚀 Starting development server on http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

npm run dev
