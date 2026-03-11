import SwiftUI

struct FortuneResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var fortuneViewModel: FortuneViewModel
    @EnvironmentObject var themeManager: ThemeManager
    let fortune: Fortune
    
    var body: some View {
        ZStack {
            themeManager.bgColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image(systemName: "sparkles.tv.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .padding(.bottom, 20)
                
                Text("Yapay Zeka Okuması")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(themeManager.primaryTextColor)
                    .padding(.bottom, 5)
                
                Text(fortune.dateGenerated, style: .date)
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .padding(.bottom, 30)
                
                Text(fortune.text)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(themeManager.primaryTextColor)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(themeManager.cardBgColor)
                    )
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    // Save fortune and return
                    fortuneViewModel.savedFortunes.append(fortune)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Kaydet ve Kapat")
                        .font(.headline)
                        .foregroundColor(themeManager.bgColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themeManager.accentYellow)
                        .cornerRadius(15)
                        .padding(.horizontal, 40)
                }
                
                Button(action: {
                    // Just return without saving
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Kapat")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .padding(.top, 10)
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    FortuneResultView(fortune: Fortune(text: "Bu bir test falıdır.", dateGenerated: Date(), type: .aiScan))
        .environmentObject(FortuneViewModel())
        .environmentObject(ThemeManager())
}
