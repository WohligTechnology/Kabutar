//
//  CheetahProperties.swift
//  Cheetah
//
//  Created by Suguru Namura on 2015/08/19.
//  Copyright © 2015年 Suguru Namura.
//

import UIKit

// CheetahProperty
public class CheetahProperty {
    
    weak var view: UIView!
    weak var group: CheetahGroup!
    
    var duration: CFTimeInterval = 1
    var delay: CFTimeInterval = 0
    var elapsed: CFTimeInterval = 0
    var dt: CFTimeInterval = 0
    var current: CGFloat = 0
    var easing: Easing = Easings.linear
    var spring: Spring?
    var completion: (() -> Void)?
    var relative: Bool = false
    var transform: CATransform3D = CATransform3DIdentity
    
    func proceed(dt: CFTimeInterval) -> Bool {
        self.dt = dt
        let end = delay + duration
        if elapsed >= end {
            return true
        }
        elapsed = min(elapsed + dt, end)
        if elapsed >= delay {
            current = CGFloat((elapsed - delay) / duration)
            update()
        }
        if let spring = spring {
            if let completion = completion where spring.ended {
                completion()
            }
            return spring.ended
        } else {
            if let completion = completion where elapsed >= end {
                completion()
            }
            return elapsed >= end
        }
    }
    
    func prepare() {
        // reset values
        elapsed = 0
        current = 0
    }
    
    func calc() {
        // should be overriden
    }
    
    func update() {
        // should be overriden
    }
    
    func calculateCGFloat(from from: CGFloat, to: CGFloat) -> CGFloat {
        if let spring = spring {
            spring.proceed(dt / duration)
            return from + (to-from) * CGFloat(spring.current)
        } else {
            return easing(t: current, b: from, c: to-from)
        }
    }
    
    func calculateCGRect(from from: CGRect, to: CGRect) -> CGRect {
        return CGRect(
            origin: calculateCGPoint(from: from.origin, to: to.origin),
            size: calculateCGSize(from: from.size, to: to.size)
        )
    }
    
    func calculateCGPoint(from from: CGPoint, to: CGPoint) -> CGPoint {
        return CGPoint(
            x: calculateCGFloat(from: from.x, to: to.x),
            y: calculateCGFloat(from: from.y, to: to.y)
        )
    }
    
    func calculateCGSize(from from: CGSize, to: CGSize) -> CGSize {
        return CGSize(
            width: calculateCGFloat(from: from.width, to: to.width),
            height: calculateCGFloat(from: from.height, to: to.height)
        )
    }
    
    func calculateUIColor(from from: UIColor, to: UIColor) -> UIColor {
        let fromRGBA = RGBA.fromUIColor(from)
        let toRGBA = RGBA.fromUIColor(to)
        return UIColor(
            red: calculateCGFloat(from: fromRGBA.red, to: toRGBA.red),
            green: calculateCGFloat(from: fromRGBA.green, to: toRGBA.green),
            blue: calculateCGFloat(from: fromRGBA.blue, to: toRGBA.blue),
            alpha: calculateCGFloat(from: fromRGBA.alpha, to: toRGBA.alpha)
        )
    }
}

private struct RGBA {
    var red:CGFloat = 0
    var green:CGFloat = 0
    var blue:CGFloat = 0
    var alpha:CGFloat = 0
    static func fromUIColor(color:UIColor) -> RGBA {
        var rgba = RGBA()
        color.getRed(&rgba.red, green: &rgba.green, blue: &rgba.blue, alpha: &rgba.alpha)
        return rgba
    }
}

public class CheetahCGFloatProperty: CheetahProperty {
    var from: CGFloat = 0
    var to: CGFloat = 0
    var toCalc: CGFloat = 0
    override func calc() {
        if relative {
            toCalc = from + to
        } else {
            toCalc = to
        }
    }
}

public class CheetahCGSizeProperty: CheetahProperty {
    var from: CGSize = CGSizeZero
    var to: CGSize = CGSizeZero
    var toCalc: CGSize = CGSizeZero
    override func calc() {
        if relative {
            toCalc = CGSize(width: from.width+to.width, height: from.height+to.height)
        } else {
            toCalc = to
        }
    }
}

public class CheetahCGPointProperty: CheetahProperty {
    var from: CGPoint = CGPointZero
    var to: CGPoint = CGPointZero
    var toCalc: CGPoint = CGPointZero
    override func calc() {
        if relative {
            toCalc = CGPoint(x: from.x+to.x, y: from.y+to.y)
        } else {
            toCalc = to
        }
    }
}

public class CheetahCGRectProperty: CheetahProperty {
    var from: CGRect = CGRectZero
    var to: CGRect = CGRectZero
    var toCalc: CGRect = CGRectZero
    override func calc() {
        if relative {
            toCalc = CGRect(x: from.origin.x+to.origin.x, y: from.origin.y+to.origin.y, width: from.width+to.width, height: from.height+to.height)
        } else {
            toCalc = to
        }
    }
}

public class CheetahUIColorProperty: CheetahProperty {
    var from: UIColor!
    var to: UIColor!
    var toCalc: UIColor!
    override func calc() {
        if relative {
            let fromRGBA = RGBA.fromUIColor(from)
            let toRGBA = RGBA.fromUIColor(to)
            toCalc = UIColor(red: fromRGBA.red+toRGBA.red, green: fromRGBA.green+toRGBA.green, blue: fromRGBA.blue+toRGBA.blue, alpha: fromRGBA.alpha+toRGBA.alpha)
        } else {
            toCalc = to
        }
    }
}
