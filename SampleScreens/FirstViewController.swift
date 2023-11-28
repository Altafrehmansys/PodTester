//
//  FirstViewController.swift
//  TesterSDKSampler
//
//  Created by Saud Waqar on 06/09/2023.
//

import UIKit

class FirstViewController: BaseViewController {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var imgToChange: UIImageView!
    
    var delegate: SendDataSDK?
    
    var onSuccess: ((String) -> ())?
    var onFailure: ((String) -> ())?
    
    var myBool = false {
        didSet {
            DispatchQueue.main.async {
                self.imgToChange.image = self.data[self.myBool]
            }
        }
    }
    
    let data: [Bool: UIImage] = [
        true: UIImage(named: "arrow-right-with-background")!,
        false: UIImage(named: "bag-tick")!,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewTop.backgroundColor = .gray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.delegate?.sendStringData(string: "me")
        self.onFailure?("viewWillAppear FirstVC")
        self.onSuccess?("viewWillAppear FirstVC")
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func actionTapHere(_ sender: UIButton!) {
        self.myBool.toggle()
        
        let mas = UIStoryboard(name: "Other", bundle: Bundle.main).instantiateViewController(withIdentifier: "TwoViewController") as! TwoViewController
        mas.delegate  = self.delegate
        mas.onSuccess = self.onSuccess
        mas.onFailure = self.onFailure
        self.navigationController?.pushViewController(mas, animated: true)
    }
}


//extension Bundle {
//    static var main: Bundle {
//        return Bundle(identifier: "com.prodFramework.TesterSDKSampler") ?? Bundle.main
//    }
//}
extension UIImage {
    convenience init?(named name: String) {
        self.init(named: name, in: Bundle(identifier: "com.prodFramework.TesterSDKSampler")!, compatibleWith: nil)
    }
}
