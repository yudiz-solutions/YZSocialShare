//
//  ViewController.swift
//  SocialShare
//
//  Created by Yudiz Solutions Pvt.Ltd. on 30/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var arrFeature = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arrFeature = ["facebook","twitter","message","message with attachment","mail","mail with attachment","instagram","Other App"]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFeature.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell")!
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = arrFeature[indexPath.row]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch arrFeature[indexPath.row] {
            case "facebook":
                YMSocialShare.shareOn(serviceType:.facebook, text:"facebook", url:"www.yudiz.com",image: #imageLiteral(resourceName: "steve jobs"))
            case "twitter":
                YMSocialShare.shareOn(serviceType:.twitter, text:"twitter", url:"www.yudiz.com")
            case "message":
                YMSocialShare.shareOnMessanger(recipients:"9638527410","9632587410", subject:"Test", body:"Hello")
            case "message with attachment":
                let attachment = (data: UIImagePNGRepresentation(#imageLiteral(resourceName: "steve jobs")),fileName:"steve.png")
                YMSocialShare.shareOnMessanger(recipients:"9638527410","9632587410", subject:"Test", body:"Hello",attachment:attachment)
            case "mail":
                YMSocialShare.shareOnMail(recipients:"yogesh@itindia.co.in","abc@mailinator.com","ethon@mailinator.com", subject:"Test", body:"Hello")
            case "mail with attachment":
                let attachment = (data: UIImagePNGRepresentation(#imageLiteral(resourceName: "steve jobs")),fileName:"steve.png")
                YMSocialShare.shareOnMail(recipients:"yogesh@itindia.co.in", subject:"Test", body:"Hello", attachment:attachment)
            case "instagram":
                
                /* // Add this key into plist file
                 
                 <key>LSApplicationQueriesSchemes</key>
                 <array>
                 <string>instagram</string>
                 </array>
                 
                 */
                
                YMSocialShare.shareOnInstagram(text:"my first post", image:#imageLiteral(resourceName: "steve jobs"))
        case "Other App" :
                YMSocialShare.shareOn(serviceType:.otherApps,text:"Yudiz",image:#imageLiteral(resourceName: "steve jobs"))
            default:
                break
        }
    }
    
}
