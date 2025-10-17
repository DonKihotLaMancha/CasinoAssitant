// Subscription Status Checker
// Validates and manages subscription status across the site

class SubscriptionChecker {
    constructor() {
        this.checkInterval = null;
        this.init();
    }

    init() {
        // Check subscription status on page load
        this.validateSubscription();
        
        // Check every 5 minutes
        this.checkInterval = setInterval(() => {
            this.validateSubscription();
        }, 5 * 60 * 1000);
        
        // Listen for storage changes (multi-tab support)
        window.addEventListener('storage', (e) => {
            if (e.key === 'casinoPremium' || e.key === 'premiumDate' || e.key === 'premiumPlan') {
                this.validateSubscription();
            }
        });
    }

    validateSubscription() {
        const premiumData = localStorage.getItem('casinoPremium');
        const premiumPlan = localStorage.getItem('premiumPlan');
        const premiumDate = localStorage.getItem('premiumDate');
        const paypalSubscriptionId = localStorage.getItem('paypalSubscriptionId');

        if (premiumData === 'true' && premiumDate) {
            const startDate = new Date(premiumDate);
            const now = new Date();
            const daysSince = Math.floor((now - startDate) / (1000 * 60 * 60 * 24));

            // Calculate expiry based on plan
            let daysTotal = 30; // Default monthly
            if (premiumPlan === 'yearly') {
                daysTotal = 365;
            }

            const daysRemaining = daysTotal - daysSince;

            if (daysRemaining <= 0) {
                // Subscription expired
                this.handleExpiredSubscription();
            } else if (daysRemaining <= 7) {
                // Expiring soon - show warning
                this.showExpiryWarning(daysRemaining);
            }

            // Update UI with subscription info
            this.updateSubscriptionUI({
                active: daysRemaining > 0,
                plan: premiumPlan,
                daysRemaining: daysRemaining,
                expiryDate: new Date(startDate.getTime() + (daysTotal * 24 * 60 * 60 * 1000))
            });
        }
    }

