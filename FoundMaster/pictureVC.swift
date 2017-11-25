//
//  pictureVC.swift
//  FoundMaster
//
//  Created by Storm Lim Got Game on 23/1/17.
//  Copyright © 2017 J.Lim. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage
import CoreLocation

class pictureVC: UIViewController, CLLocationManagerDelegate {
    
    var UUID = String()
    
    let locationManager = CLLocationManager()
    var locValue = CLLocationCoordinate2D()
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var loadingView: UIView!
    
    let captureSession = AVCaptureSession()
    
    let faceBox = UIView()
    
    var backFacingCamera:AVCaptureDevice?
    var frontFacingCamera:AVCaptureDevice?
    var currentDevice:AVCaptureDevice?
    
    var stillImageOutput:AVCaptureStillImageOutput?
    var stillImage:UIImage?
    
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var toggleCameraGestureRecognizer = UISwipeGestureRecognizer()
    var zoomInGestureRecognizer = UISwipeGestureRecognizer()
    var zoomOutGestureRecognizer = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // Preset the session for taking photo in full resolution
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as! [AVCaptureDevice]
        // Get the front and back-facing camera for taking photos
        for device in devices {
            if device.position == AVCaptureDevicePosition.back {
                backFacingCamera = device
            } else if device.position == AVCaptureDevicePosition.front {
                frontFacingCamera = device
            }
        }
        currentDevice = backFacingCamera
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
            
            // Configure the session with the output for capturing still images
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
            
            // Configure the session with the input and the output devices
            captureSession.addInput(captureDeviceInput)
            captureSession.addOutput(stillImageOutput)
            
        } catch {
            print(error)
            return
        }
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(cameraPreviewLayer!)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = view.layer.frame
        
        view.bringSubview(toFront: alertLabel)
        view.bringSubview(toFront: backBtn)
        view.bringSubview(toFront: loadingView)
        captureSession.startRunning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        load()
        capture()
    }
    
    func load() {
        self.loadingView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.alpha = 0.5
        }, completion: nil)
    }
    
    func endLoad() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.alpha = 0
        }) { (Bool) in
            self.loadingView.isHidden = true
        }
    }
    
    func capture() {
        let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo)
        stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) -> Void in
            
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
            self.stillImage = UIImage(data: imageData!)
            self.detect(UIImage(data: imageData!)!)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func detect(_ image: UIImage) {
        
        guard let personciImage = CIImage(image: image) else {
            return
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        if (faces as! [CIFaceFeature]).count != 0 {
            upload()
        } else {
            endLoad()
            let alert = UILabel()
            alert.frame = view.frame
            alert.text = "No face detected"
            alert.textColor = UIColor.white
            alert.textAlignment = .center
            alert.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.25)
            
            view.addSubview(alert)
            UIView.animate(withDuration: 2, animations: {
                alert.alpha = 0
            }, completion: { (Bool) in
                alert.removeFromSuperview()
            })
        }
    }
    
}
