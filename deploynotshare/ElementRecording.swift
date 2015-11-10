
import UIKit
import AVFoundation

class ElementRecording: UIView {
    
    var view:UIView!;
    var recorder: AVAudioRecorder!
    
    var player:AVAudioPlayer!
    
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var StopButton: UIButton!
   
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
        let nib = UINib(nibName: "ElementRecording", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
        
        StopButton.enabled = false
        PlayButton.enabled = false
     //   setSessionPlayback()
        
    }
    
    
    
    
}