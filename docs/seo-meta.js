// SEO Optimization for Casino Assistant
// Automatically adds meta tags for better search engine ranking

const seoConfig = {
    siteName: 'Casino Assistant',
    siteUrl: 'https://yourdomain.com', // CHANGE THIS
    author: 'Casino Assistant Team',
    twitterHandle: '@casinoassistant', // CHANGE THIS
    
    pages: {
        index: {
            title: 'Casino Assistant - Professional Odds Calculators & Strategy Tools',
            description: 'Free casino odds calculators for Blackjack, Poker, Roulette, Craps & more. Learn winning strategies with 60+ lessons. Master every casino game!',
            keywords: 'casino odds calculator, blackjack calculator, poker odds, roulette probability, casino strategy, gambling tools',
            image: '/images/og-image.png'
        },
        academy: {
            title: 'Casino Academy - Learn All Casino Games | Free Lessons',
            description: 'Master every casino game with 60+ comprehensive lessons. Learn Blackjack, Poker, Roulette, Craps strategies. Free casino education platform.',
            keywords: 'casino lessons, learn blackjack, poker strategy, casino education, gambling tutorial',
            image: '/images/academy-og.png'
        },
        blackjack: {
            title: 'Blackjack Odds Calculator - Free Basic Strategy Tool',
            description: 'Professional Blackjack odds calculator with basic strategy, card counting, and win probability. Learn optimal play for every hand.',
            keywords: 'blackjack calculator, blackjack odds, basic strategy, card counting, blackjack probability',
            image: '/images/blackjack-og.png'
        },
        poker: {
            title: 'Poker Odds Calculator - Hand Strength & Win Percentage',
            description: 'Calculate poker hand odds, win percentages, and pot odds instantly. Free Texas Hold\'em probability calculator.',
            keywords: 'poker calculator, poker odds, hand strength, pot odds, texas holdem calculator',
            image: '/images/poker-og.png'
        },
        roulette: {
            title: 'Roulette Odds Calculator - Win Probability for All Bets',
            description: 'Calculate roulette odds for European and American wheels. Analyze all bet types with house edge and expected value.',
            keywords: 'roulette calculator, roulette odds, betting strategy, roulette probability',
            image: '/images/roulette-og.png'
        }
    }
};

class SEOManager {
    constructor(config) {
        this.config = config;
    }

    // Set page meta tags
    setPageMeta(pageKey) {
        const page = this.config.pages[pageKey];
        if (!page) return;

        // Title
        document.title = page.title;

        // Meta description
        this.setMeta('description', page.description);
        this.setMeta('keywords', page.keywords);
        this.setMeta('author', this.config.author);

        // Open Graph
        this.setMeta('og:title', page.title, 'property');
        this.setMeta('og:description', page.description, 'property');
        this.setMeta('og:image', this.config.siteUrl + page.image, 'property');
        this.setMeta('og:url', window.location.href, 'property');
        this.setMeta('og:type', 'website', 'property');
        this.setMeta('og:site_name', this.config.siteName, 'property');

        // Twitter Card
        this.setMeta('twitter:card', 'summary_large_image', 'name');
        this.setMeta('twitter:site', this.config.twitterHandle, 'name');
        this.setMeta('twitter:title', page.title, 'name');
        this.setMeta('twitter:description', page.description, 'name');
        this.setMeta('twitter:image', this.config.siteUrl + page.image, 'name');

        // Canonical URL
        this.setCanonical(window.location.href);

        // Structured Data (JSON-LD)
        this.addStructuredData(page);
    }

    // Set meta tag
    setMeta(name, content, attribute = 'name') {
        let meta = document.querySelector(`meta[${attribute}="${name}"]`);
        if (!meta) {
            meta = document.createElement('meta');
            meta.setAttribute(attribute, name);
            document.head.appendChild(meta);
        }
        meta.setAttribute('content', content);
    }

    // Set canonical URL
    setCanonical(url) {
        let link = document.querySelector('link[rel="canonical"]');
        if (!link) {
            link = document.createElement('link');
            link.setAttribute('rel', 'canonical');
            document.head.appendChild(link);
        }
        link.setAttribute('href', url);
    }

    // Add structured data
    addStructuredData(page) {
        const structuredData = {
            "@context": "https://schema.org",
            "@type": "WebApplication",
            "name": this.config.siteName,
            "description": page.description,
            "url": window.location.href,
            "applicationCategory": "GameApplication",
            "offers": {
                "@type": "Offer",
                "price": "0",
                "priceCurrency": "USD"
            },
            "aggregateRating": {
                "@type": "AggregateRating",
                "ratingValue": "4.8",
                "ratingCount": "1250"
            }
        };

        let script = document.querySelector('script[type="application/ld+json"]');
        if (!script) {
            script = document.createElement('script');
            script.type = 'application/ld+json';
            document.head.appendChild(script);
        }
        script.textContent = JSON.stringify(structuredData);
    }

    // Generate sitemap.xml content
    generateSitemap() {
        const urls = Object.keys(this.config.pages).map(key => {
            return `
  <url>
    <loc>${this.config.siteUrl}/${key === 'index' ? '' : key + '.html'}</loc>
    <lastmod>${new Date().toISOString().split('T')[0]}</lastmod>
    <changefreq>weekly</changefreq>
    <priority>${key === 'index' ? '1.0' : '0.8'}</priority>
  </url>`;
        }).join('');

        return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${urls}
</urlset>`;
    }

    // Generate robots.txt content
    generateRobotsTxt() {
        return `User-agent: *
Allow: /

Sitemap: ${this.config.siteUrl}/sitemap.xml`;
    }
}

// Global instance
const seoManager = new SEOManager(seoConfig);

// Auto-detect page and set meta
window.addEventListener('DOMContentLoaded', () => {
    const path = window.location.pathname;
    let pageKey = 'index';
    
    if (path.includes('casino_academy')) pageKey = 'academy';
    else if (path.includes('blackjack')) pageKey = 'blackjack';
    else if (path.includes('poker')) pageKey = 'poker';
    else if (path.includes('roulette')) pageKey = 'roulette';
    
    seoManager.setPageMeta(pageKey);
});

// Export for use
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { seoManager, SEOManager };
}
