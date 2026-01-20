import React from "react";
import ReactDOM from "react-dom/client";
import { Auth0Provider } from "@auth0/auth0-react";
import App from "./App.tsx";
import "./index.css";

// Support both build-time (Vite) and runtime (Cloud Run) configuration
interface EnvConfig {
  VITE_AUTH0_DOMAIN?: string;
  VITE_AUTH0_CLIENT_ID?: string;
  [key: string]: string | undefined;
}

declare global {
  interface Window {
    ENV_CONFIG?: EnvConfig;
  }
}

const getEnvVar = (key: string): string => {
  // Try runtime config first (for Cloud Run)
  if (typeof window !== 'undefined' && window.ENV_CONFIG) {
    const runtimeValue = window.ENV_CONFIG[key];
    if (runtimeValue && !runtimeValue.startsWith('__')) {
      return runtimeValue;
    }
  }
  // Fall back to build-time config (for local development)
  return import.meta.env[key] || '';
};

const domain = getEnvVar('VITE_AUTH0_DOMAIN');
const clientId = getEnvVar('VITE_AUTH0_CLIENT_ID');

// Validate Auth0 configuration
if (!domain || !clientId) {
  console.error("Auth0 configuration missing. Please check your .env file.");
  console.error("Required environment variables:");
  console.error("- VITE_AUTH0_DOMAIN");
  console.error("- VITE_AUTH0_CLIENT_ID");
  throw new Error("Auth0 domain and client ID must be set in .env file");
}

// Validate domain format
if (!domain.includes('.auth0.com') && !domain.includes('.us.auth0.com') && !domain.includes('.eu.auth0.com') && !domain.includes('.au.auth0.com')) {
  console.warn("Auth0 domain format might be incorrect. Expected format: your-domain.auth0.com");
}

const rootElement = document.getElementById("root");
if (!rootElement) {
  throw new Error("Root element not found");
}

const onRedirectCallback = (appState?: { returnTo?: string }) => {
  window.history.replaceState(
    {},
    document.title,
    appState?.returnTo || window.location.pathname
  );
};

ReactDOM.createRoot(rootElement).render(
  <React.StrictMode>
    <Auth0Provider
      domain={domain}
      clientId={clientId}
      authorizationParams={{
        redirect_uri: window.location.origin,
      }}
      onRedirectCallback={onRedirectCallback}
    >
      <App />
    </Auth0Provider>
  </React.StrictMode>
);
