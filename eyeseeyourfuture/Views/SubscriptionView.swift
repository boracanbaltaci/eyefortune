import SwiftUI

struct SubscriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Binding to tell parent view to show the Personal Setup after dismissal
    @Binding var shouldShowPersonalSetup: Bool
    
    @AppStorage("isPremium") var isPremium = false
    @State private var selectedPlan: PlanType = .annual
    @State private var showApplePay = false
    @State private var isProcessing = false
    @State private var showSuccess = false
    
    // Theme Colors
    let bgColor = Color(red: 21.0/255.0, green: 20.0/255.0, blue: 15.0/255.0)
    let accentYellow = Color(red: 244.0/255.0, green: 192.0/255.0, blue: 37.0/255.0)
    let cardBg = Color(red: 25.0/255.0, green: 25.0/255.0, blue: 22.0/255.0)
    let lightGray = Color(red: 248.0/255.0, green: 248.0/255.0, blue: 245.0/255.0)
    
    enum PlanType {
        case monthly, annual
    }
    
    var body: some View {
        ZStack {
            bgColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Custom Navigation Bar for Modal
                HStack {
                    Text("Celestial Premium")
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundColor(accentYellow)
                    
                    Spacer()
                    
                    Button(action: {
                        shouldShowPersonalSetup = true
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(accentYellow)
                            .frame(width: 40, height: 40)
                            .background(accentYellow.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // Hero Image Area
                        ZStack(alignment: .bottom) {
                            // Border matching the design
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(accentYellow.opacity(0.2), lineWidth: 1)
                            
                            // Mocking the celestial eye background image
                            ZStack {
                                LinearGradient(gradient: Gradient(colors: [Color.black, Color(red: 30/255, green: 40/255, blue: 50/255)]), startPoint: .top, endPoint: .bottom)
                                
                                // Simulating the stars from the image
                                ForEach(0..<30) { _ in
                                    Circle()
                                        .fill(Color.white.opacity(Double.random(in: 0.2...0.9)))
                                        .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3))
                                        .position(x: CGFloat.random(in: 0...350), y: CGFloat.random(in: 0...200))
                                }
                                
                                // Eye shape simulation
                                Image(systemName: "eye.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(accentYellow.opacity(0.3))
                                    .shadow(color: accentYellow, radius: 20, x: 0, y: 0)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            // Bottom Gradient
                            LinearGradient(gradient: Gradient(colors: [bgColor.opacity(0), bgColor]), startPoint: .top, endPoint: .bottom)
                                .frame(height: 80)
                        }
                        .frame(height: 220)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        // Headline
                        Text("Unlock Your Destiny")
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 25)
                            .padding(.bottom, 20)
                        
                        // Benefits List
                        VStack(spacing: 12) {
                            BenefitRow(icon: "sparkles", text: "Detailed Daily Horoscopes", accentYellow: accentYellow)
                            BenefitRow(icon: "eye.slash.fill", text: "Ad-free Experience", accentYellow: accentYellow)
                            BenefitRow(icon: "brain.head.profile", text: "Priority Oracle Consultations", accentYellow: accentYellow)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 30)
                        
                        // Pricing Plans
                        VStack(spacing: 16) {
                            // Monthly Plan
                            PlanCard(
                                title: "Monthly Mystic",
                                price: "$3",
                                period: "/month",
                                description: "Standard celestial access, billed monthly.",
                                isSelected: selectedPlan == .monthly,
                                badge: nil,
                                saveText: nil,
                                accentYellow: accentYellow,
                                cardBg: cardBg,
                                action: { selectedPlan = .monthly }
                            )
                            
                            // Annual Plan
                            PlanCard(
                                title: "Annual Oracle",
                                price: "$25",
                                period: "/year",
                                description: nil,
                                isSelected: selectedPlan == .annual,
                                badge: "Best Value",
                                saveText: "Save 30% annually",
                                accentYellow: accentYellow,
                                cardBg: accentYellow.opacity(0.1),
                                action: { selectedPlan = .annual }
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                }
                
                // Footer Action Area
                VStack(spacing: 16) {
                    Divider().background(accentYellow.opacity(0.1))
                    
                    Button(action: {
                        showApplePay = true
                    }) {
                        Text("Subscribe Now")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(bgColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(accentYellow)
                            .cornerRadius(15)
                            .shadow(color: accentYellow.opacity(0.3), radius: 10, x: 0, y: 5)
                            .padding(.horizontal, 24)
                    }
                    
                    Text("Recurring billing, cancel anytime. By subscribing, you agree to our Terms of Service and Privacy Policy.")
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.bottom, 20)
                }
                .background(bgColor)
            }
            
            if showApplePay {
                ApplePaySimulationOverlay(
                    isProcessing: $isProcessing,
                    selectedPlan: selectedPlan == .monthly ? "Monthly Mystic ($3)" : "Annual Oracle ($25)",
                    onCancel: { showApplePay = false },
                    onConfirm: {
                        isProcessing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isProcessing = false
                            isPremium = true
                            showApplePay = false
                            withAnimation {
                                showSuccess = true
                            }
                        }
                    }
                )
                .transition(.move(edge: .bottom))
                .zIndex(100)
            }
            
            if showSuccess {
                SuccessOverlay(onDismiss: {
                    showSuccess = false
                    shouldShowPersonalSetup = true
                    presentationMode.wrappedValue.dismiss()
                })
                .zIndex(101)
            }
        }
    }
}

// MARK: - Apple Pay Simulation
struct ApplePaySimulationOverlay: View {
    @Binding var isProcessing: Bool
    let selectedPlan: String
    let onCancel: () -> Void
    let onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
                .onTapGesture { if !isProcessing { onCancel() } }
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Image(systemName: "applelogo")
                            .font(.system(size: 20))
                        Text("Pay")
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                        if !isProcessing {
                            Button("Cancel", action: onCancel)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Divider().background(Color.gray.opacity(0.3))
                    
                    // Transaction Details
                    VStack(spacing: 16) {
                        HStack {
                            Text("CARD")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                            Spacer()
                            HStack {
                                Image(systemName: "creditcard.fill")
                                Text("Apple Card (•••• 1234)")
                                    .font(.system(size: 14))
                            }
                        }
                        
                        Divider().background(Color.gray.opacity(0.1))
                        
                        HStack {
                            Text("PLAN")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                            Spacer()
                            Text(selectedPlan)
                                .font(.system(size: 14, weight: .semibold))
                        }
                        
                        Divider().background(Color.gray.opacity(0.1))
                        
                        HStack {
                            Text("PAY TO")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("EyeFortune App")
                                .font(.system(size: 14))
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Confirmation Button
                    if isProcessing {
                        VStack(spacing: 12) {
                            ProgressView()
                                .padding()
                            Text("Processing...")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 30)
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "faceid")
                                .font(.system(size: 44))
                                .foregroundColor(.blue)
                            
                            Text("Double Click to Pay")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Button(action: onConfirm) {
                                HStack {
                                    Image(systemName: "applelogo")
                                    Text("Pay with Touch ID / Face ID")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
                .background(Color(white: 0.12))
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(radius: 10)
            }
        }
    }
}

struct SuccessOverlay: View {
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                }
                .scaleEffect(1.2)
                
                VStack(spacing: 12) {
                    Text("Welcome to Premium!")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundColor(.white)
                    
                    Text("Your cosmic journey has been upgraded. All restricted insights and daily readings are now unlocked.")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Button(action: onDismiss) {
                    Text("Start Exploring")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                }
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// MARK: - Reusable Benefit Row
struct BenefitRow: View {
    var icon: String
    var text: String
    var accentYellow: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(accentYellow)
                .font(.system(size: 18))
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(accentYellow.opacity(0.05))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(accentYellow.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Plan Card
struct PlanCard: View {
    var title: String
    var price: String
    var period: String
    var description: String?
    var isSelected: Bool
    var badge: String?
    var saveText: String?
    var accentYellow: Color
    var cardBg: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        if let badge = badge {
                            Spacer()
                            Text(badge.uppercased())
                                .font(.system(size: 10, weight: .bold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(accentYellow)
                                .foregroundColor(Color(red: 26/255, green: 24/255, blue: 20/255))
                                .cornerRadius(20)
                        }
                    }
                    
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text(price)
                            .font(.system(size: 32, weight: .black))
                            .foregroundColor(.white)
                        Text(period)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    if let desc = description {
                        Text(desc)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    
                    if let saveText = saveText {
                        HStack(spacing: 6) {
                            Image(systemName: "banknote")
                            Text(saveText)
                        }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(accentYellow)
                        .padding(.top, 4)
                    }
                }
                
                Spacer()
                
                // Radio Button Design
                ZStack {
                    Circle()
                        .stroke(isSelected ? accentYellow : .gray, lineWidth: 2)
                        .frame(width: 22, height: 22)
                    
                    if isSelected {
                        Circle()
                            .fill(accentYellow)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(20)
            .background(cardBg)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? accentYellow : accentYellow.opacity(0.2), lineWidth: 2)
            )
            .shadow(color: isSelected ? accentYellow.opacity(0.1) : .clear, radius: 10, x: 0, y: 0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SubscriptionView(shouldShowPersonalSetup: .constant(false))
}
