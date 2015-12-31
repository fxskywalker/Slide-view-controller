//
//  ViewController.swift
//  SlideViewController
//
//  Created by Anne Dong on 7/17/15.
//  Copyright (c) 2015 Anne Dong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var animator:CustomTransitionAnimation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let button:UIButton = UIButton(type: UIButtonType.Custom)
        button.frame = CGRectMake(0, 0, 120, 40)
        button.center = self.view.center
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.setTitle("Click Me", forState: UIControlState.Normal)
        button.addTarget(self, action: "onButtonTapped", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func onButtonTapped(){
        if(animator == nil){
            print("animator created")
            self.animator = CustomTransitionAnimation()
        }
        let vc:DetailViewController = DetailViewController()
        //设置可交互的ViewController，将为该ViewController添加手势交互
    
       
        vc.transitioningDelegate = self.animator;
        //self.animator!.setVC(vc)
        self.animator!.attachToViewController(vc)
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

}

