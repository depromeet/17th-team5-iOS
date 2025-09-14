//
//  Bundle.swift
//  DesignKit
//
//  Created by Junyoung on 9/13/25.
//  Copyright © 2025 SampleCompany. All rights reserved.
//

import Foundation

private class __Bundle {}

public extension Bundle {
    static var hedgeUIBundle: Bundle = Bundle(for: __Bundle.self)
}
