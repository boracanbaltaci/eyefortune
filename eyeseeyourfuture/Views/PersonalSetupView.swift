import SwiftUI

struct PersonalSetupView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var lm: LocalizationManager
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
        NavigationStack {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // Header Texts
                        Text(lm.t(.setupTitle))
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(themeManager.primaryTextColor)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                            .padding(.bottom, 8)
                        
                        Text(lm.t(.setupSubtitle))
                            .font(.system(size: 14))
                            .foregroundColor(themeManager.secondaryTextColor)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                        
                        // Form Fields
                        VStack(spacing: 24) {
                            // Full Name Input
                            SetupTextField(title: lm.t(.setupFullName), placeholder: lm.t(.setupFullNamePlaceholder), text: $fullName, icon: nil, themeManager: themeManager)
                            
                            HStack(spacing: 16) {
                                // Birth Date Input
                                SetupTextField(title: lm.t(.setupBirthDate), placeholder: "MM / DD / YYYY", text: $birthDate, icon: "calendar", themeManager: themeManager)
                                
                                // Birth Time Input
                                SetupTextField(title: lm.t(.setupBirthTime), placeholder: "12:00 PM", text: $birthTime, icon: "clock", themeManager: themeManager)
                            }
                            
                            // Element Selection
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Select Your Element")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(themeManager.secondaryTextColor)
                                    .padding(.leading, 4)
                                
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
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
                        }
                        .padding(.horizontal, 24)
                        
                        // Submit Area
                        VStack(spacing: 16) {
                            Button(action: {
                                navigateToScanner = true
                            }) {
                                Text(lm.t(.setupContinue))
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(themeManager.bgColor)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 18)
                                    .background(themeManager.accentYellow)
                                    .cornerRadius(15)
                                    .shadow(color: themeManager.accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                            }
                            
                            Text("Step 1 of 1: Spiritual Alignment")
                                .font(.system(size: 12))
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .padding(.bottom, 50)
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToScanner) {
                PersonalityQuizView(navigateToNextStep: $dismissToMain)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: dismissToMain) { _, newValue in
                if newValue {
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
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(lm.t(.setupNavTitle))
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
        }
        .buttonStyle(PlainButtonStyle())
    }
}
