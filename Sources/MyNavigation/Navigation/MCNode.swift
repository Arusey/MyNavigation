//
//  MCNode.swift
//  MyCounty
//
//  Created by Kevin Lagat on 25/09/2023.
//

import Foundation
import SwiftUI
@available(iOS 15.0, *)

struct MCNode<V: View, T: Hashable>: View {
    let router: MCRouter<T>
    @ObservedObject var pathInfo: PathInfo<T>
    let index: Int
    let viewForRoute: (T) -> V
    var cachedRoute: T?

    init(
        router: MCRouter<T>,
        pathInfo: PathInfo<T>,
        index: Int,
        @ViewBuilder viewForRoute: @escaping (T) -> V
    ) {
        self.router = router
        self.pathInfo = pathInfo
        self.index = index
        self.viewForRoute = viewForRoute
        if index < pathInfo.path.count {
            self.cachedRoute = pathInfo.path[safe: index]
        }
    }

    var body: some View {
        if index > pathInfo.path.count - 1 {
            Group {
                if let cachedRouteUnwrapped = cachedRoute {
                    viewForRoute(cachedRouteUnwrapped)
                }
            }
        } else {
            if let routeAtIndex = pathInfo.path[safe: index] {
                viewForRoute(routeAtIndex)
                .background(
                    MCNavigationLink(
                        router: router,
                        pathInfo: pathInfo,
                        index: index + 1,
                        viewForRoute: viewForRoute
                    )
                    .hidden()
                )
            }
        }
    }
}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
