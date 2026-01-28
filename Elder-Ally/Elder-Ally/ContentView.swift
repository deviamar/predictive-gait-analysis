//
//  ContentView.swift
//  Elder-Ally
//
//  Created by Stella Luna on 2025.07.30.
//

import SwiftUI
import UserNotifications
import EventKit
import Foundation

// **MARK: - Sample App Structure**
struct ContentView: View {
    @EnvironmentObject var userAuth: UserAuthManager
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var accessibilityManager = AccessibilityManager()
    @State private var selectedTab = 0
    @State private var showOpeningPage = true // Add this state
    
    var body: some View {
        Group {
            if showOpeningPage {
                ElderAllyContentView(onComplete: {
                    showOpeningPage = false
                })
            } else {
                TabView(selection: $selectedTab) {
                    DashboardView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Dashboard")
                        }
                        .tag(0)
                    
                    ProgressView()
                        .tabItem {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("Progress")
                        }
                        .tag(1)
                    
                    ExerciseView()
                        .tabItem {
                            Image(systemName: "figure.strengthtraining.traditional")
                            Text("Exercise")
                        }
                        .tag(2)
                    
                    SettingsView()
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(3)
                }
            }
        }
        .environmentObject(notificationManager)
        .environmentObject(accessibilityManager)
        .onAppear {
            notificationManager.requestPermission()
        }
    }
}

enum UserRole: String, CaseIterable, Codable {
    case patient = "patient"
    case physician = "physician"
}

struct User: Codable, Identifiable {
    let id: String
    let role: UserRole
    let name: String
    let email: String
    let age: Int?
    let emergencyContact: String?
    let clinic: String?
    let licenseNumber: String?
    
    init(id: String = UUID().uuidString,
         role: UserRole,
         name: String,
         email: String,
         age: Int? = nil,
         emergencyContact: String? = nil,
         clinic: String? = nil,
         licenseNumber: String? = nil) {
        self.id = id
        self.role = role
        self.name = name
        self.email = email
        self.age = age
        self.emergencyContact = emergencyContact
        self.clinic = clinic
        self.licenseNumber = licenseNumber
    }
}

struct Patient {
    let id: String
    let name: String
    let age: Int
    let fallRiskScore: Int
    let lastActivity: String
    let deviceType: DeviceType
    let compliance: Int
    let flagged: Bool
}

enum DeviceType: String, CaseIterable {
    case cane = "CANE"
    case walker = "WALKER"
    case shoe = "SHOE"
    
    var displayName: String {
        switch self {
        case .cane: return "Cane-Mounted"
        case .walker: return "Walker-Mounted"
        case .shoe: return "Shoe-Mounted"
        }
    }
}

struct Exercise {
    let id: String
    let title: String
    let duration: String
    let difficulty: ExerciseDifficulty
    let description: String
    let videoUrl: String?
    var completed: Bool
}

enum ExerciseDifficulty: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var color: Color {
        switch self {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}

struct Goal {
    let title: String
    let current: Double
    let target: Double
    let unit: String
    
    var progress: Int {
        Int((current / target) * 100)
    }
}

struct ClinicianNote {
    let date: String
    let author: String
    let content: String
    let priority: NotePriority
}

enum NotePriority {
    case normal, positive
    
    var color: Color {
        switch self {
        case .normal: return .blue
        case .positive: return .green
        }
    }
}

struct EmergencyContact {
    let name: String
    let role: String
    let phone: String
}

// MARK: - Accessibility Settings Component
struct AccessibilitySettingsView: View {
    @State private var fontSize: FontSize = .normal
    @State private var highContrast = false
    @State private var voiceAlerts = true
    
    enum FontSize: String, CaseIterable {
        case small = "Small"
        case normal = "Normal"
        case large = "Large"
        case xlarge = "Extra Large"
        
