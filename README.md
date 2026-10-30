# AXORA Messenger
Mobile-first messenger on GitHub Pages using Supabase Auth + Postgres Realtime. Firebase is removed from the application.

## Included now
- Google OAuth and email/password authentication
- User profile creation and email lookup
- Direct conversations and realtime text messages
- Separate admin login and dashboard for user metadata, conversation totals and reports
- Row Level Security; admin does not have SELECT access to message bodies

## Required one-time setup by owner
1. Create a project at https://supabase.com/dashboard.
2. In Project Settings > API copy Project URL and anon/public key.
3. Replace YOUR_SUPABASE_PROJECT_URL and YOUR_SUPABASE_ANON_KEY in BOTH index.html and admin.html. Never put service_role key in browser code.
4. Run all of supabase-schema.sql in Supabase SQL Editor.
5. In Supabase Authentication > Providers enable Google and configure Google OAuth Client ID and Secret. Add the Supabase callback URL shown there to Google Cloud OAuth redirect URIs. Add https://hamzaali000000071-cmd.github.io/Axora/ to Supabase Auth URL Configuration > Redirect URLs.
6. Enable Email provider. If email confirmation is enabled, users must confirm their email before login.
7. Create your own account, then run the final admin-promotion SQL comment in supabase-schema.sql with your exact email.
8. GitHub Pages deploys after commit. Main app: https://hamzaali000000071-cmd.github.io/Axora/ ; Admin: https://hamzaali000000071-cmd.github.io/Axora/admin.html

## Scope
Available after setup: Google/email sign-in, profiles, direct one-to-one realtime text chat, admin metadata dashboard.
Not yet implemented: group-chat UI, media/file sharing, voice/video, push notifications, typing/presence, reactions/edit/delete, end-to-end encryption. This is an initial MVP, not audited production software.

## Privacy
Admin dashboard does not read message records. Message SELECT policy is limited to conversation members. Keep the Supabase service_role key secret; browser code uses only the anon/public key. Review policies and OAuth settings before inviting users.
