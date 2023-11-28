//
//  TestingViewController.swift
//  PodsTester
//
//  Created by Saud Waqar on 08/09/2023.
//

import UIKit

class TestingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .clear
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            let mas = self.storyboard!.instantiateViewController(withIdentifier: "AnotherViewController")
//            self.navigationController?.pushViewController(mas, animated: true)
            
            let mas = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AnotherViewController")
//            let nav = UINavigationController(rootViewController: mas)
            
//            nav.pushViewController(mas, animated: true)
            self.navigationController?.pushViewController(mas, animated: true)
//            self.present(nav, animated: true)
            
//            self.navigationController?.pushViewController(nav, animated: true)

            
        }


    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