        var size: CGFloat {
            switch self {
            case .small: return 14
            case .normal: return 16
            case .large: return 18
            case .xlarge: return 20
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "eye")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("Accessibility")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "textformat.size")
                        .foregroundColor(.secondary)
                    Text("Text Size")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                    ForEach(FontSize.allCases, id: \.self) { size in
                        Button(action: { fontSize = size }) {
                            Text(size.rawValue)
                                .font(.system(size: size.size))
                                .fontWeight(.medium)
                                .foregroundColor(fontSize == size ? .white : .secondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(fontSize == size ? Color.blue : Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            Toggle("High Contrast Mode", isOn: $highContrast)
                .toggleStyle(SwitchToggleStyle())
            
            Toggle("Voice Alerts", isOn: $voiceAlerts)
                .toggleStyle(SwitchToggleStyle())
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Goal Card Component
struct GoalCardView: View {
    let goal: Goal
    
    var isCompleted: Bool {
        goal.progress >= 100
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(Int(goal.current)) / \(Int(goal.target)) \(goal.unit)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "target")
                .foregroundColor(isCompleted ? .green : .blue)
                .font(.title2)
        }
        .padding(.bottom, 12)
        
        HStack {
            ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(height: 8)
                        .foregroundColor(Color(.systemGray5))
                        .cornerRadius(4)
                    
                    Rectangle()
                        .frame(width: CGFloat(goal.progress) / 100 * 150, height: 8)
                        .foregroundColor(isCompleted ? .green : .blue)
                        .cornerRadius(4)
                }
                .frame(maxWidth: .infinity)
            
            Text("\(goal.progress)%")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isCompleted ? .green : .blue)
                .frame(width: 40, alignment: .trailing)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Emergency Contacts Component
struct EmergencyContactsView: View {
    @State private var contacts = [
        EmergencyContact(name: "Dr. Sarah Wilson", role: "Primary Care Physician", phone: "(555) 123-4567"),
        EmergencyContact(name: "Emergency Services", role: "911", phone: "911"),
        EmergencyContact(name: "Family - John Smith", role: "Emergency Contact", phone: "(555) 987-6543")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "phone.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("Emergency Contacts")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            ForEach(contacts.indices, id: \.self) { index in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(contacts[index].name)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(contacts[index].role)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(contacts[index].phone)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "pencil")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 12)
                
                if index < contacts.count - 1 {
                    Divider()
                }
            }
            
            Button(action: {}) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Emergency Contact")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Exercise Progress Component
struct ExerciseProgressView: View {
    let completed: Int
    let total: Int
    let streak: Int
    
    private var weeklyProgress: Double {
        total > 0 ? Double(completed) / Double(total) * 100 : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Progress")
                .font(.title3)
                .fontWeight(.semibold)
            
            HStack(spacing: 20) {
                StatView(
                    icon: "target",
                    value: "\(completed)/\(total)",
                    label: "Completed",
                    color: .blue
                )
                
                StatView(
                    icon: "calendar",
                    value: "\(Int(weeklyProgress))%",
                    label: "This Week",
                    color: .green
                )
                
                StatView(
                    icon: "flame.fill",
                    value: "\(streak)",
                    label: "Day Streak",
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct StatView: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color(.systemGray6))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title3)
                )
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Clinician Notes Component
struct ClinicianNotesView: View {
    @State private var notes = [
        ClinicianNote(
            date: "2 days ago",
            author: "Dr. Sarah Wilson",
            content: "Patient showing excellent improvement in balance exercises. Continue current routine and increase walking duration by 5 minutes.",
            priority: .normal
        ),
        ClinicianNote(
            date: "1 week ago",
            author: "PT Lisa Chen",
            content: "Gait analysis shows reduced stride variability. Great progress! Focus on maintaining consistent pace during outdoor walks.",
            priority: .positive
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "message.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("Recent Notes from Care Team")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            ForEach(notes.indices, id: \.self) { index in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(notes[index].author)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(notes[index].date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text(notes[index].content)
                        .font(.body)
                        .lineLimit(nil)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    Rectangle()
                        .fill(notes[index].priority.color)
                        .frame(width: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    , alignment: .leading
                )
            }
            
            Button(action: {}) {
                Text("View All Messages")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                    )
            }
        }
    }
}

// MARK: - Patient Card Component
struct PatientCardView: View {
    let patient: Patient
    
    private var riskColor: Color {
        switch patient.fallRiskScore {
        case 0...30: return .green
        case 31...60: return .orange
        default: return .red
        }
    }
    
    private var riskLevel: String {
        switch patient.fallRiskScore {
        case 0...30: return "Low"
        case 31...60: return "Moderate"
        default: return "High"
        }
    }
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(patient.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Age \(patient.age)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if patient.flagged {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                    }
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Fall Risk")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                        
                        HStack(spacing: 6) {
                            Circle()
                                .fill(riskColor)
                                .frame(width: 8, height: 8)
                            
                            Text("\(riskLevel) (\(patient.fallRiskScore))")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(riskColor)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Compliance")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fontWeight(.medium)
                        
                        Text("\(patient.compliance)%")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "iphone")
                            .foregroundColor(.blue)
                            .font(.caption)
                        
                        Text(patient.deviceType.rawValue)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                            .font(.caption)
                        
                        Text("Active \(patient.lastActivity)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                patient.flagged ?
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 4)
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                : nil
                , alignment: .leading
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Device Status Component
struct DeviceStatusView: View {
    let mountingLocation: DeviceType
    let batteryLevel: Int
    let lastSync: String
    
    private var batteryColor: Color {
        switch batteryLevel {
        case 51...100: return .green
        case 21...50: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Smart Mobility Device")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "iphone")
                            .foregroundColor(.blue)
                        
                        Text(mountingLocation.displayName)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "gear")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
            }
            
            HStack(spacing: 40) {
                VStack(spacing: 6) {
                    Image(systemName: "battery.\(batteryLevel > 75 ? "100" : batteryLevel > 50 ? "75" : batteryLevel > 25 ? "50" : "25")")
                        .foregroundColor(batteryColor)
                        .font(.title3)
                    
                    Text("Battery")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                    
                    Text("\(batteryLevel)%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(batteryColor)
                }
                
                VStack(spacing: 6) {
                    Image(systemName: "wifi")
                        .foregroundColor(.green)
                        .font(.title3)
                    
                    Text("Last Sync")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                    
                    Text(lastSync)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Today's Schedule Component
struct TodaysScheduleView: View {
    let exerciseCount: Int
    let completedCount: Int
    
    private var progressPercentage: Double {
        exerciseCount > 0 ? Double(completedCount) / Double(exerciseCount) * 100 : 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("Today's Schedule")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("\(completedCount) of \(exerciseCount) exercises completed")
                        .font(.body)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text("\(Int(progressPercentage))%")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(progressPercentage == 100 ? .green : .blue)
                }
                
                ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 8)
                            .foregroundColor(Color(.systemGray5))
                            .cornerRadius(4)
                        
                        Rectangle()
                            .frame(width: CGFloat(progressPercentage) / 100 * 150, height: 8)
                            .foregroundColor((completedCount == exerciseCount) ? .green : .blue)
                            .cornerRadius(4)
                    }
                    .frame(maxWidth: .infinity)
            }
            
            if progressPercentage == 100 {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    Text("Great job! All exercises completed today!")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Progress Chart Component
struct ProgressChartView: View {
    let timeframe: String
    
    @State private var data = [1.1, 1.2, 1.0, 1.3, 1.2, 1.4, 1.2]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Walking Speed - \(timeframeLabel)")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.right")
                        .foregroundColor(.green)
                        .font(.caption)
                    
                    Text("+12% improvement")
                        .font(.caption)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
            }
            
            // Simple bar chart representation
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(data.indices, id: \.self) { index in
                    VStack {
                        Rectangle()
                            .fill(data[index] > (index > 0 ? data[index-1] : 0) ? Color.green : Color.blue)
                            .frame(width: 20, height: CGFloat(data[index] * 50))
                            .cornerRadius(2)
                        
                        Text(timeframe == "week" ? dayLabels[index] : "\(index + 1)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 100)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var timeframeLabel: String {
        switch timeframe {
        case "week": return "Last 7 Days"
        case "month": return "Last 30 Days"
        case "3months": return "Last 3 Months"
        default: return "Last 7 Days"
        }
    }
    
    private let dayLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
}

// MARK: - Exercise Card Component
struct ExerciseCardView: View {
    @State var exercise: Exercise
    let onMarkComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(exercise.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(exercise.completed ? .secondary : .primary)
                    
                    Text(exercise.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: exercise.completed ? "checkmark.circle.fill" : "play.fill")
                        .foregroundColor(exercise.completed ? .green : .white)
                        .font(.title2)
                        .frame(width: 48, height: 48)
                        .background(exercise.completed ? Color.clear : Color.blue)
                        .clipShape(Circle())
                }
            }
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    Text(exercise.duration)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "target")
                        .foregroundColor(exercise.difficulty.color)
                        .font(.subheadline)
                    
                    Text(exercise.difficulty.rawValue)
                        .font(.subheadline)
                        .foregroundColor(exercise.difficulty.color)
                        .fontWeight(.medium)
                }
                
                Spacer()
            }
            
            if !exercise.completed {
                Button(action: {
                    exercise.completed = true
                    onMarkComplete()
                }) {
                    Text("Mark as Complete")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(exercise.completed ? Color(.systemGray6) : Color(.systemBackground))
        .cornerRadius(12)
        .overlay(
            exercise.completed ?
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green, lineWidth: 2)
            : nil
        )
    }
}

// MARK: - Device Configuration Component
struct DeviceConfigurationCardView: View {
    @State private var currentMounting: DeviceType = .cane
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "iphone")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("Device Configuration")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Setup")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                
                Text(currentMounting.displayName)
                    .font(.body)
                    .fontWeight(.semibold)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            Button(action: {}) {
                HStack {
                    Text("Change Mounting Location")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            Text("Different mounting locations provide unique insights into your gait patterns. Make sure to recalibrate after changing the device position.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(nil)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Clinician Stats Component
struct ClinicianStatsView: View {
    let totalPatients: Int
    let highRiskPatients: Int
    let avgCompliance: Int
    let flaggedToday: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Overview")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatCardView(
                    icon: "person.2.fill",
                    value: "\(totalPatients)",
                    label: "Total Patients",
                    backgroundColor: Color.blue.opacity(0.1)
                )
                
                StatCardView(
                    icon: "exclamationmark.triangle.fill",
                    value: "\(highRiskPatients)",
                    label: "High Risk",
                    backgroundColor: Color.red.opacity(0.1)
                )
                
                StatCardView(
                    icon: "arrow.up.right",
                    value: "\(avgCompliance)%",
                    label: "Avg Compliance",
                    backgroundColor: Color.green.opacity(0.1)
                )
                
                StatCardView(
                    icon: "flag.fill",
                    value: "\(flaggedToday)",
                    label: "Flagged Today",
                    backgroundColor: Color.orange.opacity(0.1)
                )
            }
        }
    }
}

struct StatCardView: View {
    let icon: String
    let value: String
    let label: String
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

// MARK: - Helper Extensions
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Notification Manager (iOS equivalent)
class NotificationManager: ObservableObject {
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
    func scheduleExerciseReminder(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Exercise Reminder"
        content.body = "Time for your daily mobility exercises!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "exerciseReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

// MARK: - User Defaults Helper for Accessibility Settings
class AccessibilityManager: ObservableObject {
    @Published var fontSize: CGFloat = 16
    @Published var highContrast: Bool = false
    @Published var voiceAlerts: Bool = true
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadSettings()
    }
    
    func loadSettings() {
        fontSize = userDefaults.object(forKey: "fontSize") as? CGFloat ?? 16
        highContrast = userDefaults.bool(forKey: "highContrast")
        voiceAlerts = userDefaults.bool(forKey: "voiceAlerts")
    }
    
    func saveSettings() {
        userDefaults.set(fontSize, forKey: "fontSize")
        userDefaults.set(highContrast, forKey: "highContrast")
        userDefaults.set(voiceAlerts, forKey: "voiceAlerts")
    }
    
    func getTextSize(_ baseSize: CGFloat) -> CGFloat {
        return baseSize * (fontSize / 16.0)
    }
}



// MARK: - Progress View (converted from your progress.tsx)
struct ProgressView: View {
    @State private var selectedTimeframe: String = "week"
    
    private let timeframeOptions = ["week", "month", "3months"]
    private let timeframeLabels = ["7 Days", "30 Days", "3 Months"]
    
    private let goals = [
        Goal(title: "Walking Speed", current: 1.2, target: 1.4, unit: "m/s"),
        Goal(title: "Daily Steps", current: 2847, target: 3500, unit: "steps"),
        Goal(title: "Balance Stability", current: 7.8, target: 8.5, unit: "/10")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Your Progress")
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text("Track your mobility improvements")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    
                    // Timeframe Selector
                    HStack(spacing: 0) {
                        ForEach(Array(timeframeOptions.enumerated()), id: \.offset) { index, option in
                            Button(action: { selectedTimeframe = option }) {
                                Text(timeframeLabels[index])
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedTimeframe == option ? .white : .secondary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedTimeframe == option ? Color.blue : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.horizontal, 4)
                    
                    ProgressChartView(timeframe: selectedTimeframe)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "target")
                                .foregroundColor(.blue)
                                .font(.title2)
                            
                            Text("Current Goals")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        ForEach(goals.indices, id: \.self) { index in
                            GoalCardView(goal: goals[index])
                        }
                    }
                    
                    ClinicianNotesView()
                }
                .padding(20)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
        }
    }
}

// MARK: - Exercise View (converted from your exercise.tsx)
struct ExerciseView: View {
    @EnvironmentObject var notificationManager: NotificationManager
    @EnvironmentObject var accessibilityManager: AccessibilityManager
    @State private var completedToday: Set<String> = []
    @State private var showingReminderSheet = false
    
    private let todaysExercises = [
        Exercise(
            id: "balance-1",
            title: "Single Leg Balance",
            duration: "2 minutes",
            difficulty: .beginner,
            description: "Stand on one foot, hold for 30 seconds, repeat",
            videoUrl: "balance-exercise-1",
            completed: false
        ),
        Exercise(
            id: "strength-1",
            title: "Heel-to-Toe Walking",
            duration: "5 minutes",
            difficulty: .intermediate,
            description: "Walk in a straight line placing heel directly in front of toes",
            videoUrl: "walking-exercise-1",
            completed: false
        ),
        Exercise(
            id: "flexibility-1",
            title: "Ankle Circles",
            duration: "3 minutes",
            difficulty: .beginner,
            description: "Sit comfortably and rotate each ankle in circular motions",
            videoUrl: "ankle-exercise-1",
            completed: false
        )
    ]
    
    private let weeklyProgress = (completed: 4, total: 7, streak: 3)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Exercise Plan")
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text("Personalized for your mobility goals")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    
                    ExerciseProgressView(
                        completed: weeklyProgress.completed,
                        total: weeklyProgress.total,
                        streak: weeklyProgress.streak
                    )
                    
                    TodaysScheduleView(
                        exerciseCount: todaysExercises.count,
                        completedCount: completedToday.count
                    )
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "target")
                                .foregroundColor(.blue)
                                .font(.title2)
                            
                            Text("Today's Exercises")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        
                        ForEach(todaysExercises.indices, id: \.self) { index in
                            ExerciseCardView(
                                exercise: todaysExercises[index]
                            ) {
                                handleMarkComplete(exerciseId: todaysExercises[index].id)
                            }
                        }
                    }
                    
                    Button(action: { showingReminderSheet = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                            
                            Text("Set Exercise Reminders")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                        )
                    }
                }
                .padding(20)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showingReminderSheet) {
            ReminderSelectionView { hour, minute in
                notificationManager.scheduleExerciseReminder(hour: hour, minute: minute)
                showingReminderSheet = false
            }
        }
    }
    
