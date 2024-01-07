//
//  RouterStackView.swift
//  MyCounty
//
//  Created by Kevin Lagat on 25/09/2023.
//

import Foundation
import SwiftUI
@available(iOS 15.0, *)

@available(iOS 16.0, *)
struct RouterStackView<V: View, T: Hashable>: View {
    @ObservedObject var pathInfo: PathInfo<T>
    let router: MCRouter<T>
    let viewForRoute: (T) -> V

    init(router: MCRouter<T>, pathInfo: PathInfo<T>? = nil, @ViewBuilder viewForRoute: @escaping (T) -> V) {
        self.router = router
        self.pathInfo = pathInfo ?? router.pathInfo
        self.viewForRoute = viewForRoute
    }

    var body: some View {
        NavigationStack(path: $pathInfo.path) {
            viewForRoute(pathInfo.root)
            .navigationDestination(for: T.self) { route in
                viewForRoute(route)
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { return pathInfo.showFullScreen },
            set: { if $0 == false { router.popTo(pathInfo) } })
        ) {
            RouterStackView(router: router, pathInfo: pathInfo.subPath!, viewForRoute: viewForRoute)
        }
        .sheet(isPresented: Binding(
            get: { return pathInfo.showSheet },
            set: { if $0 == false { router.popTo(pathInfo) } })
        ) {
            RouterStackView(router: router, pathInfo: pathInfo.subPath!, viewForRoute: viewForRoute)
                .presentationDetents(pathInfo.detents)
        }
    }
}
