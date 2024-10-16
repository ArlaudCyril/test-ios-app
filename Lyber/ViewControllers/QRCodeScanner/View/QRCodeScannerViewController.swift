//
//  QRCodeScannerViewController.swift
//  Lyber prod
//
//  Created by Elie Boyrivent on 08/10/2024.
//

import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var onQRCodeScanned: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup background color and tap gesture for dismissing on background tap
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupBackgroundDismissGesture()
        
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            self.dismiss(animated: true)
            CommonFunctions.toster("Device video capture is not functioning")
            return
        }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Error setting up video input: \(error)")
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Could not add video input to capture session")
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Could not add metadata output")
            return
        }

        // Set the preview layer as a square in the center
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        let squareSide = min(view.bounds.width, view.bounds.height) * 0.8 // Set to 60% of the screen width
        let xOffset = (view.bounds.width - squareSide) / 2
        let yOffset = (view.bounds.height - squareSide) / 2
        previewLayer.frame = CGRect(x: xOffset, y: yOffset, width: squareSide, height: squareSide)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.cornerRadius = squareSide / 10
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    private func setupBackgroundDismissGesture() {
            let backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissOnBackgroundTap))
            backgroundTapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(backgroundTapGesture)
        }
        
        @objc private func dismissOnBackgroundTap(_ sender: UITapGestureRecognizer) {
            let touchLocation = sender.location(in: view)
            if !previewLayer.frame.contains(touchLocation) {
                dismiss(animated: true, completion: nil)
            }
        }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else { return }
            
            // Check if the scanned QR code contains a phone number
            let phoneNumber = retrievePhoneNumber(stringValue)
            if phoneNumber != nil {
                onQRCodeScanned?(phoneNumber ?? "")
                dismiss(animated: true)
            } else {
               // Display an error if it's not a valid phone number
               dismiss(animated: true){
                   CommonFunctions.toster(CommonFunctions.localisation(key: "SCANNED_QR_CODE_WRONG_FORMAT"))
               }
            }
           
        }
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }
    
    // Helper function to validate if the scanned string is a phone number
    private func retrievePhoneNumber(_ string: String) -> String? {
        // Check if it starts with "tel:"
        guard string.hasPrefix("tel:") else { return nil }
        
        // Extract the phone number part
        let phoneNumber = string.replacingOccurrences(of: "tel:", with: "")
        
        // Regular expression for phone number validation
        let phoneRegex = "^[0-9+]{5,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if(phoneTest.evaluate(with: phoneNumber)){
            return phoneNumber
        }
       return nil
    }
}
        
