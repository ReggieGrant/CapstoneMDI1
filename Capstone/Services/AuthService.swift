//
//  AuthService.swift
//  CapstoneMDI1
//
//  Created by Reginald Grant on 8/19/26.
//
import Foundation
import SwiftData
import CryptoKit

enum AuthError: LocalizedError {
    case usernameTaken
    case invalidCredentials
    case userNotFound
    
    var errorDescription: String? {
        switch self {
        case .usernameTaken: return "That username is already taken."
        case .invalidCredentials: return "Incorrect email or password."
        case .userNotFound: return "No account found with that email."
        }
    }
}

struct AuthService {
    
    // Simple SHA256 hash. Equivalent to Django's PBKDF2 password
    // hasher — not as strong, but appropriate for a local-only
    // capstone project rather than a production auth system.
    static func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    // Equivalent to Django's User.objects.create_user(username, email, password)
    static func createAccount(
        username: String,
        email: String,
        password: String,
        context: ModelContext
    ) throws -> UserAccount {
        
        // Check for existing username — equivalent to Django's
        // unique=True constraint check on the username field
        let descriptor = FetchDescriptor<UserAccount>(
            predicate: #Predicate { $0.username == username }
        )
        let existing = try context.fetch(descriptor)
        guard existing.isEmpty else {
            throw AuthError.usernameTaken
        }
        
        let newUser = UserAccount(
            username: username,
            email: email,
            passwordHash: hashPassword(password)
        )
        context.insert(newUser)
        try context.save()
        
        return newUser
    }
    
    // Equivalent to Django's authenticate(request, username=..., password=...)
    static func login(
        email: String,
        password: String,
        context: ModelContext
    ) throws -> UserAccount {
        
        let hashedInput = hashPassword(password)
        let descriptor = FetchDescriptor<UserAccount>(
            predicate: #Predicate { $0.email == email }
        )
        
        let matches = try context.fetch(descriptor)
        guard let user = matches.first else {
            throw AuthError.userNotFound
        }
        guard user.passwordHash == hashedInput else {
            throw AuthError.invalidCredentials
        }
        
        return user
    }
}
