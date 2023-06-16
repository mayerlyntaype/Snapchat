//
//  ViewController.swift
//  SuApellidoSnapchat
//
//  Created by Mayerlyn on 31/05/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseDatabase

class niciarSesionViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func googlebuttonaction(_ sender: Any) {
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            // ...
              print("no se logro loguear fuentes :C")

              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
        
            print("se logro loguear con google, tarea completa :)))")


          // ...
            return
        }
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }

        
    }
    @IBOutlet weak var googlebutton: UIButton!
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){
            (user, error) in
            print("Intentando iniciar sesion")
            if error != nil{
                print("Se presento el siguiente error :\(error)")
                                    let alerta = UIAlertController(title: "Creacion de usuario", message: "Usuario:\(self.emailTextField.text!) no existente", preferredStyle: .alert)
                                    let crearaccion = UIAlertAction(title: "Crear", style: .default, handler:
                                                                {(UIAlertAction) in
                                    self.performSegue(withIdentifier: "crearSegue", sender: nil)
                                })
                                    let cancelar = UIAlertAction(title: "Cancelar", style: .default, handler:
                                                                {(UIAlertAction) in
                                })
                                    
                                alerta.addAction(crearaccion)
                                alerta.addAction(cancelar)

                                self.present(alerta,animated:true, completion: nil)
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


