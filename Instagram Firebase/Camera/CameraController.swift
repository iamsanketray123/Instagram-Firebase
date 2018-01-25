//
//  CameraController.swift
//  Instagram Firebase
//
//  Created by Sanket  Ray on 24/01/18.
//  Copyright © 2018 Sanket  Ray. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {

    let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    let capturePhotoButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        transitioningDelegate = self
        
        setupCaptureSession()
        setupHUD()
    }
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDimisser = CustomAnimationDismisser()
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        return customAnimationPresentor
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDimisser
    }
    
    fileprivate func  setupHUD(){
        view.addSubview(capturePhotoButton)
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    let output = AVCapturePhotoOutput()
    
    @objc func handleCapturePhoto() {
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let previewImage = UIImage(data: imageData)
        
        let containerView = PreviewPhotoContainerView()
        view.addSubview(containerView)
        containerView.previewImageView.image = previewImage
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupCaptureSession(){
        let captureSession = AVCaptureSession()
        
//        1. Setup Inputs
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch {
            print("Could not setup camera input:", error)
        }
        
        
//        2. Setup Outputs
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
//        3. Setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}









