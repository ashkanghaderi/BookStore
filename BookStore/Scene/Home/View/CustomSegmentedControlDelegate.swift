//
//  CustomSegmentedControlDelegate.swift
//  BookStore
//
//  Created by Ashkan Ghaderi on 2024-09-17.
//

import Foundation
import UIKit

protocol CustomSegmentedControlDelegate: AnyObject {
    
    func buttonPressed(selectedSegment: TrendingPeriod)
}
