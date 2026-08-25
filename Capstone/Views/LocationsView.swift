//
//  LocationsView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//
import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct LocationsView: View {
    @Query(sort: \SavedLocationRecord.createdAt, order: .reverse)
    private var savedLocations: [SavedLocationRecord]
    
    @Environment(\.modelContext) private var modelContext
    @State private var showAddLocationAlert = false
    @State private var newLocationName = ""
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            if savedLocations.isEmpty {
                emptyState
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(savedLocations) { location in
                        LocationCard(location: location)
                            .contextMenu {
                                Button(role: .destructive) {
                                    deleteLocation(location)
                                } label: {
                                    Label("Remove", systemImage: "trash")
                                }
                            }
                    }
                    addLocationCard
                }
                .padding()
            }
        }
        .background(Color(hex: "f8f9fa"))
        .navigationTitle("Locations")
        .alert("Add Location", isPresented: $showAddLocationAlert) {
            TextField("City name", text: $newLocationName)
            Button("Add") { addLocation() }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "mappin.slash")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            Text("No saved locations yet")
                .font(.headline)
            Text("Tap the + below to add your first city")
                .font(.subheadline)
                .foregroundColor(.secondary)
            addLocationCard
                .frame(width: 160)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
    
    private var addLocationCard: some View {
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
    
    private func addLocation() {
        guard !newLocationName.isEmpty else { return }
        let newLocation = SavedLocationRecord(name: newLocationName)
        modelContext.insert(newLocation)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save location: \(error)")
        }
        newLocationName = ""
    }
    
    private func deleteLocation(_ location: SavedLocationRecord) {
        modelContext.delete(location)
        try? modelContext.save()
    }
}

struct LocationCard: View {
    let location: SavedLocationRecord
    
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
                Text("\(location.temperature)°F")
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
