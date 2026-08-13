//
//  ExploreViewModel.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import Foundation
internal import Combine

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var moments: [MomentModel] = []
    @Published var selectedWeatherFilter: WeatherType? = nil
    @Published var selectedTab: FeedTab = .all
    
    enum FeedTab: String, CaseIterable {
        case all = "All", trending = "Trending", recent = "Recent", featured = "Featured"
    }
    
    // Filtered results computed property - like your JS filter logic
    var filteredMoments: [MomentModel] {
        moments.filter { moment in
            selectedWeatherFilter == nil || moment.weatherType == selectedWeatherFilter
        }
    }
    
    init() {
        loadMockMoments() // Replace with real API call to your backend
    }
    
    func toggleLike(for moment: MomentModel) {
        guard let index = moments.firstIndex(where: { $0.id == moment.id }) else { return }
        moments[index].isLiked.toggle()
        moments[index].likes += moments[index].isLiked ? 1 : -1
    }
    
    func toggleBookmark(for moment: MomentModel) {
        guard let index = moments.firstIndex(where: { $0.id == moment.id }) else { return }
        moments[index].isBookmarked.toggle()
    }
    
    private func loadMockMoments() {
        moments = [
            MomentModel(username: "@sarah_travels", avatarURL: "", imageURL: "",
                        location: "Malibu, CA", temperature: 78, weatherType: .sunny,
                        caption: "Perfect beach day! ☀️🌊", postedAt: "2h ago",
                        likes: 1200, comments: 89),
            MomentModel(username: "@rainylover", avatarURL: "", imageURL: "",
                        location: "Seattle, WA", temperature: 55, weatherType: .rainy,
                        caption: "Cozy rainy afternoon ☕🌧️", postedAt: "5h ago",
                        likes: 856, comments: 34)
        ]
    }
}
