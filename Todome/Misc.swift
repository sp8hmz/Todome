//
//  Misc.swift
//  Todome
//
//  Created by Karol Karczewski on 12.02.2017.
//  Copyright © 2017 Karol Karczewski. All rights reserved.
//

import Foundation
import UIKit
import VHUD

func showAlert(title: String, message: String, vc: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    vc.present(alert, animated: true, completion: nil)
}

func startLoading() {
    var content = VHUDContent(.loop(1.0))
    content.shape = .circle
    content.style = .dark
    content.loadingText = "Loading.."
    VHUD.show(content)
}

func stopLoading() {
    VHUD.dismiss(0.1)
}
