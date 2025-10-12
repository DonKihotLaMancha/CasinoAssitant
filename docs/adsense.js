// Google AdSense Integration for Casino Assistant
// Replace 'ca-pub-XXXXXXXX' with your actual AdSense publisher ID

class AdManager {
    constructor(publisherId) {
        this.publisherId = publisherId;
        this.adsEnabled = true;
    }

    // Initialize AdSense
    init() {
        if (!this.publisherId || this.publisherId === 'ca-pub-XXXXXXXX') {
            console.warn('AdSense: Please add your publisher ID');
            return;
        }

        // Load AdSense script
        const script = document.createElement('script');
        script.src = `https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${this.publisherId}`;
        script.async = true;
        script.crossOrigin = 'anonymous';
        document.head.appendChild(script);
    }

    // Create ad slot
    createAdSlot(containerId, slot, format = 'auto', fullWidth = true) {
        const container = document.getElementById(containerId);
        if (!container) return;

        const ins = document.createElement('ins');
        ins.className = 'adsbygoogle';
        ins.style.display = 'block';
        ins.setAttribute('data-ad-client', this.publisherId);
        ins.setAttribute('data-ad-slot', slot);
        ins.setAttribute('data-ad-format', format);
        if (fullWidth) {
            ins.setAttribute('data-full-width-responsive', 'true');
        }

        container.appendChild(ins);

        // Push ad
        try {
            (adsbygoogle = window.adsbygoogle || []).push({});
        } catch (e) {
            console.error('AdSense error:', e);
        }
    }

    // Disable ads (for premium users)
    disableAds() {
        this.adsEnabled = false;
        document.querySelectorAll('.adsbygoogle').forEach(ad => {
            ad.style.display = 'none';
        });
    }

    // Enable ads
    enableAds() {
        this.adsEnabled = true;
        document.querySelectorAll('.adsbygoogle').forEach(ad => {
            ad.style.display = 'block';
        });
    }
}

// Initialize with your publisher ID
const adManager = new AdManager('ca-pub-XXXXXXXX'); // REPLACE THIS!

// Auto-init on page load
window.addEventListener('DOMContentLoaded', () => {
    // Check if user is premium
    const isPremium = localStorage.getItem('casinoPremium') === 'true';
    
    if (!isPremium) {
        adManager.init();
    }
});