    private func handleMarkComplete(exerciseId: String) {
        if completedToday.contains(exerciseId) {
            completedToday.remove(exerciseId)
        } else {
            completedToday.insert(exerciseId)
        }
    }
}

// MARK: - Reminder Selection Sheet
struct ReminderSelectionView: View {
    let onTimeSelected: (Int, Int) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    private let timeOptions = [
        (hour: 9, minute: 0, label: "Morning (9:00 AM)"),
        (hour: 14, minute: 0, label: "Afternoon (2:00 PM)"),
        (hour: 18, minute: 0, label: "Evening (6:00 PM)")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Set Exercise Reminder")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("When would you like to be reminded to do your exercises?")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 12) {
                    ForEach(timeOptions.indices, id: \.self) { index in
                        Button(action: {
                            let option = timeOptions[index]
                            onTimeSelected(option.hour, option.minute)
                        }) {
                            Text(timeOptions[index].label)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

// MARK: - Settings View (converted from your settings.tsx)
struct SettingsView: View {
    @EnvironmentObject var accessibilityManager: AccessibilityManager
    @State private var notifications = NotificationSettings()
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Settings")
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text("Manage your preferences and device")
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    
                    DeviceConfigurationCardView()
                    
                    AccessibilitySettingsView()
                    
                    NotificationSettingsView(notifications: $notifications)
                    
                    EmergencyContactsView()
                    
                    SettingsGroupView()
                    
                    Button(action: { showingSignOutAlert = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                            
                            Text("Sign Out")
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red, lineWidth: 1)
                        )
                    }
                }
                .padding(20)
                .padding(.bottom, 100)
            }
            .background(Color(.systemGroupedBackground))
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                // Handle sign out
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
}

struct NotificationSettings {
    var exerciseReminders = true
    var gaitAlerts = true
    var fallRiskWarnings = true
    var clinicianMessages = true
}

struct NotificationSettingsView: View {
    @Binding var notifications: NotificationSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "bell.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("Notifications")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            VStack(spacing: 0) {
                ToggleRow(title: "Exercise Reminders", isOn: $notifications.exerciseReminders)
                Divider()
                ToggleRow(title: "Gait Analysis Alerts", isOn: $notifications.gaitAlerts)
                Divider()
                ToggleRow(title: "Fall Risk Warnings", isOn: $notifications.fallRiskWarnings)
                Divider()
                ToggleRow(title: "Clinician Messages", isOn: $notifications.clinicianMessages)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        Toggle(title, isOn: $isOn)
            .padding()
    }
}

struct SettingsGroupView: View {
    var body: some View {
        VStack(spacing: 0) {
            SettingsButton(
                icon: "shield.fill",
                title: "Privacy & Security",
                action: {}
            )
            
            Divider()
            
            SettingsButton(
                icon: "questionmark.circle.fill",
                title: "Help & Support",
                action: {}
            )
            
            Divider()
            
            SettingsButton(
                icon: "phone.fill",
                title: "Contact Care Team",
                action: {}
            )
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct SettingsButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title3)
                
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}



@MainActor
class UserAuthManager: ObservableObject {
    @Published var user: User?
    @Published var isLoading = true
    
