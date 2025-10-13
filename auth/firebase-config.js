// Firebase Configuration for Social Authentication
// Real OAuth integration with Google, Facebook, Apple, Microsoft

// Firebase configuration
const firebaseConfig = {
    apiKey: "YOUR_API_KEY", // Replace with your Firebase API key
    authDomain: "YOUR_PROJECT.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT.appspot.com",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
};

// Initialize Firebase (will be loaded from CDN)
let auth;
let googleProvider;
let facebookProvider;
let appleProvider;
let microsoftProvider;

function initializeFirebase() {
    if (typeof firebase !== 'undefined') {
        firebase.initializeApp(firebaseConfig);
        auth = firebase.auth();
        
        // Initialize providers
        googleProvider = new firebase.auth.GoogleAuthProvider();
        facebookProvider = new firebase.auth.FacebookAuthProvider();
        appleProvider = new firebase.auth.OAuthProvider('apple.com');
        microsoftProvider = new firebase.auth.OAuthProvider('microsoft.com');
        
        // Configure providers
        googleProvider.addScope('profile');
        googleProvider.addScope('email');
        
        facebookProvider.addScope('email');
        facebookProvider.addScope('public_profile');
        
        appleProvider.addScope('email');
        appleProvider.addScope('name');
        
        microsoftProvider.addScope('User.Read');
        
        return true;
    }
    return false;
}

// Social Login Functions
async function signInWithGoogle() {
    try {
        const result = await auth.signInWithPopup(googleProvider);
        const user = result.user;
        
        // Save user data
        const userData = {
            uid: user.uid,
            username: user.displayName || 'Google User',
            email: user.email,
            photoURL: user.photoURL,
            provider: 'google',
            loginTime: Date.now()
        };
        
        localStorage.setItem('currentUser', JSON.stringify(userData));
        return { success: true, user: userData };
    } catch (error) {
        console.error('Google sign-in error:', error);
        return { success: false, error: error.message };
    }
}

async function signInWithFacebook() {
    try {
        const result = await auth.signInWithPopup(facebookProvider);
        const user = result.user;
        
        const userData = {
            uid: user.uid,
            username: user.displayName || 'Facebook User',
            email: user.email,
            photoURL: user.photoURL,
            provider: 'facebook',
            loginTime: Date.now()
        };
        
        localStorage.setItem('currentUser', JSON.stringify(userData));
        return { success: true, user: userData };
    } catch (error) {
        console.error('Facebook sign-in error:', error);
        return { success: false, error: error.message };
    }
}

async function signInWithApple() {
    try {
        const result = await auth.signInWithPopup(appleProvider);
        const user = result.user;
        
        const userData = {
            uid: user.uid,
            username: user.displayName || 'Apple User',
            email: user.email,
            photoURL: user.photoURL,
            provider: 'apple',
            loginTime: Date.now()
        };
        
        localStorage.setItem('currentUser', JSON.stringify(userData));
        return { success: true, user: userData };
    } catch (error) {
        console.error('Apple sign-in error:', error);
        return { success: false, error: error.message };
    }
}

async function signInWithMicrosoft() {
    try {
        const result = await auth.signInWithPopup(microsoftProvider);
        const user = result.user;
        
        const userData = {
            uid: user.uid,
            username: user.displayName || 'Microsoft User',
            email: user.email,
            photoURL: user.photoURL,
            provider: 'microsoft',
            loginTime: Date.now()
        };
        
        localStorage.setItem('currentUser', JSON.stringify(userData));
        return { success: true, user: userData };
    } catch (error) {
        console.error('Microsoft sign-in error:', error);
        return { success: false, error: error.message };
    }
}

// Sign out
async function signOut() {
    try {
        await auth.signOut();
        localStorage.removeItem('currentUser');
        return { success: true };
    } catch (error) {
        console.error('Sign-out error:', error);
        return { success: false, error: error.message };
    }
}

// Check authentication state
function onAuthStateChanged(callback) {
    if (auth) {
        auth.onAuthStateChanged(callback);
    }
}

// Export functions
window.firebaseAuth = {
    initialize: initializeFirebase,
    signInWithGoogle,
    signInWithFacebook,
    signInWithApple,
    signInWithMicrosoft,
    signOut,
    onAuthStateChanged
};
