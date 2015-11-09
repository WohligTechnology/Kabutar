//
//  detailViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 23/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import RichEditorView

class detailViewController: UIViewController {
    
    
    let mainColor = PinkColor
    override func viewDidLoad() {
        super.viewDidLoad()
        var vLayout:VerticalLayout!
        var editor:RichEditorView!
        
        vLayout = VerticalLayout(width: view.frame.width)
        
        vLayout.backgroundColor = UIColor.cyanColor()
        self.ScrView.insertSubview(vLayout, atIndex: 0)
        
        editor = RichEditorView(frame: CGRectMake(0,40,width,28))
        editor.setHTML("God is great")
        
        let p = editor.runJS("document.queryCommandValue('Bold')")
        print("Console");
        print(p);
        print("Console End")
        editor.delegate = self;
        
        vLayout.addSubview(editor)
        editor.setEditorBackgroundColor(UIColor.redColor())
        editor.setTextBackgroundColor(UIColor.redColor())
        editor.backgroundColor = UIColor.redColor()
        
        
        let view1 = UIView(frame: CGRectMake(0,50,50,100))
        view1.backgroundColor = UIColor.blueColor()
        
        vLayout.addSubview(view1)
        
        changeHeight()

        
        
        
        

    }
    func changeHeight() {
        
        vLayout?.layoutSubviews()
        self.ScrView.contentSize = vLayout.frame.size
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
    
    func richEditorTookFocus(editor: RichEditorView) { }
    
    func richEditorLostFocus(editor: RichEditorView) { }
    
    func richEditorDidLoad(editor: RichEditorView) { }
    
    func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool { return true }
    
    func richEditor(editor: RichEditorView, handleCustomAction content: String) { }
    
}