    private let userDefaults = UserDefaults.standard
    private let userKey = "user"
    
    var isAuthenticated: Bool {
        user != nil
    }
    
    init() {
        loadUser()
    }
    
    func loadUser() {
        isLoading = true
        
        guard let userData = userDefaults.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: userData) else {
            isLoading = false
            return
        }
        
        self.user = user
        isLoading = false
    }
    
    func saveUser(_ userData: User) {
        do {
            let encoded = try JSONEncoder().encode(userData)
            userDefaults.set(encoded, forKey: userKey)
            self.user = userData
        } catch {
            print("Error saving user: \(error)")
        }
    }
    
    func signOut() {
        userDefaults.removeObject(forKey: userKey)
        self.user = nil
    }
}

// MARK: - UserRole ObservableObject (equivalent to useUserRole hook)
@MainActor
class UserRoleManager: ObservableObject {
    @Published var isClinicianMode = false
    
    func toggleRole() {
        isClinicianMode.toggle()
    }
}

// MARK: - Framework Ready Manager (equivalent to useFrameworkReady hook)
@MainActor
class FrameworkReadyManager: ObservableObject {
    @Published var isReady = false
    
    func setReady() {
        isReady = true
    }
}




// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading...")
                .padding(.top)
        }
    }
}

// MARK: - Authentication View
struct AuthenticationView: View {
    @EnvironmentObject var userAuth: UserAuthManager
    @State private var name = ""
    @State private var email = ""
    @State private var selectedRole: UserRole = .patient
    @State private var age = ""
    @State private var emergencyContact = ""
    @State private var clinic = ""
    @State private var licenseNumber = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                    
                    Picker("Role", selection: $selectedRole) {
                        ForEach(UserRole.allCases, id: \.self) { role in
                            Text(role.rawValue.capitalized).tag(role)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                if selectedRole == .patient {
                    Section("Patient Information") {
                        TextField("Age", text: $age)
                            .keyboardType(.numberPad)
                        TextField("Emergency Contact", text: $emergencyContact)
                    }
                }
                
                if selectedRole == .physician {
                    Section("Physician Information") {
                        TextField("Clinic", text: $clinic)
                        TextField("License Number", text: $licenseNumber)
                    }
                }
                
                Section {
                    Button("Sign In") {
                        signIn()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
            .navigationTitle("Sign In")
        }
    }
    
    private func signIn() {
        let user = User(
            role: selectedRole,
            name: name,
            email: email,
            age: age.isEmpty ? nil : Int(age),
            emergencyContact: emergencyContact.isEmpty ? nil : emergencyContact,
            clinic: clinic.isEmpty ? nil : clinic,
            licenseNumber: licenseNumber.isEmpty ? nil : licenseNumber
        )
        
        userAuth.saveUser(user)
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @EnvironmentObject var userAuth: UserAuthManager
    @EnvironmentObject var userRole: UserRoleManager
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            
            if userAuth.user?.role == .physician {
                ClinicalView()
                    .tabItem {
                        Image(systemName: "stethoscope")
                        Text("Clinical")
                    }
            }
        }
    }
}

// MARK: - Placeholder Views
struct HomeView: View {
    @EnvironmentObject var userAuth: UserAuthManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome, \(userAuth.user?.name ?? "User")!")
                    .font(.title)
                    .padding()
                
