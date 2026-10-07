//
//  WellnessDataService.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import Foundation
import SwiftUI

/// Mocked reactive data service providing seed data and state management for tvOS multi-user profiles.
/// Adheres to MVVM separation of concerns and simulates household data persistence.
final class WellnessDataService {
    static let shared = WellnessDataService()
    
    // MARK: - In-Memory State
    
    private(set) var profiles: [UserProfile] = []
    private(set) var sessions: [MeditationSession] = []
    private(set) var soundscapes: [Soundscape] = []
    
    init() {
        seedProfiles()
        seedSessions()
        seedSoundscapes()
    }
    
    // MARK: - Household Profile Seeding
    
    private func seedProfiles() {
        let calendar = Calendar.current
        let today = Date()
        
        let uvinduSessions = [
            CompletedSessionRecord(
                id: UUID(),
                sessionTitle: "Box Breathing for Stress",
                categoryName: "Breathwork",
                completedDate: calendar.date(byAdding: .hour, value: -3, to: today) ?? today,
                durationMinutes: 5
            ),
            CompletedSessionRecord(
                id: UUID(),
                sessionTitle: "Morning Clarity & Awakening",
                categoryName: "Mindful Morning",
                completedDate: calendar.date(byAdding: .day, value: -1, to: today) ?? today,
                durationMinutes: 10
            ),
            CompletedSessionRecord(
                id: UUID(),
                sessionTitle: "Deep Work Flow & Grounding",
                categoryName: "Focus & Flow",
                completedDate: calendar.date(byAdding: .day, value: -2, to: today) ?? today,
                durationMinutes: 15
            )
        ]
        
        let sarahSessions = [
            CompletedSessionRecord(
                id: UUID(),
                sessionTitle: "Evening Reset & Sleep Drift",
                categoryName: "Deep Sleep",
                completedDate: calendar.date(byAdding: .hour, value: -18, to: today) ?? today,
                durationMinutes: 10
            ),
            CompletedSessionRecord(
                id: UUID(),
                sessionTitle: "Restorative Body Scan",
                categoryName: "Deep Sleep",
                completedDate: calendar.date(byAdding: .day, value: -1, to: today) ?? today,
                durationMinutes: 20
            )
        ]
        
        let leoSessions = [
            CompletedSessionRecord(
                id: UUID(),
                sessionTitle: "Living Room Family Coherence",
                categoryName: "Family Calm",
                completedDate: calendar.date(byAdding: .day, value: -1, to: today) ?? today,
                durationMinutes: 8
            )
        ]
        
        self.profiles = [
            UserProfile(
                id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
                name: "Uvindu",
                role: "Primary User",
                avatarSymbol: "person.crop.circle.fill",
                avatarColorHex: "#22D3EE", // Cyan
                streakDays: 14,
                totalMinutes: 285,
                preferredSoundscapeTitle: "Pacific Ocean Sanctuary",
                favoriteCategory: .breathing,
                weeklyActivityMinutes: [20, 15, 25, 10, 30, 20, 15],
                recentCompletedSessions: uvinduSessions
            ),
            UserProfile(
                id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
                name: "Sarah",
                role: "Partner",
                avatarSymbol: "leaf.circle.fill",
                avatarColorHex: "#34D399", // Emerald
                streakDays: 21,
                totalMinutes: 440,
                preferredSoundscapeTitle: "Rainstorm on Cedar Roof",
                favoriteCategory: .sleep,
                weeklyActivityMinutes: [30, 25, 30, 40, 20, 35, 30],
                recentCompletedSessions: sarahSessions
            ),
            UserProfile(
                id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
                name: "Leo",
                role: "Teen",
                avatarSymbol: "sparkles",
                avatarColorHex: "#A78BFA", // Lavender
                streakDays: 6,
                totalMinutes: 120,
                preferredSoundscapeTitle: "Celestial Drift",
                favoriteCategory: .focus,
                weeklyActivityMinutes: [10, 15, 0, 15, 20, 10, 10],
                recentCompletedSessions: leoSessions
            ),
            UserProfile(
                id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
                name: "Living Room Guest",
                role: "Guest",
                avatarSymbol: "heart.circle.fill",
                avatarColorHex: "#F59E0B", // Amber
                streakDays: 1,
                totalMinutes: 15,
                preferredSoundscapeTitle: "Alpine Mountain Hearth",
                favoriteCategory: .family,
                weeklyActivityMinutes: [0, 0, 0, 0, 0, 0, 15],
                recentCompletedSessions: []
            )
        ]
    }
    
