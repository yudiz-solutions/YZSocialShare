//
//  SocialShare.swift
//  SocialShare
//
//  Created by Yudiz Solutions Pvt.Ltd. on 30/12/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit
import Social
import MessageUI

enum ShareType {
    case facebook
    case twitter
    case otherApps
}
typealias Attachment = (data:Data?, fileName:String)

class YMSocialShare:NSObject {
    class func shareOn(serviceType:ShareType = ShareType.otherApps,text:String,url:String? = nil, image:UIImage? = nil) {
        switch serviceType {
            case .facebook:
                self.shareOnFacebook(serviceType:SLServiceTypeFacebook,text:text,url: url,image: image)
            case .twitter:
                self.shareOnFacebook(serviceType:SLServiceTypeTwitter,text:text,url: url,image: image)
            case .otherApps:
                self.shareOnOther(text:text,url:url,image: image)
        }
    }
    class func shareOnMail(recipients:String ...,subject:String,body:String,attachment:Attachment? = nil) {
        SocialComposer.sharedInstance.openMailComposer(recipients:recipients, subject:subject, body:body
            ,attachment:attachment)
    }
    class func shareOnMessanger(recipients:String ...,subject:String,body:String,attachment:Attachment? = nil) {
        SocialComposer.sharedInstance.openMessageComposer(recipients:recipients, subject:subject, body:body,attachment:attachment)
    }
    class func shareOnInstagram(text:String,image:UIImage) {
        SocialComposer.sharedInstance.openInstagram(text:text, image:image)
    }
    private class func shareOnOther(text:String,url:String? = nil, image:UIImage? = nil) {
        SocialComposer.sharedInstance.openActivityVC(text:text, url:url, image: image)
    }
    private class func shareOnFacebook(serviceType:String,text:String,url:String? = nil, image:UIImage? = nil) {
        if SLComposeViewController.isAvailable(forServiceType: serviceType) {
            let serviceVC:SLComposeViewController = SLComposeViewController(forServiceType: serviceType)
            serviceVC.setInitialText(text)
            
            if let link = url {
                let url = URL(string:link)
                serviceVC.add(url)
            }
            
            if let img = image {
               serviceVC.add(img)
            }
            present(controller:serviceVC)
            
        } else {
            UIAlertController.actionWithMessage(message: "Please go to settings and add at least one \(SLServiceTypeFacebook == serviceType ? "facebook" : "twitter") account.", title: "Warning", type: UIAlertControllerStyle.alert, buttons:[], block: { (str) -> Void in
            })
        }
    }
    class func present(controller:UIViewController) {
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(controller, animated: true, completion: nil)
    }
}

class SocialComposer:NSObject,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate{
    
    var documentController:UIDocumentInteractionController!
    static let sharedInstance : SocialComposer = {
        let instance = SocialComposer()
        return instance
    }()
    
    override init() {
        
    }
    func openMailComposer(recipients:[String],subject:String,body:String,attachment:Attachment?) {
        var myRecipients = recipients
        let mailComposerVC = MFMailComposeViewController()
        if myRecipients.count > 1 {
            mailComposerVC.setToRecipients([myRecipients.first!])
            myRecipients.removeFirst()
            mailComposerVC.setCcRecipients(myRecipients)
        } else {
            mailComposerVC.setToRecipients(myRecipients)
        }
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: false)
        mailComposerVC.mailComposeDelegate = self
        if let addtch = attachment {
            mailComposerVC.addAttachmentData(addtch.0!, mimeType:"", fileName:addtch.1)
        }
        if MFMailComposeViewController.canSendMail() {
            YMSocialShare.present(controller: mailComposerVC)
        }
    }
    func openMessageComposer(recipients:[String],subject:String?,body:String?,attachment:Attachment?) {
        
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.recipients = recipients
        if let sub = subject {
            messageComposeVC.subject = sub
        }
        
        if let b = body {
            messageComposeVC.body = b
        }
        if let addtch = attachment {
            messageComposeVC.addAttachmentData(addtch.data!, typeIdentifier:"public.data", filename:addtch.fileName)
        }
        if MFMessageComposeViewController.canSendText() {
            YMSocialShare.present(controller: messageComposeVC)
        }
    }
    func openInstagram(text:String,image:UIImage) {
        
        let instagramURL = NSURL(string: "instagram://app")
        if (UIApplication.shared.canOpenURL(instagramURL! as URL)) {
            let imageData = UIImageJPEGRepresentation(image, 100)
            let captionString = "caption"
            let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
            
            do {
                try imageData?.write(to:URL(string:writePath)!)
                let fileURL = NSURL(fileURLWithPath: writePath)
                documentController = UIDocumentInteractionController(url: fileURL as URL)
                documentController.delegate = self
                documentController.uti = "com.instagram.exlusivegram"
                documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
                let view = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
                documentController.presentOpenInMenu(from: view!.frame, in:view!, animated: true)

            } catch {}
            
            
        } else {
            UIAlertController.actionWithMessage(message:"Instagram isn't installed", title: "Warning", type: UIAlertControllerStyle.alert, buttons:[], block: { (str) -> Void in
            })
            print(" Instagram isn't installed ")
        }
    }

    func openActivityVC(text:String,url:String?,image:UIImage?) {
        
        let activityViewController = UIActivityViewController(activityItems:[text,url ?? "",image ?? ""], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.view
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        YMSocialShare.present(controller: activityViewController)
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIAlertController {
    class func actionWithMessage(message: String?, title: String?, type: UIAlertControllerStyle, buttons: [String],block:@escaping (_ tapped: String)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: UIAlertActionStyle.default, handler: { (action) -> Void in
                block(btn)
            }))
        }
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            block("Cancel")
        }))
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated:true, completion: {
            
        })
    }
    
    class func actionWithMessageDestructive(message: String?, title: String?, type: UIAlertControllerStyle, buttons: [String], controller: UIViewController ,block:@escaping (_ tapped: String)->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: type)
        for btn in buttons {
            alert.addAction(UIAlertAction(title: btn, style: UIAlertActionStyle.destructive, handler: { (action) -> Void in
                block(btn)
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            block("Cancel")
        }))
        controller.present(alert, animated: true, completion: nil)
    }
}

