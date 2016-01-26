//
//  ViewController.swift
//  DrawWords
//
//  Created by yangyu on 16/1/22.
//  Copyright © 2016年 YangYiYu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    
    lazy var pathLayer: CAShapeLayer = {
        
        let layer = CAShapeLayer()
        layer.path = self.getStringPath("Hello World !")
        layer.frame = CGRect(x: 20, y: 0, width: UIScreen.mainScreen().bounds.width - 40, height: UIScreen.mainScreen().bounds.height - 300)
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = nil
        layer.lineWidth = 1.0
        layer.geometryFlipped = true
        layer.lineJoin = kCALineJoinRound
        layer.speed = 0.0
        layer.timeOffset = 0.0

        layer.addAnimation(self.animation, forKey: "strokeEnd")

        return layer
    }()
    
    var animation: CABasicAnimation = CABasicAnimation()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animation.duration = Double(slider.maximumValue)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        
        view.layer.addSublayer(self.pathLayer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChange(sender: UISlider) {
        
        self.pathLayer.timeOffset = Double(sender.value)
        
    }
    //获得字符串的路径
    func getStringPath(str: String) -> CGMutablePathRef {
        
        let letters: CGMutablePathRef = CGPathCreateMutable()
        
        let fonts: CTFont = CTFontCreateWithName("SnellRoundhand", 62, nil)
        
        let attrs = [String(kCTFontAttributeName) : fonts]
        
        let attrString = NSAttributedString(string: str, attributes: attrs)
        
        let line = CTLineCreateWithAttributedString(attrString)
        
        let runArray = CTLineGetGlyphRuns(line)
        
        for var runIndex: CFIndex = 0; runIndex < CFArrayGetCount(runArray); ++runIndex {
           
            let runUnsafe: UnsafePointer<Void> = CFArrayGetValueAtIndex(runArray, runIndex)
            
            let run = unsafeBitCast(runUnsafe, CTRunRef.self)
            
            for var runGlyphIndex: CFIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); ++runGlyphIndex {
                
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                
                var glyph: CGGlyph = CGGlyph()
                var positon: CGPoint = CGPointZero
                
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                CTRunGetPositions(run, thisGlyphRange, &positon)
                
                let letter = CTFontCreatePathForGlyph(fonts, glyph, nil)
                
                var t = CGAffineTransformMakeTranslation(positon.x, positon.y)
                
                CGPathAddPath(letters, &t, letter)
            }
        }
        return letters
    }


}
