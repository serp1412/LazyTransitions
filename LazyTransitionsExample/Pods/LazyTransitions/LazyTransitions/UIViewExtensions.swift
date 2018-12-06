//
//  UIViewExtensions.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 12/26/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

extension UIView {
    public static var shadowView: UIView {
        let shadowView = UIView(frame: UIScreen.main.bounds)
        shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        return shadowView
    }
}
