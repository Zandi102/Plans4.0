//
//  LoginViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 3/24/22. 
//
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLogin: UITextField!
    
    @IBOutlet weak var passwordLogin: UITextField!
    
    @IBOutlet weak var emailLogin: UITextField!
    
    @IBOutlet weak var phoneNumberLogin: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    private var loggedIn = false;
    
    private let label: UILabel = {
        let label = UILabel();
        label.textColor = .systemRed;
        label.text = "Invalid Credentials";
        return label;
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton?.addTarget(self, action: #selector(login), for: .touchUpInside)
        /*if(failedLogin == true) {
            view.addSubview(label);
            label.frame = CGRect.init(x: 20, y: view.frame.size.height - 100, width: view.frame.size.width - 40, height: 50);
        }*/
    }
    
    @objc func login (){
        let passLength = passwordLogin.text!;
        let userLength = passwordLogin.text!;
        if(passLength.count < 7 || userLength.count < 2) {
            view.addSubview(label);
            label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100);
            label.textAlignment = .center
            label.text = "Invalid user credentials."
            usernameLogin.text = "";
            passwordLogin.text = "";
            //phoneNumberLogin.text = "";
        }
        else {
            let db = DBManager();
            let url = URL(string: "http://abdasalaam.com/Functions/login.php")!
            let parameters: [String: Any] = [
                "username":usernameLogin.text!,
                "password":passwordLogin.text!,
            ]
            let message = db.postRequest(url, parameters)
            if (message == "login successful") {
                label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100);
                User.sampleUser = User.createCurrentUser(usernameLogin.text!)
                usernameLogin.text = "";
                passwordLogin.text = "";
                
                //emailLogin.text = "";
                //phoneNumberLogin.text = "";
                //THIS PUBLIC USERNAME VAR WILL ONLY BE INSTANTIATED IF THERE IS SUCCESSFUL LOGIN
                //publicUsername will be used in other view controllers to find the info related to the user logged in
                switchScreen();
            }
            else if (message == "login unsuccessful") {
                print(message)
                view.addSubview(label);
                label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100);
                label.textAlignment = .center
                label.text = "Please make sure the credentials are correct."
            }
            else {
                view.addSubview(label);
                label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100);
                label.textAlignment = .center
                label.text = "Invalid request"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //let destVC = segue.destination as! SignUpViewController;
    }
    
    @objc func switchScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        if let viewController =  mainStoryboard.instantiateViewController(withIdentifier: "MapNav") as? UIViewController {
            self.present(viewController, animated: false, completion: nil);
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
