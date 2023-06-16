//
//  AudioViewController.swift
//  SuApellidoSnapchat
//
//  Created by Mayerlyn on 15/06/23.
//

import UIKit
import AVFoundation
import FirebaseStorage

class AudioViewController: UIViewController {

    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    var archivoID = NSUUID().uuidString

    @IBOutlet weak var grabarAudioButton: UIButton!
    @IBOutlet weak var descripcionInput: UITextField!
    @IBOutlet weak var seleccionarContacto: UIButton!
    @IBOutlet weak var playAudio: UIBarButtonItem!
    
    
    @IBAction func playAudioTapped(_ sender: Any) {
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.play()
            print("Reproduciendo")
            
        } catch {}
    }
    @IBAction func grabarAudioTapped(_ sender: Any) {
        if grabarAudio?.isRecording == true{
            grabarAudio?.stop()
            grabarAudioButton.setTitle("Grabar audio", for:  .normal)
            playAudio.isEnabled = true
        } else {
            grabarAudio?.record()
            grabarAudioButton.setTitle("Detener grabación", for:  .normal)
            playAudio.isEnabled = false
        }
    }
    @IBAction func seleccionarContactoTapped(_ sender: Any) {
        let storage = Storage.storage()
            let storageRef = storage.reference(withPath: "audios/")
            let audioFileName = archivoID + ".m4a"
            let audioFileRef = storageRef.child(audioFileName)
            guard let audioFileURL = audioURL else {
                print("URL del archivo de audio no válido")
                return
            }
            let uploadTask = audioFileRef.putFile(from: audioFileURL, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error al cargar el archivo de audio: \(error.localizedDescription)")
                    return
                }
                print("Archivo de audio cargado exitosamente")
                //Procede a seleccionar el contacto
                self.performSegue(withIdentifier: "AUseleccionarContactoSegue", sender: audioFileURL.absoluteString)
                
            }
            uploadTask.observe(.progress) { snapshot in
                // Calcula el porcentaje completado de la carga
                guard let progress = snapshot.progress else {
                    return
                }
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                print("Porcentaje completado de carga: \(percentComplete)%")
            }
    }
    
    
    
    func configurarGrabacion(){
        do{
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            let basePAth:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePAth,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("****************")
            print(audioURL!)
            print("****************")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio?.prepareToRecord()
        } catch let error as NSError{
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        // Do any additional setup after loading the view.
        playAudio.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElegirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionInput.text!
        siguienteVC.archivoID = archivoID
    }
    

}
