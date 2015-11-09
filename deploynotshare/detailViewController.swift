//
//  detailViewController.swift
//  deploynotshare
//
//  Created by Jagruti Patil on 23/10/15.
//  Copyright © 2015 Wohlig. All rights reserved.
//

import UIKit
import RichEditorView

var GDetailView:Any!

class detailViewController: UIViewController {
    
    
    
    @IBOutlet weak var ScrView: UIScrollView!
    var vLayout:VerticalLayout!
    var editor:RichEditorView!
    var mainColor = PinkColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GDetailView = self
        vLayout = VerticalFitLayout(width: view.frame.width)
        
        self.ScrView.insertSubview(vLayout, atIndex: 0)
        
        editor = RichEditorView(frame: CGRectMake(0,0,width,28))
        editor.setHTML("God is great")
        
//        let p = editor.runJS("document.queryCommandValue('Bold')")
//        print("Console");
        editor.delegate = self;
        
        vLayout.addSubview(editor)
        editor.setEditorBackgroundColor(UIColor.redColor())
        editor.setTextBackgroundColor(UIColor.redColor())
        editor.backgroundColor = UIColor.redColor()
        changeHeight()
        
        let footerView = DetailViewFooterMain(frame: CGRectMake(0,self.view.frame.height-108,width,44))
        self.view.addSubview(footerView)
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

