//
//  SaveToCollectionsHostingController.swift
//  KiddyEatsApp
//
//  Created by Arya Adyatma on 21/08/24.
//

import UIKit
import SwiftUI

class SaveToCollectionsHostingController: UIHostingController<AnyView> {
    var onHeightChange: ((CGFloat) -> Void)?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
        onHeightChange?(view.intrinsicContentSize.height)
    }
}

class LogReactionHostingController: UIHostingController<LogReactionButton> {
    var onHeightChange: ((CGFloat) -> Void)?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
        onHeightChange?(view.intrinsicContentSize.height)
    }
}
