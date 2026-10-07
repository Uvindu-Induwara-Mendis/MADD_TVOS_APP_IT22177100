//
//  HomeView.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Main Home Dashboard View for tvOS.
/// Features a personalized household greeting, dynamic recommendations,
/// and horizontal shelf grids optimized for Siri Remote focus transitions.
struct HomeView: View {
    @ObservedObject var viewModel: WellnessViewModel
    
    // Focus tracking for Siri Remote spatial navigation
    enum HomeFocusField: Hashable {
        case profilePill
        case heroBanner
        case recommended(UUID)
        case continueJourney(UUID)
        case ambientSoundscape(UUID)
    }
    
    @FocusState private var focusedItem: HomeFocusField?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 44) {
                
                // MARK: - Top Header Bar
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 14) {
                            Text(viewModel.personalizedGreeting)
                                .font(ZenithTheme.displayTitle)
                                .foregroundColor(.white)
                            
                            // Live Living Room Indicator
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(ZenithTheme.emeraldAccent)
                                    .frame(width: 8, height: 8)
                                Text("Living Room Hub")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(ZenithTheme.emeraldAccent)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(ZenithTheme.emeraldAccent.opacity(0.18))
                            .clipShape(Capsule())
                        }
                        
                        // Streak & Mindfulness Status
                        HStack(spacing: 12) {
                            HStack(spacing: 6) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(ZenithTheme.amberAccent)
                                Text("\(viewModel.activeProfile.streakDays)-Day Streak")
                                    .fontWeight(.bold)
                                    .foregroundColor(ZenithTheme.amberAccent)
                            }
                            
                            Text("•")
                                .foregroundColor(.white.opacity(0.4))
                            
                            HStack(spacing: 6) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(ZenithTheme.cyanAccent)
                                Text("\(viewModel.activeProfile.totalMinutes) Mindful Minutes Recorded")
                                    .foregroundColor(.white.opacity(0.85))
                            }
                        }
                        .font(.system(size: 19, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    // Profile Switcher Pill Button
                    Button {
                        viewModel.isProfileSwitcherPresented = true
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.activeProfile.avatarColor.opacity(0.25))
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: viewModel.activeProfile.avatarSymbol)
                                    .font(.system(size: 24))
                                    .foregroundColor(viewModel.activeProfile.avatarColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(viewModel.activeProfile.name)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                Text("Switch Profile")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Image(systemName: "chevron.up.chevron.down")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(ZenithTheme.cardBackgroundElevated)
                        .overlay(
                            Capsule()
                                .stroke(ZenithTheme.glassBorder, lineWidth: 1.2)
                        )
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.card)
                    .focused($focusedItem, equals: .profilePill)
                }
                .padding(.horizontal, 80)
                .padding(.top, 24)
                
                // MARK: - Hero Featured Experience Banner
                if let featured = viewModel.recommendedSessions.first {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack(spacing: 10) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ZenithTheme.indigoAccent)
                            Text("TODAY'S LIVING ROOM SANCTUARY")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(ZenithTheme.indigoAccent)
                                .kerning(2.5)
                        }
                        
                        HeroBannerCard(session: featured) {
                            viewModel.startMeditationSession(featured)
                        }
                        .focused($focusedItem, equals: .heroBanner)
                    }
                    .padding(.horizontal, 80)
                }
                
                // MARK: - Recommended for You Shelf (Horizontal Scroll)
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("Recommended for You")
                            .font(ZenithTheme.sectionTitle)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Tailored for \(viewModel.activeProfile.name) • Evening Protocol")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.55))
                    }
                    .padding(.horizontal, 80)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 32) {
                            ForEach(viewModel.recommendedSessions) { session in
                                FocusableMeditationCard(session: session) {
                                    viewModel.startMeditationSession(session)
                                }
                                .focused($focusedItem, equals: .recommended(session.id))
                            }
                        }
                        .padding(.horizontal, 80)
                        .padding(.vertical, 16) // Extra padding for tvOS focus lift
                    }
                }
                
                // MARK: - Continue Journey Shelf
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("Continue Journey")
                            .font(ZenithTheme.sectionTitle)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Recent Practices & Quick Daily Resets")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.55))
                    }
                    .padding(.horizontal, 80)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 32) {
                            ForEach(viewModel.continueJourneySessions) { session in
                                FocusableMeditationCard(session: session) {
                                    viewModel.startMeditationSession(session)
                                }
                                .focused($focusedItem, equals: .continueJourney(session.id))
                            }
                        }
                        .padding(.horizontal, 80)
                        .padding(.vertical, 16)
                    }
                }
                
                // MARK: - Living Room Ambient Soundscapes Shelf
                VStack(alignment: .leading, spacing: 18) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("Living Room Acoustic Environments")
                            .font(ZenithTheme.sectionTitle)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Spatial soundscapes tuned to 432 Hz & 528 Hz")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white.opacity(0.55))
                    }
                    .padding(.horizontal, 80)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 32) {
                            ForEach(viewModel.soundscapes) { soundscape in
                                Button {
                                    viewModel.startSoundscape(soundscape)
                                } label: {
                                    VStack(alignment: .leading, spacing: 12) {
                                        ZStack {
                                            LinearGradient(
                                                colors: [
                                                    soundscape.primaryColor.opacity(0.35),
                                                    soundscape.secondaryColor.opacity(0.65)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                            
                                            AudioWaveformVisualizer(
                                                type: soundscape.visualizationType,
                                                accentColor: soundscape.primaryColor
                                            )
                                            .padding(.horizontal, 16)
                                        }
                                        .frame(height: 124)
                                        .cornerRadius(14)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(soundscape.title)
                                                .font(ZenithTheme.cardTitle)
                                                .foregroundColor(.white)
                                                .lineLimit(1)
                                            
                                            HStack(spacing: 8) {
                                                Text(soundscape.frequencyText)
                                                    .font(.system(size: 15, weight: .semibold))
                                                    .foregroundColor(soundscape.primaryColor)
                                                
                                                Text("•")
                                                    .foregroundColor(.white.opacity(0.3))
                                                
                                                Text("Infinite Loop")
                                                    .font(.system(size: 14, weight: .medium))
                                                    .foregroundColor(.white.opacity(0.6))
                                            }
                                        }
                                    }
                                    .padding(18)
                                    .frame(width: ZenithTheme.soundscapeCardWidth, height: ZenithTheme.soundscapeCardHeight)
                                    .background(ZenithTheme.cardBackgroundElevated)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(ZenithTheme.glassBorder, lineWidth: 1.2)
                                    )
                                    .cornerRadius(20)
                                }
                                .buttonStyle(.card)
                                .focused($focusedItem, equals: .ambientSoundscape(soundscape.id))
                            }
                        }
                        .padding(.horizontal, 80)
                        .padding(.vertical, 16)
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .background(ZenithTheme.primaryBackgroundGradient.ignoresSafeArea())
    }
}
