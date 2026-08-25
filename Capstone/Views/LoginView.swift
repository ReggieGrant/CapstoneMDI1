//
//  LoginView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI
import SwiftData

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var showSignUp = false
    @State private var isPasswordVisible = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(colors: [Color(hex: "667eea"), Color(hex: "764ba2")],
                                               startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .frame(width: 90, height: 90)
                        Image(systemName: "cloud.sun.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    Text("Clearview")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(Color(hex: "2c3e50"))
                    Text("Weather through the eyes of the world")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
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
                    AuthTextField(icon: "envelope", placeholder: "Email address",
                                  text: $viewModel.email, keyboardType: .emailAddress)
                    AuthSecureField(placeholder: "Password", text: $viewModel.password,
                                     isVisible: $isPasswordVisible)
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {}
                            .font(.footnote.bold())
                            .foregroundColor(Color(hex: "667eea"))
                    }
                }
                .padding(.horizontal)
                
                Button {
                    viewModel.login(context: modelContext)
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Log In").font(.headline)
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
                
                HStack {
                    Rectangle().frame(height: 1).foregroundColor(Color(.systemGray4))
                    Text("or").font(.footnote).foregroundColor(.secondary)
                    Rectangle().frame(height: 1).foregroundColor(Color(.systemGray4))
                }
                .padding(.horizontal)
                
                HStack(spacing: 4) {
                    Text("Don't have an account?").foregroundColor(.secondary)
                    Button("Sign Up") { showSignUp = true }
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "667eea"))
                }
                .font(.subheadline)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "f8f9fa"))
        .navigationDestination(isPresented: $showSignUp) {
            SignUpView()
        }
        .navigationDestination(isPresented: $viewModel.isAuthenticated) {
            // CHANGED: passes the logged-in user through instead of
            // ContentView() creating its own disconnected instance
            if let user = viewModel.currentUser {
                ContentView(loggedInUser: user)
            }
        }
    }
}

#Preview {
    LoginView()
}
