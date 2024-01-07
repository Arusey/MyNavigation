//
//  MCNavigationLink.swift
//  MyCounty
//
//  Created by Kevin Lagat on 25/09/2023.
//

import Foundation
import SwiftUI
@available(iOS 15.0, *)

struct MCNavigationLink<V: View, T: Hashable>: View {
    let router: MCRouter<T>
    @ObservedObject var pathInfo: PathInfo<T>
    let index: Int
    let viewForRoute: (T) -> V

    var body: some View {
        NavigationLink(
            destination: MCNode(
                router: router,
                pathInfo: pathInfo,
                index: index,
                viewForRoute: viewForRoute
            ),
            isActive: Binding<Bool>(
                get: {
                    return pathInfo.path.count > index
                },
                set: { newValue, _ in
                    if newValue == false && pathInfo.path.count > index {
                        router.pop()
                    }
                }
            )
        ) { EmptyView() }
    }
}
