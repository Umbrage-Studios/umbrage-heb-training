//
//  ScanningViewController.swift
//  HEBProto
//
//  Created by Steve Galbraith on 8/4/22.
//

import AVFoundation
import UIKit
import Combine

protocol ScanResultReceiving {
    func found(code: String)
}

// Taken from https://www.hackingwithswift.com/example-code/media/how-to-scan-a-barcode
class ScannerViewController: UIViewController {
    // the exclamation points here mean that we wil crash when calling it if we havn't initialized it before doing so
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate: ScanResultReceiving?

    // lifecycle event #1
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession() // initializing the capture session so we don't crash (!)

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return } // mark the camera as the capture device
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice) // this assign the camera as the input provider
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            // Add video capture
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) // set this class as the delegate and make sure data comes through on the main thread
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417] // what type of objects we want to detect and get metadata for (in our case it is barcodes)
        } else {
            failed()
            return
        }

        // Now that the capture device set and the data receiving set we can show it on screen
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) // initializes a new layer that will be added once configured
        previewLayer.frame = view.layer.bounds // makes it full screen
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer) // adds the video layer on the view so it can be seen

        captureSession.startRunning() // start the capture from the camera
    }

    /// Shows an alert letting the user know that the camera setup has failed and we will not be able to scan
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    // lifecycle event #2
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // make sure that the capture session is running
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    // lifecycle event - this will stop the capture session and clean things up
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true // hide status bar stuff - battery, signal strength, etc...
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait // only scan in portrait mode
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning() // this saves battery and processing power

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) // since we have something we can use, we are going to give some haptic feedback to the user
            delegate?.found(code: stringValue)
        }

        dismiss(animated: true)
    }
}
