// Premium Features Manager
// Handles premium subscription status and feature access

class PremiumManager {
    constructor() {
        this.premiumStatus = this.checkPremiumStatus();
        this.features = {
            adFree: false,
            allLessons: false,
            allThemes: false,
            advancedAnalytics: false,
            exportData: false,
            prioritySupport: false
        };
        this.init();
    }

    init() {
        if (this.premiumStatus.isPremium) {
            this.enableAllFeatures();
            this.hideAds();
            this.showPremiumBadge();
        } else {
            this.showUpgradePrompts();
        }
    }

    checkPremiumStatus() {
        const premiumData = localStorage.getItem('casinoPremium');
        const premiumPlan = localStorage.getItem('premiumPlan');
        const premiumDate = localStorage.getItem('premiumDate');

        if (premiumData === 'true' && premiumDate) {
            const startDate = new Date(premiumDate);
            const now = new Date();
            const daysSince = Math.floor((now - startDate) / (1000 * 60 * 60 * 24));

            // Check if subscription is still valid
            const isValid = premiumPlan === 'yearly' ? daysSince < 365 : daysSince < 30;

            return {
                isPremium: isValid,
                plan: premiumPlan,
                startDate: startDate,
                daysRemaining: premiumPlan === 'yearly' ? 365 - daysSince : 30 - daysSince
            };
        }

        return {
            isPremium: false,
            plan: null,
            startDate: null,
            daysRemaining: 0
        };
    }

    enableAllFeatures() {
        this.features = {
            adFree: true,
            allLessons: true,
            allThemes: true,
            advancedAnalytics: true,
            exportData: true,
            prioritySupport: true
        };
    }

    hasFeature(featureName) {
        return this.features[featureName] || false;
    }

    hideAds() {
        // Hide all ad slots
        const adSlots = document.querySelectorAll('.adsbygoogle, [id*="ad-"]');
        adSlots.forEach(ad => {
            if (ad) ad.style.display = 'none';
        });

        // Add premium badge to replace ads
        const adContainers = document.querySelectorAll('[id*="ad-banner"]');
        adContainers.forEach(container => {
            if (container) {
                container.innerHTML = `
                    <div style="text-align: center; padding: 20px; background: linear-gradient(135deg, #FF6B35, #F7B801); border-radius: 12px; color: white; font-weight: 600;">
                        👑 Ad-Free Premium Experience
                    </div>
                `;
            }
        });
    }

    showPremiumBadge() {
        // Add premium badge to header
        const header = document.querySelector('.header, h1');
        if (header && !document.getElementById('premium-badge')) {
            const badge = document.createElement('div');
            badge.id = 'premium-badge';
            badge.style.cssText = `
                display: inline-block;
                background: linear-gradient(135deg, #FFD700, #FFA500);
                color: #000;
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 0.8em;
                font-weight: bold;
                margin-left: 15px;
                box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);
                animation: pulse 2s infinite;
            `;
            badge.innerHTML = '👑 PREMIUM';
            header.appendChild(badge);
        }
    }

    showUpgradePrompts() {
        // Show upgrade button
        this.createUpgradeButton();
    }

