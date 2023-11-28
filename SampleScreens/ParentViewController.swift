//
//  ParentViewController.swift
//  PodsTester
//
//  Created by Saud Waqar on 08/09/2023.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
    }
}

class ParentViewController: BaseViewController {
    
    var maximumContainerHeight: CGFloat = UIScreen.main.bounds.height
    var currentContainerHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    
    var navController: UINavigationController?
    var topController: TopViewController?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var constraintPanner: NSLayoutConstraint!
    
    var onSuccess: ((String) -> ())?
    var onFailure: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(valueChange)))
        
        self.setupTopBar()
        
//        self.addPanGesture()
        
//        self.onSuccess = { string in
//            print("onSuccess received \(string)")
//        }
//
//        self.onFailure = { string in
//            print("onFailure received \(string)")
//        }
    }
    
    func myOnSuccess(_ string: String) {
        print("\(#function) \(string)")
    }
    
    func myOnFailure(_ string: String) {
        print("\(#function) \(string)")
    }
    
    func onUpdate(_ string: String) {
        print("\(#function) \(string)")
    }
    
    @objc func valueChange() {
        self.onSuccess?(UUID().uuidString)
        self.onFailure?(UUID().uuidString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupConstraints()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(#function)
        if segue.identifier == "mySegue" {
            guard let nav = segue.destination as? UINavigationController,
                  let destination = nav.topViewController as? FirstViewController else {return}
            self.navController    = nav
            destination.delegate  = self
            destination.onSuccess = self.onSuccess
            destination.onFailure = self.onFailure
        } else if segue.identifier == "topView" {
            guard let destination = segue.destination as? TopViewController else {return}
            destination.delegate    = self
            destination.floDelegate = self
            topController           = destination
            
            destination.onUpdate    = self.onUpdate
        }
    }
    
    private func setupTopBar() {
        let path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSizeMake(20, 20))
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
    }
    
    @objc func doneCalled() {
        self.dismiss(animated: true) {
            self.mainView.removeFromSuperview()
        }
    }
    
    private func addPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        
        self.mainView.addGestureRecognizer(panGesture)
    }
    
    private func getSize(_ size: ScreenSizes) -> CGFloat{
        switch size {
        case .fullScreen:
            return 50
            //            return 0
        case .halfScreen:
            return UIScreen.main.bounds.height * 0.4
        }
    }
    
    private func setupConstraints() {
        self.maximumContainerHeight = UIScreen.main.bounds.height - self.view.safeAreaInsets.top
        self.constraintPanner.constant = self.getSize(.halfScreen)
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let newHeight = currentContainerHeight + translation.y
        
        switch gesture.state {
        case .changed:
            if self.mainView.bounds.height < maximumContainerHeight, newHeight < maximumContainerHeight {
                self.constraintPanner.constant = newHeight
                view.layoutIfNeeded()
            }
            
        case .ended:
            switch self.mainView.bounds.height {
            case (UIScreen.main.bounds.height * 0.7..<UIScreen.main.bounds.height):
                animateContainerHeight(getSize(.fullScreen))
            case (UIScreen.main.bounds.height * 0.3..<UIScreen.main.bounds.height * 0.7):
                animateContainerHeight(getSize(.halfScreen))
            default:
                animateContainerHeight(getSize(.halfScreen))
            }
        default:
            break
        }
    }
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.constraintPanner?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    deinit {
        print("\(#function) was called here")
    }
    
}

extension ParentViewController: SendDataSDK {
    func sendStringData(string: String) {
        guard let topController = topController else {return}
        DispatchQueue.main.async {
            switch string {
            case "OneViewController", "TwoViewController", "ThreeViewController":
                topController.setupTopView(isFirst: false, string)
            case "me":
                topController.setupTopView(isFirst: true, string)
            default:
                print("\(#function) default ran")
            }
        }
    }
}

extension ParentViewController: TopViewActionsSDK {
    func actionBack() {
        self.navController?.popViewController(animated: true)
    }
    
    func actionCross() {
        self.doneCalled()
    }
    
    func actionSwipeUp() {
        self.animateContainerHeight(getSize(.fullScreen))
    }
    
    func actionSwipeDown() {
        self.animateContainerHeight(getSize(.halfScreen))
    }
}

enum ScreenSizes {
    case fullScreen
    case halfScreen
}

protocol SendDataSDK {
    func sendStringData(string: String)
}

protocol TopViewActionsSDK {
    func actionBack()
    func actionCross()
    func actionSwipeUp()
    func actionSwipeDown()
}
