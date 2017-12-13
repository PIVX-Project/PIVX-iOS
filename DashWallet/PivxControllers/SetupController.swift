//
//  SetupController.swift
//  BreadWallet
//
//  Created by German Mendoza on 9/22/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

import UIKit

@objc class SetupController: BaseController {
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    var currentPage = 0
    
    override func setup() {
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = .white
        scrollViewHeightConstraint.constant = K.main.width * 4
        guard let step1 = Bundle.main.loadNibNamed("Step1View", owner: self, options: nil)?.first as? UIView,
        let step2 = Bundle.main.loadNibNamed("Step2View", owner: self, options: nil)?.first as? UIView,
        let step3 = Bundle.main.loadNibNamed("Step3View", owner: self, options: nil)?.first as? UIView,
        let step4 = Bundle.main.loadNibNamed("Step4View", owner: self, options: nil)?.first as? UIView else { return }
        
        containerView.addSubview(step1)
        containerView.addSubview(step2)
        containerView.addSubview(step3)
        containerView.addSubview(step4)
        step1.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 120, rightConstant: 0, widthConstant: K.main.width, heightConstant: 0)
        step2.anchor(containerView.topAnchor, left: step1.rightAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 120, rightConstant: 0, widthConstant: K.main.width, heightConstant: 0)
        step3.anchor(containerView.topAnchor, left: step2.rightAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 120, rightConstant: 0, widthConstant: K.main.width, heightConstant: 0)
        step4.anchor(containerView.topAnchor, left: step3.rightAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 120, rightConstant: 0, widthConstant: K.main.width, heightConstant: 0)
    }
    
    override func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func toGenerate(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "BRWelcomeController")
        navigationController?.show(controller, sender: nil)
    }

    @IBAction func tappedSkipButton(_ sender: Any) {
        toGenerate()
    }
    @IBAction func tappedNextButton(_ sender: Any) {
        if currentPage >= 3 {
            toGenerate()
            return
        }
        currentPage += 1
        pageControl.currentPage = currentPage
        scrollView.setContentOffset(CGPoint(x:K.main.width*CGFloat(currentPage),y:0), animated: true)
    }
}

extension SetupController:UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        pageControl.currentPage = Int(currentPage);
        self.currentPage = Int(currentPage);
    }
}
