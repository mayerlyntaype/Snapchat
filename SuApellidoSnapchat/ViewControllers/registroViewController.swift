//
//  registroViewController.swift
//  SuApellidoSnapchat
//
//  Created by Mayerlyn on 9/06/23.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class registroViewController: UIViewController {

    @IBAction func registrarbtn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: nombre.text!, password: contraseña.text!){
            (user, error) in
            print("Intentando iniciar sesion")
            if error != nil{
                print("Se presento el siguiente error :\(error)")
                Auth.auth().createUser(withEmail: self.nombre.text!, password: self.contraseña.text!,completion: {(user, error) in
                    print("intentando crear un usuario")
                    if error != nil{
                        print("se presento el siguiente error al crear un usuario :\(error)")
                    } else {
                        print("El usuario fue creado exitosamente")
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        
                    }
                })
            }else{
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "registroiniciado", sender: nil)
            }
        }
    }
    @IBOutlet weak var contraseña: UITextField!
    @IBOutlet weak var nombre: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
