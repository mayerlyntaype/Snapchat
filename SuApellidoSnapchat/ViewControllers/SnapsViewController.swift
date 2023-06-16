//
//  SnapsViewController.swift
//  SuApellidoSnapchat
//
//  Created by Mayerlyn on 7/06/23.
//

import UIKit
import Firebase
import FirebaseDatabase


class SnapsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBAction func añadirSnap(_ sender: Any) {
        let alerta = UIAlertController(title: "Selecciona tu snap", message: "¿Qué es lo que quieres enviar?", preferredStyle: .alert)
        let audio = UIAlertAction(title: "Audio", style: .default, handler:
                                    {(UIAlertAction) in
        self.performSegue(withIdentifier: "enviaraudio", sender: nil)
    })
        let foto = UIAlertAction(title: "Foto", style: .default, handler:
                                    {(UIAlertAction) in
            self.performSegue(withIdentifier: "enviarfoto", sender: nil)
    })
        
    alerta.addAction(audio)
    alerta.addAction(foto)

    self.present(alerta,animated:true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }else{
            return snaps.count

        }
            }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0{
            cell.textLabel?.text = "No tiene snaps 😭 😭"
        } else {
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "versnapsegue", sender: snap)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="versnapsegue"{
            let siguienteVC = segue.destination as! VerSnapViewController
            siguienteVC.snap = sender as! Snap
        } 
    }

    @IBAction func cerrarSesionTapped(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    @IBOutlet weak var tablaSnaps: UITableView!
    var snaps:[Snap]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: {(snapshot) in let snap = Snap()
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.descrip = (snapshot.value as! NSDictionary)["descripcion"] as! String
            snap.id = snapshot.key
            snap.archivoID = (snapshot.value as! NSDictionary)["archivoID"] as! String
            self.snaps.append(snap)
            self.tablaSnaps.reloadData()
        })
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childRemoved, with: {(snapshot)in
            var iterator = 0
            for snap in self.snaps{
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
                
            }
            self.tablaSnaps.reloadData()
        })
        
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
