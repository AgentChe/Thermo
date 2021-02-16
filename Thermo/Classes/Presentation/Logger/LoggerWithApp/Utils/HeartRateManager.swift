//
//  HeartRateManager.swift
//  BPM Demo
//
//  Created by Nika Kirkitadze on 24.01.21.
//

import Foundation
import AVFoundation

typealias ImageBufferHandler = ((_ imageBuffer: CMSampleBuffer) -> ())

class HeartRateManager: NSObject {
    
    private let captureSession = AVCaptureSession()
    private var videoDevice: AVCaptureDevice!
    private var videoConnection: AVCaptureConnection!
    private var audioConnection: AVCaptureConnection!
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var imageBufferHandler: ImageBufferHandler?
    
    init(cameraType: CameraType, preferredSpec: Video?, previewContainer: CALayer?) {
        super.init()
        videoDevice = cameraType.captureDevice()
        
        // MARK: - Setup Video Format
        do {
            captureSession.sessionPreset = .low
            if let preferredSpec = preferredSpec {
                // Update the format with a preferred fps
                videoDevice.updateFormatWithPreferredVideoSpec(preferredSpec: preferredSpec)
            }
        }
        
        // MARK: - Setup video device input
        let videoDeviceInput: AVCaptureDeviceInput
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
        } catch let error {
            fatalError("Could not create AVCaptureDeviceInput instance with error: \(error).")
        }
        guard captureSession.canAddInput(videoDeviceInput) else { fatalError() }
        captureSession.addInput(videoDeviceInput)
        
        // MARK: - Setup preview layer
        if let previewContainer = previewContainer {
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = previewContainer.bounds
            previewLayer.contentsGravity = CALayerContentsGravity.resizeAspectFill
            previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewContainer.insertSublayer(previewLayer, at: 0)
            self.previewLayer = previewLayer
        }
        
        // MARK: - Setup video output
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        let queue = DispatchQueue(label: "com.covidsense.videosamplequeue")
        videoDataOutput.setSampleBufferDelegate(self, queue: queue)
        guard captureSession.canAddOutput(videoDataOutput) else {
            fatalError()
        }
        captureSession.addOutput(videoDataOutput)
        videoConnection = videoDataOutput.connection(with: .video)
    }
    
    func startCapture() {
        #if DEBUG
        print(#function + "\(self.classForCoder)/")
        #endif
        if captureSession.isRunning {
            #if DEBUG
            print("Capture Session is already running 🏃‍♂️.")
            #endif
            return
        }
        captureSession.startRunning()
    }
    
    func stopCapture() {
        #if DEBUG
        print(#function + "\(self.classForCoder)/")
        #endif
        if !captureSession.isRunning {
            #if DEBUG
            print("Capture Session has already stopped 🛑.")
            #endif
            return
        }
        captureSession.stopRunning()
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension HeartRateManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    // Exporting buffer from video frame
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if connection.videoOrientation != .portrait {
            connection.videoOrientation = .portrait
            return
        }
        if let imageBufferHandler = imageBufferHandler {
            imageBufferHandler(sampleBuffer)
        }
    }
}
