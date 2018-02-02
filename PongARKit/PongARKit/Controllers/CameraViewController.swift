//
//  SplashViewController.swift
//  PongARKit
//
//  Created by Jones on 2018/2/2.
//  Copyright © 2018年 ssrh. All rights reserved.
//

import UIKit
import CameraEngine

class CameraViewController: UIViewController {
    private var cameraEngine = CameraEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cameraEngine.startSession()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.cameraEngine.rotationCamera = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layer = self.cameraEngine.previewLayer else {
            return
        }
        layer.frame = self.view.bounds
        self.view.layer.insertSublayer(layer, at: 0)
    }
    @IBAction func switchCamera(_ sender: UIButton) {
        self.cameraEngine.switchCurrentDevice()
    }
    @IBAction func takePhoto(_ sender: UIButton) {
        self.cameraEngine.capturePhoto { (image , error) -> (Void) in
            if let image = image {
                CameraEngineFileManager.savePhoto(image, blockCompletion: { (success, error) -> (Void) in
                    if success {
                        let alertController =  UIAlertController(title: "照片保存成功!", message: nil, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func takeVideo(_ sender: UIButton) {
        if !self.cameraEngine.isRecording {
            if let url = CameraEngineFileManager.temporaryPath("video.mp4") {
                //                self.buttonTrigger.setTitle("stop recording", for: .normal)
                self.cameraEngine.startRecordingVideo(url, blockCompletion: { (url: URL?, error: NSError?) -> (Void) in
                    if let url = url {
                        DispatchQueue.main.async {
                            //                            self.buttonTrigger.setTitle("start recording", for: .normal)
                            CameraEngineFileManager.saveVideo(url, blockCompletion: { (success: Bool, error: Error?) -> (Void) in
                                if success {
                                    let alertController =  UIAlertController(title: "Success, video saved !", message: nil, preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            })
                        }
                    }
                })
            }
        }
        else {
            self.cameraEngine.stopRecordingVideo()
        }
    }

}
