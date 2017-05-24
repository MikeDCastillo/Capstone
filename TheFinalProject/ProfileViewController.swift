//
//  ProfileViewController.swift
//  TheFinalProject
//
//  Created by Michael Castillo on 5/23/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ProfileViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        //TODO: - create provisioning profile for when going live on App Store
        //this is for simulator as of now
        bannerView.adUnitID = "ca-app-pub-3828876899715465/5171904637"
        //this is the viewController that the banner will be displayed on
        bannerView.rootViewController = self
        bannerView.load(request)
    }


}
