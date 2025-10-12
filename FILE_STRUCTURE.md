# 📁 BetSage File Structure

**Version:** 1.0.0  
**Last Updated:** October 13, 2025

---

## 🗂️ ROOT DIRECTORY

```
CAS.Assist/
├── index.html              # Main homepage
├── manifest.json           # PWA manifest
├── sw.js                   # Service worker for PWA
├── config.js               # Global configuration
├── CNAME                   # Custom domain configuration
├── .gitignore             # Git ignore rules
│
├── 📄 DOCUMENTATION FILES
├── README.md              # Project overview and setup
├── START_HERE.md          # Quick start guide
├── PRODUCTION_READY.md    # Production launch guide
├── PREMIUM_FEATURES.md    # Premium vs Free comparison
├── PROJECT_SUMMARY.md     # Complete project summary
├── IMPROVEMENTS_ROADMAP.md # Future improvements
├── CURRENT_STATUS.md      # Current project status
├── BUG_FIXES_COMPLETE.md  # Bug fix history
├── SETTINGS_BUGS_FIXED.md # Settings bug fixes
└── FILE_STRUCTURE.md      # This file
```

---

## 📂 MAIN FOLDERS

### **/games/** - All Game Pages & Calculators
```
games/
├── 🃏 BLACKJACK (7 files)
│   ├── blackjack_dashboard.html      # Main Blackjack hub (Duolingo-style)
│   ├── blackjack_basic_strategy.html # Basic strategy trainer
│   ├── blackjack_card_counting.html  # Card counting practice
│   ├── blackjack_bankroll.html       # Bankroll calculator
│   ├── blackjack_odds.html           # Odds calculator
│   ├── blackjack_live_advisor.html   # Real-time strategy advisor
│   └── blackjack_client.html         # Playable blackjack game
│
├── 🎴 POKER (2 files)
│   ├── poker_odds.html               # Texas Hold'em odds calculator
│   └── poker_hand_evaluator.html     # Hand strength evaluator
│
├── 🎡 ROULETTE (1 file)
│   └── roulette_odds.html            # Roulette odds calculator
│
├── 🎲 CRAPS (1 file)
│   └── craps_odds.html               # Craps odds calculator
│
├── 💎 BACCARAT (1 file)
│   └── baccarat_odds.html            # Baccarat odds calculator
│
├── 🎰 SLOTS (2 files)
│   ├── slots_odds.html               # Slot machine odds
│   └── slots_rtp_calculator.html     # RTP calculator
│
├── 🎰 VIDEO POKER (1 file)
│   └── video_poker.html              # Video poker odds & strategy
│
├── 🀄 PAI GOW POKER (1 file)
│   └── paigow_odds.html              # Pai Gow odds calculator
│
├── 🃏 THREE CARD POKER (1 file)
│   └── three_card_poker.html         # Three Card Poker odds
│
├── 🎲 SIC BO (1 file)
│   └── sicbo.html                    # Sic Bo odds calculator
│
├── 🎱 KENO (1 file)
│   └── keno_odds.html                # Keno odds calculator
│
├── 🎓 ACADEMY & LEARNING
│   ├── casino_academy.html           # Main learning hub
│   ├── casino-lessons.js             # All lesson content & quizzes
│   └── academy-features.js           # Academy feature logic
│
├── 👤 USER PAGES
│   ├── settings.html                 # User settings & preferences
│   ├── premium.html                  # Premium subscription page
│   └── language_selector.html        # Language selection
│
└── 📊 SIMULATORS
    └── (Various game simulators)
```

**Total Game Files:** 25+ HTML pages

---

### **/docs/** - Documentation & Scripts
```
docs/
├── 🔊 AUDIO & SOUNDS
│   ├── sounds.js                     # Sound effects manager
│   └── (sound files if any)
│
├── 🎨 STYLING & THEMES
│   ├── theme-manager.js              # Theme switching system
│   └── styles/ (if any)
│
├── 💰 MONETIZATION
│   ├── adsense.js                    # Google AdSense integration
│   ├── affiliates.js                 # Affiliate marketing system
│   └── premium-manager.js            # Premium features manager
│
├── 📈 SEO & ANALYTICS
│   ├── seo-meta.js                   # SEO metadata manager
│   └── analytics/ (if any)
│
└── 📚 HELP & SUPPORT
    └── help.html                     # Help documentation
```

---

### **/legal/** - Legal Documents
```
legal/
├── terms.html                        # Terms of Service
├── privacy.html                      # Privacy Policy
└── responsible-gambling.html         # Responsible Gambling Resources
```

**Purpose:** All legal compliance documents in one place

---

### **/auth/** - Authentication System
```
auth/
├── login.html                        # Login page
├── register.html                     # Registration page
├── auth.js                           # Authentication logic
└── (other auth files)
```

---

