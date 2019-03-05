//
//  TranstionAnimationPop.swift
//  转场动画
//
//  Created by 柯木超 on 2018/7/5.
//  Copyright © 2018年 Macoro. All rights reserved.
//

import UIKit

class TranstionAnimationPop: NSObject, UIViewControllerAnimatedTransitioning,CAAnimationDelegate{
    
    var transitionContext:UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        //不添加的话，屏幕什么都没有
        let containerView = transitionContext.containerView

        containerView.addSubview((fromVC?.view)!)
        containerView.addSubview((toVC?.view)!)

        let originRect:CGRect = CGRect.init(x: kScreenWidth/2, y: kScreenHeight/2, width: 50, height: 50)
        let maskStartPath = UIBezierPath.init(ovalIn: originRect)
        
        //OC中CGRectInset(originRect, -2000, -2000)的Swift用法:originRect.insetBy(dx: -2000, dy: -2000)
        let maskEndPath = UIBezierPath.init(ovalIn: originRect.insetBy(dx: -2000, dy: -2000))
        
        //创建一个CAShapeLayer来负责展示圆形遮盖
        let maskLayer = CAShapeLayer.init()
        //将他的path指定为最终的path，来避免在动画完成后回弹
        maskLayer.path = maskEndPath.cgPath
        
        toVC?.view.layer.mask = maskLayer
        
        let maskAnimation = CABasicAnimation.init(keyPath: "path")
        maskAnimation.fromValue = maskStartPath.cgPath
        maskAnimation.toValue = maskEndPath.cgPath
        maskAnimation.duration = self.transitionDuration(using: transitionContext)
        maskAnimation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeInEaseOut)
        maskAnimation.fillMode = CAMediaTimingFillMode.forwards
        maskAnimation.isRemovedOnCompletion = false
        maskAnimation.delegate = self
        maskLayer.add(maskAnimation, forKey: "path")
    }
    
    //MARK:----- CAAnimationDelegate
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!(self.transitionContext?.transitionWasCancelled)!)
        //去除mask
        self.transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)?.view.layer.mask = nil;
        self.transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.to)?.view.layer.mask = nil;
    }
    
    
}
