import SwiftUI

struct PersonalSetupView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var fullName = ""
    @State private var birthDate = ""
    @State private var birthTime = ""
    @State private var selectedElement: ElementType? = nil
    
    @State private var navigateToScanner = false
    @State private var dismissToMain = false
    @AppStorage("isSetupComplete") var isSetupComplete: Bool = false
    
    enum ElementType: String, CaseIterable {
        case fire = "Fire"
        case water = "Water"
        case air = "Air"
        case earth = "Earth"
        
        var icon: String {
            switch self {
            case .fire: return "flame.fill"
            case .water: return "drop.fill"
            case .air: return "wind"
            case .earth: return "leaf.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .fire: return .orange
            case .water: return .blue
            case .air: return .green
            case .earth: return .brown
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                // Background Glow effects from HTML
                Circle()
                    .fill(themeManager.accentYellow.opacity(0.05))
                    .frame(width: 400, height: 400)
                    .blur(radius: 100)
                    .position(x: 400, y: 0)
                
                Circle()
                    .fill(themeManager.accentYellow.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .position(x: 0, y: UIScreen.main.bounds.height)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // Progress Indicator
                        HStack(spacing: 12) {
                            Capsule().fill(themeManager.accentYellow).frame(width: 40, height: 6)
                            Capsule().fill(themeManager.accentYellow.opacity(0.2)).frame(width: 40, height: 6)
                            Capsule().fill(themeManager.accentYellow.opacity(0.2)).frame(width: 40, height: 6)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                        
                        // Header Texts
                        Text("Map Your Destiny")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(themeManager.primaryTextColor)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 8)
                        
                        Text("Our elders use these details to align your stars.")
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.secondaryTextColor)
                            .padding(.bottom, 30)
                        
                        // Form Fields
                        VStack(spacing: 24) {
                            // Full Name Input
                            SetupTextField(title: "Full Name", placeholder: "E.g. Alexander Orion", text: $fullName, icon: nil, themeManager: themeManager)
                            
                            HStack(spacing: 16) {
                                // Birth Date Input
                                SetupTextField(title: "Birth Date", placeholder: "MM / DD / YYYY", text: $birthDate, icon: "calendar", themeManager: themeManager)
                                
                                // Birth Time Input
                                SetupTextField(title: "Exact Birth Time", placeholder: "12:00 PM", text: $birthTime, icon: "clock", themeManager: themeManager)
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // Personality Quiz Section
                        VStack(spacing: 20) {
                            // Section Divider
                            HStack(spacing: 12) {
                                Rectangle().fill(themeManager.accentYellow.opacity(0.2)).frame(height: 1)
                                Text("PERSONALITY TEST")
                                    .font(.system(size: 11, weight: .semibold, design: .serif))
                                    .foregroundColor(themeManager.accentYellow)
                                    .tracking(2)
                                Rectangle().fill(themeManager.accentYellow.opacity(0.2)).frame(height: 1)
                            }
                            .padding(.top, 40)
                            
                            // Quiz Card
                            VStack(spacing: 24) {
                                Text("Which element do you feel most connected to?")
                                    .font(.system(size: 20, weight: .bold, design: .serif))
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .multilineTextAlignment(.center)
                                
                                // Elements Grid
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                    ForEach(ElementType.allCases, id: \.self) { element in
                                        ElementCard(
                                            element: element,
                                            isSelected: selectedElement == element,
                                            themeManager: themeManager,
                                            action: { selectedElement = element }
                                        )
                                    }
                                }
                            }
                            .padding(24)
                            .background(themeManager.cardBgColor)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(themeManager.accentYellow.opacity(0.1), lineWidth: 1)
                            )
                            .cornerRadius(15)
                        }
                        .padding(.horizontal, 24)
                        
                        // Submit Area
                        VStack(spacing: 16) {
                            Button(action: {
                                // Save profile logic
                                navigateToScanner = true
                            }) {
                                Text("Continue Journey")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(themeManager.bgColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(themeManager.accentYellow)
                                    .cornerRadius(15)
                                    .shadow(color: themeManager.accentYellow.opacity(0.2), radius: 10, x: 0, y: 5)
                            }
                            
                            Text("Step 1 of 3: Spiritual Alignment")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .padding(.bottom, 50)
                    }
                }
                
                NavigationLink(destination: EyeScannerCameraView(navigateToMainApp: $dismissToMain).navigationBarHidden(true), isActive: $navigateToScanner) {
                    EmptyView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: dismissToMain) { newValue in
                if newValue {
                    // Update app state to show MainTabView
                    isSetupComplete = true
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(themeManager.primaryTextColor)
                            .font(.system(size: 20, weight: .regular))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Birth Chart Setup")
                        .font(.system(size: 17, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                }
            }
            .toolbarBackground(themeManager.bgColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

// MARK: - Reusable Setup Text Field
struct SetupTextField: View {
    var title: String
    var placeholder: String
    @Binding var text: String
    var icon: String?
    @ObservedObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(themeManager.secondaryTextColor)
                .padding(.leading, 4)
            
            HStack {
                TextField(placeholder, text: $text)
                    .foregroundColor(themeManager.primaryTextColor)
                    // Custom placeholder color hack
                    .colorMultiply(text.isEmpty ? themeManager.secondaryTextColor : themeManager.primaryTextColor)
                
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(themeManager.inputBgColor)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(themeManager.accentYellow.opacity(0.2), lineWidth: 1)
            )
            .cornerRadius(15)
            // Focused state boundary visualization
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(themeManager.accentYellow, lineWidth: 1)
                    .opacity(text.isEmpty ? 0 : 1)
                    .animation(.easeInOut, value: text.isEmpty)
            )
        }
    }
}

// MARK: - Element Selection Card
struct ElementCard: View {
    var element: PersonalSetupView.ElementType
    var isSelected: Bool
    @ObservedObject var themeManager: ThemeManager
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(element.color.opacity(0.2))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: element.icon)
                        .foregroundColor(element.color)
                        .font(.system(size: 24))
                }
                
                Text(element.rawValue)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(themeManager.primaryTextColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? themeManager.accentYellow.opacity(0.15) : themeManager.cardBgColor)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? themeManager.accentYellow : themeManager.accentYellow.opacity(0.1), lineWidth: isSelected ? 2 : 1)
            )
            .cornerRadius(15)
            // Scaling effect for selected
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PersonalSetupView()
        .environmentObject(ThemeManager())
}
