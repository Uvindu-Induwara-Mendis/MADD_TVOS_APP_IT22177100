# Zenith: Living Room Wellness & Meditation Hub
## Academic Technical Report & tvOS Architecture Documentation

**Target Platform:** Apple tvOS 17.0+  
**Architecture Pattern:** MVVM (Model-View-ViewModel)  
**Input Modality:** Apple TV Siri Remote (Focus Engine & Clickpad)  
**Display Format:** 10-Foot Living Room UI (4K / HDR / Dark-Mode Optimized)

---

## 1. Executive Summary & Concept Innovation (25 Marks)

### 1.1 The Living Room Wellness Gap
Modern mindfulness and meditation applications (e.g., Calm, Headspace) are built overwhelmingly for **individual smartphones** with small 6-inch screens. This paradigm fosters an isolated, solitary experience where users stare down at hand-held devices, often suffering from screen notification interruptions and blue light exposure.

**Zenith** reimagines mindfulness for the **shared living room**, converting the television and home theater sound system into a communal household wellness sanctuary. It is designed around the spatial context of the living room:
1. **Shared Ambient Experience:** Family members can participate together in heart rate variability (HRV) breathing coherence or relax under high-fidelity acoustic soundscapes.
2. **True tvOS Multi-User Experience:** Apple TV is a shared device. Zenith provides instant profile switching, tracking individual streaks, preferred acoustic soundscapes, and historical minutes for each household member (parents, teens, guests).
3. **Distraction-Free 10-Foot UI:** Controlled entirely via the Siri Remote, with smooth focus transitions, high-contrast dark aesthetics for dimly lit evening rooms, and zero touch clutter.

### 1.2 Competitive Analysis: Comparison with Existing Solutions

| Feature / Metric | Mobile Calm / Headspace | Apple Fitness+ (tvOS) | Apple Breathe (Watch) | **Zenith tvOS (Our App)** |
| :--- | :--- | :--- | :--- | :--- |
| **Primary Device** | Smartphone (Handheld) | Apple TV / iPad | Apple Watch | **Apple TV (Living Room Hub)** |
| **Multi-User Household** | ❌ Single user account | ⚠️ Tied to Apple ID | ❌ Personal watch only | **✅ Native Living Room Multi-Profile Switcher** |
| **Input Model** | Touch gestures | Siri Remote / Watch | Digital Crown / Touch | **✅ Focus Engine & Siri Remote Navigation** |
| **Visual Immersion** | Mobile portrait video | Instructor workout video | Small haptic circle | **✅ Full-Screen Ambient Aura & 4K Visualizer** |
| **Living Room Acoustics** | Phone speaker / headphones | Standard TV audio | Silent / Watch speaker | **✅ Binaural Frequencies & Audio Visualizers** |
| **Communal Family Practice** | ❌ Not designed for groups | ⚠️ High physical intensity | ❌ Not applicable | **✅ Family Coherence & Kids Calm modes** |

---

## 2. Advanced Prototype Functionality & Features (25 Marks)

### 2.1 Core Implemented Features
1. **Multi-User Profile System (`UserProfile`, `WellnessDataService`):**
   - Individual tracking of **streaks**, **total mindful minutes**, **preferred ambient soundscapes**, and **recent session logs**.
   - One-click household profile switching modal (`ProfileSwitcherOverlay`) with reactive updates across greetings, recommendations, and analytics.
2. **Full-Screen Immersive Meditation Player (`ImmersivePlayerView`):**
   - Distraction-free full-screen presentation.
   - Prominent circular breathing guide with animated expansion/contraction driven by a 20Hz state engine.
   - Pacing protocol selector (Box Breathing 4-4-4-4, 4-7-8 Natural Tranquilizer, Coherent Resonance 5.5s, Gentle Wind-Down).
   - Siri Remote playback controls: Play/Pause, Rewind 15s, Forward 15s, Restart, End Session.
   - Session completion summary screen with immediate streak and minute increment.
3. **Ambient Living Room Soundscapes (`SoundscapesView`, `AudioWaveformVisualizer`):**
   - Six procedural acoustic frequencies (Ocean Waves, Rain Ripples, Celestial Orb, Mountain Fireside, Forest Canopy, Tibetan Singing Bowls).
   - Real-time animated procedural audio visualizations.
   - Favorite soundscape assignment per user profile.
4. **Rich Meditation Catalog (`MeditationsView`):**
   - Filterable by 6 distinct categories (Breathwork, Deep Sleep, Focus & Flow, Stress Relief, Mindful Morning, Family Calm).
   - Quick duration filters (Any, 5m, 8m, 10m, 15m, 20m).

---

