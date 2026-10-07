//
//  ProfileSwitcherOverlay.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// tvOS Focus-Optimized Profile Switcher Modal.
/// Enables seamless transition between household members in the shared living room.
struct ProfileSwitcherOverlay: View {
    @ObservedObject var viewModel: WellnessViewModel
    @FocusState private var focusedProfileId: UUID?
    
    var body: some View {
        ZStack {
            // Dimmed backdrop
            Color.black.opacity(0.85)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 12) {
                    Text("Switch Household Profile")
                        .font(ZenithTheme.displayTitle)
                        .foregroundColor(.white)
                    
                    Text("Select your personal mindfulness profile to sync your streaks and favorites.")
                        .font(ZenithTheme.bodyText)
                        .foregroundColor(.white.opacity(0.75))
                }
                
                // Horizontal Profile Cards with Siri Remote Focus
                HStack(spacing: 35) {
                    ForEach(viewModel.profiles) { profile in
                        let isCurrent = profile.id == viewModel.activeProfile.id
                        
                        Button {
                            viewModel.selectProfile(profile)
                        } label: {
                            VStack(spacing: 18) {
                                // Avatar Circle
                                ZStack {
                                    Circle()
                                        .fill(profile.avatarColor.opacity(0.3))
                                        .frame(width: 140, height: 140)
                                    
                                    Circle()
                                        .stroke(profile.avatarColor, lineWidth: isCurrent ? 4 : 1.5)
                                        .frame(width: 140, height: 140)
                                    
                                    Image(systemName: profile.avatarSymbol)
                                        .font(.system(size: 60))
                                        .foregroundColor(profile.avatarColor)
                                    
                                    if isCurrent {
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.system(size: 32))
                                                    .foregroundColor(ZenithTheme.emeraldAccent)
                                                    .background(Circle().fill(Color.black))
                                            }
                                        }
                                        .frame(width: 140, height: 140)
                                    }
                                }
                                
                                VStack(spacing: 6) {
                                    Text(profile.name)
                                        .font(ZenithTheme.cardTitle)
                                        .foregroundColor(.white)
                                    
                                    Text(profile.role)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.white.opacity(0.6))
                                    
                                    Text("🔥 \(profile.streakDays) Days")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(ZenithTheme.amberAccent)
                                        .padding(.top, 4)
                                }
                            }
                            .padding(24)
                            .frame(width: ZenithTheme.profileCardWidth, height: 320)
                            .background(ZenithTheme.cardBackgroundElevated)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(isCurrent ? profile.avatarColor.opacity(0.5) : Color.white.opacity(0.1), lineWidth: 1.5)
                            )
                            .cornerRadius(22)
                        }
                        .buttonStyle(.card)
                        .focused($focusedProfileId, equals: profile.id)
                    }
                }
                .padding(.horizontal, 40)
                
                // Dismiss Button
                Button {
                    dismissOverlay()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                        Text("Cancel")
                    }
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.bordered)
                .padding(.top, 16)
            }
            .padding(50)
        }
        .onExitCommand {
            dismissOverlay()
        }
        .onAppear {
            focusedProfileId = viewModel.activeProfile.id
        }
    }
    
    private func dismissOverlay() {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            viewModel.isProfileSwitcherPresented = false
        }
    }
}
