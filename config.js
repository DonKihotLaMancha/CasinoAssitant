// BetSage - Monetization Configuration
// IMPORTANT: Replace these values with your actual IDs

const CASINO_CONFIG = {
    // Google AdSense
    // Sign up at: https://www.google.com/adsense
    // Get your Publisher ID and replace below
    adsense: {
        publisherId: 'ca-pub-XXXXXXXXXXXXXXXX', // REPLACE THIS!
        enabled: true, // Set to false to disable ads
        slots: {
            topBanner: '1234567890',    // Replace with your ad slot ID
            bottomBanner: '0987654321', // Replace with your ad slot ID
            sidebar: '1122334455'       // Replace with your ad slot ID
        }
    },

    // Affiliate Programs
    // Sign up for these programs and get your affiliate IDs
    affiliates: {
        betmgm: {
            enabled: true,
            url: 'https://betmgm.com?ref=YOUR_AFFILIATE_ID', // REPLACE THIS!
            trackingId: 'YOUR_TRACKING_ID' // REPLACE THIS!
        },
        draftkings: {
            enabled: true,
            url: 'https://draftkings.com?ref=YOUR_AFFILIATE_ID', // REPLACE THIS!
            trackingId: 'YOUR_TRACKING_ID' // REPLACE THIS!
        },
        fanduel: {
            enabled: true,
            url: 'https://fanduel.com?ref=YOUR_AFFILIATE_ID', // REPLACE THIS!
            trackingId: 'YOUR_TRACKING_ID' // REPLACE THIS!
        },
        bet365: {
            enabled: true,
            url: 'https://bet365.com?ref=YOUR_AFFILIATE_ID', // REPLACE THIS!
            trackingId: 'YOUR_TRACKING_ID' // REPLACE THIS!
        },
        casino888: {
            enabled: true,
            url: 'https://888casino.com?ref=YOUR_AFFILIATE_ID', // REPLACE THIS!
            trackingId: 'YOUR_TRACKING_ID' // REPLACE THIS!
        }
    },

    // Stripe Payment (for Premium subscriptions)
    // Sign up at: https://stripe.com
    stripe: {
        publishableKey: 'pk_live_XXXXXXXXXXXXXXXXXXXXXXXX', // REPLACE THIS!
        priceIds: {
            monthly: 'price_XXXXXXXXXXXXXXXXX',  // Monthly plan price ID
            yearly: 'price_XXXXXXXXXXXXXXXXX'    // Annual plan price ID
        }
    },

    // SEO Configuration
    seo: {
        siteUrl: 'https://yourdomain.com', // REPLACE THIS!
        siteName: 'BetSage',
        twitterHandle: '@casinoassistant', // REPLACE THIS!
        facebookAppId: 'YOUR_FB_APP_ID'    // Optional
    },

    // Google Analytics
    // Sign up at: https://analytics.google.com
    analytics: {
        enabled: true,
        trackingId: 'G-XXXXXXXXXX' // REPLACE THIS!
    },

    // Email Marketing
    // Sign up at: https://mailchimp.com or https://convertkit.com
    email: {
        provider: 'mailchimp', // or 'convertkit', 'sendgrid'
        apiKey: 'YOUR_API_KEY', // REPLACE THIS!
        listId: 'YOUR_LIST_ID'  // REPLACE THIS!
    },

    // Premium Features
    premium: {
        monthlyPrice: 9.99,
        yearlyPrice: 49.99,
        trialDays: 7, // Free trial period
        features: {
            free: ['Basic calculators', '5 lessons per game', 'Standard themes'],
            premium: ['All calculators', '60+ lessons', 'Advanced analytics', 'Ad-free', 'Priority support']
        }
    }
};

// Auto-apply configuration
if (typeof window !== 'undefined') {
    window.CASINO_CONFIG = CASINO_CONFIG;
    
    // Initialize AdSense with config
    if (typeof AdManager !== 'undefined' && CASINO_CONFIG.adsense.enabled) {
        window.adManager = new AdManager(CASINO_CONFIG.adsense.publisherId);
    }
    
    // Update affiliate URLs
    if (typeof affiliatePrograms !== 'undefined') {
        Object.keys(CASINO_CONFIG.affiliates).forEach(key => {
            if (affiliatePrograms[key] && CASINO_CONFIG.affiliates[key].enabled) {
                affiliatePrograms[key].url = CASINO_CONFIG.affiliates[key].url;
            }
        });
    }
}

// Export for Node.js (if needed)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = CASINO_CONFIG;
}