    handleExpiredSubscription() {
        // Clear premium status
        localStorage.removeItem('casinoPremium');
        
        // Show expiry notification
        if (!sessionStorage.getItem('expiryNotificationShown')) {
            sessionStorage.setItem('expiryNotificationShown', 'true');
            
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                left: 50%;
                transform: translateX(-50%);
                z-index: 10000;
                background: linear-gradient(135deg, #FF6B35, #F7B801);
                color: white;
                padding: 20px 30px;
                border-radius: 12px;
                box-shadow: 0 8px 32px rgba(0,0,0,0.3);
                max-width: 500px;
                text-align: center;
                animation: slideDown 0.5s ease-out;
            `;
            
            notification.innerHTML = `
                <div style="font-size: 2em; margin-bottom: 10px;">⏰</div>
                <h3 style="margin: 0 0 10px 0;">Premium Subscription Expired</h3>
                <p style="margin: 0 0 15px 0; opacity: 0.9;">
                    Your Premium subscription has expired. Renew now to continue enjoying all premium features!
                </p>
                <a href="/games/premium.html" style="display: inline-block; background: white; color: #FF6B35; padding: 10px 25px; border-radius: 25px; text-decoration: none; font-weight: bold; margin-right: 10px;">
                    Renew Now
                </a>
                <button onclick="this.parentElement.remove()" style="background: rgba(255,255,255,0.2); color: white; padding: 10px 25px; border-radius: 25px; border: none; cursor: pointer; font-weight: bold;">
                    Dismiss
                </button>
            `;
            
            document.body.appendChild(notification);
            
            // Auto-remove after 10 seconds
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.style.animation = 'slideUp 0.5s ease-out';
                    setTimeout(() => notification.remove(), 500);
                }
            }, 10000);
        }
        
        // Reload page to update UI
        setTimeout(() => {
            window.location.reload();
        }, 3000);
    }

    showExpiryWarning(daysRemaining) {
        // Only show once per session
        if (sessionStorage.getItem('expiryWarningShown')) return;
        sessionStorage.setItem('expiryWarningShown', 'true');
        
        const warning = document.createElement('div');
        warning.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 9999;
            background: linear-gradient(135deg, #FFA500, #FF6B35);
            color: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            max-width: 350px;
            animation: slideInRight 0.5s ease-out;
        `;
        
        warning.innerHTML = `
            <div style="display: flex; align-items: center; margin-bottom: 10px;">
                <span style="font-size: 2em; margin-right: 15px;">⚠️</span>
                <div>
                    <h4 style="margin: 0 0 5px 0;">Subscription Expiring Soon</h4>
                    <p style="margin: 0; opacity: 0.9; font-size: 0.9em;">
                        ${daysRemaining} day${daysRemaining !== 1 ? 's' : ''} remaining
                    </p>
                </div>
            </div>
            <p style="margin: 0 0 15px 0; font-size: 0.9em;">
                Renew now to avoid losing access to premium features!
            </p>
            <a href="/games/premium.html" style="display: inline-block; background: white; color: #FF6B35; padding: 8px 20px; border-radius: 20px; text-decoration: none; font-weight: bold; font-size: 0.9em; margin-right: 10px;">
                Renew
            </a>
            <button onclick="this.parentElement.remove()" style="background: rgba(255,255,255,0.2); color: white; padding: 8px 20px; border-radius: 20px; border: none; cursor: pointer; font-weight: bold; font-size: 0.9em;">
                Later
            </button>
        `;
        
        document.body.appendChild(warning);
    }

    updateSubscriptionUI(info) {
        // Update any subscription status displays on the page
        const statusElements = document.querySelectorAll('[data-subscription-status]');
        statusElements.forEach(el => {
            if (info.active) {
                el.textContent = `Premium (${info.daysRemaining} days left)`;
                el.style.color = '#4CAF50';
            } else {
                el.textContent = 'Free';
                el.style.color = '#999';
            }
        });

        // Update expiry date displays
        const expiryElements = document.querySelectorAll('[data-subscription-expiry]');
        expiryElements.forEach(el => {
            if (info.active) {
                el.textContent = info.expiryDate.toLocaleDateString();
            } else {
                el.textContent = 'N/A';
            }
        });
    }

    getSubscriptionInfo() {
        const premiumData = localStorage.getItem('casinoPremium');
        const premiumPlan = localStorage.getItem('premiumPlan');
        const premiumDate = localStorage.getItem('premiumDate');

        if (premiumData === 'true' && premiumDate) {
            const startDate = new Date(premiumDate);
            const now = new Date();
            const daysSince = Math.floor((now - startDate) / (1000 * 60 * 60 * 24));
            const daysTotal = premiumPlan === 'yearly' ? 365 : 30;
            const daysRemaining = daysTotal - daysSince;

            return {
                active: daysRemaining > 0,
                plan: premiumPlan || 'monthly',
                startDate: startDate,
                daysRemaining: Math.max(0, daysRemaining),
                expiryDate: new Date(startDate.getTime() + (daysTotal * 24 * 60 * 60 * 1000)),
                price: premiumPlan === 'yearly' ? '$49.99/year' : '$9.99/month'
            };
        }

        return {
            active: false,
            plan: 'free',
            startDate: null,
            daysRemaining: 0,
            expiryDate: null,
            price: 'Free'
        };
    }

    isPremium() {
        const info = this.getSubscriptionInfo();
        return info.active;
    }

    requirePremium(featureName = 'This feature') {
        if (!this.isPremium()) {
            if (confirm(`🔒 ${featureName} requires Premium\n\n` +
                       'Upgrade to Premium to unlock:\n' +
                       '✓ All 60+ lessons\n' +
                       '✓ Ad-free experience\n' +
                       '✓ Advanced analytics\n' +
                       '✓ Export data\n' +
                       '✓ Priority support\n\n' +
                       'Want to upgrade now?')) {
                window.location.href = '/games/premium.html';
            }
            return false;
        }
        return true;
    }

    destroy() {
        if (this.checkInterval) {
            clearInterval(this.checkInterval);
        }
    }
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideDown {
        from {
            transform: translateX(-50%) translateY(-100px);
            opacity: 0;
        }
        to {
            transform: translateX(-50%) translateY(0);
            opacity: 1;
        }
    }
    
    @keyframes slideUp {
        from {
            transform: translateX(-50%) translateY(0);
            opacity: 1;
        }
        to {
            transform: translateX(-50%) translateY(-100px);
            opacity: 0;
        }
    }
    
    @keyframes slideInRight {
        from {
            transform: translateX(400px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
`;
document.head.appendChild(style);

// Initialize subscription checker
const subscriptionChecker = new SubscriptionChecker();

// Make it globally available
window.subscriptionChecker = subscriptionChecker;

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = SubscriptionChecker;
}
