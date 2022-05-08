//
//  ViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 2/23/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

  //  private let imageView: UIImageView = {
     //   let imageView = UIImageView()
      //  imageView.contentMode = .scaleAspectFill
      //  imageView.backgroundColor = .white
      //  return imageView
        
   // }()
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var userEmailField: UITextField!
    @IBOutlet weak var userDescriptionField: UITextView!
    
    @IBOutlet weak var saveChangesButton: UIButton? = {
        let saveChangesButton = UIButton()
        saveChangesButton.backgroundColor = .white
        return saveChangesButton
    }()
    
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        return button;
    }()
    override func viewDidLoad() {
        super.viewDidLoad();
        saveChangesButton?.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        saveChangesButton!.frame = CGRect.init(x: 0, y: view.frame.size.height - 250, width: self.view.bounds.width, height: 100)
        self.username.text = User.currentUser.userName
        self.username.adjustsFontSizeToFitWidth = true
        userTextField.text = User.currentUser.userName
        userPasswordField.text = User.currentUser.password
        userEmailField.text = User.currentUser.fullName;
        userDescriptionField.text = User.currentUser.description;
        userTextField.delegate = self
        userPasswordField.delegate = self
        userEmailField.delegate = self
       // userTextField.frame = CGRect.init(x: 0, y: view.frame.size.height - 300, width: self.view.bounds.width, height: 100);
        //userPasswordField.frame = CGRect.init(x: 0, y: view.frame.size.height - 300, width: self.view.bounds.width, height: 100);
        
        //saveChangesButton!.frame
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userTextField.resignFirstResponder()
        userPasswordField.resignFirstResponder()
        userEmailField.resignFirstResponder()
        userDescriptionField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func buttonTap() {
        User.currentUser.fullName = self.userEmailField.text!
        User.currentUser.description = self.userDescriptionField.text!
        let db = DBManager();
        let url = URL(string: "http://abdasalaam.com/Functions/modifyUser.php")!
        let parameters: [String: Any] = [
            "username":User.currentUser.userName,
            "password":User.currentUser.password,
            "age":"0",
            "phone":"0",
            "name":userEmailField.text!,
            "description":userDescriptionField.text!
        ]
        let message = db.postRequest(url, parameters)
    }
    @IBAction func unwindToProfile(_ sender: UIStoryboardSegue) {
        //User.sampleUser = User.createCurrentUser(User.sampleUser.userName)
    }
    

}