    // MARK: - Meditation Library Seeding
    
    private func seedSessions() {
        self.sessions = [
            MeditationSession(
                id: UUID(uuidString: "A1111111-0000-0000-0000-000000000001")!,
                title: "Box Breathing for Stress",
                subtitle: "Equal-ratio regulation for rapid cortisol reduction",
                durationMinutes: 5,
                category: .breathing,
                sessionDescription: "Experience Navy SEAL tactical regulation designed to ground the nervous system. The equal 4-second ratio balances sympathetic and parasympathetic activity, clearing mental fatigue directly from your living room.",
                instructor: "Elena Rostova",
                breathingPattern: .boxBreathing,
                recommendedBadge: "Recommended for You",
                iconSymbol: "wind",
                primaryAccentHex: "#10B981", // Emerald
                secondaryAccentHex: "#065F46",
                sessionPlayCount: 1420
            ),
            MeditationSession(
                id: UUID(uuidString: "A1111111-0000-0000-0000-000000000002")!,
                title: "Evening Reset & Sleep Drift",
                subtitle: "Slow 4-7-8 breathing to prepare body and mind for restorative sleep",
                durationMinutes: 10,
                category: .sleep,
                sessionDescription: "Dim the ambient lights and sink into deep physical release. Extended exhales stimulate the vagus nerve, dropping heart rate and quieting evening chatter.",
                instructor: "Marcus Vance",
                breathingPattern: .relaxing478,
                recommendedBadge: "Popular Tonight",
                iconSymbol: "moon.stars.fill",
                primaryAccentHex: "#6366F1", // Indigo
                secondaryAccentHex: "#312E81",
                sessionPlayCount: 2890
            ),
            MeditationSession(
                id: UUID(uuidString: "A1111111-0000-0000-0000-000000000003")!,
                title: "Living Room Family Coherence",
                subtitle: "Synchronize breathing rhythms together as a household",
                durationMinutes: 8,
                category: .family,
                sessionDescription: "A shared mindfulness practice crafted specifically for family living rooms. Harmonious 5.5-second pacing allows multiple household members to synchronize heart rate variability together.",
                instructor: "Aria Chen",
                breathingPattern: .coherentHRV,
                recommendedBadge: "Household Favorite",
                iconSymbol: "person.3.sequence.fill",
                primaryAccentHex: "#EC4899", // Pink
                secondaryAccentHex: "#831843",
                sessionPlayCount: 950
            ),
            MeditationSession(
                id: UUID(uuidString: "A1111111-0000-0000-0000-000000000004")!,
                title: "Morning Clarity & Awakening",
                subtitle: "Revitalize oxygenation and focus for the day ahead",
                durationMinutes: 10,
                category: .morning,
                sessionDescription: "Awaken your physiology without caffeine jitters. Gentle expansive inhalations and rhythmic pacing flood the bloodstream with oxygen and sharpen neural clarity.",
                instructor: "Julian Hayes",
                breathingPattern: .coherentHRV,
                recommendedBadge: "Great for Morning",
                iconSymbol: "sun.horizon.fill",
                primaryAccentHex: "#F59E0B", // Amber
                secondaryAccentHex: "#78350F",
                sessionPlayCount: 1780
            ),
            MeditationSession(
                id: UUID(uuidString: "A1111111-0000-0000-0000-000000000005")!,
                title: "Deep Work Flow & Grounding",
                subtitle: "Tune out living room distractions and enter deep concentration",
                durationMinutes: 15,
                category: .focus,
                sessionDescription: "Anchor your attention with rhythmic box breathing and theta binaural undertones. Ideal before intensive creative sessions or academic study.",
                instructor: "Elena Rostova",
                breathingPattern: .boxBreathing,
                recommendedBadge: nil,
                iconSymbol: "bolt.shield.fill",
                primaryAccentHex: "#06B6D4", // Cyan
                secondaryAccentHex: "#164E63",
                sessionPlayCount: 890
            ),
            MeditationSession(
                id: UUID(uuidString: "A1111111-0000-0000-0000-000000000006")!,
                title: "Restorative Body Scan",
                subtitle: "Progressive physical decompression from head to toe",
                durationMinutes: 20,
                category: .sleep,
                sessionDescription: "Release muscular tension stored throughout the workday. A guided vocal scan accompanied by gentle wind-down breath cues.",
                instructor: "Marcus Vance",
                breathingPattern: .gentleWindDown,
                recommendedBadge: nil,
                iconSymbol: "bed.double.fill",
                primaryAccentHex: "#8B5CF6", // Purple
                secondaryAccentHex: "#4C1D95",
                sessionPlayCount: 2150
            ),
            MeditationSession(
                id: UUID(uuidString: "A1111111-0000-0000-0000-000000000007")!,
                title: "Anxiety Dissolving Release",
                subtitle: "Emergency nervous system unclenching for high-pressure days",
                durationMinutes: 7,
                category: .stress,
                sessionDescription: "Targeted physiological sighs and 4-7-8 breathing designed to interrupt spiral thoughts and trigger immediate muscular relaxation.",
                instructor: "Aria Chen",
                breathingPattern: .relaxing478,
                recommendedBadge: nil,
                iconSymbol: "heart.circle.fill",
                primaryAccentHex: "#EF4444", // Red
                secondaryAccentHex: "#7F1D1D",
                sessionPlayCount: 1320
            ),
            MeditationSession(
                id: UUID(uuidString: "A1111111-0000-0000-0000-000000000008")!,
                title: "Kids Bedtime Starlight Story",
                subtitle: "Imaginative bedtime wind-down for younger family members",
                durationMinutes: 8,
                category: .family,
                sessionDescription: "A gentle tale through a starlit forest that slows young breathing rates naturally, fostering calm sleep hygiene for children.",
                instructor: "Julian Hayes",
                breathingPattern: .gentleWindDown,
                recommendedBadge: "Kids & Family",
                iconSymbol: "sparkles",
                primaryAccentHex: "#10B981", // Emerald
                secondaryAccentHex: "#064E3B",
                sessionPlayCount: 740
            )
        ]
    }
    
