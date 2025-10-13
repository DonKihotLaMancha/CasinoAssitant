# 🔥 Firebase OAuth Setup Guide

## Real Social Login Integration

Your website now has **REAL OAuth authentication** with Google, Facebook, Apple, and Microsoft!

---

## Setup Instructions (5 minutes)

### Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click **"Add project"**
3. Name it: `BetSage` or any name
4. Disable Google Analytics (optional)
5. Click **"Create project"**

### Step 2: Enable Authentication

1. In Firebase Console, click **"Authentication"**
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab
4. Enable these providers:

#### ✅ Google
- Click **"Google"**
- Toggle **"Enable"**
- Add support email
- Click **"Save"**

#### ✅ Facebook
- Click **"Facebook"**
- Toggle **"Enable"**
- You need:
  - Facebook App ID
  - Facebook App Secret
- Get these from: https://developers.facebook.com/
  1. Create an app
  2. Add Facebook Login product
  3. Copy App ID and Secret
  4. Add OAuth redirect URI from Firebase
- Click **"Save"**

#### ✅ Apple
- Click **"Apple"**
- Toggle **"Enable"**
- You need:
  - Apple Services ID
  - Apple Team ID
  - Key ID
  - Private Key
- Get these from: https://developer.apple.com/
  1. Create Services ID
  2. Enable Sign in with Apple
  3. Configure domains and redirect URLs
  4. Create key and download
- Click **"Save"**

#### ✅ Microsoft
- Click **"Microsoft"**
- Toggle **"Enable"**
- You need:
  - Application (client) ID
  - Client secret
- Get these from: https://portal.azure.com/
  1. Register an application
  2. Add redirect URI from Firebase
  3. Create client secret
  4. Copy IDs
- Click **"Save"**

### Step 3: Get Firebase Config

1. In Firebase Console, click **⚙️ Settings** → **Project settings**
2. Scroll to **"Your apps"**
3. Click **"Web"** icon (</>) to add web app
4. Register app with nickname: `BetSage Web`
5. Copy the `firebaseConfig` object

### Step 4: Update Your Code

Open `auth/firebase-config.js` and replace:

```javascript
const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT.appspot.com",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
};
```

With your actual Firebase config values.

### Step 5: Add Authorized Domains

1. In Firebase Console → **Authentication** → **Settings** tab
2. Scroll to **"Authorized domains"**
3. Add your domains:
   - `localhost` (for testing)
   - `your-vercel-domain.vercel.app`
   - `betsage.com` (if you have custom domain)

### Step 6: Test!

1. Save all changes
2. Push to GitHub
3. Wait for Vercel deployment
4. Visit your site
5. Click any social login button
6. ✅ Real OAuth popup will appear!

---

## Features Now Available

### ✅ Google Sign-In
- One-click login with Google account
- Automatic profile photo
- Email verification

### ✅ Facebook Login
- Login with Facebook
- Access to profile info
- Secure OAuth 2.0

### ✅ Apple Sign In
- Privacy-focused login
- Hide email option
- Works on all devices

### ✅ Microsoft Account
- Enterprise-ready
- Azure AD integration
- Office 365 accounts

---

## Security Features

✅ **OAuth 2.0** - Industry standard authentication  
✅ **No password storage** - Handled by providers  
✅ **Automatic token refresh** - Sessions stay valid  
✅ **Secure redirects** - HTTPS only  
✅ **User data encryption** - Firebase handles it  

---

## Quick Test (Without Full Setup)

The code will gracefully handle missing Firebase config:
- Shows error message if Firebase not initialized
- Falls back to email/password login
- Guest mode still works

---

## Cost

**FREE** for up to:
- 10,000 phone authentications/month
- 50,000 email/password authentications/month
- Unlimited social logins (Google, Facebook, Apple, Microsoft)

Perfect for your site! 🎉

---

## Troubleshooting

### "Firebase not defined"
- Check if Firebase CDN scripts are loading
- Check browser console for errors
- Verify internet connection

### "Popup blocked"
- Allow popups for your domain
- Some browsers block OAuth popups
- Use redirect mode instead (see Firebase docs)

### "Invalid OAuth redirect URI"
- Add your domain to authorized domains in Firebase
- Check OAuth redirect URI in provider settings
- Must use HTTPS (except localhost)

---

## Next Steps

After setup:
1. Test all 4 social logins
2. Verify user data is saved
3. Check authentication persistence
4. Monitor usage in Firebase Console

---

**Status:** Ready to deploy!  
**Setup time:** 5-10 minutes  
**Cost:** FREE  
**Users:** Unlimited  

🚀 **Your site now has enterprise-grade authentication!**
