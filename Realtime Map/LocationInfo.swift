//
//  LocationInfo.swift
//  Realtime Map
//
//  Created by Victor Idongesit on 30/08/2018.
//  Copyright © 2018 Victor Idongesit. All rights reserved.
//

import Foundation
import GoogleMaps

struct LocationInfo {
    public let title: String
    public let subTitle: String
    public let location: CLLocationCoordinate2D
    
    init(title: String, subTitle: String, location: CLLocationCoordinate2D) {
        self.title = title
        self.subTitle = subTitle
        self.location = location
    }
}
