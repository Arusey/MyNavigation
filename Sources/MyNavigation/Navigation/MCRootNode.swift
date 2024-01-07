//
//  MCRootNode.swift
//  MyCounty
//
//  Created by Kevin Lagat on 25/09/2023.
//

import Foundation

import SwiftUI
@available(iOS 15.0, *)

struct MCRootNode<V: View, T: Hashable>: View {
    let router: MCRouter<T>
    @ObservedObject var pathInfo: PathInfo<T>
    let viewForRoute: (T) -> V

    var body: some View {
        NavigationView {
            viewForRoute(pathInfo.root)
            .background(
                MCNavigationLink(
                    router: router,
                    pathInfo: pathInfo,
                    index: 0,
                    viewForRoute: viewForRoute
                )
                .hidden()
            )
        }
        .navigationViewStyle(.stack)
    }
}