    // MARK: - Soundscapes Seeding
    
    private func seedSoundscapes() {
        self.soundscapes = [
            Soundscape(
                id: UUID(uuidString: "B1111111-0000-0000-0000-000000000001")!,
                title: "Pacific Ocean Sanctuary",
                subtitle: "Rhythmic rolling surf recorded along Big Sur coast",
                visualizationType: .oceanWaves,
                iconSymbol: "water.waves",
                durationDescription: "Infinite Ambient Loop",
                frequencyText: "432 Hz Healing Harmony",
                primaryAccentHex: "#06B6D4",
                secondaryAccentHex: "#083344",
                descriptionText: "Immerse your living room with high-fidelity binaural recordings of rhythmic ocean breakers. Calibrates spatial acoustics for deep tranquility."
            ),
            Soundscape(
                id: UUID(uuidString: "B1111111-0000-0000-0000-000000000002")!,
                title: "Rainstorm on Cedar Roof",
                subtitle: "Gentle pacific northwest rainfall with distant thunder",
                visualizationType: .rainRipples,
                iconSymbol: "cloud.rain.fill",
                durationDescription: "Infinite Ambient Loop",
                frequencyText: "Pink Noise Spectrum",
                primaryAccentHex: "#3B82F6",
                secondaryAccentHex: "#1E3A8A",
                descriptionText: "Natural pink noise frequencies mask outdoor street noises and indoor commotion, ideal for bedtime or focused family work."
            ),
            Soundscape(
                id: UUID(uuidString: "B1111111-0000-0000-0000-000000000003")!,
                title: "Celestial Drift",
                subtitle: "Deep space ambient drone with subtle harmonic overtone chimes",
                visualizationType: .celestialOrb,
                iconSymbol: "sparkles",
                durationDescription: "Infinite Ambient Loop",
                frequencyText: "528 Hz Miraculous Tone",
                primaryAccentHex: "#8B5CF6",
                secondaryAccentHex: "#2E1065",
                descriptionText: "Ethereal synth pads and resonant crystalline overtones promote alpha brainwave induction and meditative stillness."
            ),
            Soundscape(
                id: UUID(uuidString: "B1111111-0000-0000-0000-000000000004")!,
                title: "Alpine Mountain Hearth",
                subtitle: "Cozy crackling birch wood embers in a stone cabin",
                visualizationType: .firesidePulse,
                iconSymbol: "flame.fill",
                durationDescription: "Infinite Ambient Loop",
                frequencyText: "Warm Acoustic Resonance",
                primaryAccentHex: "#F97316",
                secondaryAccentHex: "#7C2D12",
                descriptionText: "Warm timber crackling frequencies create an intimate, cozy atmosphere in the living room during evening wind-down rituals."
            ),
            Soundscape(
                id: UUID(uuidString: "B1111111-0000-0000-0000-000000000005")!,
                title: "Deep Pine Forest Breeze",
                subtitle: "Wind rustling through canopy needles with birdsong",
                visualizationType: .forestBreeze,
                iconSymbol: "leaf.fill",
                durationDescription: "Infinite Ambient Loop",
                frequencyText: "Natural Biophony",
                primaryAccentHex: "#10B981",
                secondaryAccentHex: "#064E3B",
                descriptionText: "Japanese Shinrin-yoku (forest bathing) sonic acoustics reduce heart rate and blood pressure by evoking primal natural environments."
            ),
            Soundscape(
                id: UUID(uuidString: "B1111111-0000-0000-0000-000000000006")!,
                title: "Tibetan Singing Bowls",
                subtitle: "Multi-layered bronze bowl harmonic oscillations",
                visualizationType: .binauralBeats,
                iconSymbol: "waveform.circle.fill",
                durationDescription: "Infinite Ambient Loop",
                frequencyText: "Theta Entrainment 6 Hz",
                primaryAccentHex: "#EAB308",
                secondaryAccentHex: "#713F12",
                descriptionText: "Ancient meditative bell resonances create constructive interference patterns that guide neural activity into deep meditative theta states."
            )
        ]
    }
    
    // MARK: - State Mutation
    
    /// Records a finished session for the given profile, incrementing streak and history
    func recordCompletedSession(profileId: UUID, session: MeditationSession) {
        guard let index = profiles.firstIndex(where: { $0.id == profileId }) else { return }
        
        let record = CompletedSessionRecord(
            id: UUID(),
            sessionTitle: session.title,
            categoryName: session.category.rawValue,
            completedDate: Date(),
            durationMinutes: session.durationMinutes
        )
        
        profiles[index].recentCompletedSessions.insert(record, at: 0)
        profiles[index].totalMinutes += session.durationMinutes
        profiles[index].streakDays += 1
        
        // Update today's weekly activity
        var weekly = profiles[index].weeklyActivityMinutes
        if !weekly.isEmpty {
            weekly[weekly.count - 1] += session.durationMinutes
            profiles[index].weeklyActivityMinutes = weekly
        }
    }
    
    /// Updates preferred soundscape for a profile
    func updatePreferredSoundscape(profileId: UUID, soundscapeTitle: String) {
        guard let index = profiles.firstIndex(where: { $0.id == profileId }) else { return }
        profiles[index].preferredSoundscapeTitle = soundscapeTitle
    }
}
