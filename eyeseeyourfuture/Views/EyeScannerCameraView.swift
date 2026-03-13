import SwiftUI
import AVFoundation
import Vision
import Combine

class CameraViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    private var videoDataOutput = AVCaptureVideoDataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    @Published var isCameraSetup = false
    @Published var isAligned = false
    @Published var isLowLight = false
    @Published var countdown: Int = 0
    @Published var isCountdownActive = false
    @Published var capturedImage: UIImage? = nil
    
    private var cameraPosition: AVCaptureDevice.Position = .front
    
    private var countdownTimer: Timer?
    private var sequenceHandler = VNSequenceRequestHandler()
    
    deinit {
        stopSession()
    }
    
    func stopSession() {
        if session.isRunning {
            session.stopRunning()
        }
        isCameraSetup = false
        stopCountdown()
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
            
            // Camera Selection
            let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: cameraPosition) ?? 
                               AVCaptureDevice.default(for: .video)
            
            guard let camera = cameraDevice else { return }
            let input = try AVCaptureDeviceInput(device: camera)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            // Add video data output for Vision
            if self.session.canAddOutput(videoDataOutput) {
                videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
                self.session.addOutput(videoDataOutput)
            }
            
            self.session.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.session.startRunning()
            }
            
            DispatchQueue.main.async {
                self.isCameraSetup = true
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func switchCamera() {
        session.beginConfiguration()
        
        // Remove current input
        if let currentInput = session.inputs.first {
            session.removeInput(currentInput)
        }
        
        // Toggle position
        cameraPosition = (cameraPosition == .front) ? .back : .front
        
        // Setup new input
        setupCamera()
        
        session.commitConfiguration()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Luminosity Check
        if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
            let luminosity = calculateLuminosity(pixelBuffer)
            DispatchQueue.main.async {
                self.isLowLight = luminosity < 0.2 // threshold for "too dark"
            }
        }

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceLandmarksRequest { [weak self] request, error in
            guard let results = request.results as? [VNFaceObservation], let face = results.first else {
                DispatchQueue.main.async {
                    self?.updateAlignment(false)
                }
                return
            }
            
            // We want both eyes within a horizontal zone
            guard let landmarks = face.landmarks,
                  let leftEye = landmarks.leftEye,
                  let rightEye = landmarks.rightEye else {
                DispatchQueue.main.async { self?.updateAlignment(false) }
                return
            }
            
            let faceRect = face.boundingBox
            
            func centeredPoint(_ points: [CGPoint]) -> CGPoint {
                let sum = points.reduce(CGPoint.zero) { CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) }
                return CGPoint(x: sum.x / CGFloat(points.count), y: sum.y / CGFloat(points.count))
            }
            
            let lEyeCenter = centeredPoint(leftEye.normalizedPoints).applying(CGAffineTransform(scaleX: faceRect.width, y: faceRect.height))
            let rEyeCenter = centeredPoint(rightEye.normalizedPoints).applying(CGAffineTransform(scaleX: faceRect.width, y: faceRect.height))
            
            let lEyeAbsolute = CGPoint(x: faceRect.minX + lEyeCenter.x, y: faceRect.minY + lEyeCenter.y)
            let rEyeAbsolute = CGPoint(x: faceRect.minX + rEyeCenter.x, y: faceRect.minY + rEyeCenter.y)
            
            // More lenient alignment for better UX
            let isLEyeAligned = abs(lEyeAbsolute.x - 0.40) < 0.15 && abs(lEyeAbsolute.y - 0.5) < 0.18
            let isREyeAligned = abs(rEyeAbsolute.x - 0.60) < 0.15 && abs(rEyeAbsolute.y - 0.5) < 0.18
            
            let isAligned = isLEyeAligned && isREyeAligned
            
            DispatchQueue.main.async {
                self?.updateAlignment(isAligned)
            }
        }
        
        let orientation: CGImagePropertyOrientation = (cameraPosition == .front) ? .leftMirrored : .right
        try? sequenceHandler.perform([request], on: pixelBuffer, orientation: orientation)
    }

    private func calculateLuminosity(_ pixelBuffer: CVPixelBuffer) -> Double {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        guard let data = baseAddress?.assumingMemoryBound(to: UInt8.self) else { return 0.5 }
        
        var totalLuminance: Double = 0
        let sampleCount = 100 // Sample 100 points for performance
        
        for _ in 0..<sampleCount {
            let x = Int.random(in: 0..<width)
            let y = Int.random(in: 0..<height)
            let offset = y * bytesPerRow + x * 4 // Assuming BGRA
            // Simple luminance formula: 0.299R + 0.587G + 0.114B
            let b = Double(data[offset]) / 255.0
            let g = Double(data[offset + 1]) / 255.0
            let r = Double(data[offset + 2]) / 255.0
            totalLuminance += (0.299 * r + 0.587 * g + 0.114 * b)
        }
        
        return totalLuminance / Double(sampleCount)
    }
    
    private func updateAlignment(_ aligned: Bool) {
        if aligned != isAligned {
            isAligned = aligned
            if aligned {
                startCountdown()
            } else {
                stopCountdown()
            }
        }
    }
    
    private func startCountdown() {
        stopCountdown()
        countdown = 3
        isCountdownActive = true
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.countdown > 1 {
                self.countdown -= 1
            } else {
                self.stopCountdown()
                self.takePhoto()
            }
        }
    }
    
    private func stopCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = nil
        isCountdownActive = false
        countdown = 0
    }
    
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        self.output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil { return }
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }
        
        DispatchQueue.main.async {
            self.capturedImage = image
            self.session.stopRunning()
        }
    }
}

