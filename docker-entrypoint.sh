#!/bin/sh

# Docker entrypoint script to inject environment variables at runtime

echo "==================================="
echo "Auth0 React App - Docker Container"
echo "==================================="
echo ""

CONFIG_FILE="/app/dist/config.js"

# Check if environment variables are provided
if [ -z "$VITE_AUTH0_DOMAIN" ] || [ -z "$VITE_AUTH0_CLIENT_ID" ]; then
    echo "⚠️  WARNING: Environment variables not set!"
    echo ""
    echo "Required environment variables:"
    echo "  - VITE_AUTH0_DOMAIN"
    echo "  - VITE_AUTH0_CLIENT_ID"
    echo ""
    echo "The application may not work correctly."
    echo ""
else
    echo "✓ Environment variables detected"
    echo "  VITE_AUTH0_DOMAIN: $VITE_AUTH0_DOMAIN"
    echo "  VITE_AUTH0_CLIENT_ID: ${VITE_AUTH0_CLIENT_ID:0:10}..."
    echo ""
fi

# Inject environment variables into config.js
if [ -f "$CONFIG_FILE" ]; then
    echo "Injecting environment variables into config.js..."

    sed -i "s|__VITE_AUTH0_DOMAIN__|${VITE_AUTH0_DOMAIN:-}|g" "$CONFIG_FILE"
    sed -i "s|__VITE_AUTH0_CLIENT_ID__|${VITE_AUTH0_CLIENT_ID:-}|g" "$CONFIG_FILE"

    echo "✓ Environment variables injected"
else
    echo "❌ ERROR: config.js not found at $CONFIG_FILE"
    exit 1
fi

echo ""
echo "Starting server on port 8080..."
echo "==================================="
echo ""

# Execute the main container command
exec "$@"
