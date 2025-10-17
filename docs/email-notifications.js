// Email Notification System
// Handles email subscriptions and notifications

class EmailNotifications {
    constructor() {
        this.config = {
            apiEndpoint: '/api/email', // Replace with your backend endpoint
            mailchimpApiKey: 'YOUR_MAILCHIMP_API_KEY',
            mailchimpListId: 'YOUR_LIST_ID',
            enabled: false // Set to true when backend is ready
        };
        this.init();
    }

    init() {
        // Check if user is subscribed
        this.checkSubscriptionStatus();
        
        // Add email subscription form if needed
        this.addSubscriptionWidget();
    }

    // Subscribe to email notifications
    async subscribe(email, name = '', preferences = {}) {
        if (!this.validateEmail(email)) {
            this.showNotification('Please enter a valid email address', 'error');
            return false;
        }

        const subscriptionData = {
            email: email,
            name: name,
            preferences: {
                newsletter: preferences.newsletter !== false,
                productUpdates: preferences.productUpdates !== false,
                premiumOffers: preferences.premiumOffers !== false,
                achievements: preferences.achievements !== false
            },
            subscribedAt: new Date().toISOString(),
            source: window.location.pathname
        };

        try {
            // Save locally
            localStorage.setItem('emailSubscription', JSON.stringify(subscriptionData));
            
            // Send to backend (if enabled)
            if (this.config.enabled) {
                await this.sendToBackend(subscriptionData);
            }

            this.showNotification('✓ Successfully subscribed to email notifications!', 'success');
            
            // Track subscription
            if (window.analyticsTracker) {
                window.analyticsTracker.trackEvent('email_subscribe', {
                    email: email,
                    source: window.location.pathname
                });
            }

            return true;
        } catch (error) {
            console.error('Subscription error:', error);
            this.showNotification('Failed to subscribe. Please try again.', 'error');
            return false;
        }
    }

    // Unsubscribe from email notifications
    async unsubscribe(email) {
        try {
            // Remove from localStorage
            localStorage.removeItem('emailSubscription');
            
            // Send to backend (if enabled)
            if (this.config.enabled) {
                await this.sendToBackend({ email: email, action: 'unsubscribe' });
            }

            this.showNotification('✓ Successfully unsubscribed', 'success');
            
            // Track unsubscribe
            if (window.analyticsTracker) {
                window.analyticsTracker.trackEvent('email_unsubscribe', {
                    email: email
                });
            }

            return true;
        } catch (error) {
            console.error('Unsubscribe error:', error);
            this.showNotification('Failed to unsubscribe. Please try again.', 'error');
            return false;
        }
    }

    // Update email preferences
    async updatePreferences(preferences) {
        const subscription = this.getSubscription();
        if (!subscription) {
            this.showNotification('No active subscription found', 'error');
            return false;
        }

        subscription.preferences = { ...subscription.preferences, ...preferences };
        localStorage.setItem('emailSubscription', JSON.stringify(subscription));

        if (this.config.enabled) {
            await this.sendToBackend({ email: subscription.email, preferences: preferences });
        }

        this.showNotification('✓ Preferences updated', 'success');
        return true;
    }

    // Get subscription status
    getSubscription() {
        const stored = localStorage.getItem('emailSubscription');
        return stored ? JSON.parse(stored) : null;
    }

    // Check if user is subscribed
    isSubscribed() {
        return this.getSubscription() !== null;
    }

    // Check subscription status
    checkSubscriptionStatus() {
        const subscription = this.getSubscription();
        if (subscription) {
            console.log('Email subscription active:', subscription.email);
        }
    }

    // Validate email
    validateEmail(email) {
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }

    // Send to backend
    async sendToBackend(data) {
        if (!this.config.enabled) {
            console.log('Email backend not configured. Data:', data);
            return;
        }

        const response = await fetch(this.config.apiEndpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });

        if (!response.ok) {
            throw new Error('Backend request failed');
        }

