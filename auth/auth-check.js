// Authentication Check Script
// Include this at the top of every protected page

(function() {
    'use strict';
    
    // Check if user is logged in
    const currentUser = localStorage.getItem('currentUser');
    
    if (!currentUser) {
        // Store the current page URL to redirect back after login
        sessionStorage.setItem('redirectAfterLogin', window.location.pathname);
        
        // Redirect to login page
        window.location.href = '/auth/login.html';
        return;
    }
    
    // Parse user data
    try {
        const userData = JSON.parse(currentUser);
        
        // Check if session is expired (24 hours)
        const loginTime = userData.loginTime || Date.now();
        const hoursSinceLogin = (Date.now() - loginTime) / (1000 * 60 * 60);
        
        if (hoursSinceLogin > 24) {
            // Session expired
            localStorage.removeItem('currentUser');
            alert('Your session has expired. Please login again.');
            window.location.href = '/auth/login.html';
            return;
        }
        
        // Update last activity time
        userData.lastActivity = Date.now();
        localStorage.setItem('currentUser', JSON.stringify(userData));
        
    } catch (e) {
        // Invalid user data, force re-login
        localStorage.removeItem('currentUser');
        window.location.href = '/auth/login.html';
    }
})();
