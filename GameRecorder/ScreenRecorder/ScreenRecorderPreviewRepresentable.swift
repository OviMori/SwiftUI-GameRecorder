//
//  ScreenRecorderPreview.swift
//   GameRecorder
//
//  Created by ovidio morisano on 07/03/23.
//

import Foundation
import SwiftUI
import ReplayKit

struct ScreenRecorderPreviewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = RPPreviewViewController
    var previewView: RPPreviewViewController?
    
    func makeUIViewController(context: Context) -> RPPreviewViewController {
        guard let previewViewController = previewView else { return RPPreviewViewController() }
        previewViewController.modalPresentationStyle = .fullScreen
        previewViewController.view.tintColor = .blue
        previewViewController.viewSafeAreaInsetsDidChange()
        return previewViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
