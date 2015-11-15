import UIKit
import RichEditorView

var GDetailView:detailViewController!
var GSketch:ElementSketch!
var GElementCheckBox:ElementCheckBox!

class detailViewController: UIViewController , UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var loadingCompleted = false
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasShown:"), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWasHidden:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let bc = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("doneTap"))
        
        self.navigationItem.rightBarButtonItem = bc
        GDetailView = self
        vLayout = VerticalFitLayout(width: view.frame.width)
        vLayout.alpha  = 1
        
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
                addTextTap(false)
                editor.setID(noteElement[NoteElementModel.id])
                if(noteElement[NoteElementModel.content] != nil)
                {
                    editor.setHTML(noteElement[NoteElementModel.content]!)
                }
                
            case "checkbox":
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
                
                if(noteElement[NoteElementModel.content] != nil) {
                    let newImage = UIImage(contentsOfFile: noteElement[NoteElementModel.content]!)
                    appendImage(newImage, isnew: false)
                }
                
                
                
                
            default :
                break;
            }
        }
        
        
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.loadingCompleted = true
            self.vLayout.alpha = 1.0
        })
        
        
    }
    
    func doneTap() {
        editor?.blur()
        sketch?.closeDrawing()
        removeSketchToolbar()
        ScrView.scrollEnabled = true
        
        let topOffset = ScrView.contentOffset.y
        GElementCheckBox?.checkBoxText.resignFirstResponder()
        
        if (sketch != nil)
        {
            let DemoImage =  UIImageView(frame: CGRectMake(0,topOffset, sketch.frame.width, sketch.frame.height))
            DemoImage.image = sketch?.mainImageView?.image
            ScrView.insertSubview(DemoImage, atIndex: 2)
            sketch?.removeFromSuperview()
            sketch?.mainImageView.image = nil
        }
        
    }
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.FooterConstrain.constant = keyboardFrame.size.height
        })
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        let info = notification.userInfo!
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.FooterConstrain.constant = 0
        })
    }
    
    func changeHeight() {
        
        let iniHeight = self.ScrView.contentSize.height;
        
        vLayout?.layoutSubviews()
        let newSize = CGSize(width: vLayout.frame.size.width, height: vLayout.frame.height + 44)
        self.ScrView.contentSize = newSize
        let newHeight = newSize.height
        
        if(iniHeight < newHeight)
        {
            if((newHeight  - ScrView.bounds.height) > 0)
            {
                ScrView.contentOffset.y = newHeight  - ScrView.bounds.height
            }
            
        }
        
    }
    
    func addTextTap(isnew: Bool) {
        
        editor = RichEditorView(frame: CGRectMake(10,5,width-20,28))
        editor.setHTML("")
        
        
        
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
                
                let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
                let destinationPath = String(documentsPath) + "/image\(id).jpg"
                UIImageJPEGRepresentation(image,1.0)!.writeToFile(destinationPath, atomically: true)
                
                print(destinationPath);
                NoteElementModel.edit(id, content2: destinationPath, contentA2: "", contentB2: "")
            }
            
            
        				
            imageView.image = image
            vLayout.addSubview(imageView)
            changeHeight()
        }
        
    }
    
    
    func addAudioTap() {
        
        let recording = ElementRecording(frame: CGRectMake(0,0,width,50))
        vLayout.addSubview(recording)
        changeHeight()
        
        
    }
    func addSketchTap() {
        let topOffset = ScrView.contentOffset.y
        sketch = ElementSketch(frame: CGRectMake(0,topOffset,width+10,height - 44))
        ScrView.insertSubview(sketch,atIndex: sketchno++)
        
        GSketch = sketch
        
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
    
}



extension detailViewController: RichEditorDelegate {
    
    
    
    func richEditor(editor: RichEditorView, heightDidChange height: Int) {
        
        editor.frame.size = CGSize(width: width, height: CGFloat(height))
        self.changeHeight()
    }
    
    func richEditor(editor: RichEditorView, contentDidChange content: String) {
        let changeElementId = editor.NoteElementID
        NoteElementModel.edit(changeElementId, content2: content,contentA2: editor.getText(),contentB2: "" )
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