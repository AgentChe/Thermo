//
//  LWAMeasurementView.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 05.02.2021.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class LWAMeasurementView: UIView {
    let pulseResult = PublishRelay<Double>()
    let cameraAccessDenied = PublishRelay<Void>()
    
    var temperatureUnit: TemperatureUnit?
    
    private lazy var thresholdLabel = makeThresholdLabel()
    private lazy var previewLayer = makePreviewLayer()
    private lazy var progressView = makeProgressView()
    private lazy var beatsContainer = makeBeatViewContainer()
    private lazy var heartImageView = makeHeartImageView()
    private lazy var beatLabel = makeBeatLabel()
    
    private var validFrameCounter = 0
    private var heartRateManager: HeartRateManager?
    private var hueFilter = Filter()
    private var beatDetector = BeatDetector()
    private var inputs: [CGFloat] = []
    private var isMeasurementStarted = false
    private var timer = Timer()
    
    private let isStartMeasure = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopMeasurement()
    }
}

// MARK: Public
extension LWAMeasurementView {
    func measurement() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self?.initVideoCapture()
                        self?.initCaptureSession()
                    }
                } else {
                    self?.cameraAccessDenied.accept(())
                }
            }
        case .restricted, .denied:
            self.cameraAccessDenied.accept(())
        case .authorized:
            initVideoCapture()
            initCaptureSession()
        @unknown default:
            return
        }
        
        isStartMeasure
            .distinctUntilChanged()
            .flatMapLatest { [weak self] isStartMeasure -> Observable<Int> in
                guard let self = self, isStartMeasure else { return .empty() }
                
                return Observable<Int>
                    .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
                    .skip(Int(self.progressTime))
                    .take(1)
            }
            .compactMap { [weak self] _ -> Double? in
                guard let self = self else { return nil }
                return Double(60.0/self.beatDetector.getAverage())
            }
            .bind(to: pulseResult)
            .disposed(by: disposeBag)
    }
    
    func stopMeasurement() {
        deinitCaptureSession()
    }
}

// MARK: Private
private extension LWAMeasurementView {
    func initialize() {
        backgroundColor = UIColor.white
    }
    
    var progressTime: Double {
        30
    }
    
    static let threasholdAttr = TextAttributes()
        .font(Fonts.Poppins.regular(size: 17.scale))
        .lineHeight(25.scale)
        .textColor(UIColor(integralRed: 2, green: 13, blue: 14))
        .textAlignment(.center)
    
    static let beatsAttr = TextAttributes()
        .font(Fonts.Poppins.regular(size: 20.scale))
        .lineHeight(30.scale)
        .textColor(.black)
}

// MARK: Make constraints
private extension LWAMeasurementView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            previewLayer.centerYAnchor.constraint(equalTo: centerYAnchor),
            previewLayer.centerXAnchor.constraint(equalTo: centerXAnchor),
            previewLayer.widthAnchor.constraint(equalToConstant: 130.scale),
            previewLayer.heightAnchor.constraint(equalTo: previewLayer.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            thresholdLabel.bottomAnchor.constraint(equalTo: previewLayer.topAnchor, constant: -50.scale),
            thresholdLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 54.scale),
            thresholdLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -54.scale)
        ])
        
        NSLayoutConstraint.activate([
            beatsContainer.topAnchor.constraint(equalTo: previewLayer.bottomAnchor, constant: 35.scale),
            beatsContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            beatsContainer.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -40.scale)
        ])
        
        NSLayoutConstraint.activate([
            heartImageView.topAnchor.constraint(equalTo: beatsContainer.topAnchor),
            heartImageView.leftAnchor.constraint(equalTo: beatsContainer.leftAnchor),
            heartImageView.bottomAnchor.constraint(equalTo: beatsContainer.bottomAnchor),
            heartImageView.heightAnchor.constraint(equalToConstant: 33.scale),
            heartImageView.widthAnchor.constraint(equalTo: heartImageView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            beatLabel.topAnchor.constraint(equalTo: beatsContainer.topAnchor),
            beatLabel.rightAnchor.constraint(equalTo: beatsContainer.rightAnchor),
            beatLabel.leftAnchor.constraint(equalTo: heartImageView.rightAnchor, constant: 10.scale),
            beatLabel.bottomAnchor.constraint(equalTo: beatsContainer.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            progressView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.scale),
            progressView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.scale),
            progressView.heightAnchor.constraint(equalToConstant: 10.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LWAMeasurementView {
    func makePreviewLayer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(integralRed: 196, green: 196, blue: 196)
        addSubview(view)
        return view
    }
    
    func makeThresholdLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.progressTintColor = UIColor(integralRed: 148, green: 165, blue: 225)
        view.trackTintColor = UIColor(integralRed: 189, green: 189, blue: 189)
        view.layer.cornerRadius = 5.scale
        view.layer.masksToBounds = true
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBeatViewContainer() -> UIView {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeHeartImageView() -> UIImageView {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "LWA.Heart")
        view.tintColor = UIColor(integralRed: 148, green: 165, blue: 225)
        beatsContainer.addSubview(view)
        return view
    }
    
    func makeBeatLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        beatsContainer.addSubview(view)
        return view
    }
}

private extension LWAMeasurementView {
    // MARK: - Frames Capture Methods
    func initVideoCapture() {
        let specs = Video(fps: 30, size: CGSize(width: 130, height: 130))
        heartRateManager = HeartRateManager(cameraType: .back, preferredSpec: specs, previewContainer: previewLayer.layer)
        heartRateManager?.imageBufferHandler = { [unowned self] (imageBuffer) in
            self.handle(buffer: imageBuffer)
        }
    }
    
    // MARK: - AVCaptureSession Helpers
    func initCaptureSession() {
        heartRateManager?.startCapture()
    }
    
    func deinitCaptureSession() {
        heartRateManager?.stopCapture()
        toggleTorch(status: false)
    }
    
    func toggleTorch(status: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        device.toggleTorch(on: status)
    }
    
    // MARK: - Measurement
    func startMeasurement() {
        UIView.animate(withDuration: 0.5, delay: 0.05, options: [.repeat]) {
            self.heartImageView.alpha = 0
            self.heartImageView.alpha = 1
        }
        
        DispatchQueue.main.async {
            self.toggleTorch(status: true)
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] (timer) in
                guard let self = self else { return }
                let average = self.beatDetector.getAverage()
                let beat = 60.0/average
                if beat == -60 {
                    self.isStartMeasure.accept(false)
                    self.progressView.layer.removeAllAnimations()
                    self.progressView.setProgress(0, animated: true)
                    UIView.animate(withDuration: 0.2, animations: {
                        self.beatsContainer.alpha = 0
                        self.progressView.alpha = 0
                    }) { (finished) in
                        self.beatsContainer.isHidden = finished
                        self.progressView.isHidden = finished
                    }
                } else {
                    self.isStartMeasure.accept(true)
                    UIView.animate(withDuration: 0.2, animations: {
                        self.beatsContainer.alpha = 1.0
                        self.progressView.alpha = 1.0
                    }) { _ in
                        self.beatsContainer.isHidden = false
                        self.progressView.isHidden = false
                        self.display(beat: beat)
                    }
                    
                    UIView.animate(withDuration: self.progressTime) {
                        self.progressView.setProgress(1, animated: true)
                    }
                }
            })
        }
    }
    
    func display(beat: Float) {
        guard let temperatureUnit = self.temperatureUnit else {
            return
        }
        
        let unit: String
        switch temperatureUnit {
        case .fahrenheit:
            unit = "Fahrenheit".localized
        case .celsius:
            unit = "Celsius".localized
        }
        
        let temperature = PulseToTemperature.calculate(pulse: Double(lroundf(beat)), unit: temperatureUnit)

        let string = String(format: "%.1f %@", temperature, unit)
            .attributed(with: Self.beatsAttr)
        
        beatLabel.attributedText = string
    }
}

