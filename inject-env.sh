#!/bin/bash

# Inject environment variables into config.js at runtime
# This script runs when the Cloud Run container starts

CONFIG_FILE="/app/dist/config.js"

# Check if running in production (Cloud Run)
if [ -f "$CONFIG_FILE" ]; then
    echo "Injecting environment variables into config.js..."

    # Replace placeholders with actual environment variables
    sed -i "s|__VITE_AUTH0_DOMAIN__|${VITE_AUTH0_DOMAIN}|g" "$CONFIG_FILE"
    sed -i "s|__VITE_AUTH0_CLIENT_ID__|${VITE_AUTH0_CLIENT_ID}|g" "$CONFIG_FILE"

    echo "Environment variables injected successfully"
else
    echo "Warning: config.js not found at $CONFIG_FILE"
    echo "This is normal for local development"
fi

# Start the web server
exec "$@"
