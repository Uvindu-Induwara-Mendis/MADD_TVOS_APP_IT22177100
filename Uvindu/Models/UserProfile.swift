//
//  UserProfile.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Log entry recording when a user finishes a meditation or breathing cycle on the Apple TV.
struct CompletedSessionRecord: Identifiable, Hashable {
    let id: UUID
    let sessionTitle: String
    let categoryName: String
    let completedDate: Date
    let durationMinutes: Int
    
    var timeAgoDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: completedDate, relativeTo: Date())
    }
}

/// Represents an individual household member on the shared Apple TV.
/// Enables personalization of streaks, sound preferences, and history per user.
struct UserProfile: Identifiable, Hashable {
    let id: UUID
    var name: String
    var role: String
    var avatarSymbol: String
    var avatarColorHex: String
    var streakDays: Int
    var totalMinutes: Int
    var preferredSoundscapeTitle: String
    var favoriteCategory: MeditationCategory
    /// 7-day historical mindfulness minutes [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
    var weeklyActivityMinutes: [Int]
    var recentCompletedSessions: [CompletedSessionRecord]
    
    var avatarColor: Color {
        Color(hex: avatarColorHex)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
        lhs.id == rhs.id
    }
}
