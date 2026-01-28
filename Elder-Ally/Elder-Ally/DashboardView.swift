import SwiftUI

struct DashboardView: View {
    
    @State private var fallRiskScore: Int = 35
    @State private var todayCompleted: Int = 3
    @State private var todayTotal: Int = 5
    @State private var batteryLevel: Int = 78
    @State private var currentStreak: Int = 7
    
    private var progressPercentage: Double {
        Double(todayCompleted) / Double(todayTotal) * 100
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Welcome Header
                    welcomeHeader
                    
                    // Fall Risk Indicator (prominent like your React component)
                    fallRiskIndicator
                    
                    // Today's Schedule
                    todaysSchedule
                    
                    // Quick Metrics Grid
                    metricsGrid
                    
                    // Device Status
                    deviceStatus
                    
                    // Recent Notes from Care Team
                    clinicianNotes
                    
                    // Quick Actions
                    quickActions
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.automatic)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    // MARK: - Welcome Header
    private var welcomeHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greetingText)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text("Here's your health overview")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: greetingIcon)
                .font(.title)
                .foregroundColor(greetingColor)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Good morning!"
        case 12..<17:
            return "Good afternoon!"
        case 17..<22:
            return "Good evening!"
        default:
            return "Good night!"
        }
    }
    
    private var greetingIcon: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "sun.max.fill"
        case 12..<17:
            return "sun.max.fill"
        case 17..<22:
            return "moon.stars.fill"
        default:
            return "moon.fill"
        }
    }
    
    private var greetingColor: Color {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return .orange
        case 12..<17:
            return .yellow
        case 17..<22:
            return .purple
        default:
            return .indigo
        }
    }
    
    // MARK: - Fall Risk Indicator
    private var fallRiskIndicator: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                fallRiskIcon
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Fall Risk Assessment")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(fallRiskLevel)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(fallRiskColor)
                }
                
                Spacer()
                
                VStack {
                    Text("\(fallRiskScore)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(fallRiskColor)
                    
                    Text("/100")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(fallRiskDescription)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Progress bar
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 8)
                    .foregroundColor(Color(.systemGray5))
                    .cornerRadius(4)
                
                Rectangle()
                    .frame(height: 8)
                    .foregroundColor(fallRiskColor)
                    .cornerRadius(4)
                    .scaleEffect(x: CGFloat(fallRiskScore) / 100, y: 1, anchor: .leading)
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(fallRiskColor, lineWidth: 0.5)
        )
    }
    
    // MARK: - Today's Schedule
    private var todaysSchedule: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.blue)
                Text("Today's Schedule")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            HStack {
                Text("\(todayCompleted) of \(todayTotal) exercises completed")
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
                    .frame(height: 8)
                    .foregroundColor(progressPercentage == 100 ? .green : .blue)
                    .cornerRadius(4)
                    .scaleEffect(x: CGFloat(progressPercentage) / 100, y: 1, anchor: .leading)
            }
            .frame(maxWidth: .infinity)
            
            if progressPercentage == 100 {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Great job! All exercises completed today!")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
                .padding(12)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Metrics Grid
    private var metricsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            MetricCard(
                title: "Walking Speed",
                value: "1.2 m/s",
                icon: "figure.walk",
                iconColor: .blue,
                backgroundColor: Color.blue.opacity(0.1)
            )
            
            MetricCard(
                title: "Daily Steps",
                value: "8,429",
                icon: "figure.walk.circle",
                iconColor: .green,
                backgroundColor: Color.green.opacity(0.1)
            )
            
            MetricCard(
                title: "Streak",
                value: "\(currentStreak) days",
                icon: "flame.fill",
                iconColor: .orange,
                backgroundColor: Color.orange.opacity(0.1)
            )
            
            MetricCard(
                title: "Cane Reliance",
                value: "87%",
                icon: "target",
                iconColor: .purple,
                backgroundColor: Color.purple.opacity(0.1)
            )
        }
    }
    
    // MARK: - Device Status
    private var deviceStatus: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "smartphone")
                    .foregroundColor(.blue)
                Text("Device Attachment")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("Cane-Mounted")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
            
            HStack(spacing: 40) {
                Spacer()
                HStack(spacing: 10) {
                    VStack {
                        Image(systemName: "battery.75")
                            .font(.title2)
                            .foregroundColor(batteryColor)
                        Text("Battery")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                    }
                    Text("\(batteryLevel)%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(batteryColor)
                }
                HStack(spacing: 10) {
                    VStack {
                        Image(systemName: "wifi")
                            .font(.title2)
                            .foregroundColor(.green)
                        Text("Last Sync")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                    }
                    Text("2 min ago")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                Spacer()
                
            }
            .frame(alignment: .center)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Clinician Notes
    private var clinicianNotes: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Notes from Care Team")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            // Sample notes
            ClinicianNoteRow(
                author: "Dr. Sarah Wilson",
                date: "2 days ago",
                content: "Patient showing excellent improvement in balance exercises. Continue current routine.",
                isPositive: true
            )
            
            ClinicianNoteRow(
                author: "PT Lisa Chen",
                date: "1 week ago",
                content: "Gait analysis shows reduced stride variability. Great progress!",
                isPositive: true
            )
            
            Button("View All Messages") {
                // Navigation action
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .foregroundColor(.blue)
            .cornerRadius(8)
            .font(.body)
            .fontWeight(.medium)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
    
    // MARK: - Quick Actions
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                QuickActionButton(
                    title: "Emergency Contact",
                    subtitle: "Call care team",
                    icon: "phone.fill",
                    backgroundColor: .red
                ) {
                    // Emergency action
                }
                
                QuickActionButton(
                    title: "Message Clinician",
                    subtitle: "Send a message",
                    icon: "message.fill",
                    backgroundColor: .blue
                ) {
                    // Message action
                }
                
                QuickActionButton(
                    title: "Schedule Appointment",
                    subtitle: "Book a visit",
                    icon: "calendar.badge.plus",
                    backgroundColor: .green
                ) {
                    // Schedule action
                }
                
                QuickActionButton(
                    title: "Get Help",
                    subtitle: "Support & FAQ",
                    icon: "questionmark.circle.fill",
                    backgroundColor: .orange
                ) {
                    // Help action
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    private var fallRiskColor: Color {
        if fallRiskScore < 30 { return .green }
        if fallRiskScore < 60 { return .orange }
        return .red
    }
    
    private var fallRiskLevel: String {
        if fallRiskScore < 30 { return "Low Risk" }
        if fallRiskScore < 60 { return "Moderate Risk" }
        return "High Risk"
    }
    
    private var fallRiskIcon: some View {
        Group {
            if fallRiskScore < 30 {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else if fallRiskScore < 60 {
                Image(systemName: "shield.fill")
                    .foregroundColor(.orange)
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
            }
        }
        .font(.title2)
    }
    
    private var fallRiskDescription: String {
        if fallRiskScore < 30 {
            return "Your mobility patterns look great! Keep up the good work."
        } else if fallRiskScore < 60 {
            return "Some patterns need attention. Follow your exercise plan."
        } else {
            return "Please contact your care team and follow safety guidelines."
        }
    }
    
    private var batteryColor: Color {
        if batteryLevel > 50 { return .green }
        if batteryLevel > 20 { return .orange }
        return .red
    }
}

// MARK: - Supporting Views

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    let backgroundColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(12)
    }
}

struct ClinicianNoteRow: View {
    let author: String
    let date: String
    let content: String
    let isPositive: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(author)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .overlay(
            Rectangle()
                .frame(width: 4)
                .foregroundColor(isPositive ? .green : .blue),
            alignment: .leading
        )
    }
}

struct QuickActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white)
                    .opacity(0.9)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, minHeight: 100)
            .padding()
            .background(backgroundColor)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    DashboardView()
}
