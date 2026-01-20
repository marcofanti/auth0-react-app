# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a financial application demo built with React, TypeScript, and Vite, featuring Auth0 authentication. The application demonstrates modern banking UX patterns with a landing page for unauthenticated users and a dashboard for authenticated users.

## Tech Stack

- **Frontend Framework**: React 19.2.0 with TypeScript
- **Build Tool**: Vite 7.2.4
- **Routing**: React Router DOM 7.12.0
- **Authentication**: Auth0 React SDK (@auth0/auth0-react)
- **Styling**: CSS (index.css, component-specific CSS files)
- **Dev Server Port**: 8080 (configured in vite.config.ts:8)

## Environment Configuration

Auth0 credentials are configured via environment variables in `.env`:
- `VITE_AUTH0_DOMAIN` - Auth0 tenant domain
- `VITE_AUTH0_CLIENT_ID` - Auth0 application client ID

The app validates these at startup in src/main.tsx:11-22.

## Key Directories & Files

- **src/** - Application source code
  - **main.tsx** - Entry point, Auth0Provider setup with redirect callback
  - **App.tsx** - Main routing component with BrowserRouter, contains landing page for unauthenticated users
  - **Dashboard.tsx** - Main authenticated dashboard with bank accounts, transactions, and insights
  - **Profile.tsx** - User profile display component
  - **Shipping.tsx** - Additional route for shipping-related content
  - **LoginButton.tsx / LogoutButton.tsx** - Auth0 authentication action components
  - **index.css** - Global styles and design system
  - **App.backup.tsx** - Backup of previous landing page implementation

## Authentication Flow

The app uses Auth0's Universal Login:
1. Auth0Provider wraps the app in main.tsx:39-48
2. App.tsx:7 uses `useAuth0()` hook to check authentication state
3. Unauthenticated users see landing page (App.tsx:38-307)
4. Authenticated users are redirected to Dashboard (App.tsx:34)
5. Login triggers `loginWithRedirect()` (can pass `screen_hint: 'signup'` for signup flow)
6. Logout uses `logout({ logoutParams: { returnTo: window.location.origin } })`

## Component Architecture

### Conditional Rendering Pattern
All main components check authentication state before rendering:
```typescript
const { isAuthenticated, isLoading, user } = useAuth0();
if (isLoading) return <LoadingSpinner />;
if (isAuthenticated) return <AuthenticatedView />;
return <UnauthenticatedView />;
```

### Data Structure
Dashboard uses demo data structures defined at the top of Dashboard.tsx:
- `bankAccounts` (Dashboard.tsx:5-35) - Account objects with id, name, type, balance, etc.
- `recentTransactions` (Dashboard.tsx:38-95) - Transaction objects with id, description, category, amount
- `categoryIcons` (Dashboard.tsx:98-106) - SVG path mapping for transaction categories

## Styling Approach

The app uses a modern dark theme for landing pages (#0a1628 background) and a light theme for the authenticated dashboard. CSS is organized in:
- **index.css** - Global styles, design system, all component styles
- **Shipping.css** - Shipping page specific styles
- Component styles use BEM-like naming: `.dashboard-nav`, `.account-card`, `.transaction-item`

Key design patterns:
- Custom properties for colors, spacing not used - hardcoded values
- Responsive grid layouts for features and accounts
- SVG icons inline in components
- Animations for loading states (spinner, glow effects)

## Build & Development Commands

```bash
# Development server (runs on port 8080)
npm run dev

# Build for production (TypeScript check + Vite build)
npm run build

# Lint with ESLint
npm run lint

# Preview production build
npm run preview
```

## Development Notes

### TypeScript Configuration
- **tsconfig.json** - Base config
- **tsconfig.app.json** - App-specific settings
- **tsconfig.node.json** - Node/Vite config settings

### ESLint Configuration
Standard setup with React hooks and refresh plugins. Type-aware linting is NOT enabled (see README.md:16-44 for upgrade path if needed).

### Adding New Routes
1. Create new component in src/
2. Add route in App.tsx:312-317 within BrowserRouter
3. Import component at top of App.tsx

### Auth0 Integration Points
- Initial setup: main.tsx:37-49
- Authentication checks: Use `useAuth0()` hook in any component
- Redirect URI: Set to `window.location.origin` (main.tsx:43)
- Custom redirect handling: `onRedirectCallback` in main.tsx:29-35

### Working with Demo Data
To modify accounts or transactions, edit the constants at the top of Dashboard.tsx:
- Bank accounts: Dashboard.tsx:5-35
- Transactions: Dashboard.tsx:38-95
- Category icons: Dashboard.tsx:98-106

## Common Tasks

### Modifying the Landing Page
The landing page is in App.tsx, HomePage component (lines 6-308). It includes:
- Navigation with logo and auth buttons
- Hero section with preview card
- Features grid (6 features)
- Security section
- CTA section
- Footer

### Modifying the Dashboard
Dashboard.tsx contains tabbed interface:
- Accounts tab: Account cards, insights panel, spending breakdown
- Transactions tab: Transaction list with category icons
- Tab switching: `activeTab` state (Dashboard.tsx:110)

### Updating Styles
All styles are in index.css. Search for component class names:
- Landing page: `.landing-page`, `.hero-section`, `.features-section`
- Dashboard: `.dashboard`, `.account-card`, `.transaction-item`
