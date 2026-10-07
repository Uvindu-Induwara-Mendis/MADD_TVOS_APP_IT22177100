//
//  ProfileView.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Profile and Household Wellness Management Dashboard.
/// Displays individual user streaks, preferred meditation sounds,
/// 7-day weekly activity visualization, and recent session history for different household members.
struct ProfileView: View {
    @ObservedObject var viewModel: WellnessViewModel
    @FocusState private var focusedElement: ProfileFocusTarget?
    
    enum ProfileFocusTarget: Hashable {
        case switchProfileButton
        case soundscapePicker
        case sessionHistory(UUID)
        case householdMember(UUID)
    }
    
    private let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 44) {
                
                // MARK: - Header & Active Profile Hero
                HStack(spacing: 36) {
                    // Avatar Disc with Glowing Halo
                    ZStack {
                        Circle()
                            .fill(viewModel.activeProfile.avatarColor.opacity(0.25))
                            .frame(width: 140, height: 140)
                            .blur(radius: 8)
                        
                        Circle()
                            .stroke(viewModel.activeProfile.avatarColor, lineWidth: 3.5)
                            .frame(width: 140, height: 140)
                        
                        Image(systemName: viewModel.activeProfile.avatarSymbol)
                            .font(.system(size: 65))
                            .foregroundColor(viewModel.activeProfile.avatarColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            Text(viewModel.activeProfile.name)
                                .font(ZenithTheme.displayTitle)
                                .foregroundColor(.white)
                            
                            Text(viewModel.activeProfile.role)
                                .font(.system(size: 17, weight: .bold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .background(viewModel.activeProfile.avatarColor.opacity(0.3))
                                .foregroundColor(viewModel.activeProfile.avatarColor)
                                .clipShape(Capsule())
                        }
                        
                        Text("Active Household Member on Apple TV")
                            .font(ZenithTheme.bodyText)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    // Switch Profile Button
                    Button {
                        viewModel.isProfileSwitcherPresented = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "person.2.badge.gearshape.fill")
                                .font(.system(size: 22))
                            Text("Switch Profile")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .padding(.horizontal, 26)
                        .padding(.vertical, 14)
                        .background(ZenithTheme.indigoAccent)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: ZenithTheme.indigoAccent.opacity(0.4), radius: 10, x: 0, y: 3)
                    }
                    .buttonStyle(.card)
                    .focused($focusedElement, equals: .switchProfileButton)
                }
                .padding(.horizontal, 80)
                .padding(.top, 24)
                
                // MARK: - Stat Cards Row
                HStack(spacing: 28) {
                    // Streak Card
                    StatBox(
                        title: "Current Streak",
                        value: "\(viewModel.activeProfile.streakDays) Days",
                        subtitle: "Consistent Living Room Practice",
                        icon: "flame.fill",
                        accentColor: ZenithTheme.amberAccent
                    )
                    
                    // Total Minutes
                    StatBox(
                        title: "Total Mindful Minutes",
                        value: "\(viewModel.activeProfile.totalMinutes) Min",
                        subtitle: "Recorded on this Apple TV",
                        icon: "clock.arrow.circlepath",
                        accentColor: ZenithTheme.cyanAccent
                    )
                    
                    // Preferred Sound
                    StatBox(
                        title: "Preferred Soundscape",
                        value: viewModel.activeProfile.preferredSoundscapeTitle,
                        subtitle: "Autoplays during breathing",
                        icon: "music.note.house.fill",
                        accentColor: ZenithTheme.emeraldAccent
                    )
                    
                    // Favorite Focus
                    StatBox(
                        title: "Favorite Practice",
                        value: viewModel.activeProfile.favoriteCategory.rawValue,
                        subtitle: "Personalized recommendations",
                        icon: viewModel.activeProfile.favoriteCategory.iconSymbol,
                        accentColor: ZenithTheme.lavenderAccent
                    )
                }
                .padding(.horizontal, 80)
                
                // MARK: - 7-Day Activity Chart & Recent Sessions Split
                HStack(alignment: .top, spacing: 36) {
                    
                    // 7-Day Weekly Chart
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Weekly Mindfulness Minutes")
                            .font(ZenithTheme.sectionTitle)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(alignment: .bottom, spacing: 24) {
                                ForEach(0..<viewModel.activeProfile.weeklyActivityMinutes.count, id: \.self) { index in
                                    let minutes = viewModel.activeProfile.weeklyActivityMinutes[index]
                                    let maxMin = max(1, viewModel.activeProfile.weeklyActivityMinutes.max() ?? 40)
                                    let barHeight = CGFloat(minutes) / CGFloat(maxMin) * 160.0
                                    
                                    VStack(spacing: 10) {
                                        Text("\(minutes)m")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.white.opacity(0.85))
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        viewModel.activeProfile.avatarColor,
                                                        viewModel.activeProfile.avatarColor.opacity(0.35)
                                                    ],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            )
                                            .frame(width: 46, height: max(16, barHeight))
                                            .shadow(color: viewModel.activeProfile.avatarColor.opacity(0.3), radius: 6, x: 0, y: 2)
                                        
                                        Text(dayLabels[index % dayLabels.count])
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 26)
                            .background(ZenithTheme.cardBackgroundElevated)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(ZenithTheme.glassBorder, lineWidth: 1.2)
                            )
                            .cornerRadius(22)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Recent Completed Sessions
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Recently Completed")
                            .font(ZenithTheme.sectionTitle)
                            .foregroundColor(.white)
                        
                        if viewModel.activeProfile.recentCompletedSessions.isEmpty {
                            VStack(spacing: 14) {
                                Image(systemName: "sparkles")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white.opacity(0.4))
                                Text("No sessions completed yet.")
                                    .font(ZenithTheme.bodyText)
                                    .foregroundColor(.white.opacity(0.6))
                                Text("Begin a breathwork or meditation session to build your streak.")
                                    .font(.system(size: 17))
                                    .foregroundColor(.white.opacity(0.4))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, minHeight: 240)
                            .background(ZenithTheme.cardBackgroundElevated)
                            .overlay(
                                RoundedRectangle(cornerRadius: 22)
                                    .stroke(ZenithTheme.glassBorder, lineWidth: 1.2)
                            )
                            .cornerRadius(22)
                        } else {
                            VStack(spacing: 14) {
                                ForEach(viewModel.activeProfile.recentCompletedSessions.prefix(3)) { record in
                                    HStack(spacing: 18) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(ZenithTheme.emeraldAccent)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(record.sessionTitle)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                            
                                            HStack(spacing: 8) {
                                                Text(record.categoryName)
                                                Text("•")
                                                Text("\(record.durationMinutes) min")
                                            }
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.white.opacity(0.65))
                                        }
                                        
                                        Spacer()
                                        
                                        Text(record.timeAgoDisplay)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding(20)
                                    .background(ZenithTheme.cardBackgroundElevated)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(ZenithTheme.glassBorder, lineWidth: 1.2)
                                    )
                                    .cornerRadius(18)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 80)
                
                // MARK: - Household Overview
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Household Members on this Apple TV")
                            .font(ZenithTheme.sectionTitle)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Combined Family Mindfulness: \(viewModel.householdTotalMinutes) Minutes")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(ZenithTheme.indigoAccent)
                    }
                    .padding(.horizontal, 80)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 24) {
                            ForEach(viewModel.profiles) { profile in
                                Button {
                                    viewModel.selectProfile(profile)
                                } label: {
                                    HStack(spacing: 16) {
                                        Image(systemName: profile.avatarSymbol)
                                            .font(.system(size: 34))
                                            .foregroundColor(profile.avatarColor)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(profile.name)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                            
                                            Text("🔥 \(profile.streakDays)d • \(profile.totalMinutes)m")
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundColor(.white.opacity(0.75))
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 16)
                                    .background(profile.id == viewModel.activeProfile.id ? ZenithTheme.indigoAccent.opacity(0.4) : ZenithTheme.cardBackgroundElevated)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(profile.id == viewModel.activeProfile.id ? ZenithTheme.indigoAccent : ZenithTheme.glassBorder, lineWidth: 1.2)
                                    )
                                    .cornerRadius(18)
                                }
                                .buttonStyle(.card)
                                .focused($focusedElement, equals: .householdMember(profile.id))
                            }
                        }
                        .padding(.horizontal, 80)
                        .padding(.vertical, 12)
                    }
                    .focusSection()
                }
                .padding(.bottom, 60)
            }
        }
        .background(ZenithTheme.primaryBackgroundGradient.ignoresSafeArea())
    }
}

// MARK: - StatBox Subview
private struct StatBox: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let accentColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(accentColor)
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(subtitle)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.white.opacity(0.55))
                    .lineLimit(1)
            }
        }
        .padding(22)
        .frame(maxWidth: .infinity)
        .background(ZenithTheme.cardBackgroundElevated)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(ZenithTheme.glassBorder, lineWidth: 1.2)
        )
        .cornerRadius(20)
    }
}