## 3. User Experience & Interaction Design (15 Marks)

### 3.1 Siri Remote & Focus Engine Optimization
On tvOS, users cannot touch the screen; navigation relies on moving focus across interactive UI elements using the Siri Remote touch surface or directional clickpad.
- **`.buttonStyle(.card)`:** Standardized across all interactive cards so focused elements smoothly scale up, elevate with parallax tilt, and cast realistic drop shadows.
- **`@FocusState` Coordination:**
  - Upon opening the `ImmersivePlayerView`, focus is programmatically locked to the primary Play/Pause button (`focusedControl = .playPause`). The user does not need to swipe around blindly.
  - In `ProfileSwitcherOverlay`, focus defaults to the active user's card.
  - In `HomeView`, focus flows logically from the profile switcher down to the featured hero banner and horizontal shelves.
- **Horizontal & Vertical Shelving:** Built using `ScrollView(.horizontal)` and `LazyHStack` / `LazyVGrid`, providing seamless scroll snapping on Apple TV.

### 3.2 10-Foot UI & Ambient Darkness
- **Color Tokens:** Deep background (`#0D1322`) prevents harsh illumination and blooming on OLED displays in dark home theaters.
- **Typography Scale:** Prominent typography hierarchy (Display Title: 44pt, Section: 32pt, Body: 22pt, Timer: 72pt monospaced) ensures crisp readability from 10 to 15 feet away.

---

## 4. Technical Implementation & Architecture (15 Marks)

### 4.1 MVVM Architecture Breakdown

```
[ View Layer (SwiftUI tvOS 17+) ]
   │  MainTabView
   │  ├── HomeView (HeroBannerCard, Shelves)
   │  ├── MeditationsView (CategoryChips, FilterGrid)
   │  ├── SoundscapesView (AudioVisualizers)
   │  ├── ProfileView (7-Day Bar Chart, History Log)
   │  └── ImmersivePlayerView (BreathingCircleView, Siri Remote Bar)
   │
[ ViewModel Layer (ObservableObject / @Published) ]
   │  ├── WellnessViewModel (App Coordinator, Filter State, Navigation)
   │  └── MeditationPlayerViewModel (20Hz Timer Engine, Phase Transitions)
   │
[ Model & Data Layer ]
   │  ├── WellnessDataService (Reactive in-memory mock repository)
   │  ├── WellnessAudioService (Dual-Engine: Bundled Audio & Procedural Synthesizer)
   │  ├── UserProfile & CompletedSessionRecord
   │  ├── MeditationSession & MeditationCategory
   │  ├── Soundscape & AudioVisualizationType
   │  └── BreathingPattern & BreathingPhase
```

### 4.2 Key Technical Highlights
- **Dual-Engine Living Room Acoustic System (`WellnessAudioService.swift`):** Employs AVFoundation to detect and play bundled audio files (`.mp3`, `.m4a`, `.wav`) with infinite looping. Features an embedded real-time procedural synthesizer (`AVAudioEngine` & `AVAudioSourceNode`) generating 432 Hz / 528 Hz binaural frequencies, ocean wave swell filters, and singing bowl acoustic transitions without requiring external media assets.
- **20 Hz Breath Engine (`MeditationPlayerViewModel.swift`):** Employs `Timer.publish(every: 0.05)` on the `.common` run loop to smoothly interpolate visual scale and progress ring transformations without stutter.
- **Fail-Safe Siri Remote Navigation:** Implements native `.onExitCommand` and bidirectional bottom control bars (`[Exit] [Rewind] [Play/Pause] [Forward] [Complete]`), preventing tvOS Focus Engine ray-casting traps.
- **Xcode 16 Modern Project Compatibility:** Leverages `PBXFileSystemSynchronizedRootGroup` so all newly created Swift source files and audio assets are automatically compiled by Xcode without manual `.pbxproj` file reference overhead.
- **Strict Concurrency & Safe State:** Fully compliant with tvOS 17+ Swift 5 concurrency guidelines with clean decoupling.

---

## 5. Testing & Verification Guide for Xcode / tvOS Simulator
When testing this project on your friend's Mac:
1. Open `Uvindu.xcodeproj` in **Xcode 16** (or Xcode 15).
2. Select the **Apple TV (17.0+ or 18.0)** Simulator or a physical Apple TV device.
3. Press **Cmd + R** to build and run.
4. **Navigating with Simulator Siri Remote:**
   - Press **Cmd + Shift + R** to toggle the on-screen Apple TV Siri Remote.
   - Use Arrow Keys / Clickpad swipe to move focus between cards.
   - Press Return or Clickpad Center to select an item and begin meditation.
   - Press Escape / Menu button to exit or navigate back.
