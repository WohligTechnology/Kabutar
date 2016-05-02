//
//  NoteCollectionUIView.swift
//  deploynotshare
//
//  Created by Chintan Shah on 05/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
var newCardNoteMenu:CardNoteMenu!
var cardSelectedId = String()


class NoteCollectionUIView: UIView {

        var view:UIView!;

    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
  
    @IBOutlet weak var cardNoteId: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var selectedId = String()
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            loadViewFromNib ()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            loadViewFromNib ()
        }
    func loadViewFromNib() {
            let bundle = NSBundle(forClass: self.dynamicType)
            let nib = UINib(nibName: "NoteCollectionViewCell", bundle: bundle)
            let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
            view.frame = bounds
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            self.addSubview(view);
//            var myImg = moreBtn.imageForState(.Normal)
//            myImg.t
            
        }
    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, (self.window?.frame.width)!, (self.window?.frame.height)!))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    func closeMenuTap (sender:UITapGestureRecognizer?) {
        newCardNoteMenu.animation.makeY((self.window?.frame.height)!).easeInOut.animateWithCompletion(transitionTime, {
            newCardNoteMenu.removeFromSuperview()
        })
        blackOut.animation.makeAlpha(0).animateWithCompletion(transitionTime,{
            blackOut.removeFromSuperview()
        })
    }

    @IBAction func addMore(sender: AnyObject) {
        print(selectedId)
        selectedNoteId = cardNoteId.text!
        let blackOutTap = UITapGestureRecognizer(target: self,action: "closeMenuTap:")
        self.addBlackView()
        blackOut.addGestureRecognizer(blackOutTap)
        blackOut.alpha = 0
        self.window?.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
        newCardNoteMenu = CardNoteMenu(frame: CGRectMake(40, (self.window?.frame.height)!-20, (self.window?.frame.width)! - 80,305));
//        newCardNoteMenu.layer.zPosition = 100000
        self.window?.addSubview(newCardNoteMenu)
        newCardNoteMenu.animation.moveY(-350).easeInOut.animate(transitionTime)

    }

}
