// PayPal Subscription Integration
// Real payment processing with PayPal

class PayPalSubscription {
    constructor() {
        this.clientId = 'YOUR_PAYPAL_CLIENT_ID'; // Replace with your PayPal Client ID
        this.planIds = {
            monthly: 'YOUR_MONTHLY_PLAN_ID',  // Replace with your monthly plan ID
            yearly: 'YOUR_YEARLY_PLAN_ID'     // Replace with your yearly plan ID
        };
        this.isInitialized = false;
    }

    // Initialize PayPal SDK
    async initialize() {
        if (this.isInitialized) return true;

        return new Promise((resolve, reject) => {
            // Check if PayPal SDK is already loaded
            if (window.paypal) {
                this.isInitialized = true;
                resolve(true);
                return;
            }

            // Load PayPal SDK
            const script = document.createElement('script');
            script.src = `https://www.paypal.com/sdk/js?client-id=${this.clientId}&vault=true&intent=subscription`;
            script.onload = () => {
                this.isInitialized = true;
                resolve(true);
            };
            script.onerror = () => reject(new Error('Failed to load PayPal SDK'));
            document.head.appendChild(script);
        });
    }

    // Create subscription button
    async createSubscriptionButton(containerId, plan = 'monthly') {
        try {
            await this.initialize();

            const planId = this.planIds[plan];
            if (!planId) {
                throw new Error('Invalid plan selected');
            }

            // Render PayPal button
            window.paypal.Buttons({
                style: {
                    shape: 'pill',
                    color: 'gold',
                    layout: 'vertical',
                    label: 'subscribe',
                    height: 50
                },
                
                createSubscription: (data, actions) => {
                    return actions.subscription.create({
                        'plan_id': planId,
                        'application_context': {
                            'shipping_preference': 'NO_SHIPPING'
                        }
                    });
                },

                onApprove: async (data, actions) => {
                    // Subscription successful
                    const subscriptionId = data.subscriptionID;
                    
                    // Save subscription data
                    await this.saveSubscription(subscriptionId, plan);
                    
                    // Show success message
                    this.showSuccess('🎉 Subscription activated! Enjoy premium features!');
                    
                    // Redirect to dashboard
                    setTimeout(() => {
                        window.location.href = '../index.html';
                    }, 2000);
                },

                onError: (err) => {
                    console.error('PayPal error:', err);
                    this.showError('Payment failed. Please try again.');
                },

                onCancel: () => {
                    this.showInfo('Payment cancelled. No charges were made.');
                }
            }).render(`#${containerId}`);

            return true;
        } catch (error) {
            console.error('PayPal initialization error:', error);
            this.showError('Failed to initialize payment system.');
            return false;
        }
    }

    // Save subscription to localStorage and backend
    async saveSubscription(subscriptionId, plan) {
        const currentUser = JSON.parse(localStorage.getItem('currentUser') || '{}');
        
        const subscriptionData = {
            subscriptionId: subscriptionId,
            plan: plan,
            status: 'active',
            startDate: new Date().toISOString(),
            userId: currentUser.uid || currentUser.email,
            price: plan === 'monthly' ? 9.99 : 79.99
        };

        // Save to localStorage
        localStorage.setItem('casinoPremium', 'true');
        localStorage.setItem('premiumPlan', plan);
        localStorage.setItem('premiumDate', subscriptionData.startDate);
        localStorage.setItem('subscriptionData', JSON.stringify(subscriptionData));

        // Update user data
        currentUser.isPremium = true;
        currentUser.premiumPlan = plan;
        localStorage.setItem('currentUser', JSON.stringify(currentUser));

        // Optional: Send to your backend
        await this.sendToBackend(subscriptionData);
    }

    // Send subscription data to backend (optional)
    async sendToBackend(data) {
        try {
            // Replace with your backend endpoint
            const response = await fetch('YOUR_BACKEND_URL/api/subscriptions', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            });

            if (!response.ok) {
                console.warn('Failed to sync subscription with backend');
            }
        } catch (error) {
            console.warn('Backend sync failed:', error);
            // Continue anyway - subscription is saved locally
        }
    }

    // Check subscription status
    async checkSubscriptionStatus() {
        const subscriptionData = localStorage.getItem('subscriptionData');
        
        if (!subscriptionData) {
            return { active: false };
        }

        const data = JSON.parse(subscriptionData);
        const startDate = new Date(data.startDate);
        const now = new Date();
        const daysSince = Math.floor((now - startDate) / (1000 * 60 * 60 * 24));

        // Check if subscription is still valid
        const isValid = data.plan === 'yearly' ? daysSince < 365 : daysSince < 30;

        return {
            active: isValid,
            plan: data.plan,
            daysRemaining: data.plan === 'yearly' ? 365 - daysSince : 30 - daysSince,
            subscriptionId: data.subscriptionId
        };
    }

    // Cancel subscription
    async cancelSubscription() {
        if (!confirm('Are you sure you want to cancel your subscription?\n\nYou will lose access to premium features at the end of your billing period.')) {
            return false;
        }

        try {
            // Get subscription data
            const subscriptionData = JSON.parse(localStorage.getItem('subscriptionData') || '{}');
            
            // Note: Actual cancellation must be done through PayPal dashboard or API
            // This is a client-side flag
            subscriptionData.status = 'cancelled';
            subscriptionData.cancelDate = new Date().toISOString();
            
            localStorage.setItem('subscriptionData', JSON.stringify(subscriptionData));
            
            this.showInfo('Subscription cancelled. You can still use premium features until the end of your billing period.');
            
            return true;
        } catch (error) {
            console.error('Cancel error:', error);
            this.showError('Failed to cancel subscription. Please contact support.');
            return false;
        }
    }

    // Notification helpers
    showSuccess(message) {
        this.showNotification(message, '#4CAF50');
    }

    showError(message) {
        this.showNotification(message, '#f44336');
    }

    showInfo(message) {
        this.showNotification(message, '#2196F3');
    }

    showNotification(message, color) {
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: ${color};
            color: white;
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            z-index: 10000;
            animation: slideIn 0.3s ease-out;
            font-weight: 600;
            max-width: 400px;
        `;
        notification.textContent = message;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease-out';
            setTimeout(() => notification.remove(), 300);
        }, 4000);
    }
}

// Create global instance
window.paypalSubscription = new PayPalSubscription();

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from { transform: translateX(400px); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(400px); opacity: 0; }
    }
`;
document.head.appendChild(style);
