//
//  TEEVideoViewController.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/11.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit
import AVFoundation

enum CameraType: String {
    case Fase = "Fase"
    case Shopping = "Shopping"
}

class TEEVideoViewController: UIViewController {
    
    @IBOutlet weak var scrollViewBg: UIView!
    @IBOutlet weak var camelarBtn: UIButton!
    
    @IBOutlet weak var fuzhuanBtn: UIButton!
    @IBOutlet weak var shipinBtn: UIButton!
    @IBOutlet weak var shangpinBtn: UIButton!
    @IBOutlet weak var dianqi: UIButton!
    @IBOutlet weak var lineView: UIView!
    
    var user = TEEUser()
    var currentMetadata = NSMutableArray() //?< 如果检测到了人脸系统会返回一个数组 我们将这个数组存起来
    // 判断当前图片是不是在上传中
    enum AploadImageStatus: String {
        case Success = "success"
        case Uploading = "Uploading"
    }
    
    
    
    var uploadImageStatus :AploadImageStatus = .Success
    var productData = TEEProductData()
    var clickProduct = TEEProduct()
    var productViews = [TEEProductView]();
    var titleTypes = ["商品","食品"]
    var zdScrollView =  ZDScrollView()
    var scanImgView =  UIImageView() // 扫描杠
    
    //用于展示视频
    var customImgView =  UIImageView()
    
    // 摄像头授权状态
    var cameraAuthStatus: AVAuthorizationStatus!
    
    // 预览Layer
    var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    // Session
    var session: AVCaptureSession!
    
    // 数据输入
    var captureInput:AVCaptureDeviceInput!
    // 捕获的视频数据输出
    var captureOutput:AVCaptureVideoDataOutput!
    // 捕获的元数据输出
    var metaDateOutput:AVCaptureMetadataOutput!

    // 拍照或者选择相册照片
    var selectImage = UIImage()
    
    // 选择照片或者拍照片时，之前的视频截取流在返回来数据的话不作响应
    var stopSession: Bool = false

    var dataType = 0
    var camaraType:CameraType! = .Fase
    var face = FaceDlibWrapper()
    let photoPickerViewController:UIImagePickerController = UIImagePickerController()
    
    enum SegueIdentifier: String {
        case toTEECenter                 = "toTEECenterVC"
        case toProduct                   = "toProductVC"
        case toTEEProductDetailHtml      = "toTEEProductDetailHtml"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customImgView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
       
        
        scanImgView = UIImageView(frame: CGRect(x: 50, y: kScreenHeight / 4, width: kScreenWidth - 100, height: 4))
        scanImgView.image = UIImage(named: "scanerLine")
        self.view.addSubview(scanImgView)
        
        self.setupCamera()
        
        self.view.addSubview(customImgView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stopSession = false
        self.navigationController?.navigationBar.isHidden = true
        scanImgView.frame = CGRect(x: 50, y: kScreenHeight / 4, width: kScreenWidth - 100, height: 4)

        UIView.animate(withDuration: 2, delay: 0, options: [.repeat,.autoreverse], animations: {
            self.scanImgView.isHidden = false
            self.scanImgView.center.y += kScreenHeight / 2
        }, completion: nil)
        self.uploadImageStatus = .Success
        session.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.uploadImageStatus = .Success
        session.stopRunning()
    }
    
    func createScrollView(){
        zdScrollView = ZDScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.scrollViewBg.height))
        zdScrollView.margin = 10
        zdScrollView.lineHeight = 3
        zdScrollView.titles = titleTypes
        zdScrollView.titleColor_normal = UIColor.white
        
