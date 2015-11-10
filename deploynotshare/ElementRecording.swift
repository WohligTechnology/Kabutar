
import UIKit
import AVFoundation

class ElementRecording: UIView {
   
    var timer:NSTimer!
    
    var recorder: AVAudioRecorder!
    @IBOutlet weak var timeSlider: UISlider!
    
    var player:AVAudioPlayer!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    var meterTimer:NSTimer!
    
    var soundFileURL:NSURL!
    
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
        stopButton.enabled = false
        playButton.enabled = false
        setSessionPlayback()
        record()
        
    }
    
    
    func updateTime() {
        let currentTime = Int(player.currentTime)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        statusLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    func getDuration() {
        
        var url:NSURL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url!)
            stopButton.enabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            
            
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }

        
        let currentTime = Int(player.duration)
        let minutes = currentTime/60
        let seconds = currentTime - minutes * 60
        
        durationLabel.text = NSString(format: "%02d:%02d", minutes,seconds) as String
    }
    
    func updateAudioMeter(timer:NSTimer) {
        
        if recorder.recording {
            let min = Int(recorder.currentTime / 60)
            let sec = Int(recorder.currentTime % 60)
            let s = String(format: "%02d:%02d", min, sec)
            statusLabel.text = s
            recorder.updateMeters()
        }
    }
    
    func record() {
        
        if player != nil && player.playing {
            player.stop()
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            //recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.recording {
            print("pausing")
            recorder.pause()
            //recordButton.setTitle("Continue", forState:.Normal)
            
        } else {
            print("recording")
            //recordButton.setTitle("Pause", forState:.Normal)
            playButton.enabled = false
            stopButton.enabled = true
            recorder.record()
            recordWithPermission(false)
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        print("stop")
        
        recorder?.stop()
        player?.stop()
        
        meterTimer.invalidate()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            playButton.enabled = true
            stopButton.enabled = false
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        //recorder = nil
    }
    
    @IBAction func play(sender: UIButton) {
        setSessionPlayback()
        play()
    }
    
    func play() {
        
        
        var url:NSURL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOfURL: url!)
            stopButton.enabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
            timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "updateTime", userInfo: nil, repeats: true)
           
            
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
        
    }
    
    
    func setupRecorder() {
        let format = NSDateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
        print(currentFileName)
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        self.soundFileURL = documentsDirectory.URLByAppendingPathComponent(currentFileName)
        
        if NSFileManager.defaultManager().fileExistsAtPath(soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(URL: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.meteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func recordWithPermission(setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.respondsToSelector("requestRecordPermission:")) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    self.meterTimer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                        target:self,
                        selector:"updateAudioMeter:",
                        userInfo:nil,
                        repeats:true)
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
}

// MARK: AVAudioRecorderDelegate
extension ElementRecording : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder,
        successfully flag: Bool) {
            print("finished recording \(flag)")
            stopButton.enabled = false
            playButton.enabled = true
            
            self.getDuration()
            self.statusLabel.text = "00:00"

    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder,
        error: NSError?) {
            
            if let e = error {
                print("\(e.localizedDescription)")
            }
    }
    
}

// MARK: AVAudioPlayerDelegate
extension ElementRecording : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
        stopButton.enabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}


    
    


