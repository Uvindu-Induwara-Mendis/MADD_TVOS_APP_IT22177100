# Zenith tvOS - Audio Files Setup & Drop-In Guide

Zenith comes with a **Dual-Engine Living Room Acoustic System**:
1. **Procedural Real-Time Audio Synthesizer (Built-in)**: Generates soothing 432 Hz / 528 Hz binaural beats, ocean surf pink noise, and singing bowl transition chimes on the fly using `AVAudioEngine` — **no external sound files required for immediate playback!**
2. **High-Fidelity Audio Tracks (Optional Drop-in)**: If you drop `.mp3`, `.m4a`, or `.wav` files into the Xcode project, Zenith automatically detects them and plays high-definition studio recordings seamlessly with infinite ambient looping.

---

## 🎵 Recommended Audio Files to Add

Drop any of the following audio files into the `Uvindu/Sounds/` folder (or drag them into Xcode):

| Recommended Filename | Soundscape / Practice | Suggested Sound Type & Frequency |
| :--- | :--- | :--- |
| `ocean.mp3` | **Pacific Ocean Sanctuary** | Gentle rolling ocean surf / Big Sur breakers (432 Hz) |
| `rain.mp3` | **Rainstorm on Cedar Roof** | Soft rainfall on a roof with distant gentle thunder |
| `celestial.mp3` | **Celestial Drift** | Deep space ethereal synth drone with harmonic overtones (528 Hz) |
| `hearth.mp3` | **Alpine Mountain Hearth** | Cozy fireplace birchwood crackling embers |
| `forest.mp3` | **Deep Pine Forest Breeze** | Gentle wind rustling through pine needles with faint birdsong |
| `singing_bowls.mp3` | **Tibetan Singing Bowls** | Bronze Tibetan singing bowls harmonic resonance (6 Hz Theta) |
| `bell.mp3` or `chime.mp3` | **Breath Phase Cue** | Clean singing bowl or meditation bell chime for Inhale/Exhale transitions |
| `meditation.mp3` | **Meditation Ambient** | Soothing warm chord pad for guided meditations |

*Supported audio formats:* `.mp3`, `.m4a`, `.wav`, `.aac`.

---

## 🌐 Where to Get Free Royalty-Free Sounds

You can download high-quality, 100% free sound effects and ambient loops from:
1. **[Pixabay Sound Effects](https://pixabay.com/sound-effects/)**: Search for `"ocean waves"`, `"rain"`, `"fireplace"`, `"singing bowl"`, `"meditation bell"`.
2. **[Freesound.org](https://freesound.org/)**: Search for `"ocean loop"`, `"rainfall"`, `"tibetan bowl"`.
3. **[YouTube Audio Library](https://studio.youtube.com/)**: Free ambient background tracks and sound effects.

---

## 📲 How to Add Sounds to Xcode

1. Download your chosen `.mp3` files and rename them to match the table above (e.g., `ocean.mp3`, `rain.mp3`).
2. Open `Uvindu.xcodeproj` in Xcode on your friend's Mac.
3. Drag and drop the audio files into the `Uvindu` project navigator.
4. In the pop-up options sheet:
   - ✅ Check **"Copy items if needed"**
   - ✅ Select **"Create groups"**
   - ✅ Ensure **"Add to targets: Uvindu"** is checked
5. Press **Cmd + R** to run! Zenith will automatically play your high-definition sound files.
