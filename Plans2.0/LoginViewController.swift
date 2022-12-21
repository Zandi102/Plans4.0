//
//  LoginViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 3/24/22. 
//
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var usernameLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var phoneNumberLogin: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    private var loggedIn = false
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.text = "Invalid Credentials"
        return label
    }();
    
    override func viewDidLoad() {
        usernameLogin.autocorrectionType = .no
        passwordLogin.autocorrectionType = .no
        passwordLogin.isSecureTextEntry = true
        super.viewDidLoad()
        loginButton?.addTarget(self, action: #selector(login), for: .touchUpInside)
        usernameLogin.delegate = self
        passwordLogin.delegate = self
        loginButton.layer.cornerRadius = loginButton.bounds.size.height / 2.0
        forgotPasswordButton.layer.cornerRadius = forgotPasswordButton.bounds.size.height / 2.0

        //let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        //view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameLogin.resignFirstResponder()
        passwordLogin.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func login (){
        let passLength = passwordLogin.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let userLength = usernameLogin.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(passLength.count < 7 || userLength.count < 2) {
            view.addSubview(label)
            label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100)
            label.textAlignment = .center
            label.text = "Invalid user credentials."
            usernameLogin.text = "";
            passwordLogin.text = "";
        }
        else {
            let hashedPassword = User.hashPassword(toHash: passLength)
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            let db = DBManager();
            let url = URL(string: "http://abdasalaam.com/Functions/login.php")!
            let parameters: [String: Any] = [
                "username": userLength,
                "password": hashedPassword
            ]
            UserDefaults.standard.setValue(userLength, forKey: "username")
            UserDefaults.standard.setValue(passLength, forKey: "password")
            let message = db.postRequest(url, parameters)
            switch (message) {
            case "login successful":
                label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100)
                User.currentUser = User.createCurrentUser(userLength)
                usernameLogin.text = ""
                passwordLogin.text = ""
                switchScreen();
                
            case "login unsuccessful":
                view.addSubview(label)
                label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100)
                label.textAlignment = .center
                label.text = "Please make sure the credentials are correct."
        
            default:
                view.addSubview(label);
                label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100)
                label.textAlignment = .center
                label.text = "Invalid request"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){}
    
    
    
    @objc func switchScreen() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "MapNav") as? UINavigationController
        homeViewController?.hidesBottomBarWhenPushed = false
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
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
