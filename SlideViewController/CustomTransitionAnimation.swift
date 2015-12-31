//
//  CustomTransitionAnimation.swift
//  SlideViewController
//
//  Created by Anne Dong on 7/17/15.
//  Copyright (c) 2015 Anne Dong. All rights reserved.
//

import UIKit

enum CCAnimationType: Int {
    case CCAnimationTypePresent
    case CCAnimationTypeDismiss
}
 
class CustomTransitionAnimation: NSObject,UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate  {
    var  presentingVC:UIViewController!
    
    var  animationType:CCAnimationType!
    var  interacting:Bool!
    var interactiveTransition:UIPercentDrivenInteractiveTransition!
    //var className:AnyClass
    
    var reverse: Bool = true
    
    func attachToViewController(viewController: UIViewController) {
        //self.className = className
        //println(className)
        self.presentingVC = viewController
        setupGestureRecognizer(viewController.view)
    }
    
    private func setupGestureRecognizer(view: UIView) {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
    }
    
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        //println("duration");
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
         //println("here")
        //获取containerView视图
        let containerView:UIView  = transitionContext.containerView()!
        
        if (self.animationType == CCAnimationType.CCAnimationTypePresent) {
            /*弹出动画*/
            //获取新的Present视图
           // println(self.animationType)
            let toVc:UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            //对要Present出来的视图设置初始位置
            let  boundsRect:CGRect = UIScreen.mainScreen().bounds
            let finalFrame:CGRect = transitionContext.finalFrameForViewController(toVc)
            toVc.view.frame = CGRectOffset(finalFrame, 0, boundsRect.size.height);
            //添加Present视图
            containerView.addSubview(toVc.view)
            //UIView动画切换,在这里用Spring动画做效果
            let interval:NSTimeInterval = self.transitionDuration(transitionContext)
            UIView .animateWithDuration(interval, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveLinear, animations: {
                toVc.view.frame = finalFrame
                }, completion: {
                    //通知动画已经完成
                    finished in transitionContext.completeTransition(true)
            })
            
            
        }else if (self.animationType == CCAnimationType.CCAnimationTypeDismiss) {
            /*消失动画*/
            //获取已经在最前的Present视图
            let fromVc:UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
            //获取Dismiss完将要显示的VC
            let toVc:UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
            toVc.view.alpha = 0.2
            //在Present视图下面插入视图
            containerView.insertSubview(toVc.view, belowSubview: fromVc.view)
            //设置最终位置
            let boundsRect:CGRect = UIScreen.mainScreen().bounds
            let originFrame:CGRect = transitionContext.initialFrameForViewController(fromVc)
            let finalFrame:CGRect = CGRectOffset(originFrame, 0, boundsRect.size.height);
            //UIView动画切换
            let interval:NSTimeInterval = self.transitionDuration(transitionContext)
            
            UIView .animateWithDuration(interval, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                
                fromVc.view.frame = finalFrame;
                toVc.view.alpha = 1
                }, completion: {
                    //通知动画已经完成
                    finished in
                    //self.presentingVC as! className
                    print(self.presentingVC)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
        
        
//        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
//        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
//        let toView = toViewController.view
//        let fromView = fromViewController.view
//        let direction: CGFloat = reverse ? -1 : 1
//        let const: CGFloat = -0.005
//        
//        toView.layer.anchorPoint = CGPointMake(0.5 , direction == 1 ? 0 : 1)
//        fromView.layer.anchorPoint = CGPointMake(0.5, direction == 1 ? 1 : 0)
//        
//        var viewFromTransform: CATransform3D = CATransform3DMakeRotation(-direction * CGFloat(M_PI_2), 1.0, 0.0, 0.0)
//        var viewToTransform: CATransform3D = CATransform3DMakeRotation(direction * CGFloat(M_PI_2), 1.0, 0.0, 0.0)
//        viewFromTransform.m34 = const
//        viewToTransform.m34 = const
//        
//        containerView.transform = CGAffineTransformMakeTranslation(0, direction * containerView.frame.size.height / 2.0 )
//        toView.layer.transform = viewToTransform
//        containerView.addSubview(toView)
//        
//        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
//            containerView.transform = CGAffineTransformMakeTranslation(0, -direction * containerView.frame.size.height / 2.0)
//            fromView.layer.transform = viewFromTransform
//            toView.layer.transform = CATransform3DIdentity
//            }, completion: {
//                finished in
//                containerView.transform = CGAffineTransformIdentity
//                fromView.layer.transform = CATransform3DIdentity
//                toView.layer.transform = CATransform3DIdentity
//                fromView.layer.anchorPoint = CGPointMake(0.5, 0.5)
//                toView.layer.anchorPoint = CGPointMake(0.5, 0.5)
//                
//                if (transitionContext.transitionWasCancelled()) {
//                    toView.removeFromSuperview()
//                } else {
//                    fromView.removeFromSuperview()
//                }
//                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
//        })
    }
    
    func handlePan(gesture:UIPanGestureRecognizer)
    {
        let tranlation:CGPoint = gesture.translationInView(presentingVC.view)
        switch gesture.state {
            case UIGestureRecognizerState.Began:
                //设置交互标识为true
                self.interacting = true;
                //生成UIPercentDrivenInteractiveTransition对象
                self.interactiveTransition = UIPercentDrivenInteractiveTransition()
                //DismissViewController
                presentingVC.dismissViewControllerAnimated(true, completion: nil)
                break;
        case UIGestureRecognizerState.Changed:
            //计算当前百分比值
            var percent:CGFloat = tranlation.y / CGRectGetHeight(presentingVC.view.frame)
            percent = min(max(0.0, percent), 1.0)
            //用updateInteractiveTransition通知更新的百分比
            self.interactiveTransition.updateInteractiveTransition(percent)
            break;
        case UIGestureRecognizerState.Ended:
        //case UIGestureRecognizerState.Cancelled:
                //设置交互标识为false
                self.interacting = false
                //判断是否完成交互
                if tranlation.y > 200 && gesture.state != UIGestureRecognizerState.Cancelled {
                    print("finish");
                    self.interactiveTransition.finishInteractiveTransition()
                }else{
                    self.interactiveTransition.cancelInteractiveTransition()
                }
                //置空UIPercentDrivenInteractiveTransition对象
                self.interactiveTransition = nil;
            break;
        default:
            break;
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animationType = CCAnimationType.CCAnimationTypeDismiss
        return self
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animationType = CCAnimationType.CCAnimationTypePresent
        return self
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
   
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (self.interacting != nil) ? self.interactiveTransition :nil
    }
    
    
}
