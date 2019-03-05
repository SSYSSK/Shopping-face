//
//  TEEImageBufVC.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/11.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit
import AVFoundation

class TEEImageBufVC: UIViewController {
    var captureSession :AVCaptureSession!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    var g_width = 0;
    var g_height = 0;
    var g_pitch = 0;

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAVCapture()
    }
    
    func setupAVCapture(){
        
        // 1 创建session
//        session = AVCaptureSession()
//
//        // 2 设置session显示分辨率
//        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
//            session.canSetSessionPreset(.vga640x480)
//        }else {
//            session.canSetSessionPreset(.photo)
//        }
//
//        // 3 获取摄像头device,并且默认使用的后置摄像头,并且将摄像头加入到captureSession中
//        let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)
//
//        do {
//            //初始化媒体捕捉的输入流
//            let input = try AVCaptureDeviceInput(device: captureDevice!)
//            if (session .canAddInput(input)) {
//                session.addInput(input)
//            }
//        }  catch  {
//            // 捕获异常退出
//            print(error)
//            return
//        }
//
//        // 4 创建预览output,设置预览videosetting,然后设置预览delegate使用的回调线程,将该预览output加入到session
//        let videoOutput = AVCaptureVideoDataOutput()
//        ///设置输出格式为 yuv420
//        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
//        if (session.canAddOutput(videoOutput)) {
//            session.addOutput(videoOutput)
//        }
//
//        // 5 显示捕捉画面
//        let queue = DispatchQueue(label: "myQueue", attributes: .concurrent)
//        videoOutput.setSampleBufferDelegate(self, queue: queue)
//        let preLayer = AVCaptureVideoPreviewLayer(session: session)
//        preLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//
//        preLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        self.view.layer.addSublayer(preLayer)
//
//        session.startRunning()
        
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video);
        var videoInput:AVCaptureDeviceInput? =  nil;
        
        do {
            if let v = videoCaptureDevice{
                videoInput = try AVCaptureDeviceInput(device: v)
            }
            else{
                print("Error: can't find videoCaptureDevice");
            }
            
        } catch {
            let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            return
        }
        
        if let videoInput = videoInput{
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                //Show error
                return;
            }
        }
        else{
            //Show error
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput);
            
//            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main);
            let queue = DispatchQueue(label: "myQueue", attributes: .concurrent)
            metadataOutput.setMetadataObjectsDelegate(self, queue: queue)
            
            
            metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr, AVMetadataObject.ObjectType.code128];
        } else {
            //Show error
            return;
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
        
    }
    
    //切换摄像头
    @IBAction func switchCreame(_ sender: UIButton) {
        
//        captureSession?.beginConfiguration()
//
//        let currenInput = (videoInputDevice == frontCamera ? backCamera : frontCamera)
//
//        captureSession?.removeInput(videoInputDevice!)
//
//        captureSession?.addInput(currenInput!)
//
//        captureSession?.commitConfiguration()
//
//        videoInputDevice = currenInput
        
    }
   
}

extension TEEImageBufVC: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
    }
}

extension TEEImageBufVC:AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//
//        // 获取图片帧数据
//        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
////        let ciImage = [CIImage imageWithCVImageBuffer:imageBuffer];
////        UIImage *image = [UIImage imageWithCIImage:ciImage];
////
////        dispatch_async(dispatch_get_main_queue(), ^{
////            self.imageView.image = image;
////            });
////
//        let ciImage = CIImage(cvImageBuffer: imageBuffer!)
//        let image = UIImage(ciImage: ciImage)
//
//        print("image == \(image)")
//
//}
    
    
    //只要解析到数据,就会调用
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("success?");
        let pixelBuffer : CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!;
        let ciimage : CIImage = CIImage(cvPixelBuffer: pixelBuffer);
//letvar features : [CIFeature] = detector!.features(in: image);
        let image = UIImage(ciImage: ciimage)
        print("image== \(image)")
    }
    
    func captureOutput(_ : AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection) {
        print("fail?");
    }
    
    
func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
    let hasAlpha = false
    let scale: CGFloat = 0.0
    
    UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
    imageObj.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    return scaledImage!
    }
}
