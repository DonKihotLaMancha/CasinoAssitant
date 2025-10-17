// Achievement System
// Tracks and unlocks user achievements

class AchievementSystem {
    constructor() {
        this.achievements = this.defineAchievements();
        this.userAchievements = this.loadUserAchievements();
        this.init();
    }

    init() {
        // Check for achievements on page load
        this.checkAchievements();
        
        // Listen for custom events
        this.setupEventListeners();
    }

    defineAchievements() {
        return {
            // First Time Achievements
            first_game: {
                id: 'first_game',
                name: 'First Steps',
                description: 'Play your first game',
                icon: '🎮',
                category: 'beginner',
                points: 10,
                condition: (stats) => stats.gamesPlayed >= 1
            },
            first_lesson: {
                id: 'first_lesson',
                name: 'Student',
                description: 'Complete your first lesson',
                icon: '📚',
                category: 'beginner',
                points: 10,
                condition: (stats) => stats.lessonsCompleted >= 1
            },
            first_quiz: {
                id: 'first_quiz',
                name: 'Quiz Taker',
                description: 'Take your first quiz',
                icon: '📝',
                category: 'beginner',
                points: 10,
                condition: (stats) => stats.quizzesTaken >= 1
            },

            // Games Played
            games_10: {
                id: 'games_10',
                name: 'Player',
                description: 'Play 10 games',
                icon: '🎯',
                category: 'games',
                points: 25,
                condition: (stats) => stats.gamesPlayed >= 10
            },
            games_50: {
                id: 'games_50',
                name: 'Enthusiast',
                description: 'Play 50 games',
                icon: '🎲',
                category: 'games',
                points: 50,
                condition: (stats) => stats.gamesPlayed >= 50
            },
            games_100: {
                id: 'games_100',
                name: 'Expert',
                description: 'Play 100 games',
                icon: '🏅',
                category: 'games',
                points: 100,
                condition: (stats) => stats.gamesPlayed >= 100
            },
            games_500: {
                id: 'games_500',
                name: 'Master',
                description: 'Play 500 games',
                icon: '🏆',
                category: 'games',
                points: 250,
                condition: (stats) => stats.gamesPlayed >= 500
            },

            // Lessons Completed
            lessons_10: {
                id: 'lessons_10',
                name: 'Learner',
                description: 'Complete 10 lessons',
                icon: '📖',
                category: 'learning',
                points: 25,
                condition: (stats) => stats.lessonsCompleted >= 10
            },
            lessons_30: {
                id: 'lessons_30',
                name: 'Scholar',
                description: 'Complete 30 lessons',
                icon: '🎓',
                category: 'learning',
                points: 75,
                condition: (stats) => stats.lessonsCompleted >= 30
            },
            lessons_60: {
                id: 'lessons_60',
                name: 'Graduate',
                description: 'Complete all 60 lessons',
                icon: '👨‍🎓',
                category: 'learning',
                points: 200,
                condition: (stats) => stats.lessonsCompleted >= 60
            },

            // Quiz Performance
            quiz_perfect: {
                id: 'quiz_perfect',
                name: 'Perfect Score',
                description: 'Get 100% on a quiz',
                icon: '💯',
                category: 'quiz',
                points: 50,
                condition: (stats) => stats.perfectQuizzes >= 1
            },
            quiz_10: {
                id: 'quiz_10',
                name: 'Quiz Master',
                description: 'Complete 10 quizzes',
                icon: '📊',
                category: 'quiz',
                points: 50,
                condition: (stats) => stats.quizzesTaken >= 10
            },

            // Streaks
            streak_3: {
                id: 'streak_3',
                name: 'Getting Started',
                description: '3 day streak',
                icon: '🔥',
                category: 'streak',
                points: 15,
                condition: (stats) => stats.currentStreak >= 3
            },
            streak_7: {
                id: 'streak_7',
                name: 'Week Warrior',
                description: '7 day streak',
                icon: '⚡',
                category: 'streak',
                points: 35,
                condition: (stats) => stats.currentStreak >= 7
            },
            streak_30: {
                id: 'streak_30',
                name: 'Month Master',
                description: '30 day streak',
                icon: '🌟',
                category: 'streak',
                points: 150,
                condition: (stats) => stats.currentStreak >= 30
            },
            streak_100: {
                id: 'streak_100',
                name: 'Century Club',
                description: '100 day streak',
                icon: '💎',
                category: 'streak',
                points: 500,
                condition: (stats) => stats.currentStreak >= 100
            },

            // Premium
            premium: {
                id: 'premium',
                name: 'Premium Member',
                description: 'Subscribe to Premium',
                icon: '👑',
                category: 'premium',
                points: 100,
                condition: (stats) => stats.isPremium === true
            },

            // Exploration
            all_games: {
                id: 'all_games',
                name: 'Game Master',
                description: 'Try all 13 games',
                icon: '🎰',
                category: 'exploration',
                points: 75,
                condition: (stats) => stats.uniqueGamesPlayed >= 13
            },

            // Time-based
            early_bird: {
                id: 'early_bird',
                name: 'Early Bird',
                description: 'Visit before 8 AM',
                icon: '🌅',
                category: 'time',
                points: 20,
                condition: (stats) => {
                    const hour = new Date().getHours();
                    return hour >= 5 && hour < 8;
                }
            },
            night_owl: {
                id: 'night_owl',
                name: 'Night Owl',
                description: 'Visit after midnight',
                icon: '🦉',
                category: 'time',
                points: 20,
                condition: (stats) => {
                    const hour = new Date().getHours();
                    return hour >= 0 && hour < 4;
                }
            },

            // Social
            social: {
                id: 'social',
                name: 'Social Butterfly',
                description: 'Share on social media',
                icon: '📱',
                category: 'social',
                points: 25,
                condition: (stats) => stats.socialShares >= 1
            },
            referral: {
                id: 'referral',
                name: 'Recruiter',
                description: 'Refer a friend',
                icon: '🤝',
                category: 'social',
                points: 50,
                condition: (stats) => stats.referrals >= 1
            },

            // Engagement
            feedback: {
                id: 'feedback',
                name: 'Voice Heard',
                description: 'Provide feedback',
                icon: '💬',
                category: 'engagement',
                points: 30,
                condition: (stats) => stats.feedbackGiven === true
            },
            time_spent: {
                id: 'time_spent',
                name: 'Dedicated',
                description: 'Spend 10 hours on the site',
                icon: '⏰',
                category: 'engagement',
                points: 100,
                condition: (stats) => stats.totalTime >= 600
            },

            // Ultimate
            legend: {
                id: 'legend',
                name: 'Legend',
                description: 'Unlock all other achievements',
                icon: '🏆',
                category: 'ultimate',
                points: 1000,
                condition: (stats) => {
                    const totalAchievements = Object.keys(this.achievements).length - 1;
                    return stats.achievementsUnlocked >= totalAchievements;
                }
            }
        };
    }

