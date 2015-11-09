//
//  datetime.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 03/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit

class DateTime: UIView {
    @IBOutlet weak var datetimepopup: UIView!
    var blackOut:UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    let dateFormatter = NSDateFormatter()
    let timeFormatter = NSDateFormatter()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    @IBAction func buttonOk(sender: AnyObject) {
        if(checkstatus == 2){
        let mainview = ViewForNotes as! Listview
            mainview.closeTimeBomb(nil);
        }else if(checkstatus == 1){
            let mainview = ViewForNotes as! Detailview
            mainview.closeTimeBomb(nil);
        }
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let SumDateFormat = NSDateFormatter()
        SumDateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        SumDateFormat.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let finalDate = SumDateFormat.dateFromString(dateFormatter.stringFromDate(datePicker.date) + ", " + timeFormatter.stringFromDate(timePicker.date))
        
        print(finalDate?.timeIntervalSince1970);
        print(SumDateFormat.stringFromDate(finalDate!));
        self.removeFromSuperview()
        
    }
    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, MainWidth, MainHeight))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func loadViewFromNib() {
        
        
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DateTime", bundle: bundle)
        let datetimepopup = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        datetimepopup.frame = bounds
        datetimepopup.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(datetimepopup);
        
        //let blackOutTap = UITapGestureRecognizer(target: self,action: "closeNewSortView:")
        print(MainWidth)
        print(MainHeight)
        addBlackView()
        
//        blackOut.addGestureRecognizer(blackOutTap)
        //blackOut.alpha = 0.5
        self.window?.rootViewController?.view.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
