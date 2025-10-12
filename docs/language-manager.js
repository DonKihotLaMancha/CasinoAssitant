// Multi-Language Support Manager
// Handles translations and language switching

class LanguageManager {
    constructor() {
        this.currentLanguage = 'en';
        this.supportedLanguages = ['en', 'es', 'fr', 'de', 'pt', 'zh', 'ja', 'ru'];
        this.translations = {};
        this.loadLanguage();
    }

    loadLanguage() {
        const savedLang = localStorage.getItem('casinoLanguage') || 'en';
        this.currentLanguage = savedLang;
        this.applyLanguage();
    }

    setLanguage(langCode) {
        if (!this.supportedLanguages.includes(langCode)) {
            console.error('Language not supported:', langCode);
            return;
        }
        
        this.currentLanguage = langCode;
        localStorage.setItem('casinoLanguage', langCode);
        this.applyLanguage();
        window.location.reload(); // Reload to apply translations
    }

    applyLanguage() {
        document.documentElement.lang = this.currentLanguage;
        this.loadTranslations(this.currentLanguage);
    }

    loadTranslations(langCode) {
        // Load translation file for the language
        this.translations = this.getTranslations(langCode);
    }

    translate(key) {
        return this.translations[key] || key;
    }

    getTranslations(langCode) {
        const translations = {
            en: {
                // Navigation
                'nav.home': 'Home',
                'nav.games': 'Games',
                'nav.academy': 'Academy',
                'nav.premium': 'Premium',
                'nav.settings': 'Settings',
                'nav.help': 'Help',
                
                // Common
                'common.free': 'Free',
                'common.premium': 'Premium',
                'common.upgrade': 'Upgrade',
                'common.login': 'Login',
                'common.register': 'Register',
                'common.logout': 'Logout',
                'common.save': 'Save',
                'common.cancel': 'Cancel',
                'common.close': 'Close',
                
                // Homepage
                'home.title': 'BetSage',
                'home.subtitle': 'Professional odds calculators and strategy tools',
                'home.games': 'Casino Games',
                'home.lessons': 'Lessons',
                'home.users': 'Active Users',
                
                // Premium
                'premium.title': 'Go Premium',
                'premium.monthly': 'Monthly',
                'premium.yearly': 'Yearly',
                'premium.features': 'Premium Features',
                'premium.upgrade_now': 'Upgrade Now',
                
                // Games
                'games.blackjack': 'Blackjack',
                'games.poker': 'Poker',
                'games.roulette': 'Roulette',
                'games.craps': 'Craps',
                'games.baccarat': 'Baccarat',
                'games.slots': 'Slots',
                
                // Academy
                'academy.lessons': 'Lessons',
                'academy.quizzes': 'Quizzes',
                'academy.progress': 'Your Progress',
                'academy.take_quiz': 'Take Quiz',
                
                // Messages
                'msg.welcome': 'Welcome to BetSage!',
                'msg.login_success': 'Login successful!',
                'msg.premium_required': 'This feature requires Premium',
                'msg.quiz_locked': 'Quizzes are a Premium feature'
            },
            es: {
                // Navigation
                'nav.home': 'Inicio',
                'nav.games': 'Juegos',
                'nav.academy': 'Academia',
                'nav.premium': 'Premium',
                'nav.settings': 'Configuración',
                'nav.help': 'Ayuda',
                
                // Common
                'common.free': 'Gratis',
                'common.premium': 'Premium',
                'common.upgrade': 'Actualizar',
                'common.login': 'Iniciar sesión',
                'common.register': 'Registrarse',
                'common.logout': 'Cerrar sesión',
                'common.save': 'Guardar',
                'common.cancel': 'Cancelar',
                'common.close': 'Cerrar',
                
                // Homepage
                'home.title': 'BetSage',
                'home.subtitle': 'Calculadoras de probabilidades profesionales',
                'home.games': 'Juegos de Casino',
                'home.lessons': 'Lecciones',
                'home.users': 'Usuarios Activos',
                
                // Premium
                'premium.title': 'Hazte Premium',
                'premium.monthly': 'Mensual',
                'premium.yearly': 'Anual',
                'premium.features': 'Características Premium',
                'premium.upgrade_now': 'Actualizar Ahora',
                
                // Games
                'games.blackjack': 'Blackjack',
                'games.poker': 'Póker',
                'games.roulette': 'Ruleta',
                'games.craps': 'Dados',
                'games.baccarat': 'Baccarat',
                'games.slots': 'Tragamonedas',
                
                // Academy
                'academy.lessons': 'Lecciones',
                'academy.quizzes': 'Cuestionarios',
                'academy.progress': 'Tu Progreso',
                'academy.take_quiz': 'Tomar Cuestionario',
                
                // Messages
                'msg.welcome': '¡Bienvenido a BetSage!',
                'msg.login_success': '¡Inicio de sesión exitoso!',
                'msg.premium_required': 'Esta función requiere Premium',
                'msg.quiz_locked': 'Los cuestionarios son una función Premium'
            },
            fr: {
                // Navigation
                'nav.home': 'Accueil',
                'nav.games': 'Jeux',
                'nav.academy': 'Académie',
                'nav.premium': 'Premium',
                'nav.settings': 'Paramètres',
                'nav.help': 'Aide',
                
                // Common
                'common.free': 'Gratuit',
                'common.premium': 'Premium',
                'common.upgrade': 'Mettre à niveau',
                'common.login': 'Connexion',
                'common.register': 'S\'inscrire',
                'common.logout': 'Déconnexion',
                'common.save': 'Enregistrer',
                'common.cancel': 'Annuler',
                'common.close': 'Fermer',
                
                // Homepage
                'home.title': 'BetSage',
                'home.subtitle': 'Calculateurs de cotes professionnels',
                'home.games': 'Jeux de Casino',
                'home.lessons': 'Leçons',
                'home.users': 'Utilisateurs Actifs',
                
                // Premium
                'premium.title': 'Devenir Premium',
                'premium.monthly': 'Mensuel',
                'premium.yearly': 'Annuel',
                'premium.features': 'Fonctionnalités Premium',
                'premium.upgrade_now': 'Mettre à niveau maintenant',
                
                // Games
                'games.blackjack': 'Blackjack',
                'games.poker': 'Poker',
                'games.roulette': 'Roulette',
                'games.craps': 'Craps',
                'games.baccarat': 'Baccarat',
                'games.slots': 'Machines à sous',
                
                // Academy
                'academy.lessons': 'Leçons',
                'academy.quizzes': 'Quiz',
                'academy.progress': 'Votre Progrès',
                'academy.take_quiz': 'Passer le Quiz',
                
                // Messages
                'msg.welcome': 'Bienvenue sur BetSage!',
                'msg.login_success': 'Connexion réussie!',
                'msg.premium_required': 'Cette fonction nécessite Premium',
                'msg.quiz_locked': 'Les quiz sont une fonction Premium'
            },
            de: {
                // Navigation
                'nav.home': 'Startseite',
                'nav.games': 'Spiele',
                'nav.academy': 'Akademie',
                'nav.premium': 'Premium',
                'nav.settings': 'Einstellungen',
                'nav.help': 'Hilfe',
                
                // Common
                'common.free': 'Kostenlos',
                'common.premium': 'Premium',
                'common.upgrade': 'Upgrade',
                'common.login': 'Anmelden',
                'common.register': 'Registrieren',
                'common.logout': 'Abmelden',
                'common.save': 'Speichern',
                'common.cancel': 'Abbrechen',
                'common.close': 'Schließen',
                
                // Homepage
                'home.title': 'BetSage',
                'home.subtitle': 'Professionelle Quotenrechner',
                'home.games': 'Casino-Spiele',
                'home.lessons': 'Lektionen',
                'home.users': 'Aktive Benutzer',
                
                // Premium
                'premium.title': 'Premium werden',
                'premium.monthly': 'Monatlich',
                'premium.yearly': 'Jährlich',
                'premium.features': 'Premium-Funktionen',
                'premium.upgrade_now': 'Jetzt upgraden',
                
                // Games
                'games.blackjack': 'Blackjack',
                'games.poker': 'Poker',
                'games.roulette': 'Roulette',
                'games.craps': 'Craps',
                'games.baccarat': 'Baccarat',
                'games.slots': 'Spielautomaten',
                
                // Academy
                'academy.lessons': 'Lektionen',
                'academy.quizzes': 'Quiz',
                'academy.progress': 'Ihr Fortschritt',
                'academy.take_quiz': 'Quiz machen',
                
                // Messages
                'msg.welcome': 'Willkommen bei BetSage!',
                'msg.login_success': 'Anmeldung erfolgreich!',
                'msg.premium_required': 'Diese Funktion erfordert Premium',
                'msg.quiz_locked': 'Quiz sind eine Premium-Funktion'
            }
        };

        return translations[langCode] || translations.en;
    }

    getSupportedLanguages() {
        return [
            { code: 'en', name: 'English', flag: '🇺🇸' },
            { code: 'es', name: 'Español', flag: '🇪🇸' },
            { code: 'fr', name: 'Français', flag: '🇫🇷' },
            { code: 'de', name: 'Deutsch', flag: '🇩🇪' },
            { code: 'pt', name: 'Português', flag: '🇵🇹' },
            { code: 'zh', name: '中文', flag: '🇨🇳' },
            { code: 'ja', name: '日本語', flag: '🇯🇵' },
            { code: 'ru', name: 'Русский', flag: '🇷🇺' }
        ];
    }

    getCurrentLanguage() {
        return this.currentLanguage;
    }

    getLanguageName(code) {
        const lang = this.getSupportedLanguages().find(l => l.code === code);
        return lang ? lang.name : 'English';
    }
}

// Initialize language manager
const languageManager = new LanguageManager();
window.languageManager = languageManager;

// Helper function for translations
function t(key) {
    return languageManager.translate(key);
}

window.t = t;
