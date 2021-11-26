//
//  ViewController.swift
//  MultiScreen
//
//  Created by vedantapps on 11/24/21.
//

import UIKit
import MultipeerConnectivity
import AVKit
import AVFoundation
import SPAlert

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var startCommand: String!
    var stopCommand: String!
    
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var joinSessionOutlet: UIButton!
    @IBOutlet weak var hostSessionOutlet: UIButton!
    @IBOutlet weak var startSession: UIBarButtonItem!
    @IBOutlet weak var stopOutlet: UIBarButtonItem!
    
    
    @IBAction func join(_ sender: Any) {
        let list = MCBrowserViewController(serviceType: "multiscreen", session: mcSession)
        list.delegate = self
        present(list, animated: true)
    }
    
    
    @IBAction func host(_ sender: Any) {
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "multiscreen", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant.start()
        SPAlert.present(title: "Session Started! look for DEVICE #MAIN on the other devices", preset: .done)
    }
    
    @IBAction func start(_ sender: Any) {
        startCommand = "play"
        let message = startCommand.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do {
          try self.mcSession.send(message!, toPeers: self.mcSession.connectedPeers, with: .unreliable)
            SPAlert.present(title: "Success", message: "Playback Started", preset: .done)
            startSession.isEnabled = false
            stopOutlet.isEnabled = true
        }
        catch {
            SPAlert.present(title: "An Error Occured", message: "\(error)", preset: .error)
        }

    }
    
    @IBAction func stop(_ sender: Any) {
        stopCommand = "stop"
        let stopMessage = stopCommand.data(using: String.Encoding.utf8, allowLossyConversion: false)
        do {
          try self.mcSession.send(stopMessage!, toPeers: self.mcSession.connectedPeers, with: .unreliable)
            SPAlert.present(title: "Success", message: "Playback Stopped", preset: .done)
            stopOutlet.isEnabled = false
            startSession.isEnabled = true
        }
        catch {
            SPAlert.present(title: "An Error Occured", message: "\(error)", preset: .error)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceLabel.text = selectediPhone

        if selectediPhone == "MAIN" {
            joinSessionOutlet.isEnabled = false
            startSession.isEnabled = true
        } else if selectediPhone != "MAIN" {
            hostSessionOutlet.isEnabled = false
            startSession.tintColor = UIColor.clear
            stopOutlet.tintColor = UIColor.clear
        }

        peerID = MCPeerID(displayName: "Device #\(selectediPhone)")
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        
    }
    
    // MARK: - MultipeerConnectivity Code
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
      switch state {
      case .connected:
        print("Connected to: \(peerID.displayName)")
      case .connecting:
        print("Connecting to: \(peerID.displayName)")
      case .notConnected:
        print("Not Connected to: \(peerID.displayName)")
      @unknown default:
        print("An Error Occured")
      }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
      DispatchQueue.main.async {
          let command = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)! as String
          if command == "play" {
              self.playVideo(videoState: "play")
          } else if command == "stop" {
              self.playVideo(videoState: "stop")
              
          }

      }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
      dismiss(animated: true)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
      dismiss(animated: true)
    }
    
    
    
    func playVideo(videoState: String){
        var xPos = 0
        var yPos = 0
        guard let path = Bundle.main.path(forResource: "3things", ofType: "mov") else {
            return
        }
        
        let videoURL = NSURL(fileURLWithPath: path)
        let player = AVPlayer(url: videoURL as URL)
        let controller = AVPlayerViewController()
        
        //Note - These x and y positions are designed for the 4.7" iPhone Screen
        switch Int(selectediPhone) {
        case 1:
            xPos = 0
            yPos = 0
        case 2:
            xPos = -750
            yPos = 0
        case 3:
            xPos = -1500
            yPos = 0
        case 4:
            xPos = 0
            yPos = -550
        case 5:
            xPos = -750
            yPos = -550
        case 6:
            xPos = -1500
            yPos = -550
        default:
            xPos = 0
            yPos = 0
        }

        controller.view.frame = CGRect(x: xPos, y: yPos, width: 2250, height: 1125)
        controller.view.contentMode = .scaleAspectFit
        controller.player = player
        
        if videoState == "play"{
            self.addChild(controller)
            self.view.addSubview(controller.view)
            controller.didMove(toParent: self)
            player.play()
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else if videoState == "stop" {
            self.removePlayer()
            navigationController?.setNavigationBarHidden(false, animated: true)
            
        }
    }
}


extension UIViewController {
        
  func removePlayer() {
    self.children.forEach {
      $0.willMove(toParent: nil)
      $0.view.removeFromSuperview()
      $0.removeFromParent()
    }
  }
}
