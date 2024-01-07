//
//  MCRouterView.swift
//  MyCounty
//
//  Created by Kevin Lagat on 25/09/2023.
//

import Foundation
import SwiftUI
@available(iOS 15.0, *)

public struct MCRouterView<V: View, T: Hashable>: View {
    let router: MCRouter<T>
    let viewForRoute: (T) -> V

    public init(router: MCRouter<T>, @ViewBuilder viewForRoute: @escaping (T) -> V) {
        self.router = router
        self.viewForRoute = viewForRoute
    }

    public var body: some View {
        Group {
            if #available(iOS 16, *) {
                RouterStackView(router: router, viewForRoute: viewForRoute)
            } else {
                MCNavigationNode(router: router, viewForRoute: viewForRoute)
            }
        }
        .environmentObject(router)
    }
}
