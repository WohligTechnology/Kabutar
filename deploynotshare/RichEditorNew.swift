//
//  RichEditorNew.swift
//  deploynotshare
//
//  Created by Chintan Shah on 27/11/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import RichEditorView

class RichEditorNew: RichEditorView {
   
    var deleteView:DeleteSection!

    func showDelete () {
        if(deleteView != nil)
        {
            deleteView.removeFromSuperview();
        }
        deleteView = DeleteSection(frame: CGRectMake(self.frame.size.width + 5, 0, 30, 30))
        self.addSubview(deleteView)
        print(self.NoteElementID);
        deleteView.setID(self.NoteElementID)
        deleteView.topView = self
        deleteView.frame = CGRectMake(self.frame.size.width + 5, 0, 30, 30)
        deleteView.animation.moveX(-30).animate(transitionTime)
        
    }
    func hideDelete() {
        deleteView.frame = CGRectMake(self.frame.size.width+10 - 30 , 0, 30, 30)
        deleteView.animation.moveX(30).animate(transitionTime)
    }

}