        self.scrollViewBg.addSubview(zdScrollView)
    }

   
    // MARK:- 摄像头设置相关
    func setupCamera() {
        
        self.session = AVCaptureSession()
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        self.captureOutput = AVCaptureVideoDataOutput()
        self.metaDateOutput = AVCaptureMetadataOutput()
        
        do{
            if self.checkVideoAuth() == true {
                try self.captureInput = AVCaptureDeviceInput(device: device!)
                //将输入、输出对象添加到session中
                if(self.session.canAddInput(self.captureInput)){
                    self.session.addInput(self.captureInput)
                }
            }
        }catch let error as NSError{
            print(error)
            _ = self.checkVideoAuth()
        }
        
        //检查摄像头是否授权
        if self.checkVideoAuth() == true {
            self.session.beginConfiguration()
            //画面质量设置
            self.session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            self.captureOutput.videoSettings =  [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_32BGRA]
            
           
            if(self.session.canAddOutput(self.captureOutput)){
                self.session.addOutput(self.captureOutput)
            }
            if(self.session.canAddOutput(self.metaDateOutput)){
                self.session.addOutput(self.metaDateOutput)
            }
            
            let subQueue = DispatchQueue(label: "subQueue")
            captureOutput.setSampleBufferDelegate(self, queue: subQueue)
            self.metaDateOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            //设置扫描类型，该处仅支持二维码扫描，如果需要更多扫描类型，请查阅开发文档
            self.metaDateOutput.metadataObjectTypes = [
                AVMetadataObject.ObjectType.qr]
            
            
            // 获取输入与输出之间的连接
            let connection = captureOutput.connection(with: .video)
            // 设置采集数据的方向
            connection?.videoOrientation = .portrait;
            // 设置镜像效果镜像
            connection?.isVideoMirrored = false;
            
            
            //预览Layer设置
            self.captureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
            self.captureVideoPreviewLayer.frame = CGRect(x:0, y:0, width:kScreenWidth, height:kScreenHeight)
            self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            //        self.view.layer.addSublayer(self.captureVideoPreviewLayer)
            self.view.layer.insertSublayer(self.captureVideoPreviewLayer, at: 0)
            
            self.session.commitConfiguration()
            self.session.startRunning()
        }
    }

    // 相机权限
    
    func checkVideoAuth() -> Bool {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return authStatus != .restricted && authStatus != .denied

        if (AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized) {
            print("有相机权限")
            return true
        }else {
            
//            print("无相机权限")
            let alertVC = UIAlertController(title: NSLocalizedString("openCameraTest", comment: ""), message: NSLocalizedString("openCamera", comment: ""), preferredStyle: .alert)
            let signInAction = UIAlertAction(title: NSLocalizedString("open", comment: ""), style: .default, handler: { action in

            })
            alertVC.addAction(signInAction)
            self.present(alertVC, animated: true, completion: nil)
            return false
        }
    }

    @objc func hiddlenAction() {

    }
    
    @objc func showAction() {

    }
    
    // MARK:-  数据界面设置
    func setDataUI(){
        for pv in productViews {
            pv.removeFromSuperview()
        }
        productViews.removeAll()
        for i in 0 ..< productData.produdtcs.count {
            let productView = loadNib("TEEProductView") as! TEEProductView

            productView.frame = CGRect(x: validCGFloat(70 * kProkScreenWidth), y: validCGFloat(300 * kProkScreenWidth) + validCGFloat(115 * i), width: validCGFloat(kScreenWidth - 150), height: 80.0)
            productView.product = productData.produdtcs[i]
            productView.productViewClick = { product in
                if product.from == "JD" {
                    if UIApplication.shared.canOpenURL(URL(fileURLWithPath: "openApp.jdMobile://")) {
                        let urlStr = "openApp.jdMobile://virtual?params={\"category\":\"jump\",\"des\":\"productDetail\",\"skuId\":\"\(validString(product.id))\",\"sourceType\":\"JSHOP_SOURCE_TYPE\",\"sourceValue\":\"JSHOP_SOURCE_VALUE\"}"
                        let encodeWord = (urlStr as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                        let url = URL(string: encodeWord!)
                        UIApplication.shared.open(url!, options: [:],
                                                  completionHandler: {
                                                    (success) in
                        })
                    }else {
                        self.clickProduct = product
                        self.performSegue(withIdentifier: SegueIdentifier.toTEEProductDetailHtml.rawValue, sender: self)
                    }
                }else {
                    self.clickProduct = product
                    self.performSegue(withIdentifier: SegueIdentifier.toTEEProductDetailHtml.rawValue, sender: self)
                }
            }
            self.view.addSubview(productView)
            productViews.append(productView)
        }
    }
    
    @IBAction func shipinAction(_ sender: Any) {
        dataType = 2
        shipinBtn.setTitleColor(RGBA(179, g: 142, b: 86, a: 1), for: UIControl.State.normal)
        shipinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        fuzhuanBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        fuzhuanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        UIView.animate(withDuration: 0.2) {
            self.lineView.frame = CGRect(x: self.shipinBtn.x, y: self.shangpinBtn.height - 1, width: self.shipinBtn.width, height: 1)
        }
        
    }
    
    @IBAction func fuzhuangAction(_ sender: Any) {
        dataType = 0
        fuzhuanBtn.setTitleColor(RGBA(179, g: 142, b: 86, a: 1), for: UIControl.State.normal)
        fuzhuanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        shipinBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        shipinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        shangpinBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        shangpinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        dianqi.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        dianqi.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        UIView.animate(withDuration: 0.2) {
            self.lineView.frame = CGRect(x: self.fuzhuanBtn.x, y: self.shangpinBtn.height - 1, width: self.fuzhuanBtn.width, height: 1)
        }
    }
    
    @IBAction func productAction(_ sender: Any) {
//        dataType = 0
////        shangpinBtn.setTitleColor(RGBA(179, g: 142, b: 86, a: 1), for: UIControl.State.normal)
////        shangpinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//        fuzhuanBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        fuzhuanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        shipinBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        shipinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
////        dianqi.setTitleColor(UIColor.white, for: UIControl.State.normal)
////        dianqi.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        UIView.animate(withDuration: 0.2) {
//            self.lineView.frame = CGRect(x: self.shangpinBtn.x, y: self.shangpinBtn.height - 1, width: self.shangpinBtn.width, height: 1)
//        }
    }
    
    @IBAction func dianqiAction(_ sender: Any) {
//        dataType = 3
//        dianqi.setTitleColor(RGBA(179, g: 142, b: 86, a: 1), for: UIControl.State.normal)
//        dianqi.titleLabel?.font = UIFont.systemFont(ofSize: 18)
//
//        shipinBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        shipinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        fuzhuanBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        fuzhuanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        shipinBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        shipinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        UIView.animate(withDuration: 0.2) {
//            self.lineView.frame = CGRect(x: self.dianqi.x, y: self.dianqi.height - 1, width: self.dianqi.width, height: 1)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for pv in productViews {
            pv.removeFromSuperview()
        }
        productViews.removeAll()
        self.uploadImageStatus = .Success
    }
}

