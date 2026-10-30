# AXORA Messenger

A mobile-first messaging PWA starter with a separate, restricted admin console.

## Current app surfaces
- Main messenger: index.html
- Separate admin console: admin.html (same Firebase project, admin custom-claim required)
- Firestore rules: firestore.rules
- One-time admin grant script: scripts/set-admin.mjs

## Main messenger MVP
- Email/password registration and login through Firebase Authentication
- Exact-email user lookup and one-to-one chat creation
- Realtime text messages with Firestore
- Browser-side message encryption using ECDH P-256, HKDF-SHA-256 and AES-256-GCM
- Device-local private key storage using IndexedDB
- Safety-code fingerprint for out-of-band verification
- Responsive mobile interface and PWA shell

## Firebase setup
1. Create a project at https://console.firebase.google.com/ and add a Web app.
2. Enable Authentication → Email/Password.
3. Create Firestore Database.
4. Replace the Firebase web config placeholders in BOTH index.html and admin.html with the same project's apiKey, authDomain, projectId, and appId.
5. Publish the complete firestore.rules file in Firestore → Rules.
6. Host over HTTPS. Enable GitHub Pages at Settings → Pages → Build and deployment → GitHub Actions.
7. Main app: open the published site root. Admin app: open /admin.html.

## Granting the first administrator
Admin access is NOT controlled by a client-side email check. Firebase custom claims must be set using the Firebase Admin SDK from a trusted computer:
1. Create the first user account from the main AXORA app.
2. On a trusted computer with Node.js, install the Admin SDK: npm install firebase-admin.
3. Download a Firebase service-account JSON from Firebase Console → Project settings → Service accounts.
4. Save it locally as serviceAccountKey.json in the repository folder. It is excluded by .gitignore; NEVER commit, upload, or share this private key.
5. Run: node scripts/set-admin.mjs admin@example.com (replace with the exact email of the account you created).
6. Sign out and sign in again at /admin.html so the refreshed token includes the admin claim.

The admin console can show account profile metadata, aggregate counts, and reports. It does NOT provide access to chat documents or encrypted message contents. The reports table will remain empty until a report-submission feature is added to the main app.

## Admin console scope and limitations
- Separate admin login and dashboard, verified using Firebase's server-set admin custom claim.
- Account directory shows profile metadata only.
- Dashboard counts are limited to the first 500 users/chats and latest 100 reports in this starter.
- Report resolution is supported for report documents.
- Account blocking/suspension controls are not enabled in this version; they require corresponding enforcement in the main app and authentication/rules design.
- This is a starter console, not a complete moderation or audit platform.

## Security limitations
This is an early MVP, not an audited secure messenger.
- The first-time public-key exchange is not authenticated by a trusted server or signed identity. Compare safety codes out-of-band.
- Private keys are stored only in the current browser's IndexedDB. Clearing site data or changing devices can make old messages unreadable.
- No key recovery, multi-device key sync, forward secrecy, or key rotation.
- User profile documents (including email and public key) are readable to signed-in users for exact-email contact lookup. Do not put sensitive data there.
- Firestore chat/message rules allow only chat members to read messages. Admin custom claims do not grant chat/message access.
- The Admin SDK service-account key has powerful project access. Keep it private and use it only on a trusted computer.
- Use HTTPS and obtain a qualified security review before production or highly sensitive use.

## Not included yet
Voice/video calls, group chats, media uploads, push notifications, status/stories, online presence, message reply/forward, account recovery, verified identity/key transparency, and Android APK packaging.

## Android
The PWA can be installed from a supported Android browser using Add to Home screen / Install app after HTTPS hosting. A standalone APK/AAB requires a separate Android wrapper/TWA build and signing configuration; no ready APK is included.
