import UIKit
import eMoneySDK

//import TesterSDKSampler
enum Language {
    case en
    case ar
    
    var title: String {
        switch self {
        case .en:
            return "English"
        case .ar:
            return "Arabic"
        }
    }
}

class ViewController: UIViewController {
    
    let fBundleName = Bundle(identifier: "com.app.taskLocalTester.asdf.asdf.asdf.eMoneySDK")
    var selectedLang: Language = .en
    @IBOutlet private var msisdnTextField: UITextField!
    @IBOutlet private var stagingButton: UIButton!
    @IBOutlet private var preProdButton: UIButton!
    var eWalletSDK: EWalletSDK?
    var selectedEnvironment: Environment!
    var configuration: EWalletConfiguration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msisdnTextField.text = "+971543934880"
        stagingButton.layer.cornerRadius = 7
        stagingButton.layer.masksToBounds = true
        preProdButton.layer.cornerRadius = 7
        preProdButton.layer.masksToBounds = true
        selectPreProd(true)
        selectStaging(false)
        
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(backgroundTapped(_:))))
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
      guard let selectedDot = sender.view else { return }
        self.view.endEditing(true)
    }
    
    func selectedTheme() -> EWalletTheme? {
//        let theme = EWalletTheme()
//        // View Background color in while app
//            .setBackgroundColor(.black)
//        // Toolbar theme that contain handler(navigation item) color, navigation title color and navigation secondary title color
//            .setToolbarTheme(EWalletToolbarTheme(handlerColor: .white, primaryTitleColor: .white, secondaryTitleColor: .lightGray))
//        // Content theme contains heading labels color and notes labels color
//            .setContentTheme(.init(headingColor: .white, notesColor: .lightGray))
//        // Edit Text theme contains active text color, inactive text color, active border color, inactive border color, hint(placeholder) color and separator(In Pin field) color
//            .setEditTextTheme(editTextTheme: EWalletEditTextTheme(activeTextColor: .white, inActiveTextColor: .lightGray, activeBorderColor: .lightGray, inActiveBorderColor: .darkGray, hintColor: .lightGray, separatorColor: .lightGray))
//        // Primary button theme contains background gradient color, text color and button title font
//        // Note all the secondary button will primary background color for titles
//            .setPrimaryButtonTheme(EWalletButtonTheme(backgroundColor: (primary: .red, secondary: .red.withAlphaComponent(0.5)), textColor: .white))
//        // Activity Indivator (Progress) color
//            .setActivityIndicatorColor(.white)
//        // All the status that contains error, success and warnings
//            .setStatusTheme(EStatusTheme(errorTextColor: .red, errorIconColor: .red, successColor: .green))
//        // List background color, that color will use be used for highlighting some list items
//            .setListBackgroundColor(.darkGray)
//        // Visibility Toggles (show/hide button) color
//            .setVisibilityToggleTextColor(.red)
//        // Segment bar selected and unselected color
//            .setSegmentBarTheme(EWalletSegmentBarTheme(selectedColor: .red, unSelectedColor: .gray))
//
//        return theme
        return nil
    }
    
    func selectPreProd(_ isSelected: Bool) {
        if isSelected {
            selectedEnvironment = .preprod
            if #available(iOS 13.0, *) {
                self.preProdButton.setImage(UIImage(named:"tick")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            preProdButton.backgroundColor = .red
        } else {
            preProdButton.setImage(UIImage(named:"defaultCheckbox"), for: .normal)
            preProdButton.backgroundColor = .clear
        }
    }
    
    func selectStaging(_ isSelected: Bool) {
        if isSelected {
            selectedEnvironment = .staging
            if #available(iOS 13.0, *) {
                self.stagingButton.setImage(UIImage(named:"tick")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            stagingButton.backgroundColor = .red
        } else {
            stagingButton.setImage(UIImage(named:"defaultCheckbox"), for: .normal)
            stagingButton.backgroundColor = .clear
        }
    }
    
    @IBAction func preProdButtonPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        selectPreProd(true)
        selectStaging(false)
    }
    
    @IBAction func stagingButtonPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        selectPreProd(false)
        selectStaging(true)
    }
    
    @IBAction func actionPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        guard let msisdn = msisdnTextField.text, !msisdn.isEmpty else {return}
        
        var clientId: String = "3475e8196f60415fb1ffb38728833921"
        if selectedEnvironment == .staging {
            clientId = "a81158526bca43328bc2282c5f893f68"
        }
        
        configuration = EWalletConfiguration(partnerName: "GOCHAT", partenerUserId: nil, clientId: clientId, environment: selectedEnvironment, theme: selectedTheme())
        eWalletSDK = EWalletSDK(configuration: configuration!)
        eWalletSDK?.enableLogs(true)
