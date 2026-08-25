//
//  AuthViewModel.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/19/26.
//

import SwiftUI
import SwiftData
internal import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var username: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    @Published var currentUser: UserAccount?
    
    private func validateLoginFields() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        return true
    }
    
    private func validateSignUpFields() -> Bool {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email address."
            return false
        }
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters."
            return false
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return false
        }
        return true
    }
    
    // context comes from the View via @Environment(\.modelContext),
    // same idea as Django views receiving `request` and using
    // request's DB connection implicitly
    func login(context: ModelContext) {
        errorMessage = nil
        guard validateLoginFields() else { return }
        
        isLoading = true
        
        do {
            let user = try AuthService.login(email: email, password: password, context: context)
            currentUser = user
            isAuthenticated = true
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }
        
        isLoading = false
    }
    
    func signUp(context: ModelContext) {
        errorMessage = nil
        guard validateSignUpFields() else { return }
        
        isLoading = true
        
        do {
            let user = try AuthService.createAccount(
                username: username, email: email, password: password, context: context
            )
            currentUser = user
            isAuthenticated = true
        } catch let error as AuthError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }
        
        isLoading = false
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
        email = ""
        password = ""
        confirmPassword = ""
        username = ""
    }
}
