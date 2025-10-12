# 🔊 Sound Effects System

## Overview

The Casino Assistant now includes a complete Web Audio API-based sound effects system that provides realistic casino sounds without requiring external audio files.

## Features

### ✅ Sound Types

1. **Click** - Button clicks and selections
2. **Win** - Small to medium wins
3. **Big Win** - Large wins and jackpots
4. **Lose** - No win/loss
5. **Deal** - Card dealing
6. **Spin** - Slot machine spinning
7. **Chip** - Chip placement/betting
8. **Shuffle** - Card shuffling
9. **Coin** - Coin drop/payout

### 🎮 Games with Sound Effects

#### **Video Poker** (`games/video_poker.html`)
- 🃏 **Deal** - When dealing cards
- 🖱️ **Click** - Holding/unholding cards
- 🎰 **Chip** - Changing bet amount
- 🏆 **Win** - Small wins (Jacks or Better, Two Pair, etc.)
- 💎 **Big Win** - Large wins (Royal Flush, Straight Flush, etc.)
- 😢 **Lose** - No winning hand

#### **Slots** (`games/slots_odds.html`)
- 🎡 **Spin** - Spinning the reels
- ✨ **Win** - 3-symbol match
- 🎊 **Big Win** - 4-5 symbol matches
- 😢 **Lose** - No match

#### **Poker Odds** (`games/poker_odds.html`)
- 🃏 **Deal** - Selecting a card
- 🖱️ **Click** - Deselecting a card

## Usage

### For Developers

Include the sound system in your HTML:

```html
<script src="../docs/sounds.js"></script>
```

Play sounds in your JavaScript:

```javascript
// Play a sound
casinoSounds.playSound('win');
casinoSounds.playSound('bigwin');
casinoSounds.playSound('deal');
casinoSounds.playSound('chip');
```

### Available Methods

```javascript
// Play specific sound
casinoSounds.playSound('type');

// Toggle sound on/off
casinoSounds.toggle();

// Set volume (0.0 to 1.0)
casinoSounds.setVolume(0.5);

// Check if enabled
casinoSounds.enabled; // true/false
```

## Settings Integration

Sound effects can be controlled through the Settings page:

1. Go to **Settings** (⚙️ button in user profile)
2. Navigate to **Game Settings**
3. Toggle **Sound Effects** on/off
4. Changes are saved to localStorage

### localStorage Key

```javascript
{
  "casinoSettings": {
    "soundEffects": true // or false
  }
}
```

## Technical Details

### Web Audio API

All sounds are generated using the Web Audio API:
- **No external files required**
- **Instant playback**
- **Small memory footprint**
- **Cross-browser compatible**

### Sound Generation

Each sound uses oscillators with specific parameters:

#### Click Sound
```javascript
- Frequency: 800 Hz
- Type: Sine wave
- Duration: 0.1s
- Volume: 30%
```

#### Win Sound
```javascript
- Frequencies: 523 → 659 → 784 Hz (C-E-G chord)
- Type: Sine wave
- Duration: 0.4s
- Volume: 100%
```

#### Big Win Sound
```javascript
- 5 ascending tones
- Frequencies: 523-923 Hz
- Duration: 0.2s each
- Interval: 100ms
- Volume: 100%
```

#### Spin Sound
```javascript
- Frequency: 100 → 50 Hz (descending)
- Type: Sawtooth wave
- Duration: 1s
- Volume: 40%
```

#### Chip Sound
```javascript
- Frequency: 1000 Hz
- Type: Sine wave
- Duration: 0.08s
- Volume: 30%
```

## Browser Compatibility

### Supported Browsers
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Opera 76+

### Mobile Support
- ✅ iOS Safari 14+
- ✅ Chrome Mobile
- ✅ Samsung Internet
- ✅ Firefox Mobile

**Note**: Some mobile browsers require user interaction before playing audio (autoplay policy).

## Performance

### Memory Usage
- **Minimal** - No audio files loaded
- **On-demand** - Sounds generated when needed
- **Efficient** - AudioContext reused

### CPU Usage
- **Low** - Simple waveforms
- **Optimized** - Short durations
- **Cached** - AudioContext persists

## Customization

### Adding New Sounds

Edit `docs/sounds.js`:

```javascript
playCustomSound() {
    const oscillator = this.audioContext.createOscillator();
    const gainNode = this.audioContext.createGain();
    
    oscillator.connect(gainNode);
    gainNode.connect(this.audioContext.destination);
    
    // Customize frequency, type, duration
    oscillator.frequency.value = 440; // A4 note
    oscillator.type = 'sine';
    
    gainNode.gain.setValueAtTime(this.volume, this.audioContext.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, this.audioContext.currentTime + 0.5);
    
    oscillator.start(this.audioContext.currentTime);
    oscillator.stop(this.audioContext.currentTime + 0.5);
}
```

### Adjusting Volume

Default volume is 30% (0.3). Adjust in `sounds.js`:

```javascript
this.volume = 0.3; // Change to 0.0-1.0
```

## Future Enhancements

### Planned Features
- 🎵 Background music toggle
- 🎚️ Individual volume controls
- 🎼 Multiple sound themes
- 📱 Vibration feedback (mobile)
- 🔇 Mute button shortcut

### Potential Sounds
- **Roulette** - Ball spinning, ball drop
- **Craps** - Dice rolling, dice hitting table
- **Baccarat** - Card flip, card slide
- **Keno** - Ball selection, number call

## Troubleshooting

### No Sound Playing

1. **Check Settings**
   - Go to Settings → Game Settings
   - Ensure "Sound Effects" is ON

2. **Browser Permissions**
   - Some browsers block autoplay
   - Click anywhere on the page first

3. **Volume**
   - Check system volume
   - Check browser tab is not muted

4. **Browser Support**
   - Update to latest browser version
   - Check Web Audio API support

### Sound Delayed

- **Normal** - First sound may have slight delay
- **AudioContext** - Initializes on first use
- **Subsequent sounds** - Should be instant

## Examples

### Video Poker Win Detection

```javascript
if (payout > 0) {
    if (payout >= 100 * bet) {
        casinoSounds.playSound('bigwin'); // Royal Flush, etc.
    } else {
        casinoSounds.playSound('win'); // Regular win
    }
} else {
    casinoSounds.playSound('lose'); // No win
}
```

### Slots Match Detection

```javascript
if (matchCount === 5) {
    casinoSounds.playSound('bigwin'); // Jackpot
} else if (matchCount === 4) {
    casinoSounds.playSound('bigwin'); // Big win
} else if (matchCount === 3) {
    casinoSounds.playSound('win'); // Small win
} else {
    casinoSounds.playSound('lose'); // No match
}
```

### Button Click

```javascript
button.addEventListener('click', () => {
    casinoSounds.playSound('click');
    // ... button action
});
```

## Credits

Sound system designed using Web Audio API for:
- Zero external dependencies
- Instant loading
- Cross-platform compatibility
- Minimal resource usage

---

**Version**: 1.0  
**Last Updated**: October 2025  
**File**: `docs/sounds.js`  
**Size**: ~5 KB  
**Dependencies**: None (Web Audio API built-in)
