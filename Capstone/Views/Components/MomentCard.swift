//
//  MomentCard.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct MomentCard: View {
    let moment: MomentModel
    @ObservedObject var viewModel: ExploreViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // ---- Gradient background (equivalent to .gradient-overlay) ----
            LinearGradient(colors: moment.weatherType.gradientColors,
                            startPoint: .topLeading, endPoint: .bottomTrailing)
            
            // ---- Large background icon (equivalent to .weather-icon-bg) ----
            Image(systemName: moment.weatherType.icon)
                .font(.system(size: 90))
                .foregroundColor(.white.opacity(0.15))
            
            // ---- Content overlay (equivalent to .moment-content) ----
            VStack(alignment: .leading, spacing: 10) {
                
                // User row
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 32, height: 32)
                        .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(moment.username)
                            .font(.caption.bold())
                            .foregroundColor(.white)
                        Text(moment.postedAt)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                
                // Badges (equivalent to .weather-badge / .location-badge)
                HStack(spacing: 6) {
                    Label("\(moment.temperature)°F", systemImage: moment.weatherType.icon)
                    Label(moment.location, systemImage: "mappin")
                }
                .font(.caption2.bold())
                .foregroundColor(.white)
                .lineLimit(1)
                
                // Caption
                Text(moment.caption)
                    .font(.caption)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                // Stats row (equivalent to .moment-stats)
                HStack(spacing: 14) {
                    Button {
                        viewModel.toggleLike(for: moment)
                    } label: {
                        Label("\(moment.likes)", systemImage: moment.isLiked ? "heart.fill" : "heart")
                            .foregroundColor(moment.isLiked ? .red : .white)
                    }
                    
                    Label("\(moment.comments)", systemImage: "bubble.right")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        viewModel.toggleBookmark(for: moment)
                    } label: {
                        Image(systemName: moment.isBookmarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(.white)
                    }
                }
                .font(.caption)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(colors: [.black.opacity(0.75), .clear],
                               startPoint: .bottom, endPoint: .top)
            )
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.12), radius: 10, y: 5)
    }
}