                Text("Role: \(userAuth.user?.role.rawValue.capitalized ?? "Unknown")")
                    .font(.headline)
                    .padding()
                
                Spacer()
            }
            .navigationTitle("Home")
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var userAuth: UserAuthManager
    @EnvironmentObject var userRole: UserRoleManager
    
    var body: some View {
        NavigationView {
            List {
                if let user = userAuth.user {
                    Section("User Information") {
                        HStack {
                            Text("Name")
                            Spacer()
                            Text(user.name)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Email")
                            Spacer()
                            Text(user.email)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Role")
                            Spacer()
                            Text(user.role.rawValue.capitalized)
                                .foregroundColor(.secondary)
                        }
                        
                        if let age = user.age {
                            HStack {
                                Text("Age")
                                Spacer()
                                Text("\(age)")
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if let emergencyContact = user.emergencyContact {
                            HStack {
                                Text("Emergency Contact")
                                Spacer()
                                Text(emergencyContact)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if let clinic = user.clinic {
                            HStack {
                                Text("Clinic")
                                Spacer()
                                Text(clinic)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if let licenseNumber = user.licenseNumber {
                            HStack {
                                Text("License Number")
                                Spacer()
                                Text(licenseNumber)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Section("Settings") {
                        Toggle("Clinician Mode", isOn: $userRole.isClinicianMode)
                    }
                    
                    Section {
                        Button("Sign Out", role: .destructive) {
                            userAuth.signOut()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ClinicalView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Clinical Dashboard")
                    .font(.title)
                    .padding()
                
                Text("Physician tools and patient management")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .navigationTitle("Clinical")
        }
    }
}
