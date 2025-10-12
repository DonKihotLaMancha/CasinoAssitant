// Casino Assistant - Theme Manager
// Handles dark mode and custom themes

class ThemeManager {
    constructor() {
        this.currentTheme = 'light';
        this.customTheme = null;
        this.loadTheme();
        this.applyTheme();
    }

    loadTheme() {
        const settings = JSON.parse(localStorage.getItem('casinoSettings') || '{}');
        this.currentTheme = settings.darkMode ? 'dark' : 'light';
        this.customTheme = settings.customTheme || null;
    }

    saveTheme() {
        const settings = JSON.parse(localStorage.getItem('casinoSettings') || '{}');
        settings.darkMode = this.currentTheme === 'dark';
        settings.customTheme = this.customTheme;
        localStorage.setItem('casinoSettings', JSON.stringify(settings));
    }

    applyTheme() {
        document.documentElement.setAttribute('data-theme', this.currentTheme);
        
        if (this.customTheme) {
            this.applyCustomTheme(this.customTheme);
        }
    }

    toggleDarkMode() {
        this.currentTheme = this.currentTheme === 'light' ? 'dark' : 'light';
        this.saveTheme();
        this.applyTheme();
        return this.currentTheme;
    }

    setTheme(themeName) {
        const themes = {
            'light': this.getLightTheme(),
            'dark': this.getDarkTheme(),
            'blue': this.getBlueTheme(),
            'green': this.getGreenTheme(),
            'purple': this.getPurpleTheme(),
            'gold': this.getGoldTheme()
        };

        if (themes[themeName]) {
            this.currentTheme = themeName;
            this.customTheme = themes[themeName];
            this.saveTheme();
            this.applyTheme();
        }
    }

    applyCustomTheme(theme) {
        const root = document.documentElement;
        Object.keys(theme).forEach(key => {
            root.style.setProperty(key, theme[key]);
        });
    }

    getLightTheme() {
        return {
            '--bg-primary': 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
            '--bg-secondary': '#ffffff',
            '--text-primary': '#333333',
            '--text-secondary': '#666666',
            '--accent-color': '#667eea',
            '--card-bg': 'rgba(255, 255, 255, 0.95)',
            '--border-color': '#ddd'
        };
    }

    getDarkTheme() {
        return {
            '--bg-primary': 'linear-gradient(135deg, #1a1a2e 0%, #16213e 100%)',
            '--bg-secondary': '#0f3460',
            '--text-primary': '#e0e0e0',
            '--text-secondary': '#b0b0b0',
            '--accent-color': '#e94560',
            '--card-bg': 'rgba(15, 52, 96, 0.95)',
            '--border-color': '#533483'
        };
    }

    getBlueTheme() {
        return {
            '--bg-primary': 'linear-gradient(135deg, #1e3c72 0%, #2a5298 100%)',
            '--bg-secondary': '#4a90e2',
            '--text-primary': '#ffffff',
            '--text-secondary': '#e0e0e0',
            '--accent-color': '#4a90e2',
            '--card-bg': 'rgba(42, 82, 152, 0.95)',
            '--border-color': '#7ab8ff'
        };
    }

    getGreenTheme() {
        return {
            '--bg-primary': 'linear-gradient(135deg, #134e5e 0%, #71b280 100%)',
            '--bg-secondary': '#4CAF50',
            '--text-primary': '#ffffff',
            '--text-secondary': '#e0e0e0',
            '--accent-color': '#4CAF50',
            '--card-bg': 'rgba(113, 178, 128, 0.95)',
            '--border-color': '#81c784'
        };
    }

    getPurpleTheme() {
        return {
            '--bg-primary': 'linear-gradient(135deg, #8e2de2 0%, #4a00e0 100%)',
            '--bg-secondary': '#9c27b0',
            '--text-primary': '#ffffff',
            '--text-secondary': '#e0e0e0',
            '--accent-color': '#9c27b0',
            '--card-bg': 'rgba(74, 0, 224, 0.95)',
            '--border-color': '#ba68c8'
        };
    }

    getGoldTheme() {
        return {
            '--bg-primary': 'linear-gradient(135deg, #f7971e 0%, #ffd200 100%)',
            '--bg-secondary': '#ffd700',
            '--text-primary': '#333333',
            '--text-secondary': '#666666',
            '--accent-color': '#ffd700',
            '--card-bg': 'rgba(255, 210, 0, 0.95)',
            '--border-color': '#ffed4e'
        };
    }

    getCurrentTheme() {
        return this.currentTheme;
    }

    isDarkMode() {
        return this.currentTheme === 'dark';
    }
}

// Global instance
const themeManager = new ThemeManager();

// Add CSS variables support
const themeStyles = document.createElement('style');
themeStyles.textContent = `
    :root {
        --bg-primary: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        --bg-secondary: #ffffff;
        --text-primary: #333333;
        --text-secondary: #666666;
        --accent-color: #667eea;
        --card-bg: rgba(255, 255, 255, 0.95);
        --border-color: #ddd;
    }

    [data-theme="dark"] {
        --bg-primary: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
        --bg-secondary: #0f3460;
        --text-primary: #e0e0e0;
        --text-secondary: #b0b0b0;
        --accent-color: #e94560;
        --card-bg: rgba(15, 52, 96, 0.95);
        --border-color: #533483;
    }

    body {
        background: var(--bg-primary);
        color: var(--text-primary);
        transition: background 0.3s ease, color 0.3s ease;
    }

    .card {
        background: var(--card-bg);
        color: var(--text-primary);
        border-color: var(--border-color);
    }

    .theme-toggle {
        position: fixed;
        top: 80px;
        right: 20px;
        z-index: 1000;
        background: rgba(255, 255, 255, 0.2);
        border: 2px solid rgba(255, 255, 255, 0.3);
        border-radius: 50px;
        padding: 10px 20px;
        cursor: pointer;
        transition: all 0.3s;
        color: white;
        font-weight: bold;
        backdrop-filter: blur(10px);
    }

    .theme-toggle:hover {
        background: rgba(255, 255, 255, 0.3);
        transform: scale(1.05);
    }
`;
document.head.appendChild(themeStyles);
