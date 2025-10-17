// Affiliate Tracking System
// Tracks referrals and affiliate conversions

class AffiliateTracker {
    constructor() {
        this.config = {
            affiliatePrograms: {
                betmgm: {
                    name: 'BetMGM',
                    url: 'https://betmgm.com',
                    commission: 0.25, // 25%
                    enabled: true
                },
                draftkings: {
                    name: 'DraftKings',
                    url: 'https://draftkings.com',
                    commission: 0.30,
                    enabled: true
                },
                fanduel: {
                    name: 'FanDuel',
                    url: 'https://fanduel.com',
                    commission: 0.25,
                    enabled: true
                },
                bet365: {
                    name: 'Bet365',
                    url: 'https://bet365.com',
                    commission: 0.35,
                    enabled: true
                }
            },
            cookieDuration: 30 // days
        };
        this.init();
    }

    init() {
        // Check for referral parameter
        this.checkReferralParam();
        
        // Track affiliate clicks
        this.trackAffiliateClicks();
    }

    // Check for referral parameter in URL
    checkReferralParam() {
        const urlParams = new URLSearchParams(window.location.search);
        const ref = urlParams.get('ref');
        
        if (ref) {
            this.setReferrer(ref);
            
            // Track referral
            if (window.analyticsTracker) {
                window.analyticsTracker.trackEvent('referral_visit', {
                    referrer: ref,
                    page: window.location.pathname
                });
            }
        }
    }

    // Set referrer cookie
    setReferrer(referrerId) {
        const referralData = {
            referrerId: referrerId,
            timestamp: new Date().toISOString(),
            expiresAt: new Date(Date.now() + (this.config.cookieDuration * 24 * 60 * 60 * 1000)).toISOString()
        };
        
        localStorage.setItem('referralData', JSON.stringify(referralData));
    }

    // Get referrer
    getReferrer() {
        const stored = localStorage.getItem('referralData');
        if (!stored) return null;
        
        const data = JSON.parse(stored);
        
        // Check if expired
        if (new Date(data.expiresAt) < new Date()) {
            localStorage.removeItem('referralData');
            return null;
        }
        
        return data.referrerId;
    }

    // Track affiliate clicks
    trackAffiliateClicks() {
        document.addEventListener('click', (e) => {
            const link = e.target.closest('a[data-affiliate]');
            if (link) {
                const affiliate = link.dataset.affiliate;
                const url = link.href;
                
                this.trackAffiliateClick(affiliate, url);
            }
        });
    }

    // Track affiliate click
    trackAffiliateClick(affiliate, url) {
        // Save click data
        const clicks = this.getAffiliateClicks();
        clicks.push({
            affiliate: affiliate,
            url: url,
            timestamp: new Date().toISOString(),
            referrer: this.getReferrer()
        });
        
        localStorage.setItem('affiliateClicks', JSON.stringify(clicks));
        
        // Track with analytics
        if (window.analyticsTracker) {
            window.analyticsTracker.trackEvent('affiliate_click', {
                affiliate: affiliate,
                url: url,
                referrer: this.getReferrer()
            });
        }
    }

    // Get affiliate clicks
    getAffiliateClicks() {
        const stored = localStorage.getItem('affiliateClicks');
        return stored ? JSON.parse(stored) : [];
    }

    // Generate referral link
    generateReferralLink(userId) {
        const baseUrl = window.location.origin;
        return `${baseUrl}?ref=${userId}`;
    }

    // Get user's referral stats
    getReferralStats(userId) {
        // This would typically come from backend
        // For now, return mock data
        return {
            totalReferrals: 0,
            activeReferrals: 0,
            totalEarnings: 0,
            pendingEarnings: 0,
            conversionRate: 0
        };
    }

    // Track conversion
    trackConversion(type, value, affiliate = null) {
        const conversion = {
            type: type,
            value: value,
            affiliate: affiliate,
            referrer: this.getReferrer(),
            timestamp: new Date().toISOString()
        };
        
        // Save conversion
        const conversions = this.getConversions();
        conversions.push(conversion);
        localStorage.setItem('affiliateConversions', JSON.stringify(conversions));
        
        // Track with analytics
        if (window.analyticsTracker) {
            window.analyticsTracker.trackConversion(type, value);
        }
        
        // Update referrer stats if applicable
        if (conversion.referrer) {
            this.updateReferrerStats(conversion.referrer, value);
        }
    }

    // Get conversions
    getConversions() {
        const stored = localStorage.getItem('affiliateConversions');
        return stored ? JSON.parse(stored) : [];
    }

    // Update referrer stats
    updateReferrerStats(referrerId, value) {
        const stats = JSON.parse(localStorage.getItem('referrerStats') || '{}');
        
        if (!stats[referrerId]) {
            stats[referrerId] = {
                conversions: 0,
                totalValue: 0,
                lastConversion: null
            };
        }
        
        stats[referrerId].conversions++;
        stats[referrerId].totalValue += value;
        stats[referrerId].lastConversion = new Date().toISOString();
        
        localStorage.setItem('referrerStats', JSON.stringify(stats));
    }

