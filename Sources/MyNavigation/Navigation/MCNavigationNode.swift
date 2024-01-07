//
//  MCNavigationNode.swift
//  MyCounty
//
//  Created by Kevin Lagat on 25/09/2023.
//

import Foundation
import SwiftUI
@available(iOS 15.0, *)

struct MCNavigationNode<V: View, T: Hashable>: View {
    let router: MCRouter<T>
    @ObservedObject var pathInfo: PathInfo<T>
    let viewForRoute: (T) -> V

    init(
        router: MCRouter<T>,
        pathInfo: PathInfo<T>? = nil,
        @ViewBuilder viewForRoute: @escaping (T) -> V
    ) {
        self.router = router
        self.pathInfo = pathInfo ?? router.pathInfo
        self.viewForRoute = viewForRoute
    }

    var body: some View {
        MCRootNode(router: router, pathInfo: pathInfo, viewForRoute: viewForRoute)
        .fullScreenCover(isPresented: Binding(
            get: { return pathInfo.showFullScreen },
            set: { if $0 == false { router.popTo(pathInfo) } })
        ) {
            if let subPath = pathInfo.subPath {
                MCNavigationNode(router: router, pathInfo: subPath, viewForRoute: viewForRoute)
            }
        }
        .sheet(isPresented: Binding(
            get: { return pathInfo.showSheet },
            set: { if $0 == false { router.popTo(pathInfo) } })
        ) {
            if let subPath = pathInfo.subPath {
                if pathInfo.isHalfSheet {
                    MCHalfSheet {
                        MCNavigationNode(router: router, pathInfo: subPath, viewForRoute: viewForRoute)
                    }
                } else {
                    MCNavigationNode(router: router, pathInfo: subPath, viewForRoute: viewForRoute)
                }
            }
        }
    }
}

