//
//  Bezier.swift
//  Cheetah
//
//  Created by Suguru Namura on 2015/08/20.
//  Copyright © 2015年 Suguru Namura.
//

// This implementation is based on WebCore Bezier implmentation
// http://opensource.apple.com/source/WebCore/WebCore-955.66/platform/graphics/UnitBezier.h
//

private let epsilon: Float = 1.0 / 1000

struct UnitBezier {
    var ax: Float
    var ay: Float
    var bx: Float
    var by: Float
    var cx: Float
    var cy: Float
    init(p1x: Float, p1y: Float, p2x: Float, p2y: Float) {
        cx = 3 * p1x
        bx = 3 * (p2x - p1x) - cx
        ax = 1 - cx - bx
        cy = 3 * p1y
        by = 3 * (p2y - p1y) - cy
        ay = 1.0 - cy - by
    }
    func sampleCurveX(t: Float) -> Float {
        return ((ax * t + bx) * t + cx) * t
    }
    func sampleCurveY(t: Float) -> Float {
        return ((ay * t + by) * t + cy) * t
    }
    func sampleCurveDerivativeX(t: Float) -> Float {
        return (3.0 * ax * t + 2.0 * bx) * t + cx
    }
    func solveCurveX(x: Float) -> Float {
        var t0, t1, t2, x2, d2: Float
        var i: Int
        
        // Firstly try a few iterations of Newton's method -- normally very fast
        for t2 = x, i = 0; i < 8; i++ {
            x2 = sampleCurveX(t2) - x
            if fabs(x2) < epsilon {
                return t2
            }
            d2 = sampleCurveDerivativeX(t2)
            if fabs(x2) < 1e-6 {
                break
            }
            t2 = t2 - x2 / d2
        }
        
        // Fall back to the bisection method for reliability
        t0 = 0
        t1 = 1
        t2 = x
        
        if t2 < t0 {
            return t0
        }
        if t2 > t1 {
            return t1
        }
        
        while t0 < t1 {
            x2 = sampleCurveX(t2)
            if fabs(x2 - x) < epsilon {
                return t2
            }
            if x > x2 {
                t0 = t2
            } else {
                t1 = t2
            }
            t2 = (t1 - t0) * 0.5 + t0
        }
        
        // Failure
        return t2
    }
    
    func solve(x: Float) -> Float {
        return sampleCurveY(solveCurveX(x))
    }
}

