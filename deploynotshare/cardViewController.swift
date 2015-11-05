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
    
    
    var num = 1
    var num1 = 1
    var shouldSort = true
    var shouldView = true
    //    var touch = UITapGestureRecognizer(target:self, action:"tapFunc")
    
    @IBAction func ViewTap(sender: AnyObject) {
        if shouldView {
            if (num1==1)
            {
                num1 = 0
                shouldView=false
                self.viewing.animation.makeOpacity(1.0).moveY(-1*viewing.frame.size.height+viewing.frame.size.height).animateWithCompletion(0.30, {
                    self.shouldView=true
                    
                })
            }
            else
            {
                num1 = 1;
                shouldView=false
                self.viewing.animation.makeOpacity(0.0).moveY(-1*(-1*viewing.frame.size.height+viewing.frame.size.height)).animateWithCompletion(0.30, {
                    self.shouldView=true
                    
                })
            }
        }
    }
    @IBAction func SortTap(sender: AnyObject) {
        
        
        
        if shouldSort {
            if (num==1)
            {
                num = 0
                shouldSort=false
                self.sorting.animation.makeOpacity(1.0).moveY(-1*sorting.frame.size.height+70).animateWithCompletion(0.30, {
                    self.shouldSort=true
                    
                })
            }
            else
            {
                num = 1;
                shouldSort=false
                self.sorting.animation.makeOpacity(0.0).moveY(-1*(-1*sorting.frame.size.height+70)).animateWithCompletion(0.30, {
                    self.shouldSort=true
                    
                })
            }
        }
    }
    
    var selected:NSIndexPath = NSIndexPath();
    
    // Modal cancel button event
    //    @IBAction func cancelbutton(sender: AnyObject) {
    //        self.dismissViewControllerAnimated(true, completion: nil)
    //    }
    //    @IBAction func cancelbutton(sender: AnyObject) {
    //        self.dismissViewControllerAnimated(true, completion: nil)
    //    }
    var labeltext = ["BIOLOGY","PYSICS","MATHS","ECOLOGY","BIOLOGY","PYSICS","MATHS","ECOLOGY"]
    let descriptiontext = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry.","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the printing and typesetting industry.","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the","Lorem Ipsum is simply dummy text of the"]
    let timestamptext = ["01.04.15","01.04.15","01.04.15","01.04.15","01.04.15","01.04.15","01.04.15","01.04.15"]
    let colorcode = ["84FA88","FA8681","5BFAE0","6365FA"]
    
    var myview: DateTime!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapoverl = UITapGestureRecognizer(target: self, action: "onTap")
        
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
        
        let bottomLine = UIView(frame: CGRectMake(0,height-114, width , 1))
        bottomLine.backgroundColor = UIColor(red: 255.0/255.0, green: 90/255, blue: 96/255, alpha: 1.0)
        self.view.addSubview(bottomLine)
        
        let addView = AddCircle(frame: CGRectMake(width/2 - 35, height-134, 70, 70))
        self.view.addSubview(addView)
        
    }
    
    func onTap(){
        self.SortTap([]);
        self.ViewTap([]);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        self.navigationController?.setToolbarHidden(true, animated: animated)
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
        return self.labeltext.count
    }
    
    
    func colorPattern(longpress: UIGestureRecognizer)
    {
        print("long press");
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let bounds = UIScreen.mainScreen().bounds
        let width = bounds.size.width
        let height = bounds.size.height
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let insideView = NoteCollectionUIView(frame: CGRectMake(0,0,(width-30)/2,(height-30)/4))
        
        insideView.titleLabel.text = labeltext[indexPath.row]
        insideView.descLabel.text = descriptiontext[indexPath.row]
        insideView.timeLabel.text = timestamptext[indexPath.row]
        insideView.view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        cell.addSubview(insideView);
        
        
        
//        print(indexPath);
        
        cell.backgroundColor = UIColor.orangeColor()
        return cell
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showdetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showdetail"){
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()!
            print(indexPaths)
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = segue.destinationViewController as! detailViewController
            vc.title = self.labeltext[indexPath.row]
            
        }
    }
    
}