### **/scripts/** - Utility Scripts
```
scripts/
├── apply_backgrounds.ps1             # Apply background patterns
├── update_backgrounds.ps1            # Update backgrounds
├── fix_backgrounds.ps1               # Fix background issues
├── fix_scripts.ps1                   # Fix script issues
├── setup_flutter.bat                 # Flutter setup (Windows)
└── setup_flutter.sh                  # Flutter setup (Unix)
```

**Purpose:** Development and maintenance scripts

---

### **/blog/** - Blog Content (Optional)
```
blog/
└── (Blog posts and articles)
```

---

### **/documentation/** - Additional Docs
```
documentation/
└── (Technical documentation)
```

---

### **/flutter_app/** - Mobile App (Future)
```
flutter_app/
└── (Flutter mobile app source code)
```

---

### **/simulators/** - Game Simulators
```
simulators/
└── (Various game simulation tools)
```

---

## 🎯 FILE ORGANIZATION PRINCIPLES

### **1. By Function**
- Games → `/games/`
- Documentation → `/docs/`
- Legal → `/legal/`
- Scripts → `/scripts/`
- Authentication → `/auth/`

### **2. By Game Type**
- All Blackjack files grouped together
- All Poker files grouped together
- Easy to find related content

### **3. Clear Naming**
- Descriptive file names
- Consistent naming convention
- Game name prefix (e.g., `blackjack_*.html`)

---

## 📊 FILE STATISTICS

### **Total Files:**
- **HTML Pages:** 40+
- **JavaScript Files:** 15+
- **Documentation:** 10+
- **Scripts:** 6
- **Legal Documents:** 3

### **By Category:**
- **Game Pages:** 25+
- **Documentation:** 10
- **System Files:** 10
- **Scripts:** 6
- **Legal:** 3

---

## 🔗 KEY FILE RELATIONSHIPS

### **Homepage (index.html) Links To:**
- All game pages in `/games/`
- Settings in `/games/settings.html`
- Premium in `/games/premium.html`
- Help in `/docs/help.html`
- Legal pages in `/legal/`

### **Game Pages Link To:**
- Back to homepage (`../index.html`)
- Related game tools
- Premium page
- Help documentation

### **Legal Pages Link To:**
- Back to homepage (`../index.html`)
- Each other (cross-references)

---

## 🎨 ASSET ORGANIZATION

### **Icons & Images:**
- PWA icons in `/icons/` (if exists)
- Game images in respective folders

### **Styles:**
- Inline styles in HTML files
- Shared styles in `/docs/`

### **Scripts:**
- Game-specific scripts inline
- Shared scripts in `/docs/`
- Utility scripts in `/scripts/`

---

## 📝 DOCUMENTATION FILES

### **For Users:**
- `README.md` - Project overview
- `START_HERE.md` - Quick start
- `PREMIUM_FEATURES.md` - Feature comparison

### **For Developers:**
- `FILE_STRUCTURE.md` - This file
- `PROJECT_SUMMARY.md` - Technical details
- `PRODUCTION_READY.md` - Launch guide

### **For Tracking:**
- `CURRENT_STATUS.md` - Current state
- `IMPROVEMENTS_ROADMAP.md` - Future plans
- `BUG_FIXES_COMPLETE.md` - Bug history

---

## 🚀 QUICK NAVIGATION

### **To Add a New Game:**
1. Create file in `/games/`
2. Name it `gamename_feature.html`
3. Add link in `index.html`
4. Update this documentation

### **To Add Documentation:**
1. Create `.md` file in root
2. Use clear naming
3. Update README if needed

### **To Add Legal Content:**
1. Create file in `/legal/`
2. Update footer links in `index.html`
3. Cross-reference other legal docs

---

## 🔧 MAINTENANCE

### **Regular Tasks:**
- Keep documentation updated
- Review file organization monthly
- Archive old files if needed
- Update this structure doc

### **File Naming Rules:**
- Use lowercase
- Use underscores for spaces
- Include game name prefix
- Be descriptive

---

## 📱 MOBILE APP STRUCTURE (Future)

```
flutter_app/
├── lib/
│   ├── screens/
│   ├── widgets/
│   ├── models/
│   └── services/
├── assets/
└── pubspec.yaml
```

---

## 🎯 BEST PRACTICES

### **DO:**
- ✅ Keep related files together
- ✅ Use clear, descriptive names
- ✅ Document file purposes
- ✅ Maintain consistent structure
- ✅ Update this doc when changing structure

### **DON'T:**
- ❌ Mix unrelated files
- ❌ Use vague names
- ❌ Leave orphaned files
- ❌ Create deep nested folders
- ❌ Forget to update documentation

---

## 📞 FILE STRUCTURE QUESTIONS?

If you need to:
- **Add new files** - Follow naming conventions
- **Move files** - Update all links
- **Delete files** - Check for dependencies
- **Reorganize** - Update this document

---

**🎰 Well-organized files = Easy maintenance!** 📁✨

**Last Updated:** October 13, 2025  
**Version:** 1.0.0
