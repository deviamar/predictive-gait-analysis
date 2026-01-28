//
//  UpdatedRegistrationView.swift
//  Elder-Ally
//
//  Created by Stella Luna on 2025.07.31.
//

import SwiftUI

struct UpdatedRegistrationView: View {
    @Binding var currentScreen: ElderAllyContentView.ScreenType
    @Binding var userType: String
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var emergencyContact = ""
    @State private var emergencyPhone = ""
    @State private var clinicName = ""
    
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(userType == "user" ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: userType == "user" ? "person.fill" : "stethoscope")
                            .font(.system(size: 35))
                            .foregroundColor(userType == "user" ? .green : .blue)
                    }
                    
                    Text("Create Account")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding(.top, 20)
                
                // Form Fields
                VStack(spacing: 25) {
                    HStack(spacing: 15) {
                        CustomTextField(title: "First Name", text: $firstName)
                        CustomTextField(title: "Last Name", text: $lastName)
                    }
                    
                    CustomTextField(title: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    
                    CustomTextField(title: "Phone", text: $phone)
                        .keyboardType(.phonePad)
                    
                    if userType == "user" {
                        CustomTextField(title: "Emergency Contact", text: $emergencyContact)
                        CustomTextField(title: "Emergency Phone", text: $emergencyPhone)
                            .keyboardType(.phonePad)
                    }
                    
                    if userType == "provider" {
                        CustomTextField(title: "Clinic Name", text: $clinicName)
                    }
                    
                    CustomTextField(title: "Password", text: $password, isSecure: true)
                }
                .padding(.horizontal, 20)
                
                // Create Account Button
                Button(action: {
                    Task {
                        await createAccount()
                    }
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text(isLoading ? "Creating Account..." : "Create Account")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(userType == "user" ? Color.green : Color.blue)
                    .cornerRadius(16)
                    .opacity(isLoading ? 0.7 : 1.0)
                }
                .disabled(isLoading || !isFormValid)
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
        }
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    currentScreen = .userSelection
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                }
                .disabled(isLoading)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertTitle == "Success!" {
                        // Navigate to main app or sign in screen
                        currentScreen = .welcome
                    }
                }
            )
        }
    }
    
    // MARK: - Form Validation
    private var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty &&
        !password.isEmpty &&
        password.count >= 6 &&
        (userType == "user" ? (!emergencyContact.isEmpty && !emergencyPhone.isEmpty) : !clinicName.isEmpty)
    }
    
    // MARK: - Create Account Function
    private func createAccount() async {
        isLoading = true
        
        do {
            if userType == "user" {
                try await supabaseManager.registerUser(
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone,
                    emergencyContact: emergencyContact,
                    emergencyPhone: emergencyPhone
                )
            } else {
                try await supabaseManager.registerProvider(
                    email: email,
                    password: password,
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone,
                    clinicName: clinicName
                )
            }
            
            // Success
            alertTitle = "Success!"
            alertMessage = "Your account has been created successfully. Please check your email to verify your account."
            showAlert = true
            
        } catch {
            // Error handling
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            showAlert = true
        }
        
        isLoading = false
    }
}

