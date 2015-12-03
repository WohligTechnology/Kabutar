//
//  cardViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 22/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//
import UIKit
import MapKit
import DKChainableAnimationKit
import UIColor_Hex_Swift


class cardViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource ,UICollectionViewDelegate {
    
    @IBOutlet weak var sorting: SortView!
    @IBOutlet weak var viewing: ViewView!
    var collectionView: UICollectionView!
    var selected:NSIndexPath = NSIndexPath();
    
    var myview: DateTime!;
    let ConfigObj = Config()
    
    var notesTitle:[String] = []
    var notesId:[Int64] = []
    var modificationTime: [Double] = []
    var noteDesc: [String!] = []
    var color: [String] = []
    var islocked: [Int64] = []
    var notesobj = Note()
    var insideView = NoteCollectionUIView()
    
    var searchTable = ""
    
    
    override func viewDidLoad() {
        
        ViewForNotes = self;
        
        super.viewDidLoad()
        if(isInsideFolder == 0)
        {
            self.setNavigationBarItem()
        }
        else
        {
            if(self.navigationController?.toolbar.barTintColor != nil)
            {
                last_navigation = self.navigationController
                print(last_navigation?.toolbar);

            }
            else
            {
                self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
                self.navigationController?.navigationBar.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.whiteColor() ]
                self.navigationController?.navigationBar.translucent = false
                self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
                self.navigationController?.toolbar.barTintColor = PinkColor
                self.navigationController?.navigationBar.barTintColor = PinkColor
            }

        }
        getAllNotes()
        
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (width-30)/2, height: (height-30)/4)
        
        collectionView = UICollectionView(frame: CGRectMake(0,-10, width,height-104 ), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.clearColor();
        self.view.addSubview(collectionView)
        
//        let createNoteTap = UIGestureRecognizer(target: self, action: "createTap:")
        
     
        
        let addView = AddCircle(frame: CGRectMake(width/2 - 35, height-134, 70, 70))
//        addView.addGestureRecognizer(createNoteTap)
        self.view.addSubview(addView)
        
       
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        searchTable = searchController.searchBar.text!
//        getAllNotes()
//        self.listView.reloadData()
    }
    
    func getAllNotes () {
        
        ViewForNotes = self;
        notesTitle = []
        notesId = []
        modificationTime = []
        color = []
        islocked = []
        
        
       
            for row in notesobj.find2("") {
                notesTitle.append(row[1] as! String!)
                notesId.append(row[0] as! Int64! )
                modificationTime.append(Double(row[5] as! Int64!) )
                color.append(row[2] as! String!)
                islocked.append(row[3] as! Int64!)
                noteDesc.append(row[4] as! String! )
            }

    }
    
    func createTap(sender:UITapGestureRecognizer?){
        
    }

    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.notesTitle.count
    }
    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (self.view.frame.width), (self.view.frame.height)))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    var addColorPattern:ColorPattern!
    
    func closeColorPattern(sender:UIGestureRecognizer?){
        PressCkeck = 0
        self.addColorPattern.animation.makeY((self.view.frame.height)).easeInOut.animateWithCompletion(transitionTime, {
            self.addColorPattern.removeFromSuperview()
            
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
        
    }
    
    var PressCkeck = 0
    
    func colorPattern(sender: UILongPressGestureRecognizer)
    {
        let pass = sender.locationInView(self.collectionView)
        let indexPath: NSIndexPath = self.collectionView.indexPathForItemAtPoint(pass)!
        ColorNote = String(notesId[indexPath.row])
        
        if(PressCkeck == 0){
           PressCkeck = 1
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeColorPattern:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.view.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
        self.addColorPattern = ColorPattern(frame: CGRectMake(MainWidth/4 - 50,MainHeight/4, 300, 200))
        self.view.addSubview(self.addColorPattern)
        }

    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        insideView = NoteCollectionUIView(frame: CGRectMake(0,0,(width-30)/2,(height-30)/4))
        
        insideView.titleLabel.text = notesTitle[indexPath.row] as? String
        insideView.descLabel.text = (noteDesc[indexPath.row] as? String?)!
        let moddate = NSDate(timeIntervalSince1970: modificationTime[indexPath.row] as! Double)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle  = .MediumStyle // superset of OP's format
        let str = dateFormatter.stringFromDate(moddate)
        //        insideView.descLabel.text = notesId[indexPath.row] as? String
        insideView.timeLabel.text = str
        let colorno = color[indexPath.row]
      
        insideView.view.backgroundColor = NoteColors[Int(colorno)!]
        
        cell.addSubview(insideView);
        
        let celllongPress = UILongPressGestureRecognizer(target: self, action: "colorPattern:")
        cell.addGestureRecognizer(celllongPress)
        
        cell.backgroundColor = UIColor(rgba:"#96CEEE")
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedNoteId = String(self.notesId[indexPath.row])
        config.set("note_id", value2: String(selectedNoteId))
        if(islocked[indexPath.row] == 0){
            selectedNoteIndex = Int(indexPath.row)

            self.performSegueWithIdentifier("showdetail", sender: self)
            
        }
        else{
            selectedNoteId = self.notesId[indexPath.row] as! String
            selectedNoteIndex = Int(indexPath.row)
            
            let passcodemodal = self.storyboard?.instantiateViewControllerWithIdentifier("PasswordViewController") as! PasswordViewController
            
            passcodemodal.setLock = String(self.islocked[indexPath.row])
            
            let realpasscode = config.get("passcode")
            passcodemodal.lockValue = 3
            passcodemodal.titleName = (self.notesTitle[indexPath.row] as? String)!
            presentViewController(passcodemodal, animated: true, completion: nil)
            
            self.getAllNotes()
            self.collectionView.reloadData()
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showdetail"){
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            let vc = segue.destinationViewController as! detailViewController
            vc.title = self.notesTitle[selectedNoteIndex] as? String
        }
    }
    
    
    func getselectedNote(val:Int64) {
        selectedNoteIndex = (self.notesId.indexOf(val))!
        
    }
    
}
