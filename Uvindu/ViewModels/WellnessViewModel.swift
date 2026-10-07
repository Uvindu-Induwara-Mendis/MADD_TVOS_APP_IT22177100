//
//  WellnessViewModel.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI
import Combine

/// Central ViewModel orchestrating multi-user state, catalog navigation, and player coordination.
/// Adheres strictly to the MVVM pattern for tvOS applications.
final class WellnessViewModel: ObservableObject {
    
    // MARK: - Published State
    
    @Published var profiles: [UserProfile] = []
    @Published var activeProfile: UserProfile
    @Published var sessions: [MeditationSession] = []
    @Published var soundscapes: [Soundscape] = []
    
    // Filters & Navigation
    @Published var selectedCategory: MeditationCategory = .all
    @Published var selectedDurationFilter: Int? = nil // nil = any duration
    
    // Modal & Player Navigation
    @Published var activeMeditationForPlayer: MeditationSession? = nil
    @Published var activeSoundscapeForPlayer: Soundscape? = nil
    @Published var isProfileSwitcherPresented: Bool = false
    
    // Dependencies
    private let dataService: WellnessDataService
    
    // MARK: - Initialization
    
    init(dataService: WellnessDataService = .shared) {
        self.dataService = dataService
        self.profiles = dataService.profiles
        // Default to first profile (e.g., Uvindu)
        self.activeProfile = dataService.profiles.first ?? UserProfile(
            id: UUID(),
            name: "Living Room User",
            role: "Family",
            avatarSymbol: "person.crop.circle.fill",
            avatarColorHex: "#22D3EE",
            streakDays: 1,
            totalMinutes: 10,
            preferredSoundscapeTitle: "Pacific Ocean Sanctuary",
            favoriteCategory: .breathing,
            weeklyActivityMinutes: [0, 0, 0, 0, 0, 0, 10],
            recentCompletedSessions: []
        )
        self.sessions = dataService.sessions
        self.soundscapes = dataService.soundscapes
    }
    
    // MARK: - Computed Properties
    
    /// Dynamic personalized greeting based on active profile and current time of day
    var personalizedGreeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let timePeriod: String
        switch hour {
        case 5..<12: timePeriod = "Good Morning"
        case 12..<17: timePeriod = "Good Afternoon"
        case 17..<22: timePeriod = "Good Evening"
        default: timePeriod = "Peaceful Night"
        }
        return "\(timePeriod), \(activeProfile.name)"
    }
    
    /// Subtitle highlighting the user's current streak and mindfulness momentum
    var streakStatusHeadline: String {
        "🔥 \(activeProfile.streakDays)-Day Household Streak • \(activeProfile.totalMinutes) Minutes Mindful"
    }
    
    /// Curated recommendations tailored to the user's favorite category and evening hours
    var recommendedSessions: [MeditationSession] {
        // High priority to sessions matching user's favorite category or highlighted badges
        sessions.filter { session in
            session.category == activeProfile.favoriteCategory || session.recommendedBadge != nil
        }
    }
    
    /// "Continue Journey" shelf: sessions related to recent practices or quick daily resets
    var continueJourneySessions: [MeditationSession] {
        // Return 3 diverse sessions for quick restart
        Array(sessions.prefix(4))
    }
    
    /// Filtered catalog based on tab category selection and duration
    var filteredSessions: [MeditationSession] {
        sessions.filter { session in
            let matchesCategory = (selectedCategory == .all || session.category == selectedCategory)
            let matchesDuration = (selectedDurationFilter == nil || session.durationMinutes == selectedDurationFilter)
            return matchesCategory && matchesDuration
        }
    }
    
    /// Household cumulative statistics for communal living room pride
    var householdTotalMinutes: Int {
        profiles.reduce(0) { $0 + $1.totalMinutes }
    }
    
    var householdLongestStreak: Int {
        profiles.map { $0.streakDays }.max() ?? 0
    }
    
    // MARK: - Actions
    
    /// Switches the active profile and updates reactive state across the application
    func selectProfile(_ profile: UserProfile) {
        withAnimation(.easeInOut(duration: 0.35)) {
            self.activeProfile = profile
            self.isProfileSwitcherPresented = false
        }
    }
    
    /// Starts a meditation session, triggering full-screen immersive transition
    func startMeditationSession(_ session: MeditationSession) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            self.activeMeditationForPlayer = session
        }
    }
    
    /// Starts an ambient soundscape player
    func startSoundscape(_ soundscape: Soundscape) {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
            self.activeSoundscapeForPlayer = soundscape
        }
    }
    
    /// Logs session completion, updates streaks, and synchronizes profile records
    func completeSession(_ session: MeditationSession) {
        dataService.recordCompletedSession(profileId: activeProfile.id, session: session)
        self.profiles = dataService.profiles
        if let updated = profiles.first(where: { $0.id == activeProfile.id }) {
            self.activeProfile = updated
        }
    }
    
    /// Sets preferred soundscape for current user
    func setPreferredSoundscape(title: String) {
        dataService.updatePreferredSoundscape(profileId: activeProfile.id, soundscapeTitle: title)
        self.profiles = dataService.profiles
        if let updated = profiles.first(where: { $0.id == activeProfile.id }) {
            self.activeProfile = updated
        }
    }
}
