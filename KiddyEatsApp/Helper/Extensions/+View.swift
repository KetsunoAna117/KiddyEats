//
//  +View.swift
//  KiddyEatsApp
//
//  Created by Hans Arthur Cupiterson on 16/08/24.
//

import Foundation
import SwiftUI

extension View {
    var width: CGFloat {
        let widthConstraint = UIHostingController(rootView: self).view.intrinsicContentSize.width
        return widthConstraint
    }
}
