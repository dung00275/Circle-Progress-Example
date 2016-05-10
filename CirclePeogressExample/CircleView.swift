//
//  CircleView.swift
//  CirclePeogressExample
//
//  Created by Hoang Phuong on 5/10/16.
//  Copyright © 2016 Hoang Dung. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class CircleView: UIView {
    
    @IBInspectable public var progress: CGFloat = 0 {
        didSet{
            
        }
    }
    
    private var layerCircle: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView(){
        
    }
    
    public override func prepareForInterfaceBuilder() {
        
    }
    
    public override func drawRect(rect: CGRect) {
        
    }
    
}