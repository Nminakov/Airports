//
//  AnnotationView.swift
//  Airports
//
//  Created by Никита on 04/10/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation
import MapKit

class AnnotationView: MKAnnotationView{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitTet = super.hitTest(point, with: event)
        if hitTet != nil{
            self.superview?.bringSubviewToFront(self)
        }
        return hitTet
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = bounds
        var isInside = rect.contains(point)
        for view in subviews{
            isInside = view.frame.contains(point)
            if isInside{
                break
            }
        }
        return isInside
    }
}
