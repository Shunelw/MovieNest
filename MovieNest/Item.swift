//
//  Item.swift
//  MovieNest
//
//  Created by Shune Lai Wai on 28/8/2569 BE.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
