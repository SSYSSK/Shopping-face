//
//  SSTAlertView.swift
//  sst-ios
//
//  Created by Amy on 16/8/29.
//  Copyright © 2016年 SST. All rights reserved.
//


// func showCustomAlert(sender: AnyObject) {
// let alertView = YNAlertView(title: "网络错误", message: "Notifications may include alerts, sounds,and icon badges.these can be configured in settings")
// alertView.addButton("取消") {
// print("取消...")
// }
// alertView.addButton("确定") {
// print("确定...")
// }
// alertView.show()
// }
// 


// or use this demo https://github.com/almas-dev/APMAlertController

import UIKit

enum SSTAlertViewStyle: Int {
    case `default`
    case plainTextInput

}
typealias SSTAction = ()->Void

class ABCAlertView: UIView {
    var title: String? {
        set {
            if newValue != nil {
                if titleLabel == nil {
                    titleLabel = self.initialTitleLabel()
                    if let tmpLabel = titleLabel {
                        self.addSubview(tmpLabel)
                    }
                }
                
                titleLabel?.text = newValue
                let newSize = sizeWithFont(titleFont, maxWidth:CGFloat(validDouble(titleLabel?.frame.size.width)), text: newValue)
                let titleFrame = titleLabel?.frame
                titleLabel?.frame = CGRect(x: validDouble(titleFrame?.origin.x), y: validDouble(titleFrame?.origin.y), width: validDouble(titleFrame?.size.width), height: validDouble(newSize.height))
            }
        }
        get {
            return self.title
        }
    }
    
    var message: String? {
        set {
            if newValue != nil {
                if messageLabel == nil {
                    messageLabel = self.initialMessageLabel()
                    if let tmpLabel = messageLabel {
                        self.addSubview(tmpLabel)
                    }
                }
                
                messageLabel?.text = newValue
                let newSize = sizeWithFont(messageFont, maxWidth:CGFloat(validDouble(messageLabel?.frame.size.width)), text: newValue)
                let messageFrame = messageLabel?.frame
                messageLabel?.frame = CGRect(x: validDouble(messageFrame?.origin.x), y: validDouble(messageFrame?.origin.y), width: validDouble(messageFrame?.size.width), height: validDouble(newSize.height))
            }
        }
        get {
            return self.message
        }
    }

    let alertWidth: CGFloat = 270.0
    let buttonHeight: CGFloat = 44.0
    let windowFrame = UIScreen.main.bounds
    let lineColorHex: UInt = 0xCCCCCC
    
    let kPaddingTop: CGFloat = 20.0
    let kPaddingLeft: CGFloat = 20.0
    let kPaddingRight: CGFloat = 20.0
    let kPaddingBottom: CGFloat = 20.0
    
    var titleLabel: UILabel?
    var messageLabel: UILabel?
    let titleFont = UIFont.systemFont(ofSize: 16)
    let messageFont = UIFont.systemFont(ofSize: 13)
    
    var buttons = [UIButton]()
    var actions = [SSTAction]()
    var alertViewWindow: SSTAlertViewWindow!
    var alertViewStyle: SSTAlertViewStyle?
    
    init(title: String?, message: String?) {
        super.init(frame: CGRect.zero)
        self.title = title
        self.message = message
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialTitleLabel() -> UILabel {
        let maxWidthOfContent = alertWidth - kPaddingLeft - kPaddingRight
        let titleFrame = CGRect(x: kPaddingLeft, y: kPaddingTop, width: maxWidthOfContent, height: 20)
        
        titleLabel = UILabel(frame: titleFrame)
        titleLabel?.textAlignment = NSTextAlignment.center
        titleLabel?.font = titleFont
        titleLabel?.numberOfLines = 0
        titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        // titleLabel?.backgroundColor = UIColor.redColor()
        
        return titleLabel!
    }

    func initialMessageLabel() -> UILabel {
        var messageLabelY: CGFloat = kPaddingTop
        if let titleLabel = self.titleLabel {
            messageLabelY += titleLabel.frame.size.height
        }
        
        let maxWidthOfContent = alertWidth - kPaddingLeft - kPaddingRight
        let messageFrame = CGRect(x: kPaddingLeft, y: messageLabelY, width: maxWidthOfContent, height: 18)
        
        messageLabel = UILabel(frame: messageFrame)
        messageLabel?.textAlignment = NSTextAlignment.center
        messageLabel?.font = messageFont
        messageLabel?.numberOfLines = 0
        messageLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        // messageLabel?.backgroundColor = UIColor.greenColor()
        
        return messageLabel!
    }

    func setup() {
        self.frame = CGRect(x: 0.0, y: 0.0, width: alertWidth, height: 0.0)
        self.center = CGPoint(x: windowFrame.size.width/2, y: windowFrame.size.height/2)
        self.backgroundColor = UIColorFromRGB(0xFFFFFF)
        self.layer.cornerRadius = 7
        self.layer.masksToBounds = true
        
        alertViewStyle = SSTAlertViewStyle.default
    }

    func addButton(_ title: String?, action:@escaping SSTAction) {
        let button = UIButton()
        
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(UIColorFromRGB(0x1062FF), for: UIControl.State())
        button.setBackgroundImage(imageWithColor(UIColorFromRGB(0xE6E6E6)), for: UIControl.State.highlighted)   // 230 230 230
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(ABCAlertView.buttonClicked(_:)), for: UIControl.Event.touchUpInside)
        button.tag = buttons.count
        buttons.append(button)
        actions.append(action)
        self.addSubview(button)
        
        refreshButtonFrame()
    }

