//
//  MCRouter.swift
//  MyCounty
//
//  Created by Kevin Lagat on 25/09/2023.
//

import Foundation

/// Implements basic routing functionality.
/// Together with MCRouterView provides dynamic navigation in your application.
///
@available(iOS 15.0, *)

public class MCRouter<T: Hashable>: ObservableObject {
    @Published var pathInfo: PathInfo<T>
    private weak var topPathInfo: PathInfo<T>?

    public var currentRoute: T {
        let info = topPathInfo ?? pathInfo
        return info.path.last ?? info.root
    }

    public init(_ root: T) {
        self.pathInfo = PathInfo(root: root)
        self.topPathInfo = self.pathInfo
    }

    public func push(_ route: T, presentationMode: PresentationMode = .stack) {
        DispatchQueue.main.async {
            if presentationMode == .stack {
                self.topPathInfo?.path.append(route)
            } else {
                let newPathInfo = PathInfo(
                    root: route,
                    presentationMode: presentationMode,
                    parent: self.topPathInfo
                )
                self.topPathInfo?.subPath = newPathInfo
                self.topPathInfo = newPathInfo
            }
        }
    }

    public func pop() {
        DispatchQueue.main.async {
            if let topInfo = self.topPathInfo, topInfo.path.count > 0 {
                topInfo.path.removeLast()
            } else if self.topPathInfo?.parent != nil {
                self.topPathInfo = self.topPathInfo?.parent
                self.topPathInfo?.subPath = nil
            }
        }
    }

    public func popToRoot() {
        DispatchQueue.main.async {
            self.topPathInfo?.path.removeAll()
            self.topPathInfo?.subPath = nil
            self.topPathInfo = self.topPathInfo?.parent ?? self.pathInfo
        }
    }

    public func replaceRoot(_ route: T, path: [T] = []) {
        DispatchQueue.main.async {
            self.pathInfo.root = route
            self.pathInfo.path = path
            self.pathInfo.subPath = nil
            self.topPathInfo = self.pathInfo
        }
    }

    public func popTo(_ route: T) {
        DispatchQueue.main.async {
            if let topInfo = self.topPathInfo, let index = topInfo.path.firstIndex(of: route) {
                let pathsToRemove = topInfo.path.count - (index + 1)
                topInfo.path.removeLast(pathsToRemove)
            } else if self.topPathInfo?.root == route {
                self.topPathInfo?.path.removeAll()
            }
        }
    }

    public func goTo(_ route: T) {
        DispatchQueue.main.async {
            if let topInfo = self.topPathInfo, let index = topInfo.path.firstIndex(of: route) {
                let pathsToRemove = topInfo.path.count - (index + 1)
                topInfo.path.removeLast(pathsToRemove)
            } else if self.topPathInfo?.root == route {
                self.topPathInfo?.path.removeAll()
            } else {
                self.topPathInfo?.path.append(route)
            }
        }
    }

    func popTo(_ pathInfo: PathInfo<T>) {
        DispatchQueue.main.async {
            var current = self.topPathInfo
            while current != nil {
                if current === pathInfo {
                    self.topPathInfo = current
                    self.topPathInfo?.subPath = nil
                    return
                }
                current = current?.parent
            }
        }
    }
}
