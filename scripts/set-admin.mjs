// Run locally once with Node.js after installing firebase-admin:
//   npm install firebase-admin
// Download a Firebase service-account JSON from Firebase Console > Project settings > Service accounts.
// Save it as ./serviceAccountKey.json (NEVER upload this file to GitHub).
// Usage: node scripts/set-admin.mjs admin@example.com
import { initializeApp, cert } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { readFile } from "node:fs/promises";
const email = process.argv[2];
if (!email) throw new Error("Usage: node scripts/set-admin.mjs admin@example.com");
const serviceAccount = JSON.parse(await readFile(new URL("../serviceAccountKey.json", import.meta.url), "utf8"));
initializeApp({ credential: cert(serviceAccount) });
const user = await getAuth().getUserByEmail(email);
await getAuth().setCustomUserClaims(user.uid, { admin: true });
console.log("Admin claim granted to:", user.email, "UID:", user.uid);
console.log("Ask this user to sign out and sign in again to refresh the ID token.");
