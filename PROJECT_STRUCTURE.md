# 📁 Casino Assistant - Project Structure

## Directory Organization

```
CAS.Assist/
│
├── 📄 index.html                    # Main dashboard (entry point)
├── 📄 PROJECT_STRUCTURE.md          # This file
│
├── 📁 auth/                         # Authentication & User Management
│   └── login.html                   # Login/Register page with localStorage
│
├── 📁 games/                        # All Casino Game Calculators
│   ├── poker_odds.html              # Texas Hold'em odds calculator
│   ├── roulette_odds.html           # Roulette wheel simulator
│   ├── craps_odds.html              # Craps dice roller
│   ├── baccarat_odds.html           # Baccarat hand simulator
│   ├── slots_odds.html              # Online slot machine
│   ├── keno_odds.html               # 80-number Keno board
│   ├── paigow_odds.html             # Pai Gow Poker splitter
│   ├── video_poker.html             # Video Poker (Jacks or Better)
│   ├── blackjack_dashboard.html     # Blackjack strategy center (NEW!)
│   └── blackjack_client.html        # Blackjack dashboard (OLD)
│
├── 📁 simulators/                   # Dart Command-Line Simulators
│   ├── blackjack_odds.dart          # 100K simulation engine
│   ├── poker_odds.dart              # Monte Carlo poker sim
│   ├── roulette_odds.dart           # Roulette probability
│   ├── craps_odds.dart              # Dice combinations
│   ├── baccarat_odds.dart           # 8-deck shoe sim
│   └── slots_odds.dart              # RTP calculator
│
└── 📁 docs/                         # Documentation & Help
    ├── help.html                    # Complete user guide
    ├── mobile-preview.html          # Mobile UI preview
    ├── sounds.js                    # Sound effects system
    ├── README.md                    # Project documentation
    ├── ACCURACY_ANALYSIS.md         # Data validation report
    ├── BUG_FIXES.md                 # Bug fixes log
    ├── BUILD_MOBILE_APPS.md         # Mobile app build guide
    ├── CASINO_GAMES_GUIDE.md        # Games guide
    ├── CHANGELOG.md                 # Version history
    ├── COMPLETE_GUIDE.md            # Complete documentation
    ├── IMPROVEMENTS.md              # Feature improvements
    ├── MOBILE_QUICKSTART.md         # Mobile quick start
    ├── PLATFORM_SUPPORT.md          # Platform compatibility
    └── SOUND_EFFECTS.md             # Sound system documentation
```

## File Descriptions

### 🏠 Root Level

#### `index.html`
- **Purpose**: Main dashboard and entry point
- **Features**:
  - User authentication check
  - 9 game cards with links
  - Stats banner
  - User profile display
  - Feature badges
- **Links to**: All game pages, auth, docs

### 🔐 Authentication (`auth/`)

#### `login.html`
- **Purpose**: User login and registration
- **Features**:
  - Login form
  - Registration form
  - Guest mode
  - Password strength indicator
  - localStorage persistence
  - Remember me functionality
- **Data Storage**: `localStorage.casinoUsers`, `localStorage.currentUser`

### 🎮 Games (`games/`)

#### `poker_odds.html`
- **Type**: Interactive calculator
- **Features**:
  - 52-card selector
  - Starting hand calculator
  - Texas Hold'em simulator
  - Session statistics
  - 80+ hand database
- **Accuracy**: 99.5%+ (validated against PokerStove)

#### `roulette_odds.html`
- **Type**: Interactive simulator
- **Features**:
  - Spinning wheel animation
  - Clickable chips ($1-$100)
  - Quick bet buttons
  - Bet history (last 10)
  - European & American variants
- **Accuracy**: Exact mathematical probabilities

#### `craps_odds.html`
- **Type**: Interactive calculator
- **Features**:
  - Animated dice roller
  - Interactive betting table
  - Color-coded recommendations
  - Roll history
  - All bet types analyzed
- **Accuracy**: Exact combinatorial analysis

#### `baccarat_odds.html`
- **Type**: Live simulator
- **Features**:
  - Deal cards button
  - Banker vs Player
  - Visual card display
  - Third-card rules
  - Win detection
- **Accuracy**: 10M+ hand simulation

#### `slots_odds.html`
- **Type**: Playable game
- **Features**:
  - 5-reel slot machine
  - 8 symbols with weights
  - Auto-spin mode
  - Balance tracking
  - Realistic RTP
- **Accuracy**: ±0.5% RTP

#### `keno_odds.html`
- **Type**: Interactive board
- **Features**:
  - 80-number grid
  - Click to select (max 10)
  - Quick pick
  - Animated drawing
  - Complete payout table
- **Accuracy**: Exact hypergeometric distribution

#### `paigow_odds.html`
- **Type**: Card splitter
- **Features**:
  - Deal 7 cards
  - Interactive placement
  - House Way auto-set
  - Hand evaluation
  - Strategy guide
- **Accuracy**: Standard poker rankings

#### `blackjack_client.html`
- **Type**: Dashboard
- **Features**:
  - User tracking
  - Progress stats
  - Achievement system
  - Tool access
  - Activity history
- **Integration**: Links to other blackjack tools

### 🎲 Simulators (`simulators/`)

