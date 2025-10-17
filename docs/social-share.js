// Social Sharing System
// Enables easy sharing to social media platforms

class SocialShare {
    constructor() {
        this.config = {
            siteUrl: window.location.origin,
            siteName: 'BetSage',
            twitterHandle: '@BetSage',
            hashtags: ['BetSage', 'CasinoOdds', 'GamblingStrategy']
        };
        this.init();
    }

    init() {
        // Add share buttons to page if needed
        this.addShareButtons();
        
        // Track shares
        this.trackShares();
    }

    // Share to Twitter
    shareToTwitter(text = null, url = null) {
        const shareText = text || `Check out ${this.config.siteName} - Professional casino odds calculators and strategy tools!`;
        const shareUrl = url || window.location.href;
        const hashtags = this.config.hashtags.join(',');
        
        const twitterUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(shareText)}&url=${encodeURIComponent(shareUrl)}&hashtags=${hashtags}`;
        
        this.openShareWindow(twitterUrl, 'Twitter');
        this.trackShare('twitter');
        
        // Update achievement
        this.incrementSocialShares();
    }

    // Share to Facebook
    shareToFacebook(url = null) {
        const shareUrl = url || window.location.href;
        const facebookUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shareUrl)}`;
        
        this.openShareWindow(facebookUrl, 'Facebook');
        this.trackShare('facebook');
        this.incrementSocialShares();
    }

    // Share to LinkedIn
    shareToLinkedIn(url = null, title = null, summary = null) {
        const shareUrl = url || window.location.href;
        const shareTitle = title || document.title;
        const shareSummary = summary || 'Professional casino odds calculators and strategy tools';
        
        const linkedInUrl = `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(shareUrl)}`;
        
        this.openShareWindow(linkedInUrl, 'LinkedIn');
        this.trackShare('linkedin');
        this.incrementSocialShares();
    }

    // Share to Reddit
    shareToReddit(url = null, title = null) {
        const shareUrl = url || window.location.href;
        const shareTitle = title || document.title;
        
        const redditUrl = `https://reddit.com/submit?url=${encodeURIComponent(shareUrl)}&title=${encodeURIComponent(shareTitle)}`;
        
        this.openShareWindow(redditUrl, 'Reddit');
        this.trackShare('reddit');
        this.incrementSocialShares();
    }

    // Share to WhatsApp
    shareToWhatsApp(text = null, url = null) {
        const shareText = text || `Check out ${this.config.siteName}!`;
        const shareUrl = url || window.location.href;
        const message = `${shareText} ${shareUrl}`;
        
        const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(message)}`;
        
        window.open(whatsappUrl, '_blank');
        this.trackShare('whatsapp');
        this.incrementSocialShares();
    }

    // Share to Telegram
    shareToTelegram(text = null, url = null) {
        const shareText = text || `Check out ${this.config.siteName}!`;
        const shareUrl = url || window.location.href;
        
        const telegramUrl = `https://t.me/share/url?url=${encodeURIComponent(shareUrl)}&text=${encodeURIComponent(shareText)}`;
        
        this.openShareWindow(telegramUrl, 'Telegram');
        this.trackShare('telegram');
        this.incrementSocialShares();
    }

    // Share via Email
    shareViaEmail(subject = null, body = null) {
        const shareSubject = subject || `Check out ${this.config.siteName}`;
        const shareBody = body || `I thought you might be interested in this: ${window.location.href}`;
        
        const emailUrl = `mailto:?subject=${encodeURIComponent(shareSubject)}&body=${encodeURIComponent(shareBody)}`;
        
        window.location.href = emailUrl;
        this.trackShare('email');
        this.incrementSocialShares();
    }

    // Copy link to clipboard
    copyLink(url = null, showNotification = true) {
        const shareUrl = url || window.location.href;
        
        navigator.clipboard.writeText(shareUrl).then(() => {
            if (showNotification) {
                this.showNotification('✓ Link copied to clipboard!');
            }
            this.trackShare('copy_link');
            this.incrementSocialShares();
        }).catch(err => {
            console.error('Failed to copy:', err);
            this.showNotification('Failed to copy link', 'error');
        });
    }

    // Native Web Share API
    async nativeShare(data = {}) {
        if (!navigator.share) {
            this.showShareModal();
            return;
        }

        const shareData = {
            title: data.title || document.title,
            text: data.text || 'Check out BetSage - Professional casino odds calculators!',
            url: data.url || window.location.href
        };

        try {
            await navigator.share(shareData);
            this.trackShare('native');
            this.incrementSocialShares();
        } catch (err) {
            if (err.name !== 'AbortError') {
                console.error('Share failed:', err);
            }
        }
    }

    // Open share window
    openShareWindow(url, platform) {
        const width = 600;
        const height = 400;
        const left = (window.innerWidth - width) / 2;
        const top = (window.innerHeight - height) / 2;
        
        window.open(
            url,
            `share-${platform}`,
            `width=${width},height=${height},left=${left},top=${top},toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,resizable=yes`
        );
    }

    // Show share modal
    showShareModal() {
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
            animation: fadeIn 0.3s ease-out;
        `;

        modal.innerHTML = `
            <div style="background: linear-gradient(135deg, #1A1A2E, #16213E); border: 2px solid #FF6B35; border-radius: 24px; padding: 40px; max-width: 500px; width: 90%; animation: slideUp 0.3s ease-out;">
                <h2 style="color: #F7B801; margin-bottom: 20px; text-align: center;">📱 Share BetSage</h2>
                
                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 25px;">
                    <button onclick="window.socialShare.shareToTwitter()" style="background: #1DA1F2; color: white; border: none; padding: 15px; border-radius: 12px; cursor: pointer; font-weight: 600; transition: transform 0.2s;">
                        🐦 Twitter
                    </button>
                    <button onclick="window.socialShare.shareToFacebook()" style="background: #4267B2; color: white; border: none; padding: 15px; border-radius: 12px; cursor: pointer; font-weight: 600; transition: transform 0.2s;">
                        📘 Facebook
                    </button>
                    <button onclick="window.socialShare.shareToLinkedIn()" style="background: #0077B5; color: white; border: none; padding: 15px; border-radius: 12px; cursor: pointer; font-weight: 600; transition: transform 0.2s;">
                        💼 LinkedIn
                    </button>
                    <button onclick="window.socialShare.shareToReddit()" style="background: #FF4500; color: white; border: none; padding: 15px; border-radius: 12px; cursor: pointer; font-weight: 600; transition: transform 0.2s;">
                        🤖 Reddit
                    </button>
                    <button onclick="window.socialShare.shareToWhatsApp()" style="background: #25D366; color: white; border: none; padding: 15px; border-radius: 12px; cursor: pointer; font-weight: 600; transition: transform 0.2s;">
                        💬 WhatsApp
                    </button>
                    <button onclick="window.socialShare.shareToTelegram()" style="background: #0088cc; color: white; border: none; padding: 15px; border-radius: 12px; cursor: pointer; font-weight: 600; transition: transform 0.2s;">
                        ✈️ Telegram
                    </button>
                </div>
                
                <div style="display: flex; gap: 10px; margin-bottom: 20px;">
                    <input type="text" value="${window.location.href}" readonly style="flex: 1; padding: 12px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.2); background: rgba(255,255,255,0.05); color: white; font-size: 0.9em;">
                    <button onclick="window.socialShare.copyLink(); this.textContent='✓ Copied!'" style="background: linear-gradient(135deg, #FF6B35, #F7B801); color: white; border: none; padding: 12px 20px; border-radius: 8px; cursor: pointer; font-weight: 600; white-space: nowrap;">
                        📋 Copy
                    </button>
                </div>
                
                <button onclick="window.socialShare.shareViaEmail()" style="width: 100%; background: rgba(255,255,255,0.1); color: white; border: 2px solid rgba(255,255,255,0.2); padding: 12px; border-radius: 8px; cursor: pointer; font-weight: 600; margin-bottom: 15px;">
                    📧 Share via Email
                </button>
                
                <button onclick="this.closest('div').parentElement.remove()" style="width: 100%; background: transparent; color: rgba(255,255,255,0.6); border: none; padding: 12px; cursor: pointer; font-weight: 600;">
                    Close
                </button>
            </div>
        `;

        // Add hover effects
        modal.querySelectorAll('button').forEach(btn => {
            btn.onmouseenter = () => btn.style.transform = 'translateY(-2px)';
            btn.onmouseleave = () => btn.style.transform = 'translateY(0)';
        });

        // Close on background click
        modal.onclick = (e) => {
            if (e.target === modal) modal.remove();
        };

        document.body.appendChild(modal);
    }

    // Add share buttons to page
    addShareButtons() {
        // Check if share buttons already exist
        if (document.getElementById('social-share-buttons')) return;

        // Create floating share button
        const shareBtn = document.createElement('button');
        shareBtn.id = 'social-share-fab';
        shareBtn.innerHTML = '📱';
        shareBtn.style.cssText = `
            position: fixed;
            bottom: 80px;
            right: 20px;
            width: 56px;
            height: 56px;
            border-radius: 50%;
            background: linear-gradient(135deg, #FF6B35, #F7B801);
            color: white;
            border: none;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 20px rgba(255, 107, 53, 0.4);
            z-index: 999;
            transition: all 0.3s;
        `;
        
        shareBtn.onmouseenter = () => {
            shareBtn.style.transform = 'scale(1.1)';
            shareBtn.style.boxShadow = '0 6px 30px rgba(255, 107, 53, 0.6)';
        };
        
        shareBtn.onmouseleave = () => {
            shareBtn.style.transform = 'scale(1)';
            shareBtn.style.boxShadow = '0 4px 20px rgba(255, 107, 53, 0.4)';
        };
        
        shareBtn.onclick = () => {
            if (navigator.share) {
                this.nativeShare();
            } else {
                this.showShareModal();
            }
        };

        document.body.appendChild(shareBtn);
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

    // Track shares
    trackShare(platform) {
        if (window.analyticsTracker) {
            window.analyticsTracker.trackEvent('social_share', {
                platform: platform,
                url: window.location.href,
                page: window.location.pathname
            });
        }
    }

    // Increment social shares count for achievements
    incrementSocialShares() {
        const dashboardData = JSON.parse(localStorage.getItem('dashboardData') || '{}');
        dashboardData.socialShares = (dashboardData.socialShares || 0) + 1;
        localStorage.setItem('dashboardData', JSON.stringify(dashboardData));

        // Check achievements
        if (window.achievementSystem) {
            window.achievementSystem.checkAchievements();
        }
    }

    // Share achievement
    shareAchievement(achievementName, achievementIcon) {
        const text = `🎉 I just unlocked the "${achievementName}" achievement on ${this.config.siteName}! ${achievementIcon}`;
        
        if (navigator.share) {
            this.nativeShare({
                title: 'Achievement Unlocked!',
                text: text,
                url: this.config.siteUrl
            });
        } else {
            this.shareToTwitter(text);
        }
    }

    // Share quiz result
    shareQuizResult(quizName, score, total) {
        const percentage = Math.round((score / total) * 100);
        const text = `I scored ${score}/${total} (${percentage}%) on the ${quizName} quiz at ${this.config.siteName}! Can you beat my score?`;
        
        if (navigator.share) {
            this.nativeShare({
                title: 'Quiz Result',
                text: text,
                url: this.config.siteUrl
            });
        } else {
            this.shareToTwitter(text);
        }
    }

    // Share game result
    shareGameResult(gameName, result) {
        const text = `Check out my ${gameName} result on ${this.config.siteName}: ${result}`;
        
        if (navigator.share) {
            this.nativeShare({
                title: 'Game Result',
                text: text,
                url: this.config.siteUrl
            });
        } else {
            this.shareToTwitter(text);
        }
    }
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }
    
    @keyframes slideUp {
        from {
            transform: translateY(50px);
            opacity: 0;
        }
        to {
            transform: translateY(0);
            opacity: 1;
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
    
    @keyframes slideOutRight {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Initialize social share
const socialShare = new SocialShare();

// Make it globally available
window.socialShare = socialShare;

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = SocialShare;
}
