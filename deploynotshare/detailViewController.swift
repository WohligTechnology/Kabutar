import UIKit
import RichEditorView

var GDetailView:Any!

class detailViewController: UIViewController , UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet weak var FooterView: UIView!
    var istoolbaropen = false
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var ScrView: UIScrollView!
    var vLayout:VerticalLayout!
    var editor:RichEditorView!
    var mainColor = PinkColor
    var toolbar:RichEditorToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let b = UIBarButtonItem(image: UIImage(named: "Checkboxicon"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addCheckBox"))
        
        self.navigationItem.rightBarButtonItem = b
        GDetailView = self
        vLayout = VerticalFitLayout(width: view.frame.width)
        
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
            //print(toolbarItem.image?.imageAsset)
            toolbarItem.tintColor = UIColor.whiteColor()
        }

        
        
    }
    func changeHeight() {
        
        vLayout?.layoutSubviews()
        let newSize = CGSize(width: vLayout.frame.size.width, height: vLayout.frame.height + 44)
        self.ScrView.contentSize = newSize
        
    }
    
    func addTextTap() {
        
        editor = RichEditorView(frame: CGRectMake(10,5,width-20,28))
        editor.setHTML("")
        editor.delegate = self;
        vLayout.addSubview(editor)
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
            print("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }

        
    }
    
    func openGallery () {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            print("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }

        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        
        })
        print(editingInfo);
        
        let fullImage = UIAlertAction(title: "Use Full Size", style: UIAlertActionStyle.Default)
        {
                UIAlertAction in
                self.appendImage(editingInfo[UIImagePickerControllerOriginalImage] as! UIImage)
        }
        let cropImage = UIAlertAction(title: "Use Crop Size", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                self.appendImage(image)
        }
        
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(fullImage)
        alert.addAction(cropImage)

        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func appendImage(image: UIImage!) {
        let newheight = width / image.size.width * image.size.height
        
        let imageView = UIImageView(frame: CGRectMake(0,0,width+10,newheight))
        imageView.image = image
        vLayout.addSubview(imageView)
        changeHeight()

    }

    
    func addAudioTap() {
        
    }
    func addSketchTap() {
        
    }
    func addCheckBox() {
        let checkbox = ElementCheckBox(frame: CGRectMake(0,0,width,50))
        vLayout.addSubview(checkbox)
        changeHeight()
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
    }
    
    func richEditorTookFocus(editor: RichEditorView) {
        print("How is it");
        toolbar.editor = editor
        if(!istoolbaropen) {
        istoolbaropen  = true
        self.toolbar.frame = CGRectMake(width, 0, width + 10, 44)
        self.toolbar.animation.moveX(-FooterView.frame.width).animate(transitionTime)
        }
        
    }
    
    func richEditorLostFocus(editor: RichEditorView) {
        print("Lost it");
        
        let seconds = 0.1
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        istoolbaropen  = false
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            if(!self.istoolbaropen)
            {
                print("Going in");
                self.istoolbaropen  = false
                self.toolbar.frame = CGRectMake(0, 0, width + 10, 44)
                self.toolbar.animation.moveX(self.FooterView.frame.width).animate(transitionTime)
            }

            
        })
        
    }
    
    func richEditorDidLoad(editor: RichEditorView) {
        editor.focus()
    }
    
    func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool { return true }
    
    func richEditor(editor: RichEditorView, handleCustomAction content: String) { }
    
}