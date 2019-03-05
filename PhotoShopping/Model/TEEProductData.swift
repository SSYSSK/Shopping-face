//
//  TEEProductData.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/14.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit


class TEEProductData: BaseModel {

    var produdtcs = [TEEProduct]()
    
    func update(dict: Dictionary<String, Any>) {
        produdtcs.removeAll()
        let array = validArray(dict["goodsInfo"])
        for info in array {
            if let product = TEEProduct(JSON:validDictionary(info)) {
                produdtcs.append(product)
            }
        }
    }
    
    func updateP(array: Array<Any>) {
        produdtcs.removeAll()
        for info in array {
            if let product = TEEProduct(JSON:validDictionary(info)) {
                if produdtcs.count >= 3 {
                    return
                }else {
                    produdtcs.append(product)
                }
            }
        }
        
    }
    
    func getProductList(productsId:[String]) {
        let pIds = "55398,54910,54407,55014,47313"
        biz.getProductList(products: pIds) { (data, error) in
            self.update(dict: validDictionary(validDictionary(data)))
            self.delegate?.refreshUI(self)
        }
    }
    
    func uploadImage(image:UIImage, dataType:Int, callback: @escaping RequestCallBack){
        let baseImage = imageToBase64String(image: image) //resizeImage(originalImg: image)
        if baseImage != nil {
            
            biz.uploadImage(image: baseImage!, dataType: dataType) { (data, error) in

                self.updateP(array: validArray(data))
                callback(self,error)
            }
        }else {
            printX("图片转换出错")
            callback(nil,"error")
        }
        
//        biz.uploadImage(image: image) { (data, error) in
//            callback(data,error)
//        }
        
//        biz.uploadImage(imageData: resizeImage(originalImg: image)) { (data, error) in
//            callback(data,error)
//        }
    }
    
    ///传入图片image回传对应的base64字符串,默认不带有data标识,
    func imageToBase64String(image:UIImage)->String?{
        
        let imageMin = image.scale(rate: 0.17)
        printX("imageMin===\(imageMin)")
//        imageMin = UIImage(named: "4321")!
        ///根据图片得到对应的二进制编码
        guard let imageData = imageMin.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        
//        let imageData  = resetImgSize(sourceImage: image, maxImageLenght: 150, maxSizeKB: 150)
        
        //根据二进制编码得到对应的base64字符串
        let base64String = imageData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String
    }
    
    func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
        
        var maxSize = maxSizeKB
        
        var maxImageSize = maxImageLenght

        if (maxSize <= 0.0) {
            maxSize = 1024.0;
        }
        
        if (maxImageSize <= 0.0)  {
            
            maxImageSize = 1024.0;
            
        }
        //先调整分辨率
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        
        let tempHeight = newSize.height / maxImageSize;
        
        let tempWidth = newSize.width / maxImageSize;
        
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            
            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
            
        }
            
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            
            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
            
        }
        
        UIGraphicsBeginImageContext(newSize)
        
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
//        var imageData = UIImageJPEGRepresentation(newImage!, 1.0)
        let imageData = newImage?.jpegData(compressionQuality: 1.0)
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        
        //调整大小
        
        var resizeRate = 0.9;
        
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            
//            imageData = UIImageJPEGRepresentation(newImage!,CGFloat(resizeRate));
            newImage?.jpegData(compressionQuality: validCGFloat(resizeRate))
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            
            resizeRate -= 0.1;
            
        }
        return imageData!
    }
}
