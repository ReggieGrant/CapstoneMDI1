//
//  ExploreView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct ExploreView: View {
    // Owns the moments data + filter state, like your explore.js
    // currentFilter / currentWeather variables
    @StateObject private var viewModel = ExploreViewModel()
    
    // Two-column grid
    // grid-template-columns: repeat(auto-fill, minmax(320px, 1fr))
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                header
                
                filterTabs
                
                weatherChips
                
                resultsCount
                
                // ---- Moments Grid (equivalent to .moments-masonry) ----
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.filteredMoments) { moment in
                        MomentCard(moment: moment, viewModel: viewModel)
                    }
                }
                .padding(.horizontal)
                
                loadMoreButton
            }
            .padding(.bottom, 40)
        }
        .background(Color(hex: "f8f9fa"))
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Header (equivalent to .explore-header)
    private var header: some View {
        ZStack {
            LinearGradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                            startPoint: .topLeading, endPoint: .bottomTrailing)
            
            VStack(spacing: 8) {
                Text("Explore Weather Moments")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Text("Discover how the world experiences weather")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(.vertical, 30)
        }
    }
    
    // MARK: - Filter Tabs (equivalent to .filter-tabs)
    private var filterTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ExploreViewModel.FeedTab.allCases, id: \.self) { tab in
                    Button {
                        viewModel.selectedTab = tab
                    } label: {
                        Text(tab.rawValue)
                            .font(.subheadline.bold())
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                viewModel.selectedTab == tab
                                    ? AnyView(LinearGradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")], startPoint: .leading, endPoint: .trailing))
                                    : AnyView(Color.white)
                            )
                            .foregroundColor(viewModel.selectedTab == tab ? .white : Color(hex: "667eea"))
                            .clipShape(Capsule())
                            .shadow(color: .black.opacity(0.06), radius: 5)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Weather Chips (equivalent to .weather-filters)
    private var weatherChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                chipButton(label: "All Weather", isSelected: viewModel.selectedWeatherFilter == nil) {
                    viewModel.selectedWeatherFilter = nil
                }
                ForEach(WeatherType.allCases, id: \.self) { type in
                    chipButton(
                        label: type.rawValue.capitalized,
                        icon: type.icon,
                        isSelected: viewModel.selectedWeatherFilter == type
                    ) {
                        viewModel.selectedWeatherFilter = type
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func chipButton(label: String, icon: String? = nil, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon { Image(systemName: icon) }
                Text(label)
            }
            .font(.caption.bold())
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color(hex: "667eea") : Color.white)
            .foregroundColor(isSelected ? .white : Color(hex: "667eea"))
            .clipShape(Capsule())
        }
    }
    
    // MARK: - Results Count (equivalent to .results-count)
    private var resultsCount: some View {
        Text("Showing \(viewModel.filteredMoments.count) moment\(viewModel.filteredMoments.count == 1 ? "" : "s")")
            .font(.subheadline)
            .foregroundColor(.secondary)
    }
    
    // MARK: - Load More Button
    private var loadMoreButton: some View {
        Button(action: {}) {
            Label("Load More Moments", systemImage: "arrow.down")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .clipShape(Capsule())
                .shadow(color: Color(hex: "667eea").opacity(0.3), radius: 15, y: 8)
        }
        .padding(.top, 8)
    }
}
