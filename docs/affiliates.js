// Affiliate Marketing System for Casino Assistant
// Manage affiliate links and track conversions

const affiliatePrograms = {
    betmgm: {
        name: 'BetMGM',
        url: 'https://betmgm.com?ref=YOUR_AFFILIATE_ID',
        commission: '$100-300 per signup',
        logo: '🎰',
        description: 'Top-rated online casino and sportsbook'
    },
    draftkings: {
        name: 'DraftKings',
        url: 'https://draftkings.com?ref=YOUR_AFFILIATE_ID',
        commission: 'High commissions',
        logo: '👑',
        description: 'Leading sports betting platform'
    },
    fanduel: {
        name: 'FanDuel',
        url: 'https://fanduel.com?ref=YOUR_AFFILIATE_ID',
        commission: 'Revenue share',
        logo: '🏆',
        description: 'Premier daily fantasy sports'
    },
    bet365: {
        name: 'Bet365',
        url: 'https://bet365.com?ref=YOUR_AFFILIATE_ID',
        commission: 'Up to 35% revenue share',
        logo: '🌟',
        description: 'Global betting leader'
    },
    casino888: {
        name: '888 Casino',
        url: 'https://888casino.com?ref=YOUR_AFFILIATE_ID',
        commission: 'Up to 40% revenue share',
        logo: '🎲',
        description: 'Established online casino'
    }
};

class AffiliateManager {
    constructor() {
        this.programs = affiliatePrograms;
        this.trackingEnabled = true;
    }

    // Track affiliate click
    trackClick(program, game) {
        if (!this.trackingEnabled) return;

        const click = {
            program: program,
            game: game,
            timestamp: new Date().toISOString(),
            referrer: document.referrer
        };

        // Store in localStorage
        const clicks = JSON.parse(localStorage.getItem('affiliateClicks') || '[]');
        clicks.push(click);
        localStorage.setItem('affiliateClicks', JSON.stringify(clicks));

        // Send to analytics (if available)
        if (typeof gtag !== 'undefined') {
            gtag('event', 'affiliate_click', {
                'program': program,
                'game': game
            });
        }
    }

    // Create affiliate button
    createButton(program, game, text = 'Play for Real Money') {
        const affiliate = this.programs[program];
        if (!affiliate) return null;

        const button = document.createElement('a');
        button.href = affiliate.url;
        button.target = '_blank';
        button.rel = 'noopener noreferrer';
        button.className = 'affiliate-btn';
        button.innerHTML = `${affiliate.logo} ${text} →`;
        
        button.onclick = () => {
            this.trackClick(program, game);
            if (typeof casinoSounds !== 'undefined') {
                casinoSounds.playSound('click');
            }
        };

        return button;
    }

    // Get affiliate stats
    getStats() {
        const clicks = JSON.parse(localStorage.getItem('affiliateClicks') || '[]');
        const stats = {};

        clicks.forEach(click => {
            if (!stats[click.program]) {
                stats[click.program] = 0;
            }
            stats[click.program]++;
        });

        return stats;
    }

    // Generate affiliate banner HTML
    generateBanner(program) {
        const affiliate = this.programs[program];
        if (!affiliate) return '';

        return `
            <div class="affiliate-banner">
                <div class="affiliate-logo">${affiliate.logo}</div>
                <div class="affiliate-info">
                    <h3>${affiliate.name}</h3>
                    <p>${affiliate.description}</p>
                    <small>Commission: ${affiliate.commission}</small>
                </div>
                <a href="${affiliate.url}" target="_blank" rel="noopener noreferrer" 
                   class="affiliate-cta" onclick="affiliateManager.trackClick('${program}', 'banner')">
                    Sign Up Now →
                </a>
            </div>
        `;
    }
}

// Global instance
const affiliateManager = new AffiliateManager();

// CSS for affiliate buttons
const affiliateStyles = `
<style>
.affiliate-btn {
    display: inline-block;
    padding: 15px 30px;
    background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
    color: white;
    text-decoration: none;
    border-radius: 50px;
    font-weight: bold;
    font-size: 1.1em;
    box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
    transition: all 0.3s;
    margin: 10px 0;
}
.affiliate-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
}
.affiliate-banner {
    background: linear-gradient(135deg, rgba(102, 126, 234, 0.1) 0%, rgba(118, 75, 162, 0.1) 100%);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 15px;
    padding: 20px;
    margin: 20px 0;
    display: flex;
    align-items: center;
    gap: 20px;
}
.affiliate-logo {
    font-size: 3em;
}
.affiliate-info {
    flex: 1;
}
.affiliate-info h3 {
    margin-bottom: 5px;
    color: white;
}
.affiliate-info p {
    color: rgba(255, 255, 255, 0.7);
    margin-bottom: 5px;
}
.affiliate-info small {
    color: rgba(255, 255, 255, 0.5);
}
.affiliate-cta {
    padding: 12px 25px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    text-decoration: none;
    border-radius: 50px;
    font-weight: bold;
    white-space: nowrap;
    transition: all 0.3s;
}
.affiliate-cta:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
}
</style>
`;

// Inject styles
document.head.insertAdjacentHTML('beforeend', affiliateStyles);
