//
//  Extensions.swift
//  Airports
//
//  Created by Никита on 04/10/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import Foundation
import MapKit


extension MKMapView {
    
    func fitMapViewToAnnotionsList(with insets: UIEdgeInsets) {
        let mapEdgePadding = insets
        var zoomRect: MKMapRect = .null
        for index in 0 ..< annotations.count {
            let annotation = annotations[index]
            let aPoint = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
            if zoomRect.isNull {
                zoomRect = rect
            }
            else {
                zoomRect = zoomRect.union(rect)
            }
            setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: true)
        }
    }
    
}

extension MKGeodesicPolyline {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
    
    convenience init(coordinates: [CLLocationCoordinate2D]) {
        var refCoordinates  = coordinates
        self.init(coordinates: &refCoordinates, count: refCoordinates.count)
    }
}
