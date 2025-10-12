// Social Features Manager
// Handles leaderboards, achievements, and social interactions

class SocialFeaturesManager {
    constructor() {
        this.achievements = [];
        this.leaderboard = [];
        this.friends = [];
        this.loadSocialData();
    }

    loadSocialData() {
        this.achievements = JSON.parse(localStorage.getItem('userAchievements') || '[]');
        this.leaderboard = JSON.parse(localStorage.getItem('globalLeaderboard') || '[]');
        this.friends = JSON.parse(localStorage.getItem('userFriends') || '[]');
    }

    saveSocialData() {
        localStorage.setItem('userAchievements', JSON.stringify(this.achievements));
        localStorage.setItem('globalLeaderboard', JSON.stringify(this.leaderboard));
        localStorage.setItem('userFriends', JSON.stringify(this.friends));
    }

    // ACHIEVEMENTS SYSTEM
    checkAchievement(achievementId) {
        const achievement = this.getAchievementById(achievementId);
        if (!achievement) return false;

        if (this.hasAchievement(achievementId)) return false;

        this.unlockAchievement(achievementId);
        return true;
    }

    unlockAchievement(achievementId) {
        const achievement = this.getAchievementById(achievementId);
        if (!achievement || this.hasAchievement(achievementId)) return;

        this.achievements.push({
            id: achievementId,
            unlockedAt: new Date().toISOString(),
            ...achievement
        });

        this.saveSocialData();
        this.showAchievementNotification(achievement);
    }

    hasAchievement(achievementId) {
        return this.achievements.some(a => a.id === achievementId);
    }

    getAchievementById(id) {
        const allAchievements = this.getAllAchievements();
        return allAchievements.find(a => a.id === id);
    }

    getAllAchievements() {
        return [
            // Learning Achievements
            { id: 'first_lesson', name: 'First Steps', description: 'Complete your first lesson', icon: '📚', points: 10 },
            { id: 'lesson_master', name: 'Lesson Master', description: 'Complete 10 lessons', icon: '🎓', points: 50 },
            { id: 'quiz_beginner', name: 'Quiz Beginner', description: 'Complete your first quiz', icon: '📝', points: 15 },
            { id: 'quiz_expert', name: 'Quiz Expert', description: 'Score 100% on any quiz', icon: '🏆', points: 100 },
            { id: 'all_quizzes', name: 'Quiz Champion', description: 'Complete all 11 quizzes', icon: '👑', points: 200 },
            
            // Game Achievements
            { id: 'blackjack_pro', name: 'Blackjack Pro', description: 'Master all blackjack lessons', icon: '🃏', points: 75 },
            { id: 'poker_shark', name: 'Poker Shark', description: 'Master all poker lessons', icon: '🎴', points: 75 },
            { id: 'all_games', name: 'Casino Expert', description: 'Try all 13 game calculators', icon: '🎰', points: 150 },
            
            // Premium Achievements
            { id: 'premium_member', name: 'Premium Member', description: 'Upgrade to Premium', icon: '💎', points: 500 },
            { id: 'theme_collector', name: 'Theme Collector', description: 'Try all 6 themes', icon: '🎨', points: 50 },
            
            // Social Achievements
            { id: 'first_friend', name: 'Social Butterfly', description: 'Add your first friend', icon: '👥', points: 25 },
            { id: 'leaderboard_top10', name: 'Top 10', description: 'Reach top 10 on leaderboard', icon: '🥉', points: 100 },
            { id: 'leaderboard_top3', name: 'Podium Finish', description: 'Reach top 3 on leaderboard', icon: '🥈', points: 250 },
            { id: 'leaderboard_first', name: 'Champion', description: 'Reach #1 on leaderboard', icon: '🥇', points: 500 },
            
            // Streak Achievements
            { id: 'streak_7', name: '7 Day Streak', description: 'Login 7 days in a row', icon: '🔥', points: 50 },
            { id: 'streak_30', name: '30 Day Streak', description: 'Login 30 days in a row', icon: '🔥🔥', points: 200 },
            { id: 'streak_100', name: '100 Day Streak', description: 'Login 100 days in a row', icon: '🔥🔥🔥', points: 1000 }
        ];
    }

    getUserAchievements() {
        return this.achievements;
    }

    getAchievementProgress() {
        const total = this.getAllAchievements().length;
        const unlocked = this.achievements.length;
        return {
            unlocked,
            total,
            percentage: Math.round((unlocked / total) * 100)
        };
    }