    // Create affiliate links
    createAffiliateLinks() {
        const affiliateLinks = document.querySelectorAll('[data-affiliate-program]');
        
        affiliateLinks.forEach(link => {
            const program = link.dataset.affiliateProgram;
            const config = this.config.affiliatePrograms[program];
            
            if (config && config.enabled) {
                // Add tracking attributes
                link.dataset.affiliate = program;
                link.rel = 'noopener noreferrer';
                link.target = '_blank';
                
                // Add click handler
                link.addEventListener('click', () => {
                    this.trackAffiliateClick(program, link.href);
                });
            }
        });
    }

    // Show referral widget
    showReferralWidget() {
        const userId = this.getUserId();
        if (!userId) return;
        
        const referralLink = this.generateReferralLink(userId);
        const stats = this.getReferralStats(userId);
        
        const widget = document.createElement('div');
        widget.style.cssText = `
            position: fixed;
            bottom: 20px;
            left: 20px;
            z-index: 999;
            background: linear-gradient(135deg, #1A1A2E, #16213E);
            border: 2px solid #F7B801;
            border-radius: 16px;
            padding: 20px;
            max-width: 300px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.5);
        `;
        
        widget.innerHTML = `
            <h3 style="color: #F7B801; margin-bottom: 15px;">🤝 Refer & Earn</h3>
            <p style="color: rgba(255,255,255,0.8); font-size: 0.9em; margin-bottom: 15px;">
                Share BetSage and earn rewards!
            </p>
            
            <div style="background: rgba(255,255,255,0.05); padding: 10px; border-radius: 8px; margin-bottom: 15px;">
                <div style="color: rgba(255,255,255,0.6); font-size: 0.8em; margin-bottom: 5px;">Your Referral Link:</div>
                <div style="display: flex; gap: 8px;">
                    <input type="text" value="${referralLink}" readonly style="flex: 1; padding: 8px; border-radius: 6px; border: 1px solid rgba(255,255,255,0.2); background: rgba(255,255,255,0.05); color: white; font-size: 0.8em;">
                    <button onclick="navigator.clipboard.writeText('${referralLink}'); this.textContent='✓'" style="background: linear-gradient(135deg, #FF6B35, #F7B801); color: white; border: none; padding: 8px 12px; border-radius: 6px; cursor: pointer; font-weight: 600;">
                        📋
                    </button>
                </div>
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 15px;">
                <div style="background: rgba(255,255,255,0.05); padding: 10px; border-radius: 8px; text-align: center;">
                    <div style="font-size: 1.5em; font-weight: 800; color: #FF6B35;">${stats.totalReferrals}</div>
                    <div style="font-size: 0.8em; color: rgba(255,255,255,0.6);">Referrals</div>
                </div>
                <div style="background: rgba(255,255,255,0.05); padding: 10px; border-radius: 8px; text-align: center;">
                    <div style="font-size: 1.5em; font-weight: 800; color: #4CAF50;">$${stats.totalEarnings}</div>
                    <div style="font-size: 0.8em; color: rgba(255,255,255,0.6);">Earned</div>
                </div>
            </div>
            
            <button onclick="window.socialShare?.shareToTwitter('Check out BetSage - Professional casino odds calculators! ${referralLink}')" style="width: 100%; background: linear-gradient(135deg, #FF6B35, #F7B801); color: white; border: none; padding: 10px; border-radius: 8px; cursor: pointer; font-weight: 600; margin-bottom: 10px;">
                📱 Share Now
            </button>
            
            <button onclick="this.parentElement.remove()" style="width: 100%; background: transparent; color: rgba(255,255,255,0.5); border: none; padding: 8px; cursor: pointer; font-size: 0.9em;">
                Close
            </button>
        `;
        
        document.body.appendChild(widget);
    }

    // Get user ID
    getUserId() {
        const user = JSON.parse(localStorage.getItem('currentUser') || '{}');
        return user.userId || null;
    }

    // Calculate commission
    calculateCommission(program, amount) {
        const config = this.config.affiliatePrograms[program];
        if (!config) return 0;
        
        return amount * config.commission;
    }

    // Get affiliate report
    getAffiliateReport() {
        const clicks = this.getAffiliateClicks();
        const conversions = this.getConversions();
        
        const report = {
            totalClicks: clicks.length,
            totalConversions: conversions.length,
            conversionRate: clicks.length > 0 ? (conversions.length / clicks.length) * 100 : 0,
            totalValue: conversions.reduce((sum, c) => sum + c.value, 0),
            byAffiliate: {}
        };
        
        // Group by affiliate
        clicks.forEach(click => {
            if (!report.byAffiliate[click.affiliate]) {
                report.byAffiliate[click.affiliate] = {
                    clicks: 0,
                    conversions: 0,
                    value: 0
                };
            }
            report.byAffiliate[click.affiliate].clicks++;
        });
        
        conversions.forEach(conv => {
            if (conv.affiliate && report.byAffiliate[conv.affiliate]) {
                report.byAffiliate[conv.affiliate].conversions++;
                report.byAffiliate[conv.affiliate].value += conv.value;
            }
        });
        
        return report;
    }
}

// Initialize affiliate tracker
const affiliateTracker = new AffiliateTracker();

// Make it globally available
window.affiliateTracker = affiliateTracker;

// Create affiliate links on page load
window.addEventListener('DOMContentLoaded', () => {
    affiliateTracker.createAffiliateLinks();
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AffiliateTracker;
}