//        eWalletSDK?.setSDKLanguage(selectedLang == .en ? .english : .arabic)
        eWalletSDK?.startWithOnboarding(in: self, msisdn: msisdn, onSuccess: { value in
            print(value)
        }, onFailure: { code, desc in
            print("Code: \(code)\n Description:\(desc)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                let alert = UIAlertController.init(title: nil, message: desc, preferredStyle: .alert)
                let action = UIAlertAction.init(title: "ok", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            })
        })
    }
    
    @IBAction func actionAddMoneyPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        guard let msisdn = msisdnTextField.text, !msisdn.isEmpty else {return}
//        let theme = EWalletTheme(buttonBackgroundColor: .red,
//                                 buttonTextColor: .white,
//                                 buttonFont: UIFont.systemFont(ofSize: 12),
//                                 toolBarTitleColor: nil,
//                                 toolBarLabelColor: nil,
//                                 toolBarIconColor: .black,
//                                 checkBoxColor: nil,
//                                 segmentBarColor: nil)
        var clientId: String = "3475e8196f60415fb1ffb38728833921"
        if selectedEnvironment == .staging {
            clientId = "a81158526bca43328bc2282c5f893f68"
        }
        
        configuration = EWalletConfiguration(partnerName: "GOCHAT", partenerUserId: nil, clientId: clientId, environment: selectedEnvironment, theme: selectedTheme())

        eWalletSDK = EWalletSDK(configuration: configuration!)
        eWalletSDK?.enableLogs(true)
//        eWalletSDK?.setSDKLanguage(selectedLang == .en ? .english : .arabic)
        eWalletSDK?.startWithAddMoney(in: self, msisdn: msisdn/*"971587585858"*/, onSuccess: { value in
            print("\(#file) value is \(value)")
        }, onFailure: { code, description in
            print("code ==> \(code)")
            print("description ==> \(description)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                let alert = UIAlertController.init(title: nil, message: description, preferredStyle: .alert)
                let action = UIAlertAction.init(title: "ok", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            })
        })
    }
    
    @IBAction func actionForgetPinPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        guard let msisdn = msisdnTextField.text, !msisdn.isEmpty else {return}
        var clientId: String = "3475e8196f60415fb1ffb38728833921"
        if selectedEnvironment == .staging {
            clientId = "a81158526bca43328bc2282c5f893f68"
        }
        
        configuration = EWalletConfiguration(partnerName: "GOCHAT", partenerUserId: nil, clientId: clientId, environment: selectedEnvironment, theme: selectedTheme())
        eWalletSDK = EWalletSDK(configuration: configuration!)
        eWalletSDK?.enableLogs(true)
//        eWalletSDK?.setSDKLanguage(selectedLang == .en ? .english : .arabic)
        eWalletSDK?.startForgetPin(in: self, msisdn: msisdn, onSuccess: { message in
            print("\(#file) value is \(message)")
        }, onFailure: { code, message in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
                let action = UIAlertAction.init(title: "ok", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            })
        })
    }
    
    @IBAction func actionChangePinPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        guard let msisdn = msisdnTextField.text, !msisdn.isEmpty else {return}
        var clientId: String = "3475e8196f60415fb1ffb38728833921"
        if selectedEnvironment == .staging {
            clientId = "a81158526bca43328bc2282c5f893f68"
        }
        
        configuration = EWalletConfiguration(partnerName: "GOCHAT", partenerUserId: nil, clientId: clientId, environment: selectedEnvironment, theme: selectedTheme())
        eWalletSDK = EWalletSDK(configuration: configuration!)
        eWalletSDK?.enableLogs(true)
