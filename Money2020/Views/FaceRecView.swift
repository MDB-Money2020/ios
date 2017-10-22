//
//  FaceRecView.swift
//  Money2020
//
//  Created by Akkshay Khoslaa on 10/22/17.
//  Copyright © 2017 Akkshay Khoslaa. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol FaceRecViewDelegate {
    func handleNewImage(image: UIImage)
}

class FaceRecView: UIView {
    var session: AVCaptureSession?
    var scannedImage: UIImage!
    lazy var previewLayer: AVCaptureVideoPreviewLayer? = {
        var previewLay = AVCaptureVideoPreviewLayer(session: self.session!)
        previewLay.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        return previewLay
    }()
    lazy var frontCamera: AVCaptureDevice? = {
        guard let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] else { return nil }
        
        return devices.filter { $0.position == .front }.first
    }()
    
    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyLow])
    var delegate: FaceRecViewDelegate?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sessionPrepare()
        session?.startRunning()
        previewLayer?.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let previewLayer = previewLayer else { return }
        layer.addSublayer(previewLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sessionPrepare() {
        session = AVCaptureSession()
        
        guard let session = session, let captureDevice = frontCamera else { return }
        
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            session.beginConfiguration()
            
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            
            output.alwaysDiscardsLateVideoFrames = true
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            session.commitConfiguration()
            
            let queue = DispatchQueue(label: "output.queue")
            output.setSampleBufferDelegate(self, queue: queue)
            
        } catch {
            print("error with creating AVCaptureDeviceInput")
        }
    }
}

extension FaceRecView: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate)
        let ciImage = CIImage(cvImageBuffer: pixelBuffer!, options: attachments as! [String : Any]?)
        let options: [String : Any] = [CIDetectorImageOrientation: calculateOrientation(orientation: UIDevice.current.orientation),
                                       CIDetectorSmile: true,
                                       CIDetectorEyeBlink: true]
        let allFeatures = faceDetector?.features(in: ciImage, options: options)
        
        let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer)
        _ = CMVideoFormatDescriptionGetCleanAperture(formatDescription!, false)
        
        guard let features = allFeatures else { return }
        
        for feature in features {
            if feature is CIFaceFeature {
                DispatchQueue.main.async {
                    guard let cgImage = CIContext(options: nil).createCGImage(ciImage, from: ciImage.extent) else {
                        log.info("Could not convert image")
                        return
                    }
                    self.scannedImage = UIImage(cgImage: cgImage)
                    
                    self.delegate?.handleNewImage(image: self.scannedImage)
                }
                
            }
        }
        
    }
    
    func calculateOrientation(orientation: UIDeviceOrientation) -> Int {
        switch orientation {
        case .portraitUpsideDown:
            return 8
        case .landscapeLeft:
            return 3
        case .landscapeRight:
            return 1
        default:
            return 6
        }
    }
    
}