// MARK:- 点击事件
extension TEEVideoViewController {
    
    @IBAction func changeCamalor(_ sender: Any) {
        // 1:获取之前的镜头
        guard var position = captureInput?.device.position else { return }
        
        // 2:获取当前显示的镜头
        position = position == .front ? .back : .front
        
        // 3:根据当前镜头创建新的device
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        guard let device = devices.filter({$0.position == position}).first else { return }
        
        // 4: 根据新的device创建新的input
        guard let videoInput = try? AVCaptureDeviceInput(device: device) else { return }
        
        // 4:在session中切换input
        session.beginConfiguration()
       

        do{
            session.removeInput(self.captureInput)
            session.addInput(videoInput)
            
        } catch let _ as NSError{
           
        }
        
        session.commitConfiguration()
        self.captureInput = videoInput
        
        // 获取输入与输出之间的连接
        let connection = captureOutput.connection(with: .video)
        // 设置采集数据的方向
        connection?.videoOrientation = .portrait;
        // 设置镜像效果镜像
        connection?.isVideoMirrored = false;
    }
    
    @IBAction func toCenterAction(_ sender: Any) {
        if validString(getUserDefautsData(kUserToken)) == ""{
            presentLoginVC { (data, error) in
                self.user.getUserDetail()
            }
        }else {
            self.performSegue(withIdentifier: SegueIdentifier.toTEECenter.rawValue, sender: self)
        }
    }
    
