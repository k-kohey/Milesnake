//
//  TextStyle.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2018/12/31.
//  Copyright © 2018年 kawaguchi kohei. All rights reserved.
//

import UIKit

enum TextStyle {
    enum Size {
        case small
        case medium
        case big
        case select(CGFloat)

        func value() -> CGFloat {
            switch self {
            case .small:
                return 10
            case .medium:
                return 14
            case .big:
                return 18
            case .select(let size):
                return size
            }
        }
    }

    enum Weight {
        case bold
        case medium
    }

    static func make(weight: Weight, size: Size) -> UIFont {
        switch weight {
        case .bold:
            return bold(size: size.value())!
        case .medium:
            return normal(size: size.value())!
        }
    }

    private static func bold(size:CGFloat) -> UIFont? { return UIFont.systemFont(ofSize: size, weight: .bold) }
    private static func normal(size:CGFloat) -> UIFont? { return UIFont.systemFont(ofSize: size, weight: .light) }
}