    createUpgradeButton() {
        if (document.getElementById('upgrade-btn')) return;

        const upgradeBtn = document.createElement('a');
        upgradeBtn.id = 'upgrade-btn';
        upgradeBtn.href = 'games/premium.html';
        upgradeBtn.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            background: linear-gradient(135deg, #FFD700, #FFA500);
            border: 2px solid rgba(255, 215, 0, 0.5);
            border-radius: 50px;
            padding: 12px 28px;
            cursor: pointer;
            transition: all 0.3s;
            color: #000;
            font-weight: bold;
            text-decoration: none;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
            font-size: 1em;
        `;
        upgradeBtn.innerHTML = '👑 Go Premium';
        upgradeBtn.onmouseenter = () => {
            upgradeBtn.style.transform = 'translateY(-3px)';
            upgradeBtn.style.boxShadow = '0 8px 25px rgba(255, 215, 0, 0.5)';
        };
        upgradeBtn.onmouseleave = () => {
            upgradeBtn.style.transform = 'translateY(0)';
            upgradeBtn.style.boxShadow = '0 4px 15px rgba(255, 215, 0, 0.3)';
        };
        document.body.appendChild(upgradeBtn);
    }

    lockFeature(featureName, message = 'This feature requires Premium') {
        if (!this.premiumStatus.isPremium) {
            alert(`🔒 ${message}\n\nUpgrade to Premium to unlock:\n✓ All 60+ lessons\n✓ Ad-free experience\n✓ Advanced analytics\n✓ Export statistics\n✓ Priority support\n\nClick OK to learn more!`);
            window.location.href = 'games/premium.html';
            return false;
        }
        return true;
    }

    showPremiumModal(feature) {
        const modal = document.createElement('div');
        modal.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
        `;

        modal.innerHTML = `
            <div style="background: linear-gradient(135deg, #1A1A2E, #16213E); border: 2px solid #FF6B35; border-radius: 24px; padding: 40px; max-width: 500px; text-align: center; color: white;">
                <div style="font-size: 4em; margin-bottom: 20px;">🔒</div>
                <h2 style="color: #F7B801; margin-bottom: 15px;">Premium Feature</h2>
                <p style="margin-bottom: 25px; color: rgba(255,255,255,0.8);">
                    ${feature} is available for Premium members only.
                </p>
                <div style="background: rgba(255,107,53,0.1); border-radius: 12px; padding: 20px; margin-bottom: 25px;">
                    <h3 style="color: #FF6B35; margin-bottom: 15px;">Premium Includes:</h3>
                    <ul style="text-align: left; list-style: none; padding: 0;">
                        <li style="margin: 10px 0;">✓ All 60+ complete lessons</li>
                        <li style="margin: 10px 0;">✓ Ad-free experience</li>
                        <li style="margin: 10px 0;">✓ Advanced analytics</li>
                        <li style="margin: 10px 0;">✓ Export statistics</li>
                        <li style="margin: 10px 0;">✓ Priority email support</li>
                    </ul>
                </div>
                <a href="games/premium.html" style="display: inline-block; background: linear-gradient(135deg, #FF6B35, #F7B801); color: white; padding: 15px 40px; border-radius: 50px; text-decoration: none; font-weight: bold; margin-right: 10px;">
                    👑 Upgrade Now
                </a>
                <button onclick="this.closest('div').parentElement.remove()" style="background: rgba(255,255,255,0.1); color: white; padding: 15px 40px; border-radius: 50px; border: 2px solid rgba(255,255,255,0.2); cursor: pointer; font-weight: bold;">
                    Maybe Later
                </button>
            </div>
        `;

        document.body.appendChild(modal);
        modal.onclick = (e) => {
            if (e.target === modal) modal.remove();
        };
    }

    getPremiumInfo() {
        return this.premiumStatus;
    }

    cancelSubscription() {
        if (confirm('Are you sure you want to cancel your Premium subscription?\n\nYou will lose access to:\n• Ad-free experience\n• All 60+ lessons\n• Advanced analytics\n• Export features\n• Priority support')) {
            localStorage.removeItem('casinoPremium');
            localStorage.removeItem('premiumPlan');
            localStorage.removeItem('premiumDate');
            alert('✓ Subscription cancelled. Premium features will remain active until the end of your billing period.');
            window.location.reload();
        }
    }

    // Export user data (Premium feature)
    exportUserData() {
        if (!this.premiumStatus.isPremium) {
            if (confirm('💾 Data Export is a Premium feature!\n\n' +
                       'Upgrade to Premium to unlock:\n' +
                       '✓ Export all your data\n' +
                       '✓ Backup statistics\n' +
                       '✓ Download settings\n' +
                       '✓ Data portability\n\n' +
                       'Want to upgrade now?')) {
                window.location.href = 'games/premium.html';
            }
            return;
        }

        const userData = {
            account: JSON.parse(localStorage.getItem('currentUser') || '{}'),
            settings: JSON.parse(localStorage.getItem('casinoSettings') || '{}'),
            academyStats: JSON.parse(localStorage.getItem('casinoAcademyStats') || '{}'),
            premium: this.premiumStatus,
            exportDate: new Date().toISOString()
        };

        const dataStr = JSON.stringify(userData, null, 2);
        const dataBlob = new Blob([dataStr], {type: 'application/json'});
        const url = URL.createObjectURL(dataBlob);
        
        const link = document.createElement('a');
        link.href = url;
        link.download = `betsage-data-${Date.now()}.json`;
        link.click();
        
        alert('✓ Your data has been exported successfully!');
    }
    
    // View advanced analytics (Premium feature)
    viewAdvancedAnalytics() {
        if (!this.premiumStatus.isPremium) {
            if (confirm('📊 Advanced Analytics is a Premium feature!\n\n' +
                       'Upgrade to Premium to unlock:\n' +
                       '✓ Detailed performance graphs\n' +
                       '✓ Win/loss trend analysis\n' +
                       '✓ Session history tracking\n' +
                       '✓ Custom date ranges\n' +
                       '✓ Visual charts & graphs\n\n' +
                       'Want to upgrade now?')) {
                window.location.href = 'games/premium.html';
            }
            return false;
        }
        return true;
    }
}

// Initialize premium manager
const premiumManager = new PremiumManager();

// Make it globally available
window.premiumManager = premiumManager;
