import UIKit
import RichEditorView

var GDetailView:detailViewController!
var GSketch:ElementSketch!
var GElementCheckBox:ElementCheckBox!
var GElementAudio:ElementRecording!
var loadingCompleted = false
var GvLayout:VerticalLayout!
class detailViewController: UIViewController , UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var keyboardOn = false
    
    @IBOutlet weak var FooterConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var FooterView: UIView!
    var istoolbaropen = false
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var ScrView: UIScrollView!
    var vLayout:VerticalLayout!
    var editor:RichEditorView!
    var mainColor = PinkColor
    var toolbar:RichEditorToolbar!
    var sketchno = 2
    var sketch:ElementSketch!
    var sketchFooter = ElementSketchFooter(frame: CGRectMake(width,0,width+10,44))
    let sideMenuController  = slideMenuLeft as! SlideMenuController
    
    var activeCheckbox : ElementCheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingCompleted = false
        initNavigationItemTitleView();
        
//        let recognizer = UITapGestureRecognizer(target: self.title, action: "titleWasTapped")
//        self.title.userInteractionEnabled = true
//        self.title.addGestureRecognizer(recognizer)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHidden:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let bc = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneTap"))
        
        self.navigationItem.rightBarButtonItem = bc
        GDetailView = self
        vLayout = VerticalFitLayout(width: view.frame.width)
        GvLayout = vLayout
        self.ScrView.alpha  = 0
        
        self.ScrView.insertSubview(vLayout, atIndex: 0)
        
        
        let footerView = DetailViewFooterMain(frame: CGRectMake(0,0,width+10,44))
        self.FooterView.addSubview(footerView)
        
        
        toolbar = RichEditorToolbar(frame: CGRectMake(width,0, width+10, 44))
        toolbar.options = RichEditorOptions.someOptions()
        
        self.FooterView.addSubview(toolbar)
        
        
        toolbar.backgroundToolbar.tintColor = PinkColor
        toolbar.toolbar.backgroundColor = PinkColor
        toolbar.toolbarScroll.backgroundColor = PinkColor
        for var toolbarItem in toolbar.toolbar.items!
        {
            toolbarItem.tintColor = UIColor.whiteColor()
        }
        
        self.FooterView.addSubview(sketchFooter)
        
        for noteElement in NoteElementModel.getAllNoteElement()
        {
            
            switch(noteElement[NoteElementModel.type]! as String) {
            case "text":
                NoteElementModel.addHeightOffset(vLayout,order2: noteElement[NoteElementModel.order]!)
                addTextTap(false)
                editor.setID(noteElement[NoteElementModel.id])
                if(noteElement[NoteElementModel.content] != nil)
                {
                    editor.setHTML(noteElement[NoteElementModel.content]!)
                }
                
            case "checkbox":
                NoteElementModel.addHeightOffset(vLayout,order2: noteElement[NoteElementModel.order]!)
                addCheckBox(false)
                
                GElementCheckBox.NoteElementID = noteElement[NoteElementModel.id]
                if(noteElement[NoteElementModel.content] != nil) {
                    GElementCheckBox.checkBoxText.text = noteElement[NoteElementModel.content]!
                }
                if(noteElement[NoteElementModel.contentA] == "true")
                {
                    GElementCheckBox.cb.isChecked = true
                    GElementCheckBox.cb.makeStrikeOut(true);
                }
                
            case "image":
                NoteElementModel.addHeightOffset(vLayout,order2: noteElement[NoteElementModel.order]!)
                if(noteElement[NoteElementModel.content] != nil) {
                    let newImage = UIImage(contentsOfFile: path  + "/" + noteElement[NoteElementModel.content]!)
                    appendImage(newImage, isnew: false)
    
                }
            
            case "audio":
                NoteElementModel.addHeightOffset(vLayout,order2: noteElement[NoteElementModel.order]!)
                if(noteElement[NoteElementModel.content] != nil) {
                    addAudioTap(false)
                    GElementAudio.soundFilename = noteElement[NoteElementModel.content]
                    GElementAudio.soundFileURL = NSURL(fileURLWithPath: path + "/" + GElementAudio.soundFilename)
                    GElementAudio.getDuration()
                }
            case "scribble":
                
                if(noteElement[NoteElementModel.content] != nil) {
                    
                    print(noteElement[NoteElementModel.content]);
                    print(noteElement[NoteElementModel.contentA]);
                    
                    let newImage = UIImage(contentsOfFile: path  + "/" + noteElement[NoteElementModel.content]!)
                    
                    if let n = NSNumberFormatter().numberFromString(noteElement[NoteElementModel.contentA]!) {
                        let f = CGFloat(n)
                        appendSketch(f, image:newImage!)
                    }

                    
                }
                
            default :
                break;
            }
        }
        
        
        let seconds = transitionTime
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            loadingCompleted = true
            self.ScrView.animation.makeOpacity(1.0).animate(transitionTime);
        })
        
        
    }
    
    func doneTap() {
        editor?.blur()
        sketch?.closeDrawing()
        removeSketchToolbar()
        ScrView.scrollEnabled = true
        
        let topOffset = ScrView.contentOffset.y
        GElementCheckBox?.checkBoxText.resignFirstResponder()
        
        if (sketch?.mainImageView?.image != nil)
        {
            appendSketch(topOffset, image: (sketch?.mainImageView?.image )!)
            sketch?.removeFromSuperview()
            sketch?.mainImageView.image = nil
        }
        
    }
    
    func appendSketch(topOffset:CGFloat , image: UIImage) {
        
        
        print(image.size)
        let DemoImage =  UIImageView(frame: CGRectMake(0,topOffset, image.size.width, image.size.height))
        DemoImage.image = image
        ScrView.insertSubview(DemoImage, atIndex: sketchno++)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        self.keyboardOn = true;
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.FooterConstrain.constant = keyboardFrame.size.height
        })
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        keyboardOn = false
        let info = notification.userInfo!
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.FooterConstrain.constant = 0
        })
    }
    
    func changeHeight() {
        
        let iniHeight = self.ScrView.contentSize.height;
        
        vLayout?.layoutSubviews()
        let newSize = CGSize(width: vLayout.frame.size.width, height: vLayout.frame.height + ScrView.bounds.height)
        self.ScrView.contentSize = newSize
        let newHeight = newSize.height
        
        if(iniHeight < newHeight)
        {
            
            let diff = newHeight - ScrView.contentOffset.y
          
            if(diff < 1200 && diff > 930)
            {
                ScrView.contentOffset.y = (newHeight  - 2*ScrView.bounds.height + 250)
            }
            
        }
        
    }
    
    func addTextTap(isnew: Bool) {
        
        print("Data");
        
        editor = RichEditorView(frame: CGRectMake(10,5,width-20,28))
        editor.setHTML("")
        print(vLayout.frame.size.height)
        
        
        editor.delegate = self;
        vLayout.addSubview(editor)
        if(isnew)
        {
            editor.setID(NoteElementModel.create("text"))
        }
        
        changeHeight()
    }
    func addImageTap() {
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
        }
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    
    
    func openCamera () {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    func openGallery () {
        
        print("Image picker");
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        print("CHECK");
        print(editingInfo[UIImagePickerControllerMediaURL])
        
        let fullImage = UIAlertAction(title: "Use Full Size", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.appendImage(editingInfo[UIImagePickerControllerOriginalImage] as! UIImage,isnew: true)
                
        }
        let cropImage = UIAlertAction(title: "Use Crop Size", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.appendImage(image,isnew: true)
        }
        
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(fullImage)
        alert.addAction(cropImage)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func appendImage(image: UIImage!, isnew:Bool) {
        if(image != nil) {
            let newheight = width / image.size.width * image.size.height
            let imageView = UIImageView(frame: CGRectMake(0,0,width+10,newheight))
            imageView.contentMode = .ScaleAspectFit
            if(newheight > ScrView.bounds.height)
            {
                imageView.frame.size.height = ScrView.bounds.height
            }
            
            if(isnew) {
                
                let id  = NoteElementModel.create("image")
                let userid = config.get("user_id")
                let currenttimestamp = String(NSDate().timeIntervalSince1970)
                let randomNum = String(arc4random_uniform(9999));
                let imagename = "IMG_" + userid + "_" + currenttimestamp + "_" + randomNum + ".jpg"  ;
                let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                let destinationPath = String(documentsPath) + "/" + imagename
                
                
                
                UIImageJPEGRepresentation(image,1.0)!.writeToFile(destinationPath, atomically: true)
                
                print(destinationPath);
                NoteElementModel.edit(id, content2: imagename, contentA2: "", contentB2: "")
            }
            
            
        				
            imageView.image = image
            vLayout.addSubview(imageView)
            changeHeight()
        }
        
    }
    
    
    func addAudioTap(isnew:Bool) {
        
        let recording = ElementRecording(frame: CGRectMake(0,0,width,50))
        GElementAudio = recording
        
        vLayout.addSubview(recording)
        changeHeight()
        
        
    }
    func addSketchTap() {
        let topOffset = ScrView.contentOffset.y
        sketch = ElementSketch(frame: CGRectMake(0,topOffset,width+10,height - 44))
        
        
        ScrView.insertSubview(sketch,atIndex: sketchno++)
        
        GSketch = sketch
        GSketch.setID(NoteElementModel.create("scribble"))
        GSketch.topOffset = topOffset
       
        
        getSketchToolbar()
        
        
        ScrView.scrollEnabled = false
        //        sideMenuController.removeLeftGestures()
        //        sideMenuController.removeRightGestures()
        
        changeHeight()
    }
    func addCheckBox(isnew: Bool) {
        
        
        
        let checkbox = ElementCheckBox(frame: CGRectMake(0,0,width,50))
        
        vLayout.addSubview(checkbox)
        GElementCheckBox = checkbox
        changeHeight()
        if(isnew)
        {
            checkbox.setID(NoteElementModel.create("checkbox"))
            checkbox.checkBoxText.becomeFirstResponder()
        }
    }
    
    
    func getSketchToolbar() {
        self.sketchFooter.frame = CGRectMake(width, 0, width + 10, 44)
        self.sketchFooter.animation.moveX(-width).animate(transitionTime)
        
    }
    func removeSketchToolbar() {
        self.sketchFooter.frame = CGRectMake(0, 0, width + 10, 44)
        self.sketchFooter.animation.moveX(width).animate(transitionTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initNavigationItemTitleView() {
        let titleView = UILabel()
        titleView.text = self.title
        titleView.textColor = UIColor.whiteColor()
        let width = titleView.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max)).width
        titleView.frame = CGRect(origin:CGPointZero, size:CGSizeMake(width, 500))
        self.navigationItem.titleView = titleView
        
        let recognizer = UITapGestureRecognizer(target: self, action: "titleWasTapped")
        titleView.userInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
    }
    
    @objc private func titleWasTapped() {
        NSLog("Hello, titleWasTapped!")
    }

    
    
}



extension detailViewController: RichEditorDelegate {
    
    
    
    func richEditor(editor: RichEditorView, heightDidChange height: Int) {
        
        editor.frame.size = CGSize(width: width, height: CGFloat(height))
        self.changeHeight()
    }
    
    func richEditor(editor: RichEditorView, contentDidChange content: String) {
        let changeElementId = editor.NoteElementID
        if(loadingCompleted)
        {
            NoteElementModel.edit(changeElementId, content2: content,contentA2: content.stripHTML() ,contentB2: "" )
        }
    }
    
    
    func richEditorTookFocus(editor: RichEditorView) {
        
        self.editor = editor
        
        toolbar.editor = editor
        if(!istoolbaropen) {
            istoolbaropen  = true
            self.toolbar.frame = CGRectMake(width, 0, width + 10, 44)
            self.toolbar.animation.moveX(-FooterView.frame.width).animate(transitionTime)
        }
    }
    
    func richEditorLostFocus(editor: RichEditorView) {
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        istoolbaropen  = false
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            if(!self.istoolbaropen)
            {
                self.istoolbaropen  = false
                self.toolbar.frame = CGRectMake(0, 0, width + 10, 44)
                self.toolbar.animation.moveX(self.FooterView.frame.width).animate(transitionTime)
            }
        })
    }
    
    func richEditorDidLoad(editor: RichEditorView) {
        if(loadingCompleted) {
            editor.focus()
        }
    }
    
    func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool { return true }
    
    func richEditor(editor: RichEditorView, handleCustomAction content: String) { }
    
}


/**
The html replacement regular expression
*/
let     htmlReplaceString   :   String  =   "<[^>]+>"




extension String {
    /**
     Takes the current String struct and strips out HTML using regular expression. All tags get stripped out.
     
     :returns: String html text as plain text
     */
    func stripHTML() -> String {
        let abc = self.stringByReplacingOccurrencesOfString(htmlReplaceString, withString: " ", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        return abc.stringByReplacingOccurrencesOfString("&nbsp;", withString:" ")
    }
}

