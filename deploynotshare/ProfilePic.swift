//
//  ViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 21/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class ProfilePic: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var profileimage: UIImageView!
    @IBOutlet weak var nametext: UITextField!
    @IBOutlet weak var emailtext: UILabel!
    
    var detailview:UIViewController!
    var listView: UIViewController!
    var noteViewController: UIViewController!
    var profilePic: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nametext.text = config.get("user_name");
        emailtext.text = config.get("user_email")
        
        profileimage.image = UIImage(contentsOfFile: path + "/" + config.get("user_pic") );
        profileimage.contentMode = .ScaleAspectFill
        profileimage.layer.cornerRadius = profileimage.frame.size.width / 2 - 2
        profileimage.clipsToBounds = true
        profileimage.layer.borderWidth = 5.0
        profileimage.layer.borderColor = UIColor.whiteColor().CGColor
        
        nametext.font = UIFont(name: "Agenda", size: 18)
        emailtext.font = UIFont(name: "Agenda", size: 18)
        
        let borderLeft = CALayer()
        let width = CGFloat(1.0)
        borderLeft.borderColor = UIColor.whiteColor().CGColor
        borderLeft.frame = CGRect(x: 1, y: 0, width: emailtext.frame.size.width, height: width)
        borderLeft.borderWidth = emailtext.frame.size.width
        emailtext.layer.addSublayer(borderLeft)
        
        self.setNavigationBarItem()
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let profilePic = storyboard.instantiateViewControllerWithIdentifier("SelectProfile") as! ProfilePic
        self.profilePic = UINavigationController(rootViewController: profilePic)
        
        let noteViewController = storyboard.instantiateViewControllerWithIdentifier("cardViewController") as! cardViewController
        self.noteViewController = UINavigationController(rootViewController: noteViewController)
        
        let listView = storyboard.instantiateViewControllerWithIdentifier("Listview") as! Listview
        self.listView = UINavigationController(rootViewController: listView)
        
        let detailview = storyboard.instantiateViewControllerWithIdentifier("Detailview") as! Detailview
        self.detailview = UINavigationController(rootViewController: detailview)
        
    }
    
    @IBAction func nextClick(sender: AnyObject) {
        
        config.set("user_name",value2: nametext.text!);
        isInsideFolder = 0
        let noteView = config.get("note_view")
        switch noteView
        {
        case "1":
            slideMenuLeft.changeMainViewController(self.detailview, close: true)
        case "2":
            slideMenuLeft.changeMainViewController(self.listView, close: true)
        case "3":
            slideMenuLeft.changeMainViewController(self.noteViewController, close: true)
        default:
            slideMenuLeft.changeMainViewController(self.detailview, close: true)
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    @IBAction func pickimage(sender: AnyObject) {
        let imagepick = UIImagePickerController()
        imagepick.delegate = self
        imagepick.sourceType = .PhotoLibrary
        self.presentViewController(imagepick, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        profileimage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        appendImage(profileimage.image)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    func appendImage(image2: UIImage!) {
        let image  = image2.resizeToWidth(500)
        if(image2 != nil) {
            let newheight = width / image.size.width * image.size.height
            let imageView = ElementImage(frame: CGRectMake(0,0,width+10,newheight))
            imageView.contentMode = .ScaleAspectFit
            
                let imagename = "profile.jpg";
                let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                let destinationPath = String(documentsPath) + "/" + imagename
                UIImageJPEGRepresentation(image,1.0)!.writeToFile(destinationPath, atomically: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

