//
//  DocumentPicker.swift
//  PDFEraser
//
//  Created by Anjin on 6/18/24.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    var onPicked: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPicked: onPicked)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPicked: (URL) -> Void
        
        init(onPicked: @escaping (URL) -> Void) {
            self.onPicked = onPicked
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onPicked(url)
        }
    }
}