    loadUserAchievements() {
        const stored = localStorage.getItem('userAchievements');
        return stored ? JSON.parse(stored) : [];
    }

    saveUserAchievements() {
        localStorage.setItem('userAchievements', JSON.stringify(this.userAchievements));
    }

    getUserStats() {
        const dashboardData = JSON.parse(localStorage.getItem('dashboardData') || '{}');
        const premiumStatus = localStorage.getItem('casinoPremium') === 'true';
        const analyticsData = JSON.parse(localStorage.getItem('analytics_events') || '[]');
        
        return {
            gamesPlayed: dashboardData.gamesPlayed || 0,
            lessonsCompleted: dashboardData.lessonsCompleted || 0,
            quizzesTaken: dashboardData.quizzesTaken || 0,
            perfectQuizzes: dashboardData.perfectQuizzes || 0,
            currentStreak: dashboardData.currentStreak || 0,
            totalTime: dashboardData.totalTime || 0,
            uniqueGamesPlayed: dashboardData.uniqueGamesPlayed || 0,
            isPremium: premiumStatus,
            socialShares: dashboardData.socialShares || 0,
            referrals: dashboardData.referrals || 0,
            feedbackGiven: dashboardData.feedbackGiven || false,
            achievementsUnlocked: this.userAchievements.length
        };
    }

