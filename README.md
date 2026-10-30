# AXORA Messenger

A mobile-first progressive web app starter for one-to-one messaging.

## Features in this MVP

- Email/password account registration and login through Firebase Authentication
- Search for another AXORA account by exact email and start a direct chat
- Realtime one-to-one text messages with Firestore
- Browser-side encryption of message bodies using ECDH P-256, HKDF-SHA-256 and AES-256-GCM
- Device-local private key storage using IndexedDB
- Safety-code fingerprint display for out-of-band verification
- Responsive mobile interface and installable PWA shell

## Required setup before first use

1. Create a project at https://console.firebase.google.com/.
2. Add a **Web app** in Firebase Project settings.
3. In **Authentication → Sign-in method**, enable **Email/Password**.
4. In **Firestore Database**, create a database.
5. Open `index.html` and replace the four placeholder values in `firebaseConfig` with your Firebase web app values: `apiKey`, `authDomain`, `projectId`, and `appId`.
6. In Firebase Firestore **Rules**, paste the complete contents of `firestore.rules` and publish the rules.
7. Host this repository over HTTPS. GitHub Pages can be enabled from **Settings → Pages → Deploy from a branch → main → /(root)**.
8. Open the HTTPS site on your phone. Create accounts on two devices using two different email addresses, then start a chat by entering the other account's exact email.

## Security limitations — read before use

This is an early MVP, **not an audited secure messenger**.

- Message text is encrypted in the browser before upload. Firestore stores ciphertext, IV, sender ID and timestamps.
- The first-time public-key exchange is not authenticated by a trusted server or signed identity. Compare the displayed safety code with your contact through a separate trusted channel.
- Private keys are stored only in the current browser's IndexedDB. Clearing site data, losing the device, or switching browsers can make old messages unreadable.
- There is no account recovery for encryption keys, no multi-device key sync, and no forward secrecy/key rotation yet.
- User profile documents (including email and public key) are readable to signed-in users to support exact-email contact lookup. Do not put sensitive profile data there.
- The current Firestore rules permit only chat members to read messages and only the sender to create their own message records. Review rules before production.
- Use HTTPS. Do not use this prototype for highly sensitive communications until a qualified security review and threat model are complete.

## Not included yet

Voice/video calls, group chats, media uploads, push notifications, blocking/reporting, admin console, account recovery, verified identity/key transparency, and Android APK packaging.

## Android

The PWA can be installed from a supported Android browser using **Add to Home screen / Install app** after HTTPS hosting. A standalone APK/AAB requires a separate Android wrapper/TWA build and signing configuration; this repository does not yet contain a ready APK.
