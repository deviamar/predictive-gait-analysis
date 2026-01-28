//
//  SupabaseManager.swift
//  Elder-Ally
//
//  Created by Stella Luna on 2025.07.31.
//


import Foundation
import Supabase

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    let client: SupabaseClient
    
    private init() {
        // Replace with your Supabase project URL and anon key
        let url = URL(string: "https://osbooqfofnglpibxrbly.supabase.co")!
        let key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9zYm9vcWZvZm5nbHBpYnhyYmx5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM5NTI2NTEsImV4cCI6MjA2OTUyODY1MX0.AFDzEHucJTQP_OINP7cmGdICl3yp4UY4gmoGxAcGgcY"
        
        self.client = SupabaseClient(supabaseURL: url, supabaseKey: key)
    }
    
    // MARK: - User Registration
    func registerUser(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        phone: String,
        emergencyContact: String? = nil,
        emergencyPhone: String? = nil
    ) async throws {
        print("🔵 Starting user registration for: \(email)")
        
        // Create auth user
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password
        )
        
        // Check if user was created successfully
        let user = authResponse.user
        let userId = user.id
        print("✅ Auth user created with ID: \(userId)")
        
        // Create user profile
        let userProfile = UserProfile(
            id: userId,
            email: email,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            userType: "user",
            emergencyContact: emergencyContact,
            emergencyPhone: emergencyPhone
        )
        
        print("🔵 Inserting user profile into database...")
        
        do {
            try await client
                .from("user_profiles")
                .insert(userProfile)
                .execute()
            
            print("✅ User profile inserted successfully!")
        } catch {
            print("❌ Failed to insert user profile: \(error)")
            throw SupabaseError.profileCreationFailed
        }
    }
    
    // MARK: - Healthcare Provider Registration
    func registerProvider(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        phone: String,
        clinicName: String
    ) async throws {
        print("🔵 Starting provider registration for: \(email)")
        
        // Create auth user
        let authResponse = try await client.auth.signUp(
            email: email,
            password: password
        )
        
        // Check if user was created successfully
        let user = authResponse.user
        
        let userId = user.id
        print("✅ Auth user created with ID: \(userId)")
        
        // Create provider profile
        let providerProfile = ProviderProfile(
            id: userId,
            email: email,
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            userType: "provider",
            clinicName: clinicName
        )
        
        print("🔵 Inserting provider profile into database...")
        
        do {
            try await client
                .from("user_profiles")
                .insert(providerProfile)
                .execute()
            
            print("✅ Provider profile inserted successfully!")
        } catch {
            print("❌ Failed to insert provider profile: \(error)")
            throw SupabaseError.profileCreationFailed
        }
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws -> String {
        let response = try await client.auth.signIn(
            email: email,
            password: password
        )
        
        let user = response.user
        return user.id.uuidString
    }
    
    // MARK: - Sign Out
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    // MARK: - Get Current User ID
    func getCurrentUserId() -> String? {
        return client.auth.currentUser?.id.uuidString
    }
    
    // MARK: - Check if User is Signed In
    func isSignedIn() -> Bool {
        return client.auth.currentUser != nil
    }
    
    // MARK: - Get User Profile
    func getUserProfile(userId: String) async throws -> UserProfile? {
        guard let uuid = UUID(uuidString: userId) else {
            throw SupabaseError.invalidUserId
        }
        
        print("🔵 Fetching user profile for ID: \(userId)")
        
        let response: [UserProfile] = try await client
            .from("user_profiles")
            .select()
            .eq("id", value: uuid)
            .execute()
            .value
        
        print("✅ Found \(response.count) profile(s)")
        return response.first
    }
    
    // MARK: - Update User Profile
    func updateUserProfile(_ profile: UserProfile) async throws {
        try await client
            .from("user_profiles")
            .update(profile)
            .eq("id", value: profile.id)
            .execute()
    }
    
    // MARK: - Test Database Connection
    func testDatabaseConnection() async throws -> Bool {
        do {
            let _: [UserProfile] = try await client
                .from("user_profiles")
                .select("id")
                .limit(1)
                .execute()
                .value
            
            print("✅ Database connection successful!")
            return true
        } catch {
            print("❌ Database connection failed: \(error)")
            throw error
        }
    }
}

// MARK: - Data Models (same as before)
struct UserProfile: Codable {
    let id: UUID
    let email: String
    let firstName: String
    let lastName: String
    let phone: String
    let userType: String
    let emergencyContact: String?
    let emergencyPhone: String?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, email, phone
        case firstName = "first_name"
        case lastName = "last_name"
        case userType = "user_type"
        case emergencyContact = "emergency_contact"
        case emergencyPhone = "emergency_phone"
        case createdAt = "created_at"
    }
    
    init(id: UUID, email: String, firstName: String, lastName: String, phone: String, userType: String, emergencyContact: String? = nil, emergencyPhone: String? = nil) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.userType = userType
        self.emergencyContact = emergencyContact
        self.emergencyPhone = emergencyPhone
        self.createdAt = nil
    }
}

struct ProviderProfile: Codable {
    let id: UUID
    let email: String
    let firstName: String
    let lastName: String
    let phone: String
    let userType: String
    let clinicName: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, email, phone
        case firstName = "first_name"
        case lastName = "last_name"
        case userType = "user_type"
        case clinicName = "clinic_name"
        case createdAt = "created_at"
    }
    
    init(id: UUID, email: String, firstName: String, lastName: String, phone: String, userType: String, clinicName: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.userType = userType
        self.clinicName = clinicName
        self.createdAt = nil
    }
}

// MARK: - Custom Errors
enum SupabaseError: Error, LocalizedError {
    case userCreationFailed
    case signInFailed
    case profileCreationFailed
    case invalidUserId
    case profileNotFound
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .userCreationFailed:
            return "Failed to create user account"
        case .signInFailed:
            return "Failed to sign in"
        case .profileCreationFailed:
            return "Failed to create user profile"
        case .invalidUserId:
            return "Invalid user ID format"
        case .profileNotFound:
            return "Profile not found"
        case .invalidCredentials:
            return "Invalid credentials"
        }
    }
}
