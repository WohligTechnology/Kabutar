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

class cardViewController: UIViewController,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource ,UICollectionViewDelegate {
    
    @IBOutlet weak var sorting: SortView!
    @IBOutlet weak var viewing: ViewView!
    var collectionView: UICollectionView!
    var selected:NSIndexPath = NSIndexPath();
    
    var myview: DateTime!;
    
    var notesTitle:NSMutableArray = []
    var notesId:NSMutableArray = []
    var modificationTime: NSMutableArray = []
    var color: [String] = []
    var notesobj = Note()
    var insideView = NoteCollectionUIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let bottomLine = UIView(frame: CGRectMake(0,height-114, width , 1))
        bottomLine.backgroundColor = PinkColor
        self.view.addSubview(bottomLine)
        
        let addView = AddCircle(frame: CGRectMake(width/2 - 35, height-134, 70, 70))
//        addView.addGestureRecognizer(createNoteTap)
        self.view.addSubview(addView)
        
    }
    
    func getAllNotes () {
        
        ViewForNotes = self;
        notesTitle = []
        notesId = []
        modificationTime = []
        color = []
        
        
        
        if(selectedFolderToNoteId==""){
            for row in notesobj.find() {
                notesTitle.addObject(row[notesobj.title]!)
                notesId.addObject(String(row[notesobj.id]))
                modificationTime.addObject(Double(row[notesobj.modificationTime]))
                color.append(row[notesobj.color]!)
            }
            print("Color");
            print(color);
            
        } else {
            for row in notesobj.getNotesFolder(selectedFolderToNoteId) {
                notesTitle.addObject(row[notesobj.title]!)
                notesId.addObject(String(row[notesobj.id]))
                modificationTime.addObject(Double(row[notesobj.modificationTime]))
                color.append(row[notesobj.color]!)
                
            }
            
        }
        

    }
    
    func createTap(sender:UITapGestureRecognizer?){
        print("create tap")
        
    }

    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(selectedFolderToNoteId=="")
        {
        self.setNavigationBarItem()
        self.navigationController?.setToolbarHidden(true, animated: animated)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
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
        ColorNote = notesId[indexPath.row] as! String
        
        if(PressCkeck == 0){
           PressCkeck = 1
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeColorPattern:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.view.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
        self.addColorPattern = ColorPattern(frame: CGRectMake(MainWidth/4 - 50,MainHeight/4, 300, 150))
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
        let moddate = NSDate(timeIntervalSince1970: modificationTime[indexPath.row] as! Double)
        //        insideView.descLabel.text = notesId[indexPath.row] as? String
        insideView.timeLabel.text = String(moddate)
        let colorno = color[indexPath.row]
        print(colorno);
        insideView.view.backgroundColor = NoteColors[Int(colorno)!]
        
        cell.addSubview(insideView);
        
        var celllongPress = UILongPressGestureRecognizer(target: self, action: "colorPattern:")
        cell.addGestureRecognizer(celllongPress)
        
        cell.backgroundColor = UIColor(rgba:"#96CEEE")
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showdetail", sender: self)
        print("im selected")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showdetail"){
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            print(indexPaths)
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = segue.destinationViewController as! detailViewController
            vc.title = self.notesTitle[indexPath.row] as? String
            
        }
    }
    
}
