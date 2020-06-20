//
//  ViewForXIB.swift
//  VedantaComms
//
//  Created by Anshul on 19/11/19.
//  Copyright © 2019 MAC240. All rights reserved.
//

import Foundation
import UIKit

class ViewFromXIB: UIView {
    
    var customView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.commonInit(emptyCheck: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit(emptyCheck: false)
    }
    
    func commonInit(emptyCheck:Bool) -> Void {
        self.backgroundColor = .clear
        
        // 1. Load the .xib file .xib file must match classname
        let className = String(describing: type(of: self).self) // type(of: self) //String(describing: CustomViewFromXIB.self)
        
        customView = Bundle.main.loadNibNamed(className, owner: self, options: nil)?.first as? UIView
        customView.backgroundColor = .clear
        customView.frame = self.bounds
        
        // 2. Set the bounds if not set by programmer (i.e. init called)
        if emptyCheck {
            
            if frame.isEmpty {
                self.bounds = customView.bounds
            }
        }
        
        // 3. Add as a subview
        self.addSubview(customView)
    }
}
