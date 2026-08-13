//
//  LoginView.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/5/26.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showingMissingCredentials = false

    private var canSignIn: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty
    }

    var body: some View {
        ZStack {
            Backgrounds.gradient1
                .ignoresSafeArea()

            VStack(spacing: 28) {
                VStack(spacing: 8) {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)

                    Text("Please enter your credentials to continue.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.85))
                }

                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textContentType(.username)
                        .padding()
                        .background(.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(Color.formText)

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 8))
                        .foregroundStyle(Color.formText)

                    Button {
                        showingMissingCredentials = !canSignIn
                    } label: {
                        Text("Sign In")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.white)
                    .foregroundStyle(Color.formText)
                    .disabled(!canSignIn)
                    .opacity(canSignIn ? 1 : 0.65)
                }
                .frame(maxWidth: 360)
            }
            .padding(24)
        }
        .alert("Missing Credentials", isPresented: $showingMissingCredentials) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Enter your email and password to sign in.")
        }
    }
}

#Preview {
    LoginView()
}
