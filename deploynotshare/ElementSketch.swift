//
//  ViewController.swift
//  DrawPad
//
//  Created by Jean-Pierre Distler on 13.11.14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit

class ElementSketch: UIView {
    
    var leastValue:CGFloat = 10000.0
    var maxValue: CGFloat = 0
    var maxRadius: CGFloat = 30
    
    
    var oldImages:[UIImage!] = [UIImage()]
    var undoposition = -1;
    var detailView = GDetailView as! detailViewController
    var NoteElementID:Int64!
    var topOffset:CGFloat!
    
    public func setID(id:Int64) {
        self.NoteElementID = id
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    
    var drawingOn = true
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 1.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
    ]
    
    
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
        let nib = UINib(nibName: "ElementSketch", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
        
//        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
//        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
//        
//        GDetailView.view.drawViewHierarchyInRect(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), afterScreenUpdates: true)
//        mainImageView.image  = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
        
        
    }
    
    
    // MARK: - Actions
    
    func changeColor(red2: CGFloat,green2 :CGFloat , blue2 : CGFloat) {
        
        red = red2;
        blue = blue2;
        green = green2;
        
    }
    func changeOpacity(opacity2 : CGFloat) {
        opacity = opacity2
    }
    
  
    func closeDrawing( ) {
        drawingOn = false
    }
    
    @IBAction func pencilPressed(sender: AnyObject) {
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    
    @IBAction func touchedRedo(sender: AnyObject!) {
        if(oldImages.count > (undoposition+2))
        {
            undoposition++
            let oldImage = (oldImages[undoposition+1])
            mainImageView.image = oldImage
            saveImageIn()
        }
        
        
    }
    
    
    @IBAction func touchedUndo(sender: AnyObject!) {
        
        if(oldImages.count > 0 && undoposition >= 0)
        {
            let oldImage = (oldImages[undoposition])
            undoposition--;
            mainImageView.image = oldImage
            saveImageIn()
        }
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(drawingOn)
        {
            swiped = false
            if let touch = touches.first as UITouch? {
                lastPoint = touch.locationInView(detailView.view)
            }
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(detailView.view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: detailView.view.frame.size.width, height: detailView.view.frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, brushWidth)
        
        if(red == 1 && green == 1 && blue == 1)
        {
            CGContextSetRGBStrokeColor(context, 0.9, 0.9, 0.9,1)
            CGContextSetBlendMode(context, CGBlendMode.Normal)
        }
        else
        {
            CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
            CGContextSetBlendMode(context, CGBlendMode.Normal)
        }
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }
    
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 6
        
        
        if(drawingOn)
        {
            swiped = true
            if let touch = touches.first as UITouch? {
                
                let centerY  = touch.locationInView(detailView.view).y
                let centerYtop = centerY - maxRadius
                let centerYbottom = centerY + maxRadius
                
                if(centerYtop < leastValue)
                {
                    leastValue = centerYtop
                }
                if(centerYbottom > maxValue)
                {
                    maxValue = centerYbottom
                }
                
                let currentPoint = touch.locationInView(detailView.view)
                drawLineFrom(lastPoint, toPoint: currentPoint)
                
                // 7
                lastPoint = currentPoint
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(drawingOn) {
            if !swiped {
                // draw a single point
                drawLineFrom(lastPoint, toPoint: lastPoint)
            }
            
            let finalwidth = self.mainImageView.frame.size.width
            let finalheight = self.mainImageView.frame.size.height
            
            // Merge tempImageView into mainImageView
            UIGraphicsBeginImageContext(mainImageView.frame.size)
            mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: finalwidth, height: finalheight), blendMode: CGBlendMode.Normal, alpha: 1.0)
            if(red == 1 && green == 1 && blue == 1 )
            {
                tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: finalwidth, height: finalheight), blendMode: CGBlendMode.DestinationOut, alpha: opacity)
            }
            else
            {
                
                tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: finalwidth, height: finalheight), blendMode: CGBlendMode.Normal, alpha: opacity)
            }
            
            mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            
            let  difference = (oldImages.count-undoposition)-2
            for (var i=0; i < (difference);i++)
            {
                oldImages.removeLast()
            }
            undoposition++;
            let singleOldImage = mainImageView.image
            oldImages.append(singleOldImage)
            
            
            saveImageIn()
            
            
            UIGraphicsEndImageContext()
            
            tempImageView.image = nil
        }
    }
    
    
    func saveImageIn() {
        
        let imagesize = mainImageView.frame.size
        
        
        let rect: CGRect = CGRectMake(0, leastValue, imagesize.width, maxValue - leastValue)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(mainImageView.image!.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef)

        
        let userid = config.get("user_id")
        let currenttimestamp = String(NSDate().timeIntervalSince1970)
        let randomNum = String(arc4random_uniform(9999));
        let sketchname = "SCR_" + userid + "_" + currenttimestamp + "_" + randomNum + ".png";
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let destinationPath = String(documentsPath) + "/" + sketchname
        
        
        
        UIImagePNGRepresentation(image)!.writeToFile(destinationPath, atomically: true)
        
        NoteElementModel.edit(self.NoteElementID, content2: sketchname, contentA2: String(self.topOffset + leastValue), contentB2: String(self.topOffset + leastValue + maxValue))
    }
    
}

