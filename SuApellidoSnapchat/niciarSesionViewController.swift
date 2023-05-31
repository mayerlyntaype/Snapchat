//
//  ViewController.swift
//  SuApellidoSnapchat
//
//  Created by Mayerlyn on 31/05/23.
//

import UIKit
import FirebaseAuth

class niciarSesionViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user, error) in
            print("Intentando iniciar sesion")
            if error != nil{
                print("Se presento el siguiente error :\(error)")
            }else{
                print("Inicio de sesion exitoso")
            }
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

