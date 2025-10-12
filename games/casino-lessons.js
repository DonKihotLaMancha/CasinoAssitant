// Casino Academy - Comprehensive Lessons for All Games

const lessons = {
    blackjack: {
        title: "🃏 Blackjack Mastery Course",
        icon: "🃏",
        content: `
            <h2>🃏 Complete Blackjack Guide</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Game Basics</h3>
                <p><strong>Objective:</strong> Get closer to 21 than the dealer without going over.</p>
                <p><strong>Card Values:</strong></p>
                <ul>
                    <li>Number cards (2-10): Face value</li>
                    <li>Face cards (J, Q, K): 10 points</li>
                    <li>Aces: 1 or 11 (your choice)</li>
                </ul>
                <p><strong>Gameplay:</strong> You receive 2 cards, dealer gets 2 (one face up). You can Hit (take card), Stand (keep hand), Double Down (double bet, one card), or Split (if pair).</p>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: Basic Strategy</h3>
                <p>Basic Strategy is mathematically optimal play for every situation:</p>
                <div class="tip-box">
                    <strong>💡 Key Rules:</strong><br>
                    • Always hit on 8 or less<br>
                    • Always stand on 17 or more<br>
                    • Double on 11 vs dealer 2-10<br>
                    • Split Aces and 8s<br>
                    • Never split 5s or 10s<br>
                    • Hit 12-16 vs dealer 7-Ace
                </div>
                <p><strong>House Edge:</strong> Perfect basic strategy reduces house edge to ~0.5%</p>
            </div>

            <div class="lesson-section">
                <h3>🔢 Lesson 3: Card Counting (Hi-Lo)</h3>
                <p><strong>The Hi-Lo System:</strong></p>
                <ul>
                    <li>Low cards (2-6): +1</li>
                    <li>Neutral (7-9): 0</li>
                    <li>High cards (10-A): -1</li>
                </ul>
                <p><strong>Running Count:</strong> Add/subtract as cards are dealt</p>
                <p><strong>True Count:</strong> Running Count ÷ Decks Remaining</p>
                <p><strong>Betting:</strong> Increase bets when true count is +2 or higher</p>
                <div class="tip-box">
                    <strong>⚠️ Important:</strong> Card counting is legal but casinos may ask you to leave. Practice extensively before attempting in a casino.
                </div>
            </div>

            <div class="lesson-section">
                <h3>💰 Lesson 4: Bankroll Management</h3>
                <p><strong>The 1-3% Rule:</strong> Never bet more than 1-3% of your total bankroll per hand</p>
                <p><strong>Session Bankroll:</strong> Bring 50-100 times your minimum bet</p>
                <p><strong>Win/Loss Limits:</strong> Set limits before playing (e.g., quit if down 50% or up 100%)</p>
                <p><strong>Kelly Criterion:</strong> Optimal bet size = (Edge × Bankroll) / Variance</p>
            </div>

            <button class="quiz-btn" onclick="startQuiz('blackjack')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='blackjack_dashboard.html'">🎓 Go to 21 Academy</button>
        `
    },
    
    poker: {
        title: "🎴 Texas Hold'em Poker Course",
        icon: "🎴",
        content: `
            <h2>🎴 Texas Hold'em Mastery</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Hand Rankings</h3>
                <p><strong>From Highest to Lowest:</strong></p>
                <ol>
                    <li><strong>Royal Flush:</strong> A-K-Q-J-10 same suit</li>
                    <li><strong>Straight Flush:</strong> 5 cards in sequence, same suit</li>
                    <li><strong>Four of a Kind:</strong> 4 cards of same rank</li>
                    <li><strong>Full House:</strong> 3 of a kind + pair</li>
                    <li><strong>Flush:</strong> 5 cards same suit</li>
                    <li><strong>Straight:</strong> 5 cards in sequence</li>
                    <li><strong>Three of a Kind:</strong> 3 cards same rank</li>
                    <li><strong>Two Pair:</strong> 2 different pairs</li>
                    <li><strong>One Pair:</strong> 2 cards same rank</li>
                    <li><strong>High Card:</strong> Highest card wins</li>
                </ol>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: Starting Hands</h3>
                <p><strong>Premium Hands (Always Play):</strong></p>
                <ul>
                    <li>AA, KK, QQ, JJ - Raise/Re-raise</li>
                    <li>AK suited - Strong raising hand</li>
                </ul>
                <p><strong>Good Hands (Play in position):</strong></p>
                <ul>
                    <li>TT, 99, 88 - Call or raise</li>
                    <li>AQ, AJ, KQ - Position dependent</li>
                </ul>
                <p><strong>Marginal Hands (Late position only):</strong></p>
                <ul>
                    <li>Small pairs (22-77)</li>
                    <li>Suited connectors (9-8, 7-6)</li>
                </ul>
            </div>

            <div class="lesson-section">
                <h3>💰 Lesson 3: Pot Odds & Probability</h3>
                <p><strong>Pot Odds:</strong> Ratio of pot size to bet you must call</p>
                <p><strong>Example:</strong> Pot is $100, opponent bets $20. You must call $20 to win $120.</p>
                <p><strong>Pot Odds:</strong> 120:20 = 6:1</p>
                <p><strong>Rule:</strong> Call if your chance of winning > pot odds</p>
                <div class="tip-box">
                    <strong>💡 Quick Outs Calculation:</strong><br>
                    • Multiply outs by 4 on flop (2 cards to come)<br>
                    • Multiply outs by 2 on turn (1 card to come)<br>
                    • Example: 9 outs on flop = 36% chance
                </div>
            </div>

            <div class="lesson-section">
                <h3>🎭 Lesson 4: Position & Strategy</h3>
                <p><strong>Early Position:</strong> Play tight, premium hands only</p>
                <p><strong>Middle Position:</strong> Expand range slightly</p>
                <p><strong>Late Position (Button/Cutoff):</strong> Play wider range, steal blinds</p>
                <p><strong>Blinds:</strong> Defend with reasonable hands, don't over-commit</p>
            </div>

            <button class="quiz-btn" onclick="startQuiz('poker')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='poker_odds.html'">🎯 Practice</button>
        `
    },

    roulette: {
        title: "🎡 Roulette Strategy Guide",
        icon: "🎡",
        content: `
            <h2>🎡 Roulette Complete Guide</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Game Basics</h3>
                <p><strong>European Roulette:</strong> 37 numbers (0-36), House edge: 2.7%</p>
                <p><strong>American Roulette:</strong> 38 numbers (0, 00, 1-36), House edge: 5.26%</p>
                <div class="tip-box">
                    <strong>💡 Pro Tip:</strong> Always play European roulette when available - half the house edge!
                </div>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: Bet Types & Odds</h3>
                <p><strong>Inside Bets:</strong></p>
                <ul>
                    <li><strong>Straight Up:</strong> Single number - 35:1 payout (2.7% chance)</li>
                    <li><strong>Split:</strong> Two numbers - 17:1 payout (5.4% chance)</li>
                    <li><strong>Street:</strong> Three numbers - 11:1 payout (8.1% chance)</li>
                    <li><strong>Corner:</strong> Four numbers - 8:1 payout (10.8% chance)</li>
                </ul>
                <p><strong>Outside Bets:</strong></p>
                <ul>
                    <li><strong>Red/Black:</strong> 1:1 payout (48.6% chance)</li>
                    <li><strong>Odd/Even:</strong> 1:1 payout (48.6% chance)</li>
                    <li><strong>Dozen:</strong> 12 numbers - 2:1 payout (32.4% chance)</li>
                    <li><strong>Column:</strong> 12 numbers - 2:1 payout (32.4% chance)</li>
                </ul>
            </div>

            <div class="lesson-section">
                <h3>💰 Lesson 3: Betting Systems</h3>
                <p><strong>Martingale:</strong> Double bet after loss (risky, requires large bankroll)</p>
                <p><strong>D'Alembert:</strong> Increase by 1 unit after loss, decrease after win</p>
                <p><strong>Fibonacci:</strong> Follow Fibonacci sequence (1,1,2,3,5,8...)</p>
                <div class="tip-box">
                    <strong>⚠️ Warning:</strong> No betting system can overcome the house edge. They only manage short-term variance.
                </div>
            </div>

            <button class="quiz-btn" onclick="startQuiz('roulette')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='roulette_odds.html'">🎡 Play</button>
        `
    },

    craps: {
        title: "🎲 Craps Strategy Course",
        icon: "🎲",
        content: `
            <h2>🎲 Craps Mastery Guide</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Game Basics</h3>
                <p><strong>Come Out Roll:</strong> First roll of a new game</p>
                <p><strong>Point:</strong> Number established on come out (4,5,6,8,9,10)</p>
                <p><strong>Win:</strong> Roll 7 or 11 on come out, or make point</p>
                <p><strong>Lose:</strong> Roll 2, 3, or 12 on come out (craps), or 7 before point</p>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: Best Bets</h3>
                <p><strong>Pass Line:</strong> 1.41% house edge - BEST BET</p>
                <p><strong>Don't Pass:</strong> 1.36% house edge - BEST BET</p>
                <p><strong>Come/Don't Come:</strong> Same as Pass/Don't Pass</p>
                <p><strong>Odds Bet:</strong> 0% house edge! - ALWAYS TAKE ODDS</p>
                <div class="tip-box">
                    <strong>💡 Optimal Strategy:</strong><br>
                    1. Bet Pass Line<br>
                    2. Take maximum odds (3x-4x-5x)<br>
                    3. Place 6 and 8 if you want more action<br>
                    Combined house edge: ~0.5%
                </div>
            </div>

            <div class="lesson-section">
                <h3>❌ Lesson 3: Bets to Avoid</h3>
                <p><strong>Any 7:</strong> 16.67% house edge - NEVER BET</p>
                <p><strong>Hardways:</strong> 9.09-11.11% house edge - AVOID</p>
                <p><strong>Field:</strong> 2.78-5.56% house edge - POOR</p>
                <p><strong>Proposition Bets:</strong> 10-16% house edge - TERRIBLE</p>
            </div>

            <button class="quiz-btn" onclick="startQuiz('craps')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='craps_odds.html'">🎲 Practice</button>
        `
    },

    baccarat: {
        title: "💎 Baccarat Strategy Guide",
        icon: "💎",
        content: `
            <h2>💎 Baccarat Complete Guide</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Game Rules</h3>
                <p><strong>Objective:</strong> Bet on which hand (Player or Banker) will be closest to 9</p>
                <p><strong>Card Values:</strong></p>
                <ul>
                    <li>Aces: 1 point</li>
                    <li>2-9: Face value</li>
                    <li>10, J, Q, K: 0 points</li>
                </ul>
                <p><strong>Scoring:</strong> Add card values, drop the tens digit (e.g., 7+8=15 = 5 points)</p>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: Betting Strategy</h3>
                <p><strong>Banker Bet:</strong> 1.06% house edge - BEST BET (5% commission on wins)</p>
                <p><strong>Player Bet:</strong> 1.24% house edge - GOOD BET</p>
                <p><strong>Tie Bet:</strong> 14.36% house edge - NEVER BET</p>
                <div class="tip-box">
                    <strong>💡 Optimal Strategy:</strong> Always bet Banker. It has the lowest house edge in the casino!
                </div>
            </div>

            <div class="lesson-section">
                <h3>📊 Lesson 3: Pattern Tracking</h3>
                <p><strong>Scoreboards:</strong> Casinos provide pattern tracking boards</p>
                <p><strong>Truth:</strong> Past results don't affect future outcomes (independent events)</p>
                <p><strong>Why track?:</strong> For fun and to follow trends, not for prediction</p>
            </div>

            <button class="quiz-btn" onclick="startQuiz('baccarat')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='baccarat_odds.html'">💎 Play</button>
        `
    },

    slots: {
        title: "🎰 Slot Machine Guide",
        icon: "🎰",
        content: `
            <h2>🎰 Slot Machines Explained</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: How Slots Work</h3>
                <p><strong>RNG:</strong> Random Number Generator determines every spin</p>
                <p><strong>RTP:</strong> Return to Player - percentage returned over time</p>
                <p><strong>Volatility:</strong> How often and how much slots pay</p>
                <ul>
                    <li><strong>Low Volatility:</strong> Frequent small wins</li>
                    <li><strong>High Volatility:</strong> Rare but large wins</li>
                </ul>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: RTP & House Edge</h3>
                <p><strong>Typical RTP:</strong> 92-98% (varies by casino and machine)</p>
                <p><strong>House Edge:</strong> 2-8% (100% - RTP)</p>
                <p><strong>Example:</strong> 95% RTP = expect to lose $5 per $100 wagered (long term)</p>
                <div class="tip-box">
                    <strong>💡 Pro Tip:</strong> Look for machines with 96%+ RTP. Check paytables!
                </div>
            </div>

            <div class="lesson-section">
                <h3>💰 Lesson 3: Bankroll Management</h3>
                <p><strong>Session Bankroll:</strong> 200-300 times your bet per spin</p>
                <p><strong>Bet Sizing:</strong> Never bet more than 1-2% of bankroll per spin</p>
                <p><strong>Max Bet Myth:</strong> Doesn't increase RTP (except for progressives)</p>
                <p><strong>Stop Loss:</strong> Set a loss limit before playing</p>
            </div>

            <button class="quiz-btn" onclick="startQuiz('slots')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='slots_odds.html'">🎰 Play</button>
        `
    },

    videopoker: {
        title: "🎰 Video Poker Strategy",
        icon: "🎰",
        content: `
            <h2>🎰 Video Poker Mastery</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Jacks or Better Basics</h3>
                <p><strong>Paytable (9/6 Full Pay):</strong></p>
                <ul>
                    <li>Royal Flush: 800:1 (max bet)</li>
                    <li>Straight Flush: 50:1</li>
                    <li>Four of a Kind: 25:1</li>
                    <li>Full House: 9:1</li>
                    <li>Flush: 6:1</li>
                    <li>Straight: 4:1</li>
                    <li>Three of a Kind: 3:1</li>
                    <li>Two Pair: 2:1</li>
                    <li>Jacks or Better: 1:1</li>
                </ul>
                <p><strong>RTP with perfect play:</strong> 99.54%</p>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: Optimal Strategy</h3>
                <p><strong>Hand Priority (what to hold):</strong></p>
                <ol>
                    <li>Royal Flush, Straight Flush, Four of a Kind</li>
                    <li>4 to a Royal Flush</li>
                    <li>Full House, Flush, Straight, Three of a Kind</li>
                    <li>4 to a Straight Flush</li>
                    <li>Two Pair</li>
                    <li>High Pair (Jacks or Better)</li>
                    <li>3 to a Royal Flush</li>
                    <li>4 to a Flush</li>
                    <li>Low Pair (2s-10s)</li>
                    <li>4 to an Outside Straight</li>
                    <li>2 High Cards (same suit)</li>
                    <li>3 to a Straight Flush</li>
                    <li>2 High Cards (different suits)</li>
                    <li>1 High Card</li>
                    <li>Discard everything</li>
                </ol>
            </div>

            <div class="lesson-section">
                <h3>💡 Lesson 3: Key Tips</h3>
                <div class="tip-box">
                    <strong>Always play max bet</strong> - Royal Flush bonus only pays on max bet<br>
                    <strong>Never hold a kicker</strong> - Don't keep extra cards with pairs<br>
                    <strong>Break up pairs for Royal draws</strong> - 4 to Royal > Low Pair<br>
                    <strong>Study the strategy chart</strong> - Memorize for optimal play
                </div>
            </div>

            <button class="quiz-btn" onclick="startQuiz('videopoker')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='video_poker.html'">🎰 Play</button>
        `
    },

    paigow: {
        title: "🀄 Pai Gow Poker Guide",
        icon: "🀄",
        content: `
            <h2>🀄 Pai Gow Poker Strategy</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Game Rules</h3>
                <p><strong>Objective:</strong> Split 7 cards into 5-card high hand and 2-card low hand</p>
                <p><strong>Rule:</strong> 5-card hand MUST be stronger than 2-card hand</p>
                <p><strong>Win:</strong> Both hands beat dealer (5% commission)</p>
                <p><strong>Push:</strong> Win one, lose one (most common outcome - 41.5%)</p>
                <p><strong>Lose:</strong> Both hands lose to dealer</p>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: House Way Strategy</h3>
                <p><strong>No Pair:</strong> Highest card in 5-card, next 2 highest in 2-card</p>
                <p><strong>One Pair:</strong> Pair in 5-card, two highest in 2-card</p>
                <p><strong>Two Pair:</strong> Split unless both low (6s or less)</p>
                <p><strong>Three Pair:</strong> Highest pair in 2-card hand</p>
                <p><strong>Three of a Kind:</strong> Keep together (except Aces - split 2 to low)</p>
                <p><strong>Straights/Flushes:</strong> Play in 5-card unless you have two pair</p>
                <p><strong>Full House:</strong> Split (pair in 2-card, trips in 5-card)</p>
                <p><strong>Four of a Kind:</strong> Split Aces, Kings, Queens</p>
            </div>

            <div class="lesson-section">
                <h3>💰 Lesson 3: Bankroll Tips</h3>
                <p><strong>House Edge:</strong> 2.54% (with 5% commission)</p>
                <p><strong>Volatility:</strong> Very low - great for extending play</p>
                <p><strong>Push Rate:</strong> 41.5% - highest of any casino game</p>
                <div class="tip-box">
                    <strong>💡 Perfect for:</strong> Low-risk players who want long sessions with minimal losses
                </div>
            </div>

            <button class="quiz-btn" onclick="startQuiz('paigow')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='paigow_odds.html'">🀄 Play</button>
        `
    },

    threecard: {
        title: "🃏 Three Card Poker Guide",
        icon: "🃏",
        content: `
            <h2>🃏 Three Card Poker Strategy</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Game Rules</h3>
                <p><strong>Ante/Play:</strong> Bet ante, get 3 cards, Play or Fold</p>
                <p><strong>Play Strategy:</strong> Play with Q-6-4 or better, fold worse hands</p>
                <p><strong>Pair Plus:</strong> Optional side bet on your hand quality</p>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: Hand Probabilities</h3>
                <ul>
                    <li><strong>Straight Flush:</strong> 0.22% (40:1)</li>
                    <li><strong>Three of a Kind:</strong> 0.24% (30:1)</li>
                    <li><strong>Straight:</strong> 3.26% (6:1)</li>
                    <li><strong>Flush:</strong> 4.96% (4:1)</li>
                    <li><strong>Pair:</strong> 16.94% (1:1)</li>
                    <li><strong>High Card:</strong> 74.39%</li>
                </ul>
            </div>

            <div class="lesson-section">
                <h3>💡 Lesson 3: Optimal Strategy</h3>
                <p><strong>Ante/Play:</strong> Play Q-6-4 or better (house edge: 3.37%)</p>
                <p><strong>Pair Plus:</strong> Optional - house edge varies (2.3-7.3%)</p>
                <div class="tip-box">
                    <strong>💡 Simple Rule:</strong> If you have Queen-high or better, play. Otherwise, fold.
                </div>
            </div>

            <button class="quiz-btn" onclick="startQuiz('threecard')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='three_card_poker.html'">🃏 Play</button>
        `
    },

    sicbo: {
        title: "🎲 Sic Bo Guide",
        icon: "🎲",
        content: `
            <h2>🎲 Sic Bo Strategy</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Game Basics</h3>
                <p><strong>Objective:</strong> Bet on outcome of 3 dice</p>
                <p><strong>Bet Types:</strong> Small/Big, Odd/Even, Specific totals, Combinations</p>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: Best Bets</h3>
                <p><strong>Small (4-10):</strong> 48.61% chance, 1:1 payout, 2.78% edge - BEST</p>
                <p><strong>Big (11-17):</strong> 48.61% chance, 1:1 payout, 2.78% edge - BEST</p>
                <p><strong>Specific Totals:</strong> Higher payouts but much lower probability</p>
                <div class="tip-box">
                    <strong>💡 Strategy:</strong> Stick to Small/Big bets for best odds. Avoid specific totals unless betting for fun.
                </div>
            </div>

            <button class="quiz-btn" onclick="startQuiz('sicbo')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='sicbo.html'">🎲 Play</button>
        `
    },

    keno: {
        title: "🎱 Keno Guide",
        icon: "🎱",
        content: `
            <h2>🎱 Keno Strategy</h2>
            
            <div class="lesson-section">
                <h3>📚 Lesson 1: Game Basics</h3>
                <p><strong>Objective:</strong> Pick 1-20 numbers from 1-80, match drawn numbers</p>
                <p><strong>Draw:</strong> 20 numbers are randomly selected</p>
                <p><strong>Payout:</strong> Based on how many numbers you match</p>
            </div>

            <div class="lesson-section">
                <h3>🎯 Lesson 2: Odds & Strategy</h3>
                <p><strong>House Edge:</strong> Typically 25-40% (very high!)</p>
                <p><strong>Best Spots:</strong> 4-8 numbers offer best balance</p>
                <p><strong>Probability:</strong> Matching all 10 numbers: 1 in 8.9 million</p>
                <div class="tip-box">
                    <strong>💡 Reality Check:</strong> Keno has one of the worst odds in the casino. Play for entertainment, not profit.
                </div>
            </div>

            <button class="quiz-btn" onclick="startQuiz('keno')">📝 Take Quiz</button>
            <button class="quiz-btn" onclick="window.location.href='keno_odds.html'">🎱 Play</button>
        `
    }
};

function openLesson(game) {
    casinoSounds.playSound('click');
    const lesson = lessons[game];
    if (!lesson) return;
    
    document.getElementById('lessonContent').innerHTML = lesson.content;
    document.getElementById('lessonModal').style.display = 'block';
    
    // Track lesson view
    const stats = JSON.parse(localStorage.getItem('casinoAcademyStats') || '{}');
    if (!stats.lessonsViewed) stats.lessonsViewed = [];
    if (!stats.lessonsViewed.includes(game)) {
        stats.lessonsViewed.push(game);
        localStorage.setItem('casinoAcademyStats', JSON.stringify(stats));
    }
}

function closeLesson() {
    casinoSounds.playSound('click');
    document.getElementById('lessonModal').style.display = 'none';
}

function startQuiz(game) {
    casinoSounds.playSound('click');
    alert(`📝 ${lessons[game].title} Quiz\n\nQuiz feature coming soon!\n\nYou'll be able to test your knowledge and earn XP for correct answers.`);
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('lessonModal');
    if (event.target == modal) {
        closeLesson();
    }
}