    // 选择照片
    @IBAction func choseImage(_ sender: Any) {
        
        if  isCanUsePhoto() {
            stopSession = true
            photoPickerViewController.sourceType = UIImagePickerController.SourceType.photoLibrary
            photoPickerViewController.delegate = self
            self.present(photoPickerViewController, animated: true, completion: nil)
        }else{
            let alertView: UIAlertController = UIAlertController(title: nil, message: kOpenPhotoMessage, preferredStyle: UIAlertController.Style.alert)
            alertView.addAction(UIAlertAction(title:"取消", style: UIAlertAction.Style.cancel, handler:nil))
            alertView.addAction(UIAlertAction(title:"去设置", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
                if let tmpUrl = URL(string:UIApplication.openSettingsURLString) {
                    if  UIApplication.shared.canOpenURL(tmpUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(tmpUrl, options:[:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(tmpUrl)
                        }
                    }
                }
            }))
            getCurrentVCBS().present(alertView, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cameraAction(_ sender: Any) {
        (sender as! UIButton).isEnabled = false
        stopSession = true
        session.stopRunning()
        for pv in productViews {
            pv.removeFromSuperview()
        }
        productViews.removeAll()
        
        TaskUtil.delayExecuting(1) {
            for pv in self.productViews {
                pv.removeFromSuperview()
            }
            self.productViews.removeAll()
        }
        
        if let image = customImgView.image {
            selectImage = image
            self.productData.uploadImage(image: image, dataType: self.dataType, callback: { (data, error) in
                (sender as! UIButton).isEnabled = true
                self.stopSession = false
                self.performSegue(withIdentifier: SegueIdentifier.toProduct.rawValue, sender: self)
            })
        }
    }
    
}




// MARK:- 遵从捕获元数据协议，可以监控到相关的捕获数据回调方法
extension TEEVideoViewController : AVCaptureMetadataOutputObjectsDelegate{
    //扫描二维码成功回调该方法
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        //扫码完成
        if metadataObjects.count > 0{
            
            if let resultObj = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
                //获取到二维码的数据，可以去处理自己的业务逻辑，比如此处假设我扫描的是一个连接，直接打开这个连接

                self.currentMetadata = metadataObjects as! NSMutableArray
                print(resultObj)
            }
        }
        
        
    }
    
}

//MARK:- 遵从捕获视频数据协议，可以监控到相关的捕获数据回调方法
extension TEEVideoViewController : AVCaptureVideoDataOutputSampleBufferDelegate{
    //捕获视频数据回调该方法
    private func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){

        let bounds = NSMutableArray(capacity: 0)
        for faceobject in self.currentMetadata{
            let face = output.transformedMetadataObject(for: faceobject as! AVMetadataObject, connection: connection)
            bounds.add(NSValue(cgRect: face!.bounds))
        }


        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        let ciImage = CIImage(cvImageBuffer: imageBuffer!)
        print("TEEOpenCVUtil.image(")
        TEEOpenCVUtil.image(fromCIImage: UIImage(ciImage: ciImage), imageview: self.customImgView, bounds: bounds, face: self.face)

//        TEEOpenCVUtil(fromPixelBuffer: imageBuffer, imageview: self.customImgView, bounds: bounds, face: self.face)

//        DispatchQueue.main.async {
//            self.customImgView.image = image
//        }

//        TEEOpenCVUtil.image(fromPixelBuffer: sampleBuffer, imageview: self.customImgView, bounds: bounds , face: self.face)

//        switch self.camaraType {
//        case .Fase?:
//            //调用你写在.mm文件中的OpenCV方法
//            //获取关键点，将脸部信息的数组 和 相机流 传进去
//            let facesLandmarks = face.deteciton(on: sampleBuffer, inRects: bounds)
//            // 绘制68 个关键点
//            break
//        case .Shopping?:
//            DispatchQueue.main.async {
//                self.customImgView.image = image
//                if self.uploadImageStatus == .Success {
//                    self.uploadImageStatus = .Uploading
//                    self.productData.uploadImage(image: image, dataType: self.dataType, callback: { (data, error) in
//                        //                    self.uploadImageStatus = .Success
//                        if data != nil {
//                            if self.stopSession != true {
//                                self.setDataUI()
//                            }
//                        }
//                    })
//                }
//            }
//            break
//        default:
//            break
//        }
    }
}

///打开闪光灯的方法
extension TEEVideoViewController {
    @objc func openLight(){
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        if device?.hasTorch == false{
            printX("闪光灯故障")
        }else{
            if device?.torchMode == AVCaptureDevice.TorchMode.off {
                do{
                    try device?.lockForConfiguration()
                    device?.torchMode = AVCaptureDevice.TorchMode.on
                    device?.unlockForConfiguration()
                }catch{
                    print(error)
                }
            }else {
                do{
                    try device?.lockForConfiguration()
                    device?.torchMode = AVCaptureDevice.TorchMode.off
                    device?.unlockForConfiguration()
                }catch{
                    print(error)
                    
                }
            }
        }
    }
}


extension TEEVideoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //获得照片
        if let image = info[.originalImage] as? UIImage {
            session.stopRunning()
            stopSession = true
            selectImage = image
            self.customImgView.image = image
            
            for pv in productViews {
                pv.removeFromSuperview()
            }
            productViews.removeAll()
            TaskUtil.delayExecuting(1) {
                for pv in self.productViews {
                    pv.removeFromSuperview()
                }
                self.productViews.removeAll()
            }

            self.productData.uploadImage(image: image, dataType: self.dataType, callback: { (data, error) in
                self.performSegue(withIdentifier: SegueIdentifier.toProduct.rawValue, sender: self)
            })
            picker.dismiss(animated: true, completion: nil)
            
            
        }else {
            picker.dismiss(animated: true, completion: nil)
            self.session.startRunning()
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        // 拍照
        session.startRunning()
    }
}

// MARK: - 跳转
extension TEEVideoViewController: SegueHandlerType {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch validString(segue.identifier) {
        case SegueIdentifier.toProduct.rawValue:
            let destVC = segue.destination as! TEEProductVC
            destVC.productData = self.productData
            destVC.selectImage = selectImage
            break
        case SegueIdentifier.toTEEProductDetailHtml.rawValue:
            let destVC = segue.destination as! TEEProductDetailHtml
            destVC.path = validString(self.clickProduct.url)
            break
        default:
            break
        }
    }
}

