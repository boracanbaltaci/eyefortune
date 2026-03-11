import SwiftUI

struct ScannerView: View {
    @EnvironmentObject var scannerViewModel: ScannerViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.bgColor.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Gözünü Tarat")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.primaryTextColor)
                    
                    Text("Yapay zeka göz irisine bakarak kaderini okuyacak.")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .strokeBorder(
                                LinearGradient(gradient: Gradient(colors: [themeManager.accentYellow, themeManager.accentYellow.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 4
                            )
                            .frame(width: 250, height: 250)
                            .shadow(color: themeManager.accentYellow, radius: scannerViewModel.isScanning ? 20 : 0)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scannerViewModel.isScanning)
                        
                        if scannerViewModel.isScanning {
                            Circle()
                                .trim(from: 0.0, to: CGFloat(scannerViewModel.scanProgress))
                                .stroke(themeManager.secondaryTextColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 270, height: 270)
                                .rotationEffect(Angle(degrees: -90))
                                .animation(.linear(duration: 0.1), value: scannerViewModel.scanProgress)
                            
                            VStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: themeManager.primaryTextColor))
                                Text("Analiz ediliyor...")
                                    .foregroundColor(themeManager.primaryTextColor)
                                    .font(.caption)
                                    .padding(.top, 5)
                                Text("\(Int(scannerViewModel.scanProgress * 100))%")
                                    .foregroundColor(themeManager.accentYellow)
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                        } else {
                            Image(systemName: "eye")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .foregroundColor(themeManager.primaryTextColor.opacity(0.5))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        scannerViewModel.startScan()
                    }) {
                        Text(scannerViewModel.isScanning ? "Taranıyor..." : "Taramayı Başlat")
                            .font(.headline)
                            .foregroundColor(themeManager.bgColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.accentYellow)
                            .cornerRadius(15)
                            .shadow(color: themeManager.accentYellow.opacity(0.4), radius: 5, x: 0, y: 5)
                            .padding(.horizontal, 40)
                    }
                    .disabled(scannerViewModel.isScanning)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .background(
                NavigationLink(
                    destination: FortuneResultView(fortune: scannerViewModel.generatedFortune ?? Fortune(text: "", dateGenerated: Date(), type: .aiScan)),
                    isActive: $scannerViewModel.scanComplete,
                    label: { EmptyView() }
                )
            )
        }
    }
}

#Preview {
    ScannerView()
        .environmentObject(ScannerViewModel())
        .environmentObject(ThemeManager())
}
