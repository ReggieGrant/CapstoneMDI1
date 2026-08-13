//
//  HomeView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct HomeView: View {
    // @StateObject creates and owns the ViewModel
    // the context dict fresh each time home() is called
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // ---- Hero Section  ----
                heroSection
                
                // ---- Error Message ----
                if let error = viewModel.errorMessage {
                    errorBanner(message: error)
                }
                
                // ---- Weather Widget ----
                if let weather = viewModel.weather {
                    WeatherWidgetView(weather: weather)
                        .padding(.horizontal)
                } else if viewModel.isLoading {
                    loadingView
                }
                
                // ---- 7-Day Forecast ----
                if !viewModel.forecast.isEmpty {
                    ForecastView(forecast: viewModel.forecast)
                }
                
                // ---- Trending Moments Preview ----
                trendingMomentsSection
                
            }
            .padding(.bottom, 40)
        }
        .background(Color(hex: "f8f9fa"))
        .task {
            // Equivalent to Django running home() when the page loads
            await viewModel.loadWeather()
        }
        .refreshable {
            // Pull-to-refresh, like your "refresh every 10 minutes" JS
            await viewModel.loadWeather()
        }
    }
    
    // MARK: - Hero Section
    
    private var heroSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            
            VStack(spacing: 20) {
                Text("Clearview")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Weather through the eyes of the world")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.95))
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search any location...", text: $viewModel.searchQuery)
                        .onSubmit {
                            Task { await viewModel.searchLocation() }
                        }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(50)
                .shadow(radius: 10)
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 50)
        }
    }
    
    // MARK: - Error Banner
    
    private func errorBanner(message: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title)
                .foregroundColor(.orange)
            Text("Weather Data Unavailable")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(hex: "fff3cd"))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading weather data...")
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color.white)
        .cornerRadius(25)
        .padding(.horizontal)
    }
    
    // MARK: - Trending Moments Preview
    // Equivalent to <section class="community-section">
    private var trendingMomentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Trending Weather Moments")
                    .font(.title2.bold())
                Spacer()
                NavigationLink(destination: ExploreView()) {
                    HStack(spacing: 4) {
                        Text("See All")
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(Color(hex: "667eea"))
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(WeatherType.allCases.prefix(4), id: \.self) { type in
                        MomentPreviewCard(weatherType: type)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// Small preview card used on Home - simplified version of the Explore moment card
struct MomentPreviewCard: View {
    let weatherType: WeatherType
    
    var body: some View {
        ZStack {
            LinearGradient(colors: weatherType.gradientColors,
                            startPoint: .topLeading, endPoint: .bottomTrailing)
            Image(systemName: weatherType.icon)
                .font(.system(size: 50))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(width: 160, height: 160)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}
#Preview {
    HomeView()
}
