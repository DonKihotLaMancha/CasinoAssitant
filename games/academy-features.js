// 21 Academy - Advanced Features
// Enhanced learning system for blackjack mastery

// Study Plan Generator
function generateStudyPlan() {
    casinoSounds.playSound('click');
    
    const stats = JSON.parse(localStorage.getItem('blackjackStats') || '{}');
    const level = stats.level || 1;
    
    const plans = {
        beginner: [
            { time: 'Morning', duration: '30 min', task: '📋 Basic Strategy - Hard Hands', focus: 'Focus on 12-16 vs Dealer 2-6' },
            { time: 'Afternoon', duration: '20 min', task: '🎯 Live Advisor Practice', focus: 'Target: 80% accuracy' },
            { time: 'Evening', duration: '15 min', task: '📚 Review Session', focus: 'Soft hands and pairs' }
        ],
        intermediate: [
            { time: 'Morning', duration: '40 min', task: '🔢 Card Counting Basics', focus: 'Hi-Lo system practice' },
            { time: 'Afternoon', duration: '30 min', task: '🎯 Strategy Trainer', focus: 'Target: 90% accuracy' },
            { time: 'Evening', duration: '20 min', task: '💰 Bankroll Management', focus: 'Kelly Criterion study' }
        ],
        advanced: [
            { time: 'Morning', duration: '45 min', task: '🎓 Advanced Counting', focus: 'True count conversion' },
            { time: 'Afternoon', duration: '35 min', task: '🎯 Live Play Simulation', focus: 'Target: 95% accuracy' },
            { time: 'Evening', duration: '25 min', task: '📊 Hand Analysis', focus: 'Review tough decisions' }
        ]
    };
    
    let planType = 'beginner';
    if (level >= 8) planType = 'advanced';
    else if (level >= 4) planType = 'intermediate';
    
    const plan = plans[planType];
    
    alert(`📚 Your Personalized Study Plan Generated!\n\n` +
          `Level: ${level} (${getLevelTitle(level)})\n\n` +
          plan.map((session, i) => 
              `${i + 1}. ${session.time} (${session.duration})\n` +
              `   ${session.task}\n` +
              `   ${session.focus}\n`
          ).join('\n') +
          `\n✨ Follow this plan daily for best results!`);
}

// Skill Tree System
const skillTree = {
    'basic-strategy': {
        name: 'Basic Strategy',
        icon: '📋',
        level: 0,
        unlocked: true,
        xpRequired: 0,
        description: 'Master the fundamentals of blackjack'
    },
    'card-counting': {
        name: 'Card Counting',
        icon: '🔢',
        level: 0,
        unlocked: false,
        xpRequired: 500,
        prerequisite: 'basic-strategy',
        description: 'Learn the Hi-Lo counting system'
    },
    'advanced-counting': {
        name: 'Advanced Counting',
        icon: '🎯',
        level: 0,
        unlocked: false,
        xpRequired: 1500,
        prerequisite: 'card-counting',
        description: 'Master true count and betting spreads'
    },
    'bankroll-management': {
        name: 'Bankroll Management',
        icon: '💰',
        level: 0,
        unlocked: false,
        xpRequired: 300,
        prerequisite: 'basic-strategy',
        description: 'Learn proper money management'
    },
    'tournament-play': {
        name: 'Tournament Play',
        icon: '🏆',
        level: 0,
        unlocked: false,
        xpRequired: 2000,
        prerequisite: 'advanced-counting',
        description: 'Master tournament strategies'
    }
};

function unlockSkill(skillId) {
    const stats = JSON.parse(localStorage.getItem('blackjackStats') || '{}');
    const skill = skillTree[skillId];
    
    if (!skill) return;
    
    if (skill.unlocked) {
        alert(`✅ ${skill.name} is already unlocked!`);
        return;
    }
    
    if (stats.totalXP < skill.xpRequired) {
        alert(`🔒 Need ${skill.xpRequired - stats.totalXP} more XP to unlock ${skill.name}`);
        return;
    }
    
    if (skill.prerequisite && !skillTree[skill.prerequisite].unlocked) {
        alert(`🔒 Must complete ${skillTree[skill.prerequisite].name} first!`);
        return;
    }
    
    skill.unlocked = true;
    casinoSounds.playSound('win');
    alert(`🎉 ${skill.name} unlocked!\n\n${skill.description}`);
    
    // Save progress
    if (!stats.unlockedSkills) stats.unlockedSkills = [];
    stats.unlockedSkills.push(skillId);
    localStorage.setItem('blackjackStats', JSON.stringify(stats));
}

