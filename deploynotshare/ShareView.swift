//
//  ShareView.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/02/16.
//  Copyright © 2016 Wohlig. All rights reserved.
//

import UIKit
import SwiftyJSON
var emailsText = ""


@IBDesignable class ShareView: UIView {
    
    @IBOutlet var shareNoteshare: UIButton!
    @IBOutlet var shareText: UIButton!
    @IBOutlet var shareSreenshot: UIButton!
    @IBOutlet var shareUrl: UIButton!
    var noteobj = Note()
    let checkstatus = config.get("note_view");
    @IBOutlet var shareview: UIView!
    var note = ""
    var emaillist = UITextField()
    var checkvalidation = true;
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
        //        NSBundle.mainBundle().loadNibNamed("SortView", owner: self, options: nil)
        //        self.addSubview(self.sortnewview)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ShareView", bundle: bundle)
        let sortnewview = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        sortnewview.frame = bounds
        sortnewview.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(sortnewview);
    }
    
    func resShareNote(json: JSON){
        print(json)
    }
    
    func closeAllView(){
        
    }
    
    func showError(){
        let alert = UIAlertController(title: "Alert", message: "Invalid Email", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            self.showShareEmail()
        }
        alert.addAction(alertAction)
        switch(checkstatus){
        case "2" :
            let mainview = ViewForNotes as! Listview
            mainview.presentViewController(alert, animated: true, completion: nil)
            break
        case "1" :
            let mainview = ViewForNotes as! Detailview
            mainview.presentViewController(alert, animated: true, completion: nil)
            break
        case "3" :
            let mainview = ViewForNotes as! cardViewController
            mainview.presentViewController(alert, animated: true, completion: nil)
            break
        default:
            let mainview = ViewForNotes as! Detailview
            mainview.presentViewController(alert, animated: true, completion: nil)
            break
        }

        
    }
    
    func showShareEmail(){
        let createalert = UIAlertController(title: "Share Note", message: "Emails to Share", preferredStyle: UIAlertControllerStyle.Alert)
        let createcancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            switch(self.checkstatus){
            case "2" :
                let mainview = ViewForNotes as! Listview
                mainview.closeShareView(nil)
                break
            case "1" :
                let mainview = ViewForNotes as! Detailview
                mainview.closeShareView(nil)
                break
            default:
                let mainview = ViewForNotes as! Detailview
                mainview.closeShareView(nil)
                break
            }
            
        }
        let createsave = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                
                self.checkvalidation = true
                emailsText = self.emaillist.text!;
                var fullNameArr = self.emaillist.text?.characters.split{$0 == ","}.map(String.init)
                print(fullNameArr)
                if(self.emaillist.text! == ""){
                    self.checkvalidation = false
                }
                for(var i = 0 ; i < fullNameArr?.count ; i++){
                    print(fullNameArr![i])
                    if(fullNameArr![i].isBlank){
                        self.checkvalidation = false
                    }
                    print(fullNameArr![i].isEmail)
                    if(!fullNameArr![i].isEmail){
                        self.checkvalidation = false
                    }
                }
                print(self.checkvalidation);
                if(self.checkvalidation){
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.noteobj.localtoserver{(json: JSON) -> () in
                            self.noteobj.servertolocal{(json: JSON) -> () in
                                let onenote = self.noteobj.findOne(strtoll(selectedNoteId,nil,10));
                                self.noteobj.shareNote(onenote![self.noteobj.serverid]!, email: self.emaillist.text!, completion: self.resShareNote)
                            }
                        }
                    })
                    
                    switch(self.checkstatus){
                    case "2" :
                        let mainview = ViewForNotes as! Listview
                        mainview.closeShareView(nil)
                        break
                    case "1" :
                        let mainview = ViewForNotes as! Detailview
                        mainview.closeShareView(nil)
                        break
                    default:
                        let mainview = ViewForNotes as! Detailview
                        mainview.closeShareView(nil)
                        break
                    }

                    
                    
                }else{
                    print("inside check validation")
                    self.showError()
                }
            })
            //            self.folderobj.create(self.createfolsername.text!)
            //            self.viewDidLoad()
        }
        createalert.addAction(createcancel)
        createalert.addAction(createsave)
        createalert.addTextFieldWithConfigurationHandler { shareemaillist -> Void in
            shareemaillist.placeholder = "Enter email(,)"
            self.emaillist = shareemaillist
        }
        //        let mainview = ViewForNotes as! Listview
        
        switch(checkstatus){
        case "2" :
            let mainview = ViewForNotes as! Listview
            mainview.presentViewController(createalert, animated: true, completion: nil)
            break
        case "1" :
            let mainview = ViewForNotes as! Detailview
            mainview.presentViewController(createalert, animated: true, completion: nil)
            break
        case "3" :
            let mainview = ViewForNotes as! cardViewController
            mainview.presentViewController(createalert, animated: true, completion: nil)
            break
        default:
            let mainview = ViewForNotes as! Detailview
            mainview.presentViewController(createalert, animated: true, completion: nil)
            break
        }
    }
    
    @IBAction func shareViaNoteshare(sender: AnyObject) {
//        print(checkstatus);
        
        showShareEmail()
        
        
    }
    
    func shareViaText() {}
    
    func shareViaSreenshot () {}
    
    func shareViaUrl () {}
    
}