    checkAchievements() {
        const stats = this.getUserStats();
        const newAchievements = [];

        Object.values(this.achievements).forEach(achievement => {
            // Skip if already unlocked
            if (this.userAchievements.includes(achievement.id)) {
                return;
            }

            // Check condition
            if (achievement.condition(stats)) {
                this.unlockAchievement(achievement.id);
                newAchievements.push(achievement);
            }
        });

        return newAchievements;
    }

    unlockAchievement(achievementId) {
        if (this.userAchievements.includes(achievementId)) {
            return false;
        }

        this.userAchievements.push(achievementId);
        this.saveUserAchievements();

        const achievement = this.achievements[achievementId];
        this.showAchievementNotification(achievement);
        
        // Track achievement unlock
        if (window.analyticsTracker) {
            window.analyticsTracker.trackEvent('achievement_unlocked', {
                achievement_id: achievementId,
                achievement_name: achievement.name,
                points: achievement.points
            });
        }

        return true;
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
            box-shadow: 0 8px 32px rgba(255, 215, 0, 0.5);
            max-width: 350px;
            animation: slideInRight 0.5s ease-out, pulse 0.5s ease-out 0.5s;
            cursor: pointer;
        `;

        notification.innerHTML = `
            <div style="display: flex; align-items: center; gap: 15px;">
                <div style="font-size: 3em;">${achievement.icon}</div>
                <div>
                    <div style="font-weight: 800; font-size: 1.2em; margin-bottom: 5px;">
                        🎉 Achievement Unlocked!
                    </div>
                    <div style="font-weight: 600; margin-bottom: 3px;">
                        ${achievement.name}
                    </div>
                    <div style="opacity: 0.8; font-size: 0.9em;">
                        ${achievement.description}
                    </div>
                    <div style="margin-top: 8px; font-weight: 700;">
                        +${achievement.points} points
                    </div>
                </div>
            </div>
        `;

        document.body.appendChild(notification);

        // Play sound if available
        this.playAchievementSound();

        // Remove after 5 seconds
        setTimeout(() => {
            notification.style.animation = 'slideOutRight 0.5s ease-out';
            setTimeout(() => notification.remove(), 500);
        }, 5000);

        // Click to dismiss
        notification.onclick = () => {
            notification.style.animation = 'slideOutRight 0.5s ease-out';
            setTimeout(() => notification.remove(), 500);
        };
    }

    playAchievementSound() {
        try {
            const audio = new Audio('data:audio/wav;base64,UklGRnoGAABXQVZFZm10IBAAAAABAAEAQB8AAEAfAAABAAgAZGF0YQoGAACBhYqFbF1fdJivrJBhNjVgodDbq2EcBj+a2/LDciUFLIHO8tiJNwgZaLvt559NEAxQp+PwtmMcBjiR1/LMeSwFJHfH8N2QQAoUXrTp66hVFApGn+DyvmwhBSuBzvLZiTYIGGS57OihUBELTKXh8bllHAU2jdXzzn0vBSh+zPDajz4KE1y06+qnVRQLRp/g8r5sIQUrgc7y2Yk2CBhkuezooVARDEyl4fG5ZRwFNo3V885+LwUofszw2o8+ChNctOvqp1UVC0af4PK+bCEFK4HO8tmJNggYZLns6KFQEQxMpeHxuWUcBTaN1fPOfi8FKH7M8NqPPgoTXLTr6qdVFQtGn+DyvmwhBSuBzvLZiTYIGGS57OihUBEMTKXh8bllHAU2jdXzzn4vBSh+zPDajz4KE1y06+qnVRULRp/g8r5sIQUrgc7y2Yk2CBhkuezooVARDEyl4fG5ZRwFNo3V885+LwUofszw2o8+ChNctOvqp1UVC0af4PK+bCEFK4HO8tmJNggYZLns6KFQEQxMpeHxuWUcBTaN1fPOfi8FKH7M8NqPPgoTXLTr6qdVFQtGn+DyvmwhBSuBzvLZiTYIGGS57OihUBEMTKXh8bllHAU2jdXzzn4vBSh+zPDajz4KE1y06+qnVRULRp/g8r5sIQUrgc7y2Yk2CBhkuezooVARDEyl4fG5ZRwFNo3V885+LwUofszw2o8+ChNctOvqp1UVC0af4PK+bCEFK4HO8tmJNggYZLns6KFQEQxMpeHxuWUcBTaN1fPOfi8FKH7M8NqPPgoTXLTr6qdVFQtGn+DyvmwhBSuBzvLZiTYIGGS57OihUBEMTKXh8bllHAU2jdXzzn4vBSh+zPDajz4KE1y06+qnVRULRp/g8r5sIQUrgc7y2Yk2CBhkuezooVARDEyl4fG5ZRwFNo3V885+LwUofszw2o8+ChNctOvqp1UVC0af4PK+bCEFK4HO8tmJNggYZLns6KFQEQxMpeHxuWUcBTaN1fPOfi8FKH7M8NqPPgoTXLTr6qdVFQtGn+DyvmwhBSuBzvLZiTYIGGS57OihUBEMTKXh8bllHAU2jdXzzn4vBSh+zPDajz4KE1y06+qnVRULRp/g8r5sIQUrgc7y2Yk2CBhkuezooVARDEyl4fG5ZRwFNo3V885+LwUofszw2o8+ChNctOvqp1UVC0af4PK+bCEFK4HO8tmJNggYZLns6KFQEQxMpeHxuWUcBTaN1fPOfi8FKH7M8NqPPgoTXLTr6qdVFQtGn+DyvmwhBSuBzvLZiTYIGGS57OihUBEMTKXh8bllHAU2jdXzzn4vBSh+zPDajz4KE1y06+qnVRULRp/g8r5sIQUrgc7y2Yk2CBhkuezooVARDEyl4fG5ZRwFNo3V885+LwUofszw2o8+ChNctOvqp1UVC0af4PK+bCEFK4HO8tmJNggYZLns6KFQEQxMpeHxuWUcBTaN1fPOfi8FKH7M8NqPPgoTXLTr6qdVFQ==');
            audio.volume = 0.3;
            audio.play().catch(() => {});
        } catch (e) {
            // Silently fail if audio doesn't work
        }
    }

    setupEventListeners() {
        // Listen for custom achievement events
        window.addEventListener('achievement:check', () => {
            this.checkAchievements();
        });

        window.addEventListener('achievement:unlock', (e) => {
            if (e.detail && e.detail.achievementId) {
                this.unlockAchievement(e.detail.achievementId);
            }
        });
    }

    getTotalPoints() {
        return this.userAchievements.reduce((total, achievementId) => {
            const achievement = this.achievements[achievementId];
            return total + (achievement ? achievement.points : 0);
        }, 0);
    }

    getProgress() {
        const total = Object.keys(this.achievements).length;
        const unlocked = this.userAchievements.length;
        return {
            unlocked: unlocked,
            total: total,
            percentage: Math.round((unlocked / total) * 100)
        };
    }

    getAchievementsByCategory(category) {
        return Object.values(this.achievements).filter(a => a.category === category);
    }

    isUnlocked(achievementId) {
        return this.userAchievements.includes(achievementId);
    }

    resetAchievements() {
        if (confirm('Are you sure you want to reset all achievements? This cannot be undone.')) {
            this.userAchievements = [];
            this.saveUserAchievements();
            alert('All achievements have been reset.');
            return true;
        }
        return false;
    }
}

// Add CSS animations
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

// Initialize achievement system
const achievementSystem = new AchievementSystem();

// Make it globally available
window.achievementSystem = achievementSystem;

// Check achievements periodically
setInterval(() => {
    achievementSystem.checkAchievements();
}, 30000); // Every 30 seconds

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = AchievementSystem;
}
