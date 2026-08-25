//
//  ProfileView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/19/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogoutConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .frame(width: 90, height: 90)
                        Text(String(authViewModel.currentUser?.username.prefix(1) ?? "?").uppercased())
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Text(authViewModel.currentUser?.username ?? "Unknown")
                        .font(.title2.bold())
                        .foregroundColor(Color(hex: "2c3e50"))
                    Text(authViewModel.currentUser?.email ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 30)
                
                VStack(alignment: .leading, spacing: 0) {
                    profileRow(icon: "calendar", label: "Member Since",
                               value: authViewModel.currentUser?.createdAt.formatted(date: .abbreviated, time: .omitted) ?? "—")
                    Divider().padding(.leading, 52)
                    profileRow(icon: "mappin.and.ellipse", label: "Saved Locations",
                               value: "\(authViewModel.currentUser?.savedLocations.count ?? 0)")
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(.horizontal)
                
                Button {
                    showLogoutConfirmation = true
                } label: {
                    Label("Log Out", systemImage: "arrow.right.square")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .background(Color(hex: "f8f9fa"))
        .navigationTitle("Profile")
        .confirmationDialog("Are you sure you want to log out?",
                             isPresented: $showLogoutConfirmation,
                             titleVisibility: .visible) {
            Button("Log Out", role: .destructive) {
                authViewModel.logout()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private func profileRow(icon: String, label: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "667eea"))
                .frame(width: 24)
            Text(label)
                .foregroundColor(Color(hex: "2c3e50"))
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
