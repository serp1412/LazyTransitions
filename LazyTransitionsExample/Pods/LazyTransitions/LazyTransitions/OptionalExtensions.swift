//
//  OptionalExtensions.swift
//  LazyTransitions
//
//  Created by Serghei Catraniuc on 9/12/16.
//  Copyright © 2016 BeardWare. All rights reserved.
//

import Foundation

extension Optional {
    func apply<T>(_ function: (Wrapped) -> T?) -> T? {
        guard case let .some(p) = self else { return nil }
        return function(p)
    }
}
