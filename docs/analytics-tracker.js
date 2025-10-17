// Advanced Analytics Tracker
// Tracks user behavior, conversions, and revenue

class AnalyticsTracker {
    constructor() {
        this.sessionId = this.generateSessionId();
        this.userId = this.getUserId();
        this.events = [];
        this.config = {
            googleAnalyticsId: 'G-XXXXXXXXXX', // Replace with your GA4 ID
            trackPageViews: true,
            trackClicks: true,
            trackScrollDepth: true,
            trackTimeOnPage: true,
            trackConversions: true
        };
        this.init();
    }

    init() {
        // Initialize Google Analytics
        this.initGoogleAnalytics();
        
        // Track page view
        if (this.config.trackPageViews) {
            this.trackPageView();
        }
        
        // Track scroll depth
        if (this.config.trackScrollDepth) {
            this.trackScrollDepth();
        }
        
        // Track time on page
        if (this.config.trackTimeOnPage) {
            this.trackTimeOnPage();
        }
        
        // Track clicks
        if (this.config.trackClicks) {
            this.trackClicks();
        }
        
        // Track before unload
        window.addEventListener('beforeunload', () => {
            this.trackEvent('session_end', {
                duration: Date.now() - this.sessionStartTime,
                events_count: this.events.length
            });
        });
    }

    initGoogleAnalytics() {
        // Load Google Analytics
        if (typeof gtag === 'undefined') {
            const script = document.createElement('script');
            script.async = true;
            script.src = `https://www.googletagmanager.com/gtag/js?id=${this.config.googleAnalyticsId}`;
            document.head.appendChild(script);
            
            window.dataLayer = window.dataLayer || [];
            window.gtag = function() { dataLayer.push(arguments); };
            gtag('js', new Date());
            gtag('config', this.config.googleAnalyticsId);
        }
    }

