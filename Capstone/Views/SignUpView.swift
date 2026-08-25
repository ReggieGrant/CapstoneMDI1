//
//  SignUpView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/19/26.
//

import SwiftUI
import SwiftData

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.modelContext) private var modelContext   // <- NEW
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                VStack(spacing: 8) {
                    Text("Create Account")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "2c3e50"))
                    Text("Join the Clearview community")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 30)
                
                if let error = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(error)
                    }
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                VStack(spacing: 16) {
                    AuthTextField(
                        icon: "person",
                        placeholder: "Username",
                        text: $viewModel.username
                    )
                    
                    AuthTextField(
                        icon: "envelope",
                        placeholder: "Email address",
                        text: $viewModel.email,
                        keyboardType: .emailAddress
                    )
                    
                    AuthSecureField(
                        placeholder: "Password",
                        text: $viewModel.password,
                        isVisible: $isPasswordVisible
                    )
                    
                    AuthSecureField(
                        placeholder: "Confirm Password",
                        text: $viewModel.confirmPassword,
                        isVisible: $isConfirmPasswordVisible
                    )
                    
                    Text("Password must be at least 8 characters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                Button {
                    viewModel.signUp(context: modelContext)   // <- CHANGED: no longer async, passes modelContext
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Create Account")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(color: Color(hex: "667eea").opacity(0.3), radius: 15, y: 8)
                }
                .disabled(viewModel.isLoading)
                .padding(.horizontal)
                
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundColor(.secondary)
                    Button("Log In") {
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "667eea"))
                }
                .font(.subheadline)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "f8f9fa"))
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $viewModel.isAuthenticated) {
            if let user = viewModel.currentUser {
                ContentView(loggedInUser: user)
            }
        }
    }
}
