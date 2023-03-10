//
//  PreviewViewController.swift
//   GameRecorder
//
//  Created by ovidio morisano on 07/03/23.
//

import Foundation
import UIKit
import ReplayKit

class PreviewViewController: UIViewController {
    var preview: RPPreviewViewController?

    func present(myPreview: RPPreviewViewController) {
        preview = myPreview
        preview?.modalPresentationStyle = .pageSheet
        preview?.previewControllerDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.setNeedsUpdateConstraints()
        view.safeAreaInsetsDidChange()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let preview = preview else { return }
        present(preview, animated: true)
    }
}

extension PreviewViewController: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.dismiss(animated: true)
    }

    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
    }
}