    generateSessionId() {
        return 'session_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    }

    getUserId() {
        let userId = localStorage.getItem('analytics_user_id');
        if (!userId) {
            userId = 'user_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
            localStorage.setItem('analytics_user_id', userId);
        }
        return userId;
    }

    trackPageView() {
        const pageData = {
            page_title: document.title,
            page_location: window.location.href,
            page_path: window.location.pathname,
            referrer: document.referrer,
            user_agent: navigator.userAgent,
            screen_resolution: `${window.screen.width}x${window.screen.height}`,
            viewport_size: `${window.innerWidth}x${window.innerHeight}`,
            language: navigator.language,
            timestamp: new Date().toISOString()
        };

        this.trackEvent('page_view', pageData);
        
        // Track to Google Analytics
        if (typeof gtag !== 'undefined') {
            gtag('event', 'page_view', pageData);
        }
    }

    trackEvent(eventName, eventData = {}) {
        const event = {
            event_name: eventName,
            event_data: eventData,
            session_id: this.sessionId,
            user_id: this.userId,
            timestamp: new Date().toISOString(),
            page: window.location.pathname
        };

        this.events.push(event);
        
        // Store in localStorage
        this.saveEvents();
        
        // Send to Google Analytics
        if (typeof gtag !== 'undefined') {
            gtag('event', eventName, eventData);
        }
        
        // Log to console in development
        if (window.location.hostname === 'localhost') {
            console.log('📊 Analytics Event:', eventName, eventData);
        }
    }

    trackScrollDepth() {
        let maxScroll = 0;
        const milestones = [25, 50, 75, 100];
        const tracked = new Set();

        window.addEventListener('scroll', () => {
            const scrollPercent = Math.round(
                (window.scrollY / (document.documentElement.scrollHeight - window.innerHeight)) * 100
            );

            if (scrollPercent > maxScroll) {
                maxScroll = scrollPercent;
            }

            milestones.forEach(milestone => {
                if (scrollPercent >= milestone && !tracked.has(milestone)) {
                    tracked.add(milestone);
                    this.trackEvent('scroll_depth', {
                        depth: milestone,
                        page: window.location.pathname
                    });
                }
            });
        });
    }

    trackTimeOnPage() {
        this.sessionStartTime = Date.now();
        
        // Track every 30 seconds
        setInterval(() => {
            const timeOnPage = Math.round((Date.now() - this.sessionStartTime) / 1000);
            this.trackEvent('time_on_page', {
                seconds: timeOnPage,
                page: window.location.pathname
            });
        }, 30000);
    }

    trackClicks() {
        document.addEventListener('click', (e) => {
            const target = e.target.closest('a, button');
            if (target) {
                const eventData = {
                    element_type: target.tagName.toLowerCase(),
                    element_text: target.textContent.trim().substring(0, 50),
                    element_id: target.id || null,
                    element_class: target.className || null,
                    href: target.href || null
                };

                this.trackEvent('click', eventData);
            }
        });
    }

    // Track conversions
    trackConversion(conversionType, value = 0, currency = 'USD') {
        const conversionData = {
            conversion_type: conversionType,
            value: value,
            currency: currency,
            page: window.location.pathname,
            timestamp: new Date().toISOString()
        };

        this.trackEvent('conversion', conversionData);
        
        // Track to Google Analytics as purchase
        if (typeof gtag !== 'undefined') {
            gtag('event', 'purchase', {
                transaction_id: this.generateSessionId(),
                value: value,
                currency: currency,
                items: [{
                    item_name: conversionType,
                    price: value
                }]
            });
        }
    }

    // Track premium subscription
    trackPremiumSubscription(plan, price) {
        this.trackConversion('premium_subscription', price);
        this.trackEvent('subscribe', {
            plan: plan,
            price: price,
            user_id: this.userId
        });
    }

    // Track game usage
    trackGameUsage(gameName, action) {
        this.trackEvent('game_usage', {
            game: gameName,
            action: action,
            timestamp: new Date().toISOString()
        });
    }

    // Track lesson completion
    trackLessonCompletion(lessonName, gameName) {
        this.trackEvent('lesson_completed', {
            lesson: lessonName,
            game: gameName,
            timestamp: new Date().toISOString()
        });
    }

    // Track quiz results
    trackQuizResult(quizName, score, totalQuestions) {
        this.trackEvent('quiz_completed', {
            quiz: quizName,
            score: score,
            total: totalQuestions,
            percentage: Math.round((score / totalQuestions) * 100),
            timestamp: new Date().toISOString()
        });
    }

    // Track errors
    trackError(errorMessage, errorStack) {
        this.trackEvent('error', {
            message: errorMessage,
            stack: errorStack,
            page: window.location.pathname,
            timestamp: new Date().toISOString()
        });
        
        if (typeof gtag !== 'undefined') {
            gtag('event', 'exception', {
                description: errorMessage,
                fatal: false
            });
        }
    }

    // Track performance
    trackPerformance() {
        if (window.performance && window.performance.timing) {
            const timing = window.performance.timing;
            const performanceData = {
                dns_time: timing.domainLookupEnd - timing.domainLookupStart,
                tcp_time: timing.connectEnd - timing.connectStart,
                request_time: timing.responseEnd - timing.requestStart,
                response_time: timing.responseEnd - timing.responseStart,
                dom_processing: timing.domComplete - timing.domLoading,
                load_time: timing.loadEventEnd - timing.navigationStart,
                page: window.location.pathname
            };

            this.trackEvent('performance', performanceData);
        }
    }

    // Save events to localStorage
    saveEvents() {
        try {
            const existingEvents = JSON.parse(localStorage.getItem('analytics_events') || '[]');
            const allEvents = [...existingEvents, ...this.events];
            
            // Keep only last 100 events
            const recentEvents = allEvents.slice(-100);
            localStorage.setItem('analytics_events', JSON.stringify(recentEvents));
            
            this.events = [];
        } catch (e) {
            console.error('Failed to save analytics events:', e);
        }
    }

    // Get analytics summary
    getAnalyticsSummary() {
        try {
            const events = JSON.parse(localStorage.getItem('analytics_events') || '[]');
            
            const summary = {
                total_events: events.length,
                page_views: events.filter(e => e.event_name === 'page_view').length,
                clicks: events.filter(e => e.event_name === 'click').length,
                conversions: events.filter(e => e.event_name === 'conversion').length,
                games_played: events.filter(e => e.event_name === 'game_usage').length,
                lessons_completed: events.filter(e => e.event_name === 'lesson_completed').length,
                quizzes_completed: events.filter(e => e.event_name === 'quiz_completed').length,
                errors: events.filter(e => e.event_name === 'error').length,
                session_id: this.sessionId,
                user_id: this.userId
            };

            return summary;
        } catch (e) {
            console.error('Failed to get analytics summary:', e);
            return null;
        }
    }

    // Export analytics data (Premium feature)
    exportAnalyticsData() {
        try {
            const events = JSON.parse(localStorage.getItem('analytics_events') || '[]');
            const summary = this.getAnalyticsSummary();
            
            const exportData = {
                summary: summary,
                events: events,
                exported_at: new Date().toISOString()
            };

            const dataStr = JSON.stringify(exportData, null, 2);
            const dataBlob = new Blob([dataStr], {type: 'application/json'});
            const url = URL.createObjectURL(dataBlob);
            
            const link = document.createElement('a');
            link.href = url;
            link.download = `analytics-${Date.now()}.json`;
            link.click();
            
            return true;
        } catch (e) {
            console.error('Failed to export analytics:', e);
            return false;
        }
    }

    // Clear analytics data
    clearAnalyticsData() {
        localStorage.removeItem('analytics_events');
        this.events = [];
    }
}

// Initialize analytics tracker
const analyticsTracker = new AnalyticsTracker();

// Make it globally available
window.analyticsTracker = analyticsTracker;

// Track performance after page load
window.addEventListener('load', () => {
    setTimeout(() => {
        analyticsTracker.trackPerformance();
    }, 1000);
});

// Track errors
window.addEventListener('error', (e) => {
    analyticsTracker.trackError(e.message, e.error?.stack);
});

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AnalyticsTracker;
}
