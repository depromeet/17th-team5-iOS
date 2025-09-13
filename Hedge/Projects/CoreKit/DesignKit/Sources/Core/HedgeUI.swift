//
//  HedgeUI.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public struct HedgeUI<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol HedgeUISupporttable {
    
    associatedtype Base
    
    static var hedgeUI: HedgeUI<Base>.Type { get set }
    var hedgeUI: HedgeUI<Base> { get set }
}

extension HedgeUISupporttable {
    
    public var hedgeUI: HedgeUI<Self> {
        get { HedgeUI(self) }
        set { }
    }
    
    public static var hedgeUI: HedgeUI<Self>.Type {
        get { HedgeUI<Self>.self }
        set {}
    }
}

extension UIColor: HedgeUISupporttable {}
extension Color: HedgeUISupporttable {}

extension UIImage : HedgeUISupporttable {}
extension Image: HedgeUISupporttable {}