//        eWalletSDK?.setSDKLanguage(selectedLang == .en ? .english : .arabic)
        eWalletSDK?.startChangePin(in: self, msisdn: msisdn, onSuccess: { message in
            print("\(#file) value is \(message)")
        }, onFailure: { code, message in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
                let action = UIAlertAction.init(title: "ok", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            })
        })
    }
    
    @IBAction func actionUpdateEmiratesIdPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        guard let msisdn = msisdnTextField.text, !msisdn.isEmpty else {return}
        var clientId: String = "3475e8196f60415fb1ffb38728833921"
        if selectedEnvironment == .staging {
            clientId = "a81158526bca43328bc2282c5f893f68"
        }
        
        configuration = EWalletConfiguration(partnerName: "GOCHAT", partenerUserId: nil, clientId: clientId, environment: selectedEnvironment, theme: selectedTheme())
        eWalletSDK = EWalletSDK(configuration: configuration!)
        eWalletSDK?.enableLogs(true)
//        eWalletSDK?.setSDKLanguage(selectedLang == .en ? .english : .arabic)
        eWalletSDK?.startUpdateEmiratesId(in: self, msisdn: msisdn, onSuccess: { message in
            print("\(#file) value is \(message)")
        }, onFailure: { code, message in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
                let action = UIAlertAction.init(title: "ok", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            })
        })
    }
    
    @IBAction func actionLoginPressed(_ sender: UIButton!) {
        self.view.endEditing(true)
        guard let msisdn = msisdnTextField.text, !msisdn.isEmpty else {return}
        var clientId: String = "3475e8196f60415fb1ffb38728833921"
        if selectedEnvironment == .staging {
            clientId = "a81158526bca43328bc2282c5f893f68"
        }
        
        configuration = EWalletConfiguration(partnerName: "GOCHAT", partenerUserId: nil, clientId: clientId, environment: selectedEnvironment, theme: selectedTheme())
        eWalletSDK = EWalletSDK(configuration: configuration!)
        eWalletSDK?.enableLogs(true)
//        eWalletSDK?.setSDKLanguage(selectedLang == .en ? .english : .arabic)
        eWalletSDK?.login(in: self, msisdn: msisdn, onSuccess: { response in
            let alert = UIAlertController.init(title: "Welcome \(response.data.fullName ?? "")!", message: "You have been logged in to e&Money", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "ok", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        }, onFailure: { code, message in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
                let action = UIAlertAction.init(title: "ok", style: .cancel)
                alert.addAction(action)
                self.present(alert, animated: true)
            })
        })
    }
    
    
//    func getTheme() -> EWalletTheme {
//        let theme = EWalletTheme()
//            .setBackgroundColor(.black)
//            .setToolbarTheme(EWalletToolbarTheme(handlerColor: .white, primaryTitleColor: .white, secondaryTitleColor: .lightGray))
//            .setContentTheme(.init(headingColor: .white, notesColor: .lightGray))
//            .setEditTextTheme(editTextTheme: EWalletEditTextTheme(activeTextColor: .white, inActiveTextColor: .lightGray, activeBorderColor: .lightGray, inActiveBorderColor: .darkGray, hintColor: .lightGray, separatorColor: .lightGray))
//            .setPrimaryButtonTheme(EWalletButtonTheme(backgroundColor: (primary: .red, secondary: .red.withAlphaComponent(0.5)), textColor: .white))
//            .setActivityIndicatorColor(.white)
//            .setStatusTheme(EStatusTheme(errorTextColor: .red, errorIconColor: .red, successColor: .green))
//            .setListBackgroundColor(.darkGray)
//            .setVisibilityToggleTextColor(.red)
//            .setSegmentBarTheme(EWalletSegmentBarTheme(selectedColor: .red, unSelectedColor: .gray))
//        
//        return theme
//    }
    @IBAction func showBottomSheet(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Language", message: "", preferredStyle: .actionSheet)
        
        // Add actions
        let action1 = UIAlertAction(title: "English", style: .default) {[weak self] _ in
            self?.selectedLang = .en
            sender.setTitle("Language: English", for: .normal)
        }
        alertController.addAction(action1)
        
        let action2 = UIAlertAction(title: "Arabic", style: .default) {[weak self] _ in
            self?.selectedLang = .ar
            sender.setTitle("Language: Arabic", for: .normal)
        }
        alertController.addAction(action2)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel tapped")
        }
        alertController.addAction(cancelAction)
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    
}
