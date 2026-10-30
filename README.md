# AXORA Messenger

AXORA is a mobile-first messaging app starter.

## Current status

This repository is being initialized. The app requires a Firebase project before account registration and messaging can work.

## Setup

1. Create a Firebase project at https://console.firebase.google.com/.
2. Register a Web app in the Firebase project.
3. Enable Email/Password in Authentication.
4. Create a Firestore database.
5. Copy the Firebase web configuration into `index.html`.
6. Deploy the Firestore rules from `firestore.rules`.
7. Host the repository with HTTPS (for example, GitHub Pages or Firebase Hosting).

## Security notes

- Message bodies are encrypted in the browser using Web Crypto before being written to Firestore.
- This is an MVP implementation, not an audited secure messenger.
- The initial key exchange is not independently authenticated. Verify safety codes with your contact over a separate trusted channel.
- Browser-local private keys are not backed up; clearing browser data or changing devices can make old messages unreadable.
- Do not use this starter for sensitive communications until it has had a professional security review.

## Planned

- Android packaging (PWA/TWA or native wrapper)
- Push notifications
- Media messages and group chats
- Account recovery and multi-device key management
- Abuse reporting and blocking