    @objc func buttonClicked(_ sender: AnyObject) {
        let button = sender as! UIButton
        let action = actions[button.tag]
        action()
        dismiss()
    }
    
    func show() {
        if alertViewWindow == nil {
            alertViewWindow = SSTAlertViewWindow(frame: windowFrame)
        }
        
        if alertViewWindow.isHidden {
            alertViewWindow.isHidden = false
        }
        
        alertViewWindow.addSubview(self)
        alertViewWindow.makeKeyAndVisible()
        
        self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2);
        alertViewWindow.alpha = 0
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform.identity
            self.alertViewWindow.alpha = 1
            }, completion: nil)
    }
    
    func dismiss() {
        self.removeFromSuperview()
        alertViewWindow.alpha = 1
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: { () -> Void in
            self.alertViewWindow.alpha = 0
        }) { (completion) -> Void in
            self.alertViewWindow.isHidden = true
            self.alertViewWindow.alpha = 1
        }
    }
    
    func refreshButtonFrame() {
        let count = buttons.count
        let contentHeight = heightOfTopContent()
        resetFrame(count, contentHeight: contentHeight)
        
        if count == 1 {
            let firstButton =  buttons[0] as UIButton
            let buttonFrame = CGRect(x: 0.0, y: contentHeight, width: self.frame.size.width, height: buttonHeight)
            firstButton.frame = buttonFrame
        } else if count == 2 {
            let firstButton =  buttons[0] as UIButton
            var buttonFrame = CGRect(x: 0.0, y: contentHeight, width: self.frame.size.width/2, height: buttonHeight)
            firstButton.frame = buttonFrame
            
            let secondButton =  buttons[1] as UIButton
            buttonFrame = CGRect(x: self.frame.size.width/2, y: contentHeight, width: self.frame.size.width/2, height: buttonHeight)
            secondButton.frame = buttonFrame
        } else {
            for (index, button) in buttons.enumerated() {
                let frame: CGRect = CGRect(
                    x: 0.0,
                    y: self.frame.size.height - self.buttonHeight * CGFloat(count - index),
                    width: self.frame.size.width,
                    height: self.buttonHeight)
                
                button.frame = frame
            }
        }
        
        self.setNeedsDisplay()
    }

    func heightOfTopContent() -> CGFloat {
        let paddingHeight = kPaddingTop + kPaddingBottom
        var contentHeight = paddingHeight
        
        if let titleLabel = self.titleLabel {
            contentHeight += titleLabel.frame.size.height
        }
        
        if let messageLabel = self.messageLabel {
            contentHeight += messageLabel.frame.size.height
        }
        
        switch alertViewStyle! {
        case SSTAlertViewStyle.default:
            return contentHeight
        case SSTAlertViewStyle.plainTextInput:
            return paddingHeight + 0    // UITextFiled height
//        default:
//            return paddingHeight
        }
    }

    func resetFrame(_ count: Int, contentHeight: CGFloat) {
        if count == 1 || count == 2 {
            self.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: contentHeight + buttonHeight)
            self.center = CGPoint(x: windowFrame.size.width/2, y: windowFrame.size.height/2)
        } else {
            self.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: contentHeight + CGFloat(count - 1) * buttonHeight)
            self.center = CGPoint(x: windowFrame.size.width/2, y: windowFrame.size.height/2)
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            
            context.setLineWidth(0.5)
            context.setStrokeColor(UIColorFromRGB(lineColorHex).cgColor)
            
            if buttons.count == 2 {
                // Horizontal line
                let horizontalLineY = rect.size.height-buttonHeight
                context.move(to: CGPoint(x: 0.0, y: horizontalLineY))
                context.addLine(to: CGPoint(x: rect.size.width, y: horizontalLineY))
                // Vertical line
                context.move(to: CGPoint(x: rect.size.width/2, y: horizontalLineY))
                context.addLine(to: CGPoint(x: rect.size.width/2, y: rect.size.height))
            } else {
                // Horizontal line
                for i in 0..<buttons.count {
                    let horizontalLineY = self.frame.size.height - buttonHeight * CGFloat(buttons.count - i)
                    context.move(to: CGPoint(x: 0.0, y: horizontalLineY))
                    context.addLine(to: CGPoint(x: rect.size.width, y: horizontalLineY))
                }
            }
            
            context.strokePath()
        }
    }

    // http://stackoverflow.com/questions/18897896/replacement-for-deprecated-sizewithfont-in-ios-7
    func sizeWithFont(_ font: UIFont, maxWidth: CGFloat, text: String?) -> CGSize {
        if let text = text {
            let content = text as NSString
            let rect = content.boundingRect(
                with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: font],
                context: nil)
            return rect.size
        }
        return CGSize.zero
    }
    
    // Helper function to convert from RGB to UIColor
    func UIColorFromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size);
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
            
            if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return image
            }
        }
        return UIImage()
    }

}

// Background window
class SSTAlertViewWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

