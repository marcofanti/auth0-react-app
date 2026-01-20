# Deployment Guide

## Google Cloud Run Deployment

This application is configured to deploy to Google Cloud Run with runtime environment variable injection.

### Prerequisites

1. Google Cloud SDK installed (`gcloud` CLI)
2. Authenticated with Google Cloud: `gcloud auth login`
3. Project selected: `gcloud config set project YOUR_PROJECT_ID`

### Step 1: Configure Auth0

In your Auth0 Dashboard, add your Cloud Run URL to the application settings:

1. Go to **Applications** → **Applications** → Select your app
2. Add to **Allowed Callback URLs**: `https://your-app-name-xyz.a.run.app`
3. Add to **Allowed Logout URLs**: `https://your-app-name-xyz.a.run.app`
4. Add to **Allowed Web Origins**: `https://your-app-name-xyz.a.run.app`
5. Click **Save Changes**

### Step 2: Build and Deploy

```bash
# Set your project ID
export PROJECT_ID="your-gcp-project-id"

# Build the container
gcloud builds submit --tag gcr.io/$PROJECT_ID/auth0-react-app

# Deploy to Cloud Run with environment variables
gcloud run deploy auth0-react-app \
  --image gcr.io/$PROJECT_ID/auth0-react-app \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-env-vars VITE_AUTH0_DOMAIN=your-domain.auth0.com \
  --set-env-vars VITE_AUTH0_CLIENT_ID=your-client-id \
  --port 8080
```

### Step 3: Update Auth0 with the Deployed URL

After deployment, Cloud Run will give you a URL like `https://auth0-react-app-xyz.a.run.app`

Go back to Auth0 and update the URLs with your actual Cloud Run URL.

### Using Secrets Manager (Recommended)

For better security, use Google Cloud Secret Manager instead of environment variables:

```bash
# Create secrets
echo -n "your-domain.auth0.com" | gcloud secrets create auth0-domain --data-file=-
echo -n "your-client-id" | gcloud secrets create auth0-client-id --data-file=-

# Deploy with secrets
gcloud run deploy auth0-react-app \
  --image gcr.io/$PROJECT_ID/auth0-react-app \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --set-secrets VITE_AUTH0_DOMAIN=auth0-domain:latest \
  --set-secrets VITE_AUTH0_CLIENT_ID=auth0-client-id:latest \
  --port 8080
```

### Updating Environment Variables

To update environment variables without rebuilding:

```bash
gcloud run services update auth0-react-app \
  --set-env-vars VITE_AUTH0_DOMAIN=new-domain.auth0.com \
  --set-env-vars VITE_AUTH0_CLIENT_ID=new-client-id
```

### Troubleshooting

**Blank page after deployment:**
- Check Cloud Run logs: `gcloud run services logs read auth0-react-app`
- Verify environment variables are set: `gcloud run services describe auth0-react-app`
- Ensure Auth0 callback URLs include your Cloud Run URL

**Authentication errors:**
- Verify Auth0 domain and client ID are correct
- Check Auth0 Application settings for allowed URLs
- Review browser console for specific Auth0 error messages

### Local Testing with Docker

```bash
# Build the image
docker build -t auth0-react-app .

# Run locally with environment variables
docker run -p 8080:8080 \
  -e VITE_AUTH0_DOMAIN=your-domain.auth0.com \
  -e VITE_AUTH0_CLIENT_ID=your-client-id \
  auth0-react-app
```

Visit http://localhost:8080 to test.
