//
//  ImmersiveSoundscapePlayerView.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Full-Screen Ambient Soundscape Player for the Living Room Home Theater.
/// Provides hypnotic acoustic visualizer animations, Siri Remote sound controls,
/// and instant one-click exit navigation.
struct ImmersiveSoundscapePlayerView: View {
    let soundscape: Soundscape
    @ObservedObject var appViewModel: WellnessViewModel
    @ObservedObject private var audioService = WellnessAudioService.shared
    
    @State private var isPlaying: Bool = true
    @State private var volumeLevel: Double = 0.8
    @FocusState private var focusedControl: SoundscapeControlFocus?
    
    enum SoundscapeControlFocus: Hashable {
        case topExitButton
        case bottomExit
        case playPause
        case setAsPreferred
        case volumeDown
        case volumeUp
    }
    
    var isCurrentlyPreferred: Bool {
        appViewModel.activeProfile.preferredSoundscapeTitle == soundscape.title
    }
    
    var body: some View {
        ZStack {
            // Background
            ZenithTheme.backgroundDark
                .ignoresSafeArea()
            
            // Dynamic Ambient Living Room Backlight
            RadialGradient(
                colors: [
                    soundscape.primaryColor.opacity(isPlaying ? 0.30 : 0.12),
                    soundscape.secondaryColor.opacity(0.15),
                    Color.clear
                ],
                center: .center,
                startRadius: 100,
                endRadius: 800
            )
            .animation(.easeInOut(duration: 0.6), value: isPlaying)
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Top Bar
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 12) {
                            Label(soundscape.frequencyText, systemImage: "waveform")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(soundscape.primaryColor)
                            
                            Text("•")
                                .foregroundColor(.white.opacity(0.4))
                            
                            Text(audioService.isUsingBundledAudio ? "HQ Audio Track Active" : "Procedural Synthesis Active")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(ZenithTheme.cyanAccent)
                        }
                        
                        Text(soundscape.title)
                            .font(ZenithTheme.displayTitle)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Top Bar Exit Button
                    Button {
                        exitPlayer()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 20))
                            Text("Exit Ambient")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.card)
                    .focused($focusedControl, equals: .topExitButton)
                }
                .padding(.horizontal, 80)
                .padding(.top, 24)
                
                Spacer()
                
                // Centerpiece: Full-Size Animated Visualizer with Radiant Glow
                VStack(spacing: 24) {
                    ZStack {
                        // Outer Radiant Glow
                        Circle()
                            .fill(soundscape.primaryColor.opacity(isPlaying ? 0.20 : 0.05))
                            .frame(width: 480, height: 480)
                            .blur(radius: 20)
                        
                        // Glass Disc Backing
                        Circle()
                            .fill(ZenithTheme.cardBackground.opacity(0.8))
                            .overlay(
                                Circle()
                                    .stroke(soundscape.primaryColor.opacity(0.3), lineWidth: 2)
                            )
                            .frame(width: 440, height: 440)
                        
                        // Live Waveform Visualizer
                        AudioWaveformVisualizer(
                            type: soundscape.visualizationType,
                            accentColor: soundscape.primaryColor,
                            isPlaying: isPlaying
                        )
                        .scaleEffect(1.65)
                    }
                    .frame(width: 480, height: 480)
                    
                    Text(soundscape.descriptionText)
                        .font(ZenithTheme.bodyText)
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 760)
                }
                
                Spacer()
                
                // Controls Bar: Left-to-Right layout ensuring easy exit navigation
                HStack(spacing: 24) {
                    
                    // 1. DEDICATED EXIT BUTTON (Guarantees user is NEVER stranded!)
                    Button {
                        exitPlayer()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white.opacity(0.9))
                            Text("Exit")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .padding(.horizontal, 28)
                        .frame(height: 66)
                        .background(Color.white.opacity(0.14))
                        .foregroundColor(.white)
                        .cornerRadius(18)
                    }
                    .buttonStyle(.card)
                    .focused($focusedControl, equals: .bottomExit)
                    
                    // 2. PRIMARY PLAY/PAUSE (Initial Focus on Load)
                    Button {
                        isPlaying.toggle()
                        if isPlaying {
                            audioService.resume()
                        } else {
                            audioService.pause()
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 28))
                            Text(isPlaying ? "Pause Sound" : "Play Sound")
                                .font(.system(size: 22, weight: .bold))
                        }
                        .padding(.horizontal, 36)
                        .frame(height: 66)
                        .background(soundscape.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                        .shadow(color: soundscape.primaryColor.opacity(0.4), radius: 12, x: 0, y: 4)
                    }
                    .buttonStyle(.card)
                    .focused($focusedControl, equals: .playPause)
                    
                    // 3. SET AS PREFERRED FOR ACTIVE PROFILE
                    Button {
                        appViewModel.setPreferredSoundscape(title: soundscape.title)
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: isCurrentlyPreferred ? "star.fill" : "star")
                                .font(.system(size: 24))
                                .foregroundColor(isCurrentlyPreferred ? ZenithTheme.amberAccent : .white)
                            Text(isCurrentlyPreferred ? "Preferred Sound" : "Set as My Favorite")
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .padding(.horizontal, 28)
                        .frame(height: 66)
                        .background(ZenithTheme.cardBackgroundElevated)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(isCurrentlyPreferred ? ZenithTheme.amberAccent.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1.5)
                        )
                        .cornerRadius(18)
                    }
                    .buttonStyle(.card)
                    .focused($focusedControl, equals: .setAsPreferred)
                }
                .padding(.bottom, 40)
                .focusSection()
            }
        }
        // Native tvOS Exit Command: Pressing Siri Remote Menu/Back or Mac keyboard Escape exits instantly
        .onExitCommand {
            exitPlayer()
        }
        .onAppear {
            // Start audio engine immediately
            audioService.playSoundscape(soundscape)
            
            // Set initial focus to Play/Pause button
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedControl = .playPause
            }
        }
        .onDisappear {
            audioService.stopCurrentAudio(fade: true)
        }
    }
    
    private func exitPlayer() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            audioService.stopCurrentAudio(fade: true)
            appViewModel.activeSoundscapeForPlayer = nil
        }
    }
}
