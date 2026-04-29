# Muscle Log

Personal workout logging PWA.

## Current Status

- Single-file app: `index.html`
- PWA files: `manifest.json`, `sw.js`, app icons
- Local-first storage with `localStorage`
- Optional Supabase sync through the settings screen
- Supabase schema: `supabase-muscle-log.sql`

## Local Check

Serve the folder with any static HTTP server, then open the local URL.

```bash
python3 -m http.server 4187
```

Recommended verification after edits:

```bash
node --check sw.js
node -e "const fs=require('fs');const html=fs.readFileSync('index.html','utf8');const scripts=[...html.matchAll(/<script[^>]*>([\s\S]*?)<\/script>/gi)].map(m=>m[1].trim()).filter(Boolean);for(const script of scripts)new Function(script);console.log('inline scripts ok:', scripts.length);"
git diff --check
```

## Supabase Setup

1. Create or open the personal Supabase project for Muscle Log.
2. Run `supabase-muscle-log.sql` in the Supabase SQL editor.
3. Confirm email/password auth is enabled.
4. In the app settings screen, sign up or log in with the Muscle Log user account.

The app currently keeps the Supabase project URL and anon key in `index.html`. Do not put service role keys or personal passwords in the app code.