// Daily Challenge System
function generateDailyChallenge() {
    const challenges = [
        { name: 'Perfect Practice', task: 'Complete 50 hands with 100% accuracy', xp: 200, icon: '🎯' },
        { name: 'Speed Demon', task: 'Make 100 correct decisions in under 10 minutes', xp: 150, icon: '⚡' },
        { name: 'Card Counter', task: 'Maintain accurate count for 5 shoes', xp: 300, icon: '🔢' },
        { name: 'Bankroll Boss', task: 'Manage a session without going broke', xp: 100, icon: '💰' },
        { name: 'Strategy Master', task: 'Score 95%+ on strategy quiz', xp: 250, icon: '📚' }
    ];
    
    const today = new Date().toDateString();
    const stats = JSON.parse(localStorage.getItem('blackjackStats') || '{}');
    
    if (stats.lastChallenge === today) {
        alert('✅ You\'ve already completed today\'s challenge!\n\nCome back tomorrow for a new one.');
        return;
    }
    
    const challenge = challenges[Math.floor(Math.random() * challenges.length)];
    
    alert(`🎯 Daily Challenge\n\n` +
          `${challenge.icon} ${challenge.name}\n\n` +
          `Task: ${challenge.task}\n` +
          `Reward: ${challenge.xp} XP\n\n` +
          `Good luck!`);
}

// Achievement System
const achievements = [
    { id: 'first-steps', name: 'First Steps', desc: 'Complete your first lesson', icon: '👣', xp: 10 },
    { id: 'quick-learner', name: 'Quick Learner', desc: 'Reach level 5', icon: '🚀', xp: 50 },
    { id: 'strategy-master', name: 'Strategy Master', desc: '100% accuracy on 20 hands', icon: '🎯', xp: 100 },
    { id: 'card-counter', name: 'Card Counter', desc: 'Complete counting tutorial', icon: '🔢', xp: 150 },
    { id: 'high-roller', name: 'High Roller', desc: 'Analyze 100 hands', icon: '💎', xp: 75 },
    { id: 'perfectionist', name: 'Perfectionist', desc: 'Get 100% on strategy quiz', icon: '✨', xp: 200 },
    { id: 'dedicated', name: 'Dedicated', desc: '7-day streak', icon: '🔥', xp: 100 },
    { id: 'master', name: 'Blackjack Master', desc: 'Reach level 15', icon: '🏆', xp: 500 }
];

function checkAchievement(achievementId) {
    const stats = JSON.parse(localStorage.getItem('blackjackStats') || '{}');
    if (!stats.achievements) stats.achievements = [];
    
    if (stats.achievements.includes(achievementId)) return;
    
    const achievement = achievements.find(a => a.id === achievementId);
    if (!achievement) return;
    
    stats.achievements.push(achievementId);
    stats.totalXP = (stats.totalXP || 0) + achievement.xp;
    
    localStorage.setItem('blackjackStats', JSON.stringify(stats));
    
    casinoSounds.playSound('bigwin');
    alert(`🎉 Achievement Unlocked!\n\n` +
          `${achievement.icon} ${achievement.name}\n\n` +
          `${achievement.desc}\n\n` +
          `+${achievement.xp} XP`);
}

// Progress Analytics
function showDetailedAnalytics() {
    const stats = JSON.parse(localStorage.getItem('blackjackStats') || '{}');
    
    const totalHands = stats.handsAnalyzed || 0;
    const correct = stats.correctDecisions || 0;
    const accuracy = totalHands > 0 ? ((correct / totalHands) * 100).toFixed(1) : 0;
    const level = stats.level || 1;
    const xp = stats.totalXP || 0;
    const streak = stats.streak || 0;
    const achievements = (stats.achievements || []).length;
    
    const report = `
📊 21 ACADEMY PROGRESS REPORT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🎓 LEVEL & XP
   Current Level: ${level} (${getLevelTitle(level)})
   Total XP: ${xp}
   Next Level: ${(level * 100) - (xp % 100)} XP needed

🎯 PERFORMANCE
   Hands Analyzed: ${totalHands}
   Correct Decisions: ${correct}
   Accuracy: ${accuracy}%
   
🔥 ENGAGEMENT
   Current Streak: ${streak} days
   Achievements: ${achievements}/8
   
📈 SKILL LEVEL
   ${level < 3 ? 'Keep practicing basics!' : ''}
   ${level >= 3 && level < 8 ? 'Good progress! Focus on counting.' : ''}
   ${level >= 8 && level < 15 ? 'Advanced player! Master true count.' : ''}
   ${level >= 15 ? 'Expert level! Ready for tournaments!' : ''}

💡 RECOMMENDATION
   ${accuracy < 80 ? 'Focus on Basic Strategy review' : ''}
   ${accuracy >= 80 && accuracy < 95 ? 'Practice with Live Advisor' : ''}
   ${accuracy >= 95 ? 'Ready for advanced techniques!' : ''}
    `.trim();
    
    alert(report);
}

// Export functions for global use
window.generateStudyPlan = generateStudyPlan;
window.unlockSkill = unlockSkill;
window.generateDailyChallenge = generateDailyChallenge;
window.checkAchievement = checkAchievement;
window.showDetailedAnalytics = showDetailedAnalytics;
