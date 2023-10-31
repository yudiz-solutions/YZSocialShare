# YZSocial Share
Share Content and Image to Facebook, twitter, Instagram, mail and to mobile number via sms.

 * share content , url and image into social networtk like facebook, twitter, email, messanger and instagrtam
 * used native iOS api 
 
 ![Toast message](https://github.com/yudiz-solutions/YMSocialShare/blob/master/Screenshort/image.gif)

And here's some code! :+1:
* facebook and twitter 
```
// facebook
YZSocialShare.shareOn(serviceType:.facebook, text:"facebook", url:"www.yudiz.com",image:UIImage(named:"steve jobs")) 

// twitter
YZSocialShare.shareOn(serviceType:.twitter, text:"twitter", url:"www.yudiz.com") 
 
```
* mail and messanger (with attachment)
```
// mail with attchament
let attachment = (data: UIImagePNGRepresentation(UIImage(named:"steve jobs")),fileName:"steve.png") // create attachment
YZSocialShare.shareOnMail(recipients:"yogesh@itindia.co.in", subject:"Test", body:"Hello", attachment:attachment)

// Messanger 
YZSocialShare.shareOnMessanger(recipients:"9638527410","9632587410", subject:"Test", body:"Hello")

```

* instagram and other apps

```
// instagram 

/* Add this key into plist file
                 
  <key>LSApplicationQueriesSchemes</key>
  <array>
  <string>instagram</string>
  </array>
                 
 */

 YZSocialShare.shareOnInstagram(text:"my first post", image:UIImage(named:"steve jobs"))
 
 // Other apps
 YZSocialShare.shareOn(serviceType:.otherApps,text:"Yudiz",image:UIImage(named:"steve jobs"))
                 
```
