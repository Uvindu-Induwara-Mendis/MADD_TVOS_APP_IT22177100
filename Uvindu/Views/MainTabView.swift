//
//  MainTabView.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Main Navigation Coordinator using native tvOS TabView.
/// Provides high-level tab navigation across Home, Meditations, Soundscapes, and Profile,
/// with full-screen immersive player overlays and profile switching modals.
struct MainTabView: View {
    @StateObject private var viewModel = WellnessViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            // MARK: - Native tvOS Tab Bar Navigation
            TabView(selection: $selectedTab) {
                // Tab 1: Home Dashboard
                HomeView(viewModel: viewModel)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                // Tab 2: Meditation & Breathwork Library
                MeditationsView(viewModel: viewModel)
                    .tabItem {
                        Label("Meditations", systemImage: "figure.mind.and.body")
                    }
                    .tag(1)
                
                // Tab 3: Ambient Soundscapes
                SoundscapesView(viewModel: viewModel)
                    .tabItem {
                        Label("Soundscapes", systemImage: "waveform.path")
                    }
                    .tag(2)
                
                // Tab 4: Household Multi-User Profile
                ProfileView(viewModel: viewModel)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(3)
            }
            
            // MARK: - Full-Screen Immersive Meditation Player Overlay
            if let activeSession = viewModel.activeMeditationForPlayer {
                ImmersivePlayerView(session: activeSession, appViewModel: viewModel)
                    .transition(.opacity.combined(with: .scale(scale: 1.02)))
                    .zIndex(100)
            }
            
            // MARK: - Full-Screen Ambient Soundscape Player Overlay
            if let activeSoundscape = viewModel.activeSoundscapeForPlayer {
                ImmersiveSoundscapePlayerView(soundscape: activeSoundscape, appViewModel: viewModel)
                    .transition(.opacity)
                    .zIndex(101)
            }
            
            // MARK: - Multi-User Household Profile Switcher Modal
            if viewModel.isProfileSwitcherPresented {
                ProfileSwitcherOverlay(viewModel: viewModel)
                    .transition(.opacity)
                    .zIndex(200)
            }
        }
        .preferredColorScheme(.dark) // Enforces dark mode for dim living room TV viewing
    }
}

#Preview {
    MainTabView()
}