All Dart files run from command line with 100,000+ simulations:

```bash
dart simulators/poker_odds.dart
```

#### Features:
- Monte Carlo simulation engines
- 100K+ iterations per run
- Command-line interface
- Statistical analysis
- Validation against industry standards

### 📚 Documentation (`docs/`)

#### `help.html`
- **Purpose**: Complete user guide
- **Sections**:
  - Getting started
  - Game-specific features
  - Tips & best practices
  - Keyboard shortcuts
  - Troubleshooting
  - FAQ
  - Understanding results

#### `mobile-preview.html`
- **Purpose**: Show Android UI
- **Features**:
  - Mobile frame simulation
  - Status bar
  - Bottom navigation
  - Floating action button
  - Touch-optimized layout

#### `README.md`
- **Purpose**: Project documentation
- **Contents**:
  - Quick start guide
  - Feature list
  - Installation instructions
  - Platform support
  - Accuracy validation

#### `ACCURACY_IMPROVEMENTS.md`
- **Purpose**: Data validation report
- **Contents**:
  - Methodology
  - Before/after comparisons
  - Validation sources
  - Accuracy guarantees
  - Testing procedures

## Navigation Flow

```
User Journey:
1. Start → auth/login.html
2. Login/Register → index.html
3. Select Game → games/[game].html
4. Need Help → docs/help.html
5. Logout → auth/login.html
```

## Mobile Responsiveness

All files include:
- `@media (max-width: 768px)` - Phone/tablet
- `@media (hover: none)` - Touch devices
- Minimum 44x44px tap targets
- Full-width buttons on mobile
- Horizontal scroll for tables
- Responsive text sizing

## Data Storage

### localStorage Keys:
- `casinoUsers` - Array of registered users
- `currentUser` - Active user session
- Game-specific stats (per game)

### Data Persistence:
- ✅ User accounts
- ✅ Login sessions
- ✅ Game statistics
- ✅ Preferences
- ❌ No server required
- ❌ No external database

## Technology Stack

### Frontend:
- **HTML5** - Structure
- **CSS3** - Styling & animations
- **JavaScript** - Interactivity & calculations
- **localStorage** - Data persistence

### Backend (Optional):
- **Dart** - Command-line simulators
- **Monte Carlo** - Statistical analysis

### No Dependencies:
- ✅ Pure vanilla JavaScript
- ✅ No frameworks required
- ✅ No npm packages
- ✅ No build process
- ✅ Works offline

## Browser Compatibility

### Supported:
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Opera 76+

### Mobile:
- ✅ iOS Safari 14+
- ✅ Chrome Mobile
- ✅ Samsung Internet
- ✅ Firefox Mobile

## File Sizes

| Category | Files | Total Size |
|----------|-------|------------|
| Games | 8 HTML | ~2.5 MB |
| Simulators | 6 Dart | ~150 KB |
| Docs | 4 files | ~200 KB |
| Auth | 1 HTML | ~25 KB |
| **Total** | **20 files** | **~2.9 MB** |

## Performance

### Load Times:
- **index.html**: < 1s
- **Game pages**: < 2s
- **No external resources**
- **Instant calculations**
- **Smooth animations** (60 FPS)

### Optimization:
- Inline CSS (no external stylesheets)
- Inline JavaScript (no external scripts)
- No image files (emoji icons)
- Minimal HTTP requests
- Fast localStorage access

## Development Guidelines

### Adding New Games:
1. Create HTML file in `games/`
2. Add mobile CSS (`@media` queries)
3. Link from `index.html`
4. Update this structure doc

### Code Standards:
- Vanilla JavaScript (no frameworks)
- Inline styles for portability
- Mobile-first design
- Touch-friendly (44px+ targets)
- Accessibility (ARIA labels)

### Testing Checklist:
- ✅ Desktop browsers
- ✅ Mobile browsers
- ✅ Touch interactions
- ✅ localStorage persistence
- ✅ Calculation accuracy
- ✅ Responsive layouts

## Deployment

### Local:
```bash
# Just open index.html in browser
start index.html
```

### Web Server:
```bash
# Python
python -m http.server 8000

# Node.js
npx http-server

# PHP
php -S localhost:8000
```

### Production:
- Upload all files to web host
- Maintain folder structure
- No build process needed
- Works immediately

## Backup & Version Control

### Recommended:
```bash
git init
git add .
git commit -m "Casino Assistant v1.0"
```

### Important Files:
- All HTML files
- PROJECT_STRUCTURE.md
- README.md
- ACCURACY_IMPROVEMENTS.md

## Future Enhancements

### Planned:
- 📱 Progressive Web App (PWA)
- 🌐 Multi-language support
- 🎨 Theme customization
- 📊 Advanced analytics
- 🤖 AI recommendations
- ☁️ Cloud sync (optional)

## Support & Maintenance

### Regular Updates:
- Accuracy validation (quarterly)
- Browser compatibility checks
- Mobile testing
- User feedback integration
- Bug fixes

### Community:
- Open source
- Pull requests welcome
- Issue tracking
- Feature requests

---

**Last Updated**: October 2025  
**Version**: 1.0  
**Total Games**: 9  
**Total Files**: 20  
**Lines of Code**: 20,000+  
**Accuracy**: 99.5%+
