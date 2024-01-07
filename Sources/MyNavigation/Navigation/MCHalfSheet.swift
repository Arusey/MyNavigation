//
//  MCHalfSheet.swift
//  MyCounty
//
//  Created by Kevin Lagat on 25/09/2023.
//

import Foundation
import SwiftUI
import UIKit

@available(iOS 15.0, *)
struct MCHalfSheet<Content>: UIViewControllerRepresentable where Content: View {
    private let content: Content
    private let detents: [UISheetPresentationController.Detent]
    private let prefersGrabberVisible: Bool

    @available(iOS 15.0, *)
    init(
        detents: [UISheetPresentationController.Detent] = [.medium()],
        prefersGrabberVisible: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.detents = detents
        self.prefersGrabberVisible = prefersGrabberVisible
        self.content = content()
    }

    func makeUIViewController(context: Context) -> VBHalfSheetController<Content> {
        return VBHalfSheetController(rootView: content)
    }

    func updateUIViewController(_ controller: VBHalfSheetController<Content>, context: Context) {
        controller.detents = detents
        controller.prefersGrabberVisible = prefersGrabberVisible
    }
}

@available(iOS 15.0, *)
final class VBHalfSheetController<Content>: UIHostingController<Content> where Content: View {
    var detents: [UISheetPresentationController.Detent] = []
    var prefersGrabberVisible: Bool = false
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let presentation = sheetPresentationController {
            presentation.detents = detents
            presentation.prefersGrabberVisible = prefersGrabberVisible
            presentation.preferredCornerRadius = 16
            presentation.largestUndimmedDetentIdentifier = .none
        }
    }
}