    getTotalPoints() {
        return this.achievements.reduce((sum, a) => sum + (a.points || 0), 0);
    }

    showAchievementNotification(achievement) {
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 10000;
            background: linear-gradient(135deg, #FFD700, #FFA500);
            color: #000;
            padding: 20px 30px;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(255,215,0,0.5);
            animation: slideInRight 0.5s ease, pulse 2s ease infinite;
            font-weight: 600;
            max-width: 350px;
        `;

        notification.innerHTML = `
            <div style="font-size: 3em; text-align: center; margin-bottom: 10px;">${achievement.icon}</div>
            <div style="font-size: 1.2em; font-weight: 800; margin-bottom: 5px;">Achievement Unlocked!</div>
            <div style="font-size: 1em;">${achievement.name}</div>
            <div style="font-size: 0.9em; opacity: 0.8; margin-top: 5px;">${achievement.description}</div>
            <div style="font-size: 0.9em; margin-top: 10px;">+${achievement.points} points</div>
        `;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOutRight 0.5s ease';
            setTimeout(() => notification.remove(), 500);
        }, 5000);
    }

    // LEADERBOARD SYSTEM
    updateLeaderboard(username, score) {
        const existingIndex = this.leaderboard.findIndex(entry => entry.username === username);
        
        if (existingIndex >= 0) {
            if (score > this.leaderboard[existingIndex].score) {
                this.leaderboard[existingIndex].score = score;
                this.leaderboard[existingIndex].updatedAt = new Date().toISOString();
            }
        } else {
            this.leaderboard.push({
                username,
                score,
                updatedAt: new Date().toISOString()
            });
        }

        this.leaderboard.sort((a, b) => b.score - a.score);
        this.leaderboard = this.leaderboard.slice(0, 100); // Keep top 100
        this.saveSocialData();
    }

    getLeaderboard(limit = 10) {
        return this.leaderboard.slice(0, limit);
    }

    getUserRank(username) {
        const index = this.leaderboard.findIndex(entry => entry.username === username);
        return index >= 0 ? index + 1 : null;
    }

    // FRIENDS SYSTEM
    addFriend(friendUsername) {
        if (this.friends.includes(friendUsername)) {
            return { success: false, message: 'Already friends' };
        }

        this.friends.push(friendUsername);
        this.saveSocialData();
        
        // Check first friend achievement
        if (this.friends.length === 1) {
            this.checkAchievement('first_friend');
        }

        return { success: true, message: 'Friend added!' };
    }

    removeFriend(friendUsername) {
        const index = this.friends.indexOf(friendUsername);
        if (index < 0) {
            return { success: false, message: 'Not in friends list' };
        }

        this.friends.splice(index, 1);
        this.saveSocialData();
        return { success: true, message: 'Friend removed' };
    }

    getFriends() {
        return this.friends;
    }

    isFriend(username) {
        return this.friends.includes(username);
    }

    // SOCIAL STATS
    getSocialStats() {
        const user = JSON.parse(localStorage.getItem('currentUser') || '{}');
        const rank = this.getUserRank(user.username);
        
        return {
            achievements: this.getAchievementProgress(),
            totalPoints: this.getTotalPoints(),
            leaderboardRank: rank,
            friendsCount: this.friends.length,
            recentAchievements: this.achievements.slice(-5).reverse()
        };
    }

    // SHARE ACHIEVEMENT
    shareAchievement(achievementId) {
        const achievement = this.achievements.find(a => a.id === achievementId);
        if (!achievement) return;

        const shareText = `🏆 I just unlocked "${achievement.name}" on BetSage! ${achievement.icon}\n\n${achievement.description}\n\n+${achievement.points} points!`;
        
        if (navigator.share) {
            navigator.share({
                title: 'BetSage Achievement',
                text: shareText,
                url: window.location.origin
            }).catch(err => console.log('Share failed:', err));
        } else {
            // Fallback: Copy to clipboard
            navigator.clipboard.writeText(shareText).then(() => {
                alert('✓ Achievement copied to clipboard!');
            });
        }
    }
}

// Initialize social features
const socialFeatures = new SocialFeaturesManager();
window.socialFeatures = socialFeatures;

// Add CSS for animations
const style = document.createElement('style');
style.textContent = `
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
    
    @keyframes pulse {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.05);
        }
    }
`;
document.head.appendChild(style);
