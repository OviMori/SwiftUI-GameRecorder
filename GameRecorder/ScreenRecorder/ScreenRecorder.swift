//
//  ScreenRecorder.swift
//   GameRecorder
//
//  Created by ovidio morisano on 07/03/23.
//

import Foundation
import ReplayKit
import Combine

class ScreenRecorder: NSObject {
    var onPreviewReady = PassthroughSubject<Void, Never>()
    var onDismissPreview = PassthroughSubject<Void, Never>()
    private var preview: RPPreviewViewController?
    var isActive = false 
    
    func add(newPreview preview: RPPreviewViewController) {
        self.preview = preview
    }
    
    
    func play() {
        guard isActive == true else { return }
        RPScreenRecorder.shared().startRecording { err in
            if let err = err {
                print("Error attempting to start buffering \(err.localizedDescription)")
            } else {
                print("Clip buffering started.")
            }
        }
    }
    
    func stop() {
        guard isActive == true else { return }
        RPScreenRecorder.shared().stopRecording { [weak self] preview, err in
            guard let preview = preview else {
                print("No preview window")
                return
            }
            self?.preview = preview
            self?.onPreviewReady.send()
        }
    }
    
    func retrievePreviewView() -> ScreenRecorderPreviewRepresentable {
        preview!.previewControllerDelegate = self
        return ScreenRecorderPreviewRepresentable(previewView: preview)
    }
}

extension ScreenRecorder: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
        onDismissPreview.send()
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
    }
}
