//
//  FriendViewController.swift
//  Plans2.0
//
//  Created by Alex Pallozzi on 5/8/22.
//

import UIKit

class FriendViewController: UIViewController {

    @IBOutlet weak var usernameField: UILabel!
    
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var friendPicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.text = User.friendToShow.userName
        usernameField.adjustsFontSizeToFitWidth = true;
        nameField.text = User.friendToShow.fullName
        usernameField.adjustsFontSizeToFitWidth = true;
        descriptionField.text = User.friendToShow.description
        if User.currentUser.image.count > 0 {
            var stringImg = User.currentUser.image
            let remainder = stringImg.count % 4
            if remainder > 0 {
                stringImg = stringImg.padding(toLength: stringImg.count + 4 - remainder,
                                              withPad: "=",
                                              startingAt: 0)
            }
            let imageData = Data(base64Encoded: stringImg)
            print(imageData)
            friendPicture.image = UIImage(data: imageData!)!
        }
        else {
            friendPicture.image = UIImage(named: "ProfilePicture")
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
