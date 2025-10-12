// Cloud Sync Manager (Optional Feature)
// Syncs user data across devices

class CloudSyncManager {
    constructor() {
        this.syncEnabled = false;
        this.lastSyncTime = null;
        this.syncInterval = 5 * 60 * 1000; // 5 minutes
        this.syncTimer = null;
        this.loadSyncSettings();
    }

    loadSyncSettings() {
        const settings = JSON.parse(localStorage.getItem('cloudSyncSettings') || '{}');
        this.syncEnabled = settings.enabled || false;
        this.lastSyncTime = settings.lastSync ? new Date(settings.lastSync) : null;
        
        if (this.syncEnabled) {
            this.startAutoSync();
        }
    }

    saveSyncSettings() {
        const settings = {
            enabled: this.syncEnabled,
            lastSync: this.lastSyncTime ? this.lastSyncTime.toISOString() : null
        };
        localStorage.setItem('cloudSyncSettings', JSON.stringify(settings));
    }

    enableSync() {
        if (!this.isPremiumUser()) {
            if (confirm('☁️ Cloud Sync is a Premium feature!\n\n' +
                       'Upgrade to Premium to unlock:\n' +
                       '✓ Sync across all devices\n' +
                       '✓ Automatic backups\n' +
                       '✓ Never lose your data\n' +
                       '✓ Access anywhere\n\n' +
                       'Want to upgrade now?')) {
                window.location.href = 'games/premium.html';
            }
            return false;
        }

        this.syncEnabled = true;
        this.saveSyncSettings();
        this.startAutoSync();
        this.syncNow();
        return true;
    }

    disableSync() {
        this.syncEnabled = false;
        this.saveSyncSettings();
        this.stopAutoSync();
    }

    startAutoSync() {
        if (this.syncTimer) {
            clearInterval(this.syncTimer);
        }
        
        this.syncTimer = setInterval(() => {
            this.syncNow();
        }, this.syncInterval);
    }

    stopAutoSync() {
        if (this.syncTimer) {
            clearInterval(this.syncTimer);
            this.syncTimer = null;
        }
    }

    async syncNow() {
        if (!this.syncEnabled || !this.isPremiumUser()) {
            return { success: false, message: 'Sync not enabled or premium required' };
        }

        try {
            // Collect all data to sync
            const dataToSync = this.collectSyncData();
            
            // In production, this would send to your backend API
            // For now, we'll simulate cloud storage using localStorage with a special key
            const syncKey = this.getSyncKey();
            const encryptedData = this.encryptData(dataToSync);
            
            localStorage.setItem(syncKey, encryptedData);
            
            this.lastSyncTime = new Date();
            this.saveSyncSettings();
            
            return {
                success: true,
                message: 'Data synced successfully',
                timestamp: this.lastSyncTime
            };
        } catch (error) {
            console.error('Sync error:', error);
            return {
                success: false,
                message: 'Sync failed: ' + error.message
            };
        }
    }

    async pullFromCloud() {
        if (!this.syncEnabled || !this.isPremiumUser()) {
            return { success: false, message: 'Sync not enabled or premium required' };
        }

        try {
            const syncKey = this.getSyncKey();
            const encryptedData = localStorage.getItem(syncKey);
            
            if (!encryptedData) {
                return { success: false, message: 'No cloud data found' };
            }
            
            const cloudData = this.decryptData(encryptedData);
            this.restoreSyncData(cloudData);
            
            return {
                success: true,
                message: 'Data restored from cloud',
                timestamp: new Date(cloudData.timestamp)
            };
        } catch (error) {
            console.error('Pull error:', error);
            return {
                success: false,
                message: 'Failed to restore data: ' + error.message
            };
        }
    }

    collectSyncData() {
        return {
            timestamp: new Date().toISOString(),
            user: JSON.parse(localStorage.getItem('currentUser') || '{}'),
            settings: JSON.parse(localStorage.getItem('casinoSettings') || '{}'),
            academyStats: JSON.parse(localStorage.getItem('casinoAcademyStats') || '{}'),
            premium: {
                status: localStorage.getItem('casinoPremium'),
                plan: localStorage.getItem('premiumPlan'),
                date: localStorage.getItem('premiumDate')
            },
            language: localStorage.getItem('casinoLanguage'),
            theme: localStorage.getItem('casinoTheme')
        };
    }

    restoreSyncData(data) {
        if (data.user) localStorage.setItem('currentUser', JSON.stringify(data.user));
        if (data.settings) localStorage.setItem('casinoSettings', JSON.stringify(data.settings));
        if (data.academyStats) localStorage.setItem('casinoAcademyStats', JSON.stringify(data.academyStats));
        if (data.premium) {
            if (data.premium.status) localStorage.setItem('casinoPremium', data.premium.status);
            if (data.premium.plan) localStorage.setItem('premiumPlan', data.premium.plan);
            if (data.premium.date) localStorage.setItem('premiumDate', data.premium.date);
        }
        if (data.language) localStorage.setItem('casinoLanguage', data.language);
        if (data.theme) localStorage.setItem('casinoTheme', data.theme);
    }

    getSyncKey() {
        const user = JSON.parse(localStorage.getItem('currentUser') || '{}');
        const userId = user.email || user.username || 'guest';
        return `cloudSync_${btoa(userId)}`;
    }

    encryptData(data) {
        // Simple base64 encoding (in production, use proper encryption)
        return btoa(JSON.stringify(data));
    }

    decryptData(encrypted) {
        // Simple base64 decoding (in production, use proper decryption)
        return JSON.parse(atob(encrypted));
    }

    isPremiumUser() {
        const premium = localStorage.getItem('casinoPremium');
        const date = localStorage.getItem('premiumDate');
        
        if (premium !== 'true' || !date) return false;
        
        const startDate = new Date(date);
        const now = new Date();
        const daysSince = Math.floor((now - startDate) / (1000 * 60 * 60 * 24));
        const plan = localStorage.getItem('premiumPlan');
        
        if (plan === 'yearly') return daysSince < 365;
        if (plan === 'monthly') return daysSince < 30;
        
        return false;
    }

    getSyncStatus() {
        return {
            enabled: this.syncEnabled,
            lastSync: this.lastSyncTime,
            isPremium: this.isPremiumUser(),
            autoSyncActive: this.syncTimer !== null
        };
    }

    getTimeSinceLastSync() {
        if (!this.lastSyncTime) return 'Never';
        
        const now = new Date();
        const diff = now - this.lastSyncTime;
        const minutes = Math.floor(diff / 60000);
        const hours = Math.floor(minutes / 60);
        const days = Math.floor(hours / 24);
        
        if (days > 0) return `${days} day${days > 1 ? 's' : ''} ago`;
        if (hours > 0) return `${hours} hour${hours > 1 ? 's' : ''} ago`;
        if (minutes > 0) return `${minutes} minute${minutes > 1 ? 's' : ''} ago`;
        return 'Just now';
    }
}

// Initialize cloud sync manager
const cloudSync = new CloudSyncManager();
window.cloudSync = cloudSync;