// UIViewController bindings to show camera
struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var cameraVM: CameraViewModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let layer = AVCaptureVideoPreviewLayer(session: cameraVM.session)
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        cameraVM.previewLayer = layer
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
    @State private var currentMysticNote = "İris haritası çıkarılıyor..."
    
    private let mysticNotes = [
        "İris haritası çıkarılıyor...",
        "Işık yansımaları analiz ediliyor...",
        "Pupil tepkimeleri ölçülüyor...",
        "Kişilik katmanları ile eşleştiriliyor...",
        "Kozmik enerji frekansı belirleniyor...",
        "Yıldız tozları ile bağlantı kuruluyor...",
        "Ruh haritası dijitalleştiriliyor..."
    ]
    
    @AppStorage("irisHex") var irisHex: String = "#4A90E2"
    @AppStorage("irisColorName") var irisColorName: String = ""
    @AppStorage("irisReading") var irisReading: String = ""
    @AppStorage("userName") var userNameStoreForReading: String = ""
    
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
                                    Ellipse()
                                        .frame(width: 320, height: 200)
                                        .blendMode(.destinationOut)
                                )
                        )
                    
                    // Main Scanning Frame
                    ZStack {
                        // Outer Ring with dash
                        Ellipse()
                            .stroke(cameraVM.isAligned ? Color.green.opacity(0.3) : themeManager.accentYellow.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [10, 5]))
                            .frame(width: 340, height: 220)
                        
                        // Progress Ring (Perfect Circle)
                        Circle()
                            .trim(from: 0, to: scanProgress)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [cameraVM.isAligned ? Color.green : themeManager.accentYellow, .white, cameraVM.isAligned ? Color.green : themeManager.accentYellow]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 8, lineCap: .round)
                            )
                            .frame(width: 200, height: 200)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 0.1), value: scanProgress)
                            .shadow(color: (cameraVM.isAligned ? Color.green : themeManager.accentYellow).opacity(0.3), radius: 10)
                        
                        // Corner Guides (Bank style - adjusted for wider oval)
                        ScannerCorners(color: cameraVM.isAligned ? Color.green : themeManager.accentYellow.opacity(0.4))
                            .frame(width: 320, height: 200)
                        
                        if !isScanning && !scanCompleted {
                            HStack(spacing: 24) {
                                Image(systemName: "eye")
                                    .font(.system(size: 44))
                                    .foregroundColor(cameraVM.isAligned ? .green : themeManager.accentYellow.opacity(0.5))
                                    .scaleEffect(cameraVM.isAligned ? 1.1 : 1.0)
                                
                                Image(systemName: "eye")
                                    .font(.system(size: 44))
                                    .foregroundColor(cameraVM.isAligned ? .green : themeManager.accentYellow.opacity(0.5))
                                    .scaleEffect(cameraVM.isAligned ? 1.1 : 1.0)
                            }
                            .animation(.spring(), value: cameraVM.isAligned)
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
            
            if cameraVM.isLowLight && !scanCompleted {
                VStack {
                    HStack {
                        Image(systemName: "sun.max.fill")
                        Text("Daha aydınlık bir yere gidin")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.top, 60)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(100)
            }

            // 3. Instruction Content
            VStack {
                // 3-Step Navigator
                StepNavigator(currentStep: 3, themeManager: themeManager)
                
                Text(scanCompleted ? "Kozmik Bağlantı Kuruldu" : "Gözünü Tarat")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundColor(themeManager.accentYellow)
                    .padding(.top, 40)
                    .padding(.bottom, 8)
                
                Text(scanCompleted ? "Yıldızlar ruhunuzu tanıdı." : "İki gözünüz de ovalin içerisinde görünecek şekilde yaklaşın")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                
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
                } else if isScanning {
                    VStack(spacing: 12) {
                        Text(currentMysticNote)
                            .font(.system(size: 16, weight: .medium, design: .serif))
                            .foregroundColor(themeManager.accentYellow)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .id(currentMysticNote)
                        
                        ProgressView()
                            .tint(themeManager.accentYellow)
                            .controlSize(.large)
                    }
                    .padding(.bottom, 80)
                } else {
                    // Countdown and scanning status indicator
                    VStack(spacing: 16) {
                        if cameraVM.isCountdownActive {
                            Text("\(cameraVM.countdown)")
                                .font(.system(size: 60, weight: .black, design: .serif))
                                .foregroundColor(themeManager.accentYellow)
                                .transition(.scale.combined(with: .opacity))
                                .id("countdown_bottom_\(cameraVM.countdown)")
                                .shadow(color: themeManager.accentYellow.opacity(0.5), radius: 10)
                        }
                        
                        HStack(spacing: 8) {
                            Circle()
                                .fill(cameraVM.isAligned ? Color.green : Color.red)
                                .frame(width: 8, height: 8)
                            Text(cameraVM.isAligned ? "Hazır" : "Haritalanıyor...")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    Text("Adım 3 / 3: Kozmik Tarama")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.top, 8)
                        .padding(.bottom, 60)
                    }
                }
                
                // Camera Flip Button
                if !scanCompleted {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                cameraVM.switchCamera()
                            }) {
                                Image(systemName: "camera.rotate")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(themeManager.accentYellow.opacity(0.3), lineWidth: 1))
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
            }
            .onAppear {
                cameraVM.checkPermissions()
            }
            .onDisappear {
                cameraVM.stopSession()
            }
            .onChange(of: cameraVM.capturedImage) { _, newImage in
                if let img = newImage {
                    // Perform Iris Analysis right after capture
                    if let irisInfo = IrisAnalysisUtils.detectIrisInfo(from: img) {
                        irisHex = irisInfo.hexColor
                        irisColorName = irisInfo.colorName
                        
                        // Generate AI Reading
                        irisReading = PersonalityAnalysisService.generateReading(for: irisInfo, userName: userNameStoreForReading)
                    }
                    
                    startScanningAnimation()
            }
        }
    }
    
    private func startScanningAnimation() {
        withAnimation { isScanning = true }
        
        // Scan for ~7 seconds (0.01 progress every 0.07 seconds)
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { timer in
            if scanProgress < 1.0 {
                // Slower near transitions for "analysis" feeling
                let speed: Double = (scanProgress > 0.4 && scanProgress < 0.6) ? 0.005 : 0.01
                scanProgress += speed
                
                // Update mystic notes periodically
                let noteIndex = Int(scanProgress * CGFloat(mysticNotes.count))
                if noteIndex < mysticNotes.count && currentMysticNote != mysticNotes[noteIndex] {
                    withAnimation {
                        currentMysticNote = mysticNotes[noteIndex]
                    }
                }
            } else {
                timer.invalidate()
                withAnimation {
                    isScanning = false
                    scanCompleted = true
                }
            }
        }
    }
}

struct ScannerCorners: View {
    var color: Color
    
    var body: some View {
        ZStack {
            // Adjusted paths for a more "rectangular-oval" guide
            VStack {
                HStack {
                    cornerShape().rotationEffect(.degrees(0))
                    Spacer()
                    cornerShape().rotationEffect(.degrees(90))
                }
                Spacer()
                HStack {
                    cornerShape().rotationEffect(.degrees(270))
                    Spacer()
                    cornerShape().rotationEffect(.degrees(180))
                }
            }
        }
    }
    
    private func cornerShape() -> some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 30))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 30, y: 0))
        }
        .stroke(color, lineWidth: 4)
        .frame(width: 30, height: 30)
    }
}

#Preview {
    EyeScannerCameraView(navigateToMainApp: .constant(false))
        .environmentObject(ThemeManager())
}
