//
//  VerSnapViewController.swift
//  SuApellidoSnapchat
//
//  Created by Mayerlyn on 14/06/23.
//

import UIKit
import SDWebImage
import Firebase
import AVFoundation

class VerSnapViewController: UIViewController {
    
    var player: AVPlayer?
    var isPlaying = false
    var timer: Timer?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var indicadorSnap: UILabel!
    
    @IBAction func reproducirAudioTap(_ sender: Any) {
        if snap.imagenURL.contains(".m4a") {
                    guard let audioURL = URL(string: snap.imagenURL) else {
                        print("URL de audio inválida")
                        return
                    }
                    
                    if isPlaying {

                        player?.pause()
                        isPlaying = false
                        audioPlayer.value = 0.0
                        audioPlayer.isEnabled = true
                        audioPlayer.alpha = 1.0
                        audioPlayer.setThumbImage(UIImage(systemName: "play.fill"), for: .normal)
                        audioPlayer.minimumTrackTintColor = view.tintColor
                        timer?.invalidate()
                    } else {
                        // Iniciar la reproducción si no se está reproduciendo
                        let playerItem = AVPlayerItem(url: audioURL)
                        player = AVPlayer(playerItem: playerItem)
                        player?.play()
                        isPlaying = true
                        audioPlayer.isEnabled = false
                        audioPlayer.alpha = 0.5
                        audioPlayer.minimumTrackTintColor = UIColor.gray
                                        
                        let duration = playerItem.asset.duration
                        let durationInSeconds = CMTimeGetSeconds(duration)
                                        
                        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                            guard let self = self else { return }
                            let currentTimeInSeconds = CMTimeGetSeconds(self.player?.currentTime() ?? CMTime.zero)
                            let progress = Float(currentTimeInSeconds / durationInSeconds)
                            self.audioPlayer.value = progress
                        }
                    }
                }
    }

    @IBOutlet weak var audioPlayer: UISlider!
    
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip
        if snap.imagenURL.contains(".m4a") {
            indicadorSnap.text = "Audio enviado:"
            imageView.isHidden = true
            audioPlayer.isHidden = false
            
        } else{
            indicadorSnap.text = "Imagen enviada:"
            imageView.isHidden = false
            audioPlayer.isHidden = true
            imageView.sd_setImage(with: URL(string: snap.imagenURL),completed :nil)
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        if snap.imagenURL.contains(".jpg") {
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
            Storage.storage().reference().child("imagenes").child("\(snap.archivoID).jpg").delete{(error) in
                print("El Snap se eliminó correctamente")
            }
            
        } else {
            Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
            Storage.storage().reference().child("audios").child("\(snap.archivoID).m4a").delete{(error) in
                print("El Snap se eliminó correctamente")
            }
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
