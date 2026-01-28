//
//  OpeningPage.swift
//  Elder-Ally
//
//  Created by Stella Luna on 2025.07.31.
//

import SwiftUI

struct ElderAllyContentView: View {
    @State private var currentScreen: ScreenType = .welcome
    @State private var userType: String = ""
    let onComplete: () -> Void // Add this parameter
    
    enum ScreenType {
        case welcome, userSelection, registration, signIn
    }
    
    var body: some View {
        NavigationView {
            switch currentScreen {
            case .welcome:
                WelcomeView(currentScreen: $currentScreen)
            case .userSelection:
                UserSelectionView(currentScreen: $currentScreen, userType: $userType)
            case .registration:
                RegistrationView(currentScreen: $currentScreen, userType: $userType, onComplete: onComplete)
            case .signIn:
                SignInView(currentScreen: $currentScreen, onComplete: onComplete)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct WelcomeView: View {
    @Binding var currentScreen: ElderAllyContentView.ScreenType
    
    var body: some View {
        VStack(spacing: 50) {
            Spacer()
            
            // Logo Section
            VStack(spacing: 30) {
                // Logo Circle with Activity Icon
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 140, height: 140)
                        .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    // Activity/Pulse Icon
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.green)
                }
                
                // Title
                Text("Elder Ally")
                    .font(.system(size: 52, weight: .bold))
                    .foregroundColor(.primary)
                
                // Subtitle
                Text("Step bolder, Step safer")
                    .font(.system(size: 22))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            // Feature Icons
            VStack(spacing: 25) {
                HStack(spacing: 60) {
                    FeatureIcon(icon: "waveform.path.ecg", text: "Smart Device", color: .green)
                    FeatureIcon(icon: "iphone", text: "Gait Analysis", color: .blue)
                }
                
                FeatureIcon(icon: "chart.bar.fill", text: "Progress Tracking", color: .purple)
            }
            
            Spacer()
            
            // Get Started Button
            Button(action: {
                currentScreen = .userSelection
            }) {
                Text("Get Started")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Color.green)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .background(Color(.systemGray6))
    }
}

struct FeatureIcon: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 150)
    }
}

struct UserSelectionView: View {
    @Binding var currentScreen: ElderAllyContentView.ScreenType
    @Binding var userType: String
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 0) {
                Text("Get Started")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                Text("Choose your role")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 140)
            .padding(.horizontal, 20)
            
            Spacer()
            
            // User Type Cards
            VStack(spacing: 30) {
                // User Card
                Button(action: {
                    userType = "user"
                    currentScreen = .registration
                }) {
                    VStack(spacing: 20) {
                        // User Icon
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 35))
                                .foregroundColor(.green)
                        }
                        
                        Text("I'm Using Elder Ally")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                // Healthcare Provider Card
                Button(action: {
                    userType = "provider"
                    currentScreen = .registration
                }) {
                    VStack(spacing: 20) {
                        // Provider Icon
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "stethoscope")
                                .font(.system(size: 35))
                                .foregroundColor(.blue)
                        }
                        
                        Text("I'm a Healthcare Provider")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Sign In Link
            Button("Already have an account? Sign In") {
                currentScreen = .signIn
            }
            .font(.system(size: 18))
            .foregroundColor(.green)
            .padding(.bottom, 150)
        }
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    currentScreen = .welcome
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct FeatureBullet: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text("•")
            Text(text)
            Spacer()
        }
    }
}

struct RegistrationView: View {
    @Binding var currentScreen: ElderAllyContentView.ScreenType
    @Binding var userType: String
    let onComplete: () -> Void
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var emergencyContact = ""
    @State private var emergencyPhone = ""
    @State private var clinicName = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var isLoading = false
    
    // Add reference to SupabaseManager
    @StateObject private var supabaseManager = SupabaseManager.shared
    
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
                .foregroundColor(.black)
                
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
                .disabled(isLoading || !isFormValid())
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
                    if alertTitle == "Welcome!" {
                        onComplete() // Only call onComplete for successful registration
                    }
                }
            )
        }
    }
    
    // MARK: - Helper Functions
    
    private func isFormValid() -> Bool {
        let basicFieldsValid = !firstName.isEmpty &&
                              !lastName.isEmpty &&
                              !email.isEmpty &&
                              !phone.isEmpty &&
                              !password.isEmpty
        
        if userType == "user" {
            return basicFieldsValid && !emergencyContact.isEmpty && !emergencyPhone.isEmpty
        } else if userType == "provider" {
            return basicFieldsValid && !clinicName.isEmpty
        }
        
        return basicFieldsValid
    }
    
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
            alertTitle = "Welcome!"
            alertMessage = "Your account has been created successfully."
            showAlert = true
            
        } catch {
            // Error handling
            alertTitle = "Registration Failed"
            alertMessage = "There was an error creating your account. Please try again.\n\nError: \(error.localizedDescription)"
            showAlert = true
        }
        
        isLoading = false
    }
}

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.primary)
            
            if isSecure {
                SecureField("", text: $text)
                    .font(.system(size: 22))
                    .padding()
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            } else {
                TextField("", text: $text)
                    .font(.system(size: 22))
                    .padding()
                    .frame(height: 60)
                    .background(Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
        }
    }
}

struct SignInView: View {
    @Binding var currentScreen: ElderAllyContentView.ScreenType
    //@Binding var userType: String
    let onComplete: () -> Void
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    @State private var isLoading = false
    
    //Add reference to Supabase Manager
    @StateObject private var supabaseManager = SupabaseManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Spacer()
                
                // Header
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.1))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.green)
                    }
                    
                    Text("Welcome Back")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Sign in to your account")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Form Fields
                VStack(spacing: 25) {
                    CustomTextField(title: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                    
                    CustomTextField(title: "Password", text: $password, isSecure: true)
                }
                .padding(.horizontal, 20)
                .foregroundColor(.black)
                
                // Sign In Button
                Button(action: {
                    Task {
                        await signIn()
                    }
                }) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text(isLoading ? "Signing In..." : "Sign In")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 70)
                    .background(Color.green)
                    .cornerRadius(16)
                    .opacity(isLoading ? 0.7 : 1.0)
                }
                .disabled(isLoading || !isFormValid())
                .padding(.horizontal, 20)
                
                // Create Account Link
                Button("Don't have an account? Create one") {
                    currentScreen = .userSelection
                }
                .font(.system(size: 18))
                .foregroundColor(.green)
                
                Spacer()
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        currentScreen = .welcome
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
                        if alertTitle == "Welcome Back!" {
                            onComplete()
                        }
                    }
                )
            }
        }
    }
    
    private func isFormValid() -> Bool {
            return !email.isEmpty && !password.isEmpty
        }
    
    private func signIn() async {
        isLoading = true
        do {
           try await supabaseManager.signIn(email: email, password: password)
            
            alertTitle="Welcome Back!"
            alertMessage="You have successfully signed in"
            showAlert=true
        } catch {
            alertTitle = "Sign In Failed"
            alertMessage = "Invalid email or password. Please try again.\n\nError: \(error.localizedDescription)"
            showAlert = true
        }
        
        isLoading = false
    }
}

#Preview {
    ElderAllyContentView(onComplete: {})
}
