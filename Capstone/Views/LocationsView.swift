//
//  LocationsView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//
import SwiftUI

struct LocationsView: View {
    // Mirrors the 3 saved-location cards + "Add Location" card
    
    @State private var savedLocations = [
        SavedLocation(name: "Los Angeles", icon: "sun.max.fill", temp: 78, condition: "Clear Sky"),
        SavedLocation(name: "New York", icon: "cloud.fill", temp: 64, condition: "Overcast"),
        SavedLocation(name: "Miami", icon: "cloud.sun.fill", temp: 82, condition: "Partly Cloudy")
    ]
    @State private var showAddLocationAlert = false
    @State private var newLocationName = ""
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(savedLocations) { location in
                    LocationCard(location: location)
                }
                
                // "+" card, equivalent to .add-location
                Button {
                    showAddLocationAlert = true
                } label: {
                    VStack(spacing: 10) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 36))
                        Text("Add Location")
                            .font(.subheadline.bold())
                    }
                    .foregroundColor(Color(hex: "667eea"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 140)
                    .background(Color(hex: "667eea").opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color(hex: "667eea"), style: StrokeStyle(lineWidth: 2, dash: [6]))
                    )
                    .cornerRadius(20)
                }
            }
            .padding()
        }
        .background(Color(hex: "f8f9fa"))
        .navigationTitle("Locations")
        .alert("Add Location", isPresented: $showAddLocationAlert) {
            TextField("City name", text: $newLocationName)
            Button("Add") {
                guard !newLocationName.isEmpty else { return }
                savedLocations.append(SavedLocation(name: newLocationName, icon: "cloud.fill", temp: 0, condition: "Loading..."))
                newLocationName = ""
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

struct SavedLocation: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let temp: Int
    let condition: String
}

struct LocationCard: View {
    let location: SavedLocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(location.name)
                    .font(.headline)
                    .foregroundColor(Color(hex: "2c3e50"))
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            HStack(spacing: 10) {
                Image(systemName: location.icon)
                    .font(.system(size: 32))
                    .foregroundColor(Color(hex: "667eea"))
                Text("\(location.temp)°F")
                    .font(.title2.bold())
                    .foregroundColor(Color(hex: "2c3e50"))
            }
            
            Text(location.condition)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.06), radius: 10, y: 5)
    }
}