//MARK: - Handle Image Buffer
private extension LWAMeasurementView {
    func handle(buffer: CMSampleBuffer) {
        var redmean:CGFloat = 0.0;
        var greenmean:CGFloat = 0.0;
        var bluemean:CGFloat = 0.0;

        let pixelBuffer = CMSampleBufferGetImageBuffer(buffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!)

        let extent = cameraImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let averageFilter = CIFilter(name: "CIAreaAverage",
                                        parameters: [kCIInputImageKey: cameraImage, kCIInputExtentKey: inputExtent])!
        let outputImage = averageFilter.outputImage!

        let ctx = CIContext(options:nil)
        let cgImage = ctx.createCGImage(outputImage, from:outputImage.extent)!

        let rawData:NSData = cgImage.dataProvider!.data!
        let pixels = rawData.bytes.assumingMemoryBound(to: UInt8.self)
        let bytes = UnsafeBufferPointer<UInt8>(start:pixels, count:rawData.length)
        var BGRA_index = 0
        for pixel in UnsafeBufferPointer(start: bytes.baseAddress, count: bytes.count) {
            switch BGRA_index {
            case 0:
                bluemean = CGFloat (pixel)
            case 1:
                greenmean = CGFloat (pixel)
            case 2:
                redmean = CGFloat (pixel)
            case 3:
                break
            default:
                break
            }
            BGRA_index += 1
        }

        let hsv = rgb2hsv((red: redmean, green: greenmean, blue: bluemean, alpha: 1.0))
        // Do a sanity check to see if a finger is placed over the camera
        if (hsv.1 > 0.5 && hsv.2 > 0.5) {
            DispatchQueue.main.async {
                self.thresholdLabel.attributedText = "LWA.Measurenment.ProgressTitle".localized.attributed(with: Self.threasholdAttr)
                self.toggleTorch(status: true)
                if !self.isMeasurementStarted {
                    self.startMeasurement()
                    self.isMeasurementStarted = true
                }
            }
            validFrameCounter += 1
            inputs.append(hsv.0)
            // Filter the hue value - the filter is a simple BAND PASS FILTER that removes any DC component and any high frequency noise
            let filtered = hueFilter.processValue(value: Double(hsv.0))
            if validFrameCounter > 60 {
                self.beatDetector.addNewValue(newVal: filtered, atTime: CACurrentMediaTime())
            }
        } else {
            validFrameCounter = 0
            isMeasurementStarted = false
            beatDetector.reset()
            DispatchQueue.main.async {
                self.thresholdLabel.attributedText = "LWA.Measurenment.Title".localized.attributed(with: Self.threasholdAttr)
            }
        }
    }
}
