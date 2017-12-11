//
//  PageVC.swift
//  pageviewcontroller
//
//  Created by Nguyen Dinh Dung on 2017/10/18.
//  Copyright © 2017年 Nguyen Dinh Dung. All rights reserved.
//
import UIKit

class PageVC: UIPageViewController, UIPageViewControllerDataSource {
    var timer: Timer!
    var index: Int = 0
    let Slide1Controller : UIViewController = {
        let view = slide1Controller()
        view.view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let Slide2Controller : UIViewController = {
        let view = slide2Controller()
        view.view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let Slide3Controller : UIViewController = {
        let view = slide3Controller()
        view.view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var VCArr: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        VCArr = [Slide1Controller, Slide2Controller, Slide3Controller]
        if let firstVC = VCArr.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        runtimer()
        view.frame = self.view.frame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = self.view.frame
            } else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    func runtimer(){
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.pageSlide), userInfo: nil, repeats: true)
    }
    
    func pageSlide(){
        index += 1
        if index < VCArr.count {
            self.setViewControllers([VCArr[index]], direction: .forward, animated: true, completion: nil)
        }
        else {
            index = 0
            self.setViewControllers([VCArr[0]], direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return VCArr.last
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        }
        return VCArr[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex <= VCArr.count - 1 else {
            return VCArr.first
        }
        
        guard VCArr.count > nextIndex else {
            return nil
        }
        return VCArr[nextIndex]
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = VCArr.index(of: firstViewController) else {return 0 }
        return firstViewControllerIndex
    }
}

class slide1Controller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purple
    }
}

class slide2Controller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
    }
}

class slide3Controller: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
    }
}

