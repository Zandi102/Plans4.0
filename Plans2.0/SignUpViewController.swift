//
//  SignUpViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 3/24/22.
//
import UIKit

public class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!;
    
    @IBOutlet weak var passwordField: UITextField!;
    
    @IBOutlet weak var emailField: UITextField!;
    
    @IBOutlet weak var phoneNumberField: UITextField!;
    
    @IBOutlet weak var registerButton: UIButton!;
    
    @IBOutlet weak var loginButton: UIButton!;
    
    public var publicUsername : String = "";
    
    private let label: UILabel = {
        let label = UILabel();
        label.textColor = .systemRed;
        return label;
    }();
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        label.frame = CGRect.init(x: view.frame.size.width - 1000, y: view.frame.size.height - 200, width: 500, height: 100)
        registerButton?.addTarget(self, action: #selector(register), for: .touchUpInside);
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func unwindToSignup(_ sender: UIStoryboardSegue) {}
    
    @objc func register () {
        let passLength = passwordField.text!;
        let userLength = usernameField.text!;
        if(passLength.count < 7 || userLength.count < 2) {
            view.addSubview(label);
            label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100);
            label.textAlignment = .center
            label.text = "Invalid user credentials."
           
            usernameField.text = "";
            passwordField.text = "";
            //emailField.text = "";
            //phoneNumberField.text = "";
        }
        else {
            let db = DBManager();
            let url = URL(string: "http://abdasalaam.com/Functions/register.php")!
            let parameters: [String: Any] = [
                "username":usernameField.text!,
                "password":passwordField.text!,
            ]
            let message = db.postRequest(url, parameters)
            if (message == "User created successfully") {
                label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100);
                //emailField.text = "";
                //phoneNumberField.text = "";
                //THIS PUBLIC USERNAME VAR WILL ONLY BE INSTANTIATED IF THERE IS SUCCESSFUL LOGIN
                //publicUsername will be used in other view controllers to find the info related to the user logged in
                User.sampleUser = User.createCurrentUser(usernameField.text!)
                switchScreen();
            }
            else if (message == "User already exist") {
                print(message)
                view.addSubview(label);
                label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100);
                label.textAlignment = .center
                label.text = "Username already taken."
            }
            else {
                view.addSubview(label);
                label.frame = CGRect.init(x: 0, y: view.frame.size.height - 200, width: self.view.bounds.width, height: 100);
                label.textAlignment = .center
                label.text = "Error. Please try again."
            }
        }
    }
    
    @objc func switchScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MapNav") as? UIViewController {
            self.present(viewController, animated: false, completion: nil);
        }
    }
}
