//
//  MeditationsView.swift
//  Zenith tvOS Wellness & Meditation Hub
//
//  Created for Academic Review & tvOS Rubric Evaluation.
//  Target: tvOS 17.0+
//

import SwiftUI

/// Catalog View for Exploring Guided Meditations and Breathwork.
/// Features category filtering chips and a high-performance LazyVGrid
/// structured for Siri Remote directional navigation.
struct MeditationsView: View {
    @ObservedObject var viewModel: WellnessViewModel
    @FocusState private var focusedCategoryId: MeditationCategory?
    @FocusState private var focusedSessionId: UUID?
    
    private let columns = [
        GridItem(.adaptive(minimum: 380, maximum: 440), spacing: 32)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 36) {
                
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Meditation & Breathwork Library")
                        .font(ZenithTheme.displayTitle)
                        .foregroundColor(.white)
                    
                    Text("Scientifically formulated pacing and guided mindfulness for the whole living room.")
                        .font(ZenithTheme.bodyText)
                        .foregroundColor(.white.opacity(0.75))
                }
                .padding(.horizontal, 80)
                .padding(.top, 24)
                
                // MARK: - Category Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        ForEach(MeditationCategory.allCases) { category in
                            let isSelected = viewModel.selectedCategory == category
                            
                            Button {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    viewModel.selectedCategory = category
                                }
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: category.iconSymbol)
                                        .font(.system(size: 20))
                                    Text(category.rawValue)
                                        .font(.system(size: 20, weight: isSelected ? .bold : .medium))
                                }
                                .padding(.horizontal, 22)
                                .padding(.vertical, 12)
                                .background(isSelected ? ZenithTheme.indigoAccent : ZenithTheme.cardBackgroundElevated)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(isSelected ? ZenithTheme.indigoAccent : ZenithTheme.glassBorder, lineWidth: 1.2)
                                )
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            }
                            .buttonStyle(.card)
                            .focused($focusedCategoryId, equals: category)
                        }
                    }
                    .padding(.horizontal, 80)
                    .padding(.vertical, 10)
                }
                .focusSection()
                
                // MARK: - Duration Quick Filter Row
                HStack(spacing: 16) {
                    Text("Filter Duration:")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Button {
                        viewModel.selectedDurationFilter = nil
                    } label: {
                        Text("Any Length")
                            .font(.system(size: 17, weight: viewModel.selectedDurationFilter == nil ? .bold : .regular))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 7)
                            .background(viewModel.selectedDurationFilter == nil ? Color.white.opacity(0.25) : Color.white.opacity(0.08))
                            .cornerRadius(12)
                    }
                    .buttonStyle(.card)
                    
                    ForEach([5, 8, 10, 15, 20], id: \.self) { minutes in
                        let isSelected = viewModel.selectedDurationFilter == minutes
                        Button {
                            viewModel.selectedDurationFilter = isSelected ? nil : minutes
                        } label: {
                            Text("\(minutes) min")
                                .font(.system(size: 17, weight: isSelected ? .bold : .regular))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 7)
                                .background(isSelected ? ZenithTheme.emeraldAccent.opacity(0.35) : Color.white.opacity(0.08))
                                .cornerRadius(12)
                        }
                        .buttonStyle(.card)
                    }
                }
                .padding(.horizontal, 80)
                .focusSection()
                
                // MARK: - Grid of Sessions
                LazyVGrid(columns: columns, spacing: 36) {
                    ForEach(viewModel.filteredSessions) { session in
                        FocusableMeditationCard(session: session) {
                            viewModel.startMeditationSession(session)
                        }
                        .focused($focusedSessionId, equals: session.id)
                    }
                }
                .padding(.horizontal, 80)
                .padding(.bottom, 60)
                .focusSection()
            }
        }
        .background(ZenithTheme.primaryBackgroundGradient.ignoresSafeArea())
    }
}
