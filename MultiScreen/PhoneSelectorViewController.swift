//
//  PhoneSelectorViewController.swift
//  MultiScreen
//
//  Created by vedantapps on 11/24/21.
//

import UIKit
import Foundation

var selectediPhone = ""

class PhoneSelectorViewController: UIViewController {
    
    @IBAction func mainiPhone(_ sender: Any) {
        selectediPhone = "MAIN"
        openViewController()
    }
    
    @IBAction func iPhoneOne(_ sender: Any) {
        selectediPhone = "1"
        openViewController()
    }
    
    @IBAction func iPhoneTwo(_ sender: Any) {
        selectediPhone = "2"
        openViewController()
    }
    
    @IBAction func iPhoneThree(_ sender: Any) {
        selectediPhone = "3"
        openViewController()
    }
    
    @IBAction func iPhoneFour(_ sender: Any) {
        selectediPhone = "4"
        openViewController()
    }
    
    @IBAction func iPhoneFive(_ sender: Any) {
        selectediPhone = "5"
        openViewController()
    }
    
    @IBAction func iPhoneSix(_ sender: Any) {
        selectediPhone = "6"
        openViewController()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func openViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let views = storyboard.instantiateViewController(withIdentifier: "mainView")
        views.modalPresentationStyle = .fullScreen
        self.present(views, animated: true)

    }
}
