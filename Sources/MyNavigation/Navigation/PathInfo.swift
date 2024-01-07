//
//  PathInfo.swift
//  MyCounty
//
//  Created by Kevin Lagat on 25/09/2023.
//

import Foundation
import SwiftUI
@available(iOS 15.0, *)

public enum PresentationMode {
    case stack
    case fullScreen
    case sheet
    case halfSheet
}

@available(iOS 15.0, *)
public class PathInfo<Т: Hashable>: ObservableObject {
    @Published public var root: Т
    @Published public var path: [Т] = []
    @Published public var presentationMode: PresentationMode = .stack
    @Published public var subPath: PathInfo?
    public weak var parent: PathInfo?

    public var showFullScreen: Bool {
        subPath != nil && subPath!.presentationMode == .fullScreen
    }

    public var showSheet: Bool {
        subPath != nil && (subPath!.presentationMode == .sheet || isHalfSheet)
    }

    public var isHalfSheet: Bool {
        subPath != nil && subPath!.presentationMode == .halfSheet
    }

    @available(iOS 16.0, *)
    public var detents: Set<PresentationDetent> {
        guard showSheet else { return [] }
        if subPath!.presentationMode == .halfSheet {
            return [.medium]
        } else {
            return [.large]
        }
    }

    public init(
        root: Т,
        presentationMode: PresentationMode = .stack,
        parent: PathInfo? = nil
    ) {
        self.root = root
        self.presentationMode = presentationMode
        self.parent = parent
    }
}