        return await response.json();
    }

    // Add subscription widget
    addSubscriptionWidget() {
        // Check if already subscribed
        if (this.isSubscribed()) return;

        // Check if widget already exists
        if (document.getElementById('email-subscription-widget')) return;

        // Create widget after 10 seconds on page
        setTimeout(() => {
            this.showSubscriptionPopup();
        }, 10000);
    }

    // Show subscription popup
    showSubscriptionPopup() {
        // Don't show if already dismissed in this session
        if (sessionStorage.getItem('emailPopupDismissed')) return;

        const popup = document.createElement('div');
        popup.id = 'email-subscription-widget';
        popup.style.cssText = `
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 9999;
            background: linear-gradient(135deg, #1A1A2E, #16213E);
            border: 2px solid #FF6B35;
            border-radius: 16px;
            padding: 25px;
            max-width: 350px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.5);
            animation: slideInRight 0.5s ease-out;
        `;

        popup.innerHTML = `
            <button onclick="this.parentElement.remove(); sessionStorage.setItem('emailPopupDismissed', 'true')" style="position: absolute; top: 10px; right: 10px; background: none; border: none; color: rgba(255,255,255,0.5); font-size: 24px; cursor: pointer; padding: 0; width: 30px; height: 30px;">×</button>
            
            <div style="text-align: center; margin-bottom: 15px;">
                <div style="font-size: 3em; margin-bottom: 10px;">📧</div>
                <h3 style="color: #F7B801; margin-bottom: 8px;">Stay Updated!</h3>
                <p style="color: rgba(255,255,255,0.8); font-size: 0.9em; margin: 0;">
                    Get the latest tips, strategies, and exclusive offers
                </p>
            </div>
            
            <form id="emailSubscriptionForm" style="display: flex; flex-direction: column; gap: 10px;">
                <input type="email" id="emailInput" placeholder="Enter your email" required style="padding: 12px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.2); background: rgba(255,255,255,0.05); color: white; font-size: 0.9em;">
                <button type="submit" style="background: linear-gradient(135deg, #FF6B35, #F7B801); color: white; border: none; padding: 12px; border-radius: 8px; cursor: pointer; font-weight: 600; transition: transform 0.2s;">
                    Subscribe
                </button>
            </form>
            
            <p style="color: rgba(255,255,255,0.5); font-size: 0.75em; margin-top: 10px; text-align: center;">
                Unsubscribe anytime. We respect your privacy.
            </p>
        `;

        document.body.appendChild(popup);

        // Handle form submission
        document.getElementById('emailSubscriptionForm').onsubmit = async (e) => {
            e.preventDefault();
            const email = document.getElementById('emailInput').value;
            const success = await this.subscribe(email);
            if (success) {
                popup.remove();
            }
        };
    }

    // Show notification
    showNotification(message, type = 'success') {
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 10001;
            background: ${type === 'success' ? 'linear-gradient(135deg, #4CAF50, #45a049)' : 'linear-gradient(135deg, #f44336, #da190b)'};
            color: white;
            padding: 15px 25px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            animation: slideInRight 0.3s ease-out;
            font-weight: 600;
        `;
        notification.textContent = message;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOutRight 0.3s ease-out';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }

    // Email templates (for backend)
    getEmailTemplate(type, data = {}) {
        const templates = {
            welcome: {
                subject: 'Welcome to BetSage! 🎰',
                body: `
                    <h2>Welcome to BetSage!</h2>
                    <p>Thank you for subscribing to our newsletter.</p>
                    <p>You now have access to:</p>
                    <ul>
                        <li>Weekly strategy tips</li>
                        <li>Exclusive premium offers</li>
                        <li>New feature announcements</li>
                        <li>Casino odds insights</li>
                    </ul>
                    <p><a href="${this.config.siteUrl}">Visit BetSage</a></p>
                `
            },
            premiumTrial: {
                subject: '🎁 Start Your 7-Day Premium Trial',
                body: `
                    <h2>Try Premium Free for 7 Days!</h2>
                    <p>Unlock all features with our Premium trial:</p>
                    <ul>
                        <li>60+ complete lessons</li>
                        <li>Ad-free experience</li>
                        <li>Advanced analytics</li>
                        <li>Priority support</li>
                    </ul>
                    <p><a href="${this.config.siteUrl}/games/premium.html">Start Free Trial</a></p>
                `
            },
            achievementUnlocked: {
                subject: '🏆 Achievement Unlocked!',
                body: `
                    <h2>Congratulations!</h2>
                    <p>You've unlocked the "${data.achievementName}" achievement!</p>
                    <p>${data.achievementDescription}</p>
                    <p>Points earned: ${data.points}</p>
                    <p><a href="${this.config.siteUrl}/auth/dashboard.html">View Dashboard</a></p>
                `
            },
            subscriptionExpiring: {
                subject: '⚠️ Your Premium Subscription is Expiring Soon',
                body: `
                    <h2>Don't Lose Access!</h2>
                    <p>Your Premium subscription expires in ${data.daysRemaining} days.</p>
                    <p>Renew now to continue enjoying:</p>
                    <ul>
                        <li>All premium features</li>
                        <li>Ad-free experience</li>
                        <li>Advanced analytics</li>
                    </ul>
                    <p><a href="${this.config.siteUrl}/games/premium.html">Renew Subscription</a></p>
                `
            }
        };

        return templates[type] || templates.welcome;
    }

    // Queue email (for backend processing)
    queueEmail(to, type, data = {}) {
        const template = this.getEmailTemplate(type, data);
        const emailData = {
            to: to,
            subject: template.subject,
            body: template.body,
            type: type,
            queuedAt: new Date().toISOString()
        };

        // Store in queue
        const queue = JSON.parse(localStorage.getItem('emailQueue') || '[]');
        queue.push(emailData);
        localStorage.setItem('emailQueue', JSON.stringify(queue));

        console.log('Email queued:', emailData);
    }
}

// Initialize email notifications
const emailNotifications = new EmailNotifications();

// Make it globally available
window.emailNotifications = emailNotifications;

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = EmailNotifications;
}
