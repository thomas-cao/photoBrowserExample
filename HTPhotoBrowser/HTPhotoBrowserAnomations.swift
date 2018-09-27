//
//  HTPhotoBrowserAnomations.swift
//  photoBrowserExample
//
//  Created by 魏小庄 on 2017/11/26.
//  Copyright © 2017年 魏小庄. All rights reserved.
//

import UIKit

protocol animationForPresentDelegate: NSObjectProtocol {
    func startRect(indePath: IndexPath) -> CGRect
    func endRect(indePath: IndexPath) -> CGRect
    func placeholderImage(indePath: IndexPath) -> UIImageView
}
protocol animationForDismassDelegate: NSObjectProtocol {
    func indexPathForDismassView() -> IndexPath
    func indexPathForCurrentImage() -> UIImageView
}

class HTPhotoBrowserAnomations: NSObject {
    // 定义变量记录显示&消失
    fileprivate var isPresented : Bool = false
  // 定义显示和消失的代理
   weak open var presentDelegate: animationForPresentDelegate?
   weak open var dismassDelegate: animationForDismassDelegate?
    
    open var selectedIdx: IndexPath?
    
}

//MARK: - 遵守自定义动画的代理方法，返回显示动画和隐藏动画的执行者
extension HTPhotoBrowserAnomations: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension HTPhotoBrowserAnomations: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentView(transitionContext) : animationForDismassView(transitionContext)
    }
}

extension HTPhotoBrowserAnomations{
    
    fileprivate func animationForPresentView(_ context: UIViewControllerContextTransitioning){
        // 校验空值
        guard let delegate = presentDelegate, let idx = selectedIdx else {
            return
        }
        let presentView = context.view(forKey: UITransitionContextViewKey.to)!
        context.containerView.addSubview(presentView)
        // 获取开始位置，和占位图片
        let startRect = delegate.startRect(indePath: idx)
        let tempImageV = delegate.placeholderImage(indePath: idx)
        
        // 将占位图片添加到容器
        context.containerView.addSubview(tempImageV)
        // 设置临时图片的开始位置
        tempImageV.frame = startRect
        presentView.alpha = 0.0
        context.containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: context), animations: {
            tempImageV.frame = delegate.endRect(indePath: idx)
             context.containerView.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        }) { (_) in
            tempImageV.removeFromSuperview()
            presentView.alpha = 1.0
            context.containerView.backgroundColor = .clear
            context.completeTransition(true)
        }
    }
    
    fileprivate func animationForDismassView(_ context: UIViewControllerContextTransitioning){
        guard let disDelegate = dismassDelegate, let prenDelegate = presentDelegate else {
            return
        }
        let dismassVIew = context.view(forKey: UITransitionContextViewKey.from)
        dismassVIew?.removeFromSuperview()
        
        // 代理获取当前的图片，和下标
        let tempImage = disDelegate.indexPathForCurrentImage()
        let currentIdx = disDelegate.indexPathForDismassView()
        
        // 将当前占位图片添加到容器
        context.containerView.addSubview(tempImage)
//        context.containerView.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        UIView.animate(withDuration: transitionDuration(using: context), animations: {
            // 设置回归位置
            tempImage.frame = prenDelegate.startRect(indePath: currentIdx)
            context.containerView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        }) { (_) in
            tempImage.removeFromSuperview()
            context.completeTransition(true)
        }
        
    }
}
