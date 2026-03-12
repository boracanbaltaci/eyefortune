import SwiftUI
import AVFoundation
import Combine

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
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
        let view = UIView()
        cameraVM.previewLayer = AVCaptureVideoPreviewLayer(session: cameraVM.session)
        cameraVM.previewLayer.frame = view.bounds
        cameraVM.previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraVM.previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let layer = cameraVM.previewLayer {
            layer.frame = uiView.bounds
        }
    }
}

struct EyeScannerCameraView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var cameraVM = CameraViewModel()
    
    @State private var scanProgress: CGFloat = 0
    @State private var isScanning = false
    @State private var scanCompleted = false
    
    @Binding var navigateToMainApp: Bool
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            // 1. Camera Feed
            CameraPreviewView(cameraVM: cameraVM)
                .edgesIgnoringSafeArea(.all)
                .opacity(scanCompleted ? 0.3 : 1.0)
            
            // 2. Dark Overlay with Frame Cutout
            GeometryReader { geo in
                ZStack {
                    // Dimmed background
                    Color.black.opacity(0.6)
                        .edgesIgnoringSafeArea(.all)
                        .mask(
                            Rectangle()
                                .overlay(
                                    Circle()
                                        .frame(width: 280, height: 280)
                                        .blendMode(.destinationOut)
                                )
                        )
                    
                    // Main Scanning Frame
                    ZStack {
                        // Outer Ring with dash
                        Circle()
                            .stroke(themeManager.accentYellow.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
                            .frame(width: 320, height: 320)
                        
                        // Progress Ring
                        Circle()
                            .trim(from: 0, to: scanProgress)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [themeManager.accentYellow, .white, themeManager.accentYellow]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 6, lineCap: .round)
                            )
                            .frame(width: 280, height: 280)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 0.1), value: scanProgress)
                        
                        // Corner Guides (Bank style)
                        ScannerCorners(color: isScanning ? themeManager.accentYellow : themeManager.accentYellow.opacity(0.4))
                            .frame(width: 280, height: 280)
                        
                        if !isScanning && !scanCompleted {
                            VStack(spacing: 8) {
                                Image(systemName: "face.dashed")
                                    .font(.system(size: 40))
                                    .foregroundColor(themeManager.accentYellow.opacity(0.5))
                                Text("HİZALANIYOR")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(themeManager.accentYellow.opacity(0.6))
                            }
                        }
                        
                        if isScanning && !scanCompleted {
                            VStack(spacing: 4) {
                                Text("\(Int(scanProgress * 100))%")
                                    .font(.system(size: 38, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                Text("TARIYOR")
                                    .font(.system(size: 11, weight: .black))
                                    .tracking(2)
                                    .foregroundColor(themeManager.accentYellow)
                            }
                        }
                        
                        if scanCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.green)
                                .shadow(color: .green.opacity(0.5), radius: 10)
                        }
                    }
                }
            }
            .compositingGroup()
            
            // 3. Instruction Content
            VStack {
                Text(scanCompleted ? "Kozmik Bağlantı Kuruldu" : "Kozmik Tarama")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .foregroundColor(themeManager.accentYellow)
                    .padding(.top, 60)
                
                Text(scanCompleted ? "Yıldızlar ruhunuzu tanıdı." : "Gözünüzü dairenin içine getirin ve sabit tutun.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 8)
                
                Spacer()
                
                if scanCompleted {
                    Button(action: {
                        navigateToMainApp = true
                    }) {
                        Text("Yıldızlara Sor")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(themeManager.bgColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(themeManager.accentYellow)
                            .cornerRadius(16)
                            .shadow(color: themeManager.accentYellow.opacity(0.4), radius: 10)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 60)
                } else {
                    // Scanning status indicator
                    HStack(spacing: 8) {
                        Circle()
                            .fill(isScanning ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text(isScanning ? "Tarama Devam Ediyor..." : "Yüzünüzü Yaklaştırın")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.bottom, 80)
                }
            }
        }
        .onAppear {
            cameraVM.checkPermissions()
            startAutomatedScanner()
        }
    }
    
    private func startAutomatedScanner() {
        // Simulate detection and then progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { isScanning = true }
            
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                if scanProgress < 1.0 {
                    scanProgress += 0.01
                } else {
                    timer.invalidate()
                    withAnimation {
                        isScanning = false
                        scanCompleted = true
                    }
                    // Optional: Take a photo for the profile at the end
                    cameraVM.takePhoto()
                }
            }
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
