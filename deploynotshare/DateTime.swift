//
//  datetime.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 03/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import EventKit

class DateTime: UIView {
    var savedEventId : String = ""
    @IBOutlet weak var datetimepopup: UIView!
    var blackOut:UIView!
    var notesobj = Note()
    
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
    
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
    }
    
    @IBAction func buttonOk(sender: AnyObject) {
        let checkstatus = config.get("note_view")
        if(innotepage == 1){
            let mainview = ViewForNotes as! InsideNoteMenu
            mainview.closeTimeBomb(nil);
        }else{
            if(checkstatus == "2"){
                let mainview = ViewForNotes as! Listview
                mainview.closeTimeBomb(nil);
            }else if(checkstatus == "1"){
                let mainview = ViewForNotes as! Detailview
                mainview.closeTimeBomb(nil);
            }
        }
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let SumDateFormat = NSDateFormatter()
        SumDateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
        SumDateFormat.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let finalDate = SumDateFormat.dateFromString(dateFormatter.stringFromDate(datePicker.date) + ", " + timeFormatter.stringFromDate(timePicker.date))
        
        
        let singlenote = notesobj.findOne(strtoll(selectedNoteId,nil,10))
    
        
        
        if(datetimepopupType == "reminder")
        {
            let eventStore = EKEventStore()
            
            let startDate = finalDate
            let endDate = startDate!.dateByAddingTimeInterval(60 * 60) // One hour
            
            if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
                eventStore.requestAccessToEntityType(.Event, completion: {
                    granted, error in
                    self.createEvent(eventStore, title: singlenote![self.notesobj.title]!, startDate: startDate!, endDate: endDate)
                })
            } else {
                createEvent(eventStore, title: singlenote![self.notesobj.title]!, startDate: startDate!, endDate: endDate)
            }
            notesobj.changeReminderTime(Int64((finalDate?.timeIntervalSince1970)!), id2: selectedNoteId)
            
        }
        else if(datetimepopupType == "timebomb")
        {
            notesobj.changeTimeBomb(Int64((finalDate?.timeIntervalSince1970)!), id2: selectedNoteId)
        }
        self.removeFromSuperview()
        
    }
    
    @IBAction func buttonCancel(sender: AnyObject) {
        self.animation.makeY(height).easeInOut.animateWithCompletion(transitionTime, {
            self.removeFromSuperview()
            let checkstatus = config.get("note_view")
            if(checkstatus == "2"){
                let mainview = ViewForNotes as! Listview
                mainview.closeTimeBomb(nil);
            } else if(checkstatus == "1"){
                let mainview = ViewForNotes as! Detailview
                mainview.closeTimeBomb(nil);
            }
        })
    }
    
    func addBlackView(){
        blackOut = UIView(frame: CGRectMake(0, 0, MainWidth, MainHeight))
        blackOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "DateTime", bundle: bundle)
        let datetimepopup = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
//        datetimepopup.frame = bounds
        datetimepopup.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(datetimepopup);
        
        //let blackOutTap = UITapGestureRecognizer(target: self,action: "closeNewSortView:")
       
        addBlackView()
        datePicker.minimumDate = NSDate();
//        blackOut.addGestureRecognizer(blackOutTap)
        //blackOut.alpha = 0.5
        self.window?.rootViewController?.view.addSubview(blackOut);
        blackOut.animation.makeAlpha(1).animate(transitionTime);
        
    }

}
