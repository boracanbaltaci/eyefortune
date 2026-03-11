import SwiftUI
import AVFoundation

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    @Published var previewLayer: AVCaptureVideoPreviewLayer!
    
    @Published var isCameraSetup = false
    @Published var isAligned = false
    @Published var showCaptureOverlay = false
    @Published var capturedImage: UIImage? = nil
    
    // Simulate alignment after 2 seconds
    func simulateAlignment() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.isAligned = true
            }
        }
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }
        default:
            break
        }
    }
    
    private func setupCamera() {
        do {
            self.session.beginConfiguration()
            
            // Try to find the front camera, otherwise use default
            let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) ?? 
                               AVCaptureDevice.default(for: .video)
            
            guard let camera = cameraDevice else { return }
            let input = try AVCaptureDeviceInput(device: camera)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
            DispatchQueue.global(qos: .background).async {
                self.session.startRunning()
            }
            
            DispatchQueue.main.async {
                self.isCameraSetup = true
                self.simulateAlignment()
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        // We capture an image to display underneath the scanning animation
        self.output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
        DispatchQueue.main.async {
            self.capturedImage = image
            // We successfully captured, stop session
            self.session.stopRunning()
        }
    }
}

// UIViewController bindings to show camera
struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var cameraVM: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        cameraVM.previewLayer = AVCaptureVideoPreviewLayer(session: cameraVM.session)
        cameraVM.previewLayer.frame = view.bounds
        cameraVM.previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraVM.previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct EyeScannerCameraView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var cameraVM = CameraViewModel()
    
    @State private var scanAnimationOffset: CGFloat = -150
    @State private var scanCompleted = false
    
    // Binding or state to navigate to main app
    @Binding var navigateToMainApp: Bool
    
    var body: some View {
        ZStack {
            themeManager.bgColor.edgesIgnoringSafeArea(.all)
            
            // 1. Camera Feed / Captured Image
            if let capturedImage = cameraVM.capturedImage {
                // Show captured image
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
            } else {
                // Show live camera preview
                CameraPreviewView(cameraVM: cameraVM)
                    .edgesIgnoringSafeArea(.all)
            }
            
            // 2. Translucent Overlay with Cutout (Optional, simplified by just drawing rings)
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            // 3. UI Layer
            VStack {
                // Header
                HStack {
                    Spacer()
                    Text("Eye Scanner")
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.primaryTextColor)
                    Spacer()
                }
                .padding(.top, 50)
                
                Spacer()
                
                // Titles and Guidance
                VStack(spacing: 8) {
                    Text(scanCompleted ? "Analiz Tamamlandı" : "Ruhunun Aynası")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundColor(themeManager.accentYellow)
                        .multilineTextAlignment(.center)
                    
                    Text(scanCompleted ? "Kaderin yıldızlara kazındı." : "Gözünüzü ortadaki kılavuza hizalayın.")
                        .font(.system(size: 14))
                        .foregroundColor(themeManager.secondaryTextColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Scanner Target Area
                ZStack {
                    // Outer dashed ring
                    Circle()
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundColor(cameraVM.isAligned ? .green : themeManager.accentYellow.opacity(0.4))
                        .frame(width: 280, height: 280)
                    
                    // Inner solid ring
                    Circle()
                        .stroke(cameraVM.isAligned ? Color.green : themeManager.accentYellow.opacity(0.2), lineWidth: 4)
                        .frame(width: 250, height: 250)
                        
                    // Box corners
                    ScannerCorners(color: cameraVM.isAligned ? .green : themeManager.accentYellow)
                        .frame(width: 300, height: 300)
                    
                    // Center Eye prompt
                    if !cameraVM.isAligned && cameraVM.capturedImage == nil {
                        Image(systemName: "eye")
                            .font(.system(size: 60))
                            .foregroundColor(themeManager.accentYellow.opacity(0.3))
                    }
                    
                    // Scanning Animation (only visible during scanning phase)
                    if cameraVM.capturedImage != nil && !scanCompleted {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.clear, themeManager.accentYellow, .clear]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 280, height: 2)
                            .shadow(color: themeManager.accentYellow, radius: 10)
                            .offset(y: scanAnimationOffset)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 1.5).repeatCount(3, autoreverses: true)) {
                                    self.scanAnimationOffset = 150
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                                    withAnimation {
                                        scanCompleted = true
                                    }
                                }
                            }
                    }
                }
                
                Spacer()
                
                // Bottom Button
                VStack {
                    if scanCompleted {
                        Button(action: {
                            // Navigate to MainTabView
                            navigateToMainApp = true
                        }) {
                            Text("Devam et")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(themeManager.bgColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(themeManager.accentYellow)
                                .cornerRadius(15)
                                .shadow(color: themeManager.accentYellow.opacity(0.4), radius: 10)
                        }
                    } else if cameraVM.capturedImage != nil {
                        // Empty placeholder while scanning
                        Text("Yıldızlar taranıyor...")
                            .foregroundColor(themeManager.accentYellow)
                            .padding(.vertical, 18)
                    } else {
                        Button(action: {
                            if cameraVM.isAligned {
                                cameraVM.takePhoto()
                            }
                        }) {
                            HStack {
                                Image(systemName: "center.focus.strong")
                                Text(cameraVM.isAligned ? "Fotoğraf Çek" : "Hizalanıyor...")
                            }
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(cameraVM.isAligned ? themeManager.bgColor : themeManager.primaryTextColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(cameraVM.isAligned ? themeManager.accentYellow : themeManager.cardBgColor)
                            .cornerRadius(15)
                            .shadow(color: cameraVM.isAligned ? themeManager.accentYellow.opacity(0.4) : .clear, radius: 10)
                        }
                        .disabled(!cameraVM.isAligned)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            cameraVM.checkPermissions()
        }
    }
}

struct ScannerCorners: View {
    var color: Color
    
    var body: some View {
        ZStack {
            // Top Left
            Path { path in
                path.move(to: CGPoint(x: 0, y: 30))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 30, y: 0))
            }
            .stroke(color, lineWidth: 4)
            .frame(width: 300, height: 300)
            
            // Top Right
            Path { path in
                path.move(to: CGPoint(x: 270, y: 0))
                path.addLine(to: CGPoint(x: 300, y: 0))
                path.addLine(to: CGPoint(x: 300, y: 30))
            }
            .stroke(color, lineWidth: 4)
            .frame(width: 300, height: 300)
            
            // Bottom Left
            Path { path in
                path.move(to: CGPoint(x: 0, y: 270))
                path.addLine(to: CGPoint(x: 0, y: 300))
                path.addLine(to: CGPoint(x: 30, y: 300))
            }
            .stroke(color, lineWidth: 4)
            .frame(width: 300, height: 300)
            
            // Bottom Right
            Path { path in
                path.move(to: CGPoint(x: 300, y: 270))
                path.addLine(to: CGPoint(x: 300, y: 300))
                path.addLine(to: CGPoint(x: 270, y: 300))
            }
            .stroke(color, lineWidth: 4)
            .frame(width: 300, height: 300)
        }
    }
}

#Preview {
    EyeScannerCameraView(navigateToMainApp: .constant(false))
        .environmentObject(ThemeManager())
}
