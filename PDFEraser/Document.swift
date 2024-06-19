//
//  Document.swift
//  PDFEraser
//
//  Created by Anjin on 6/19/24.
//

import PDFKit
import SwiftData
import SwiftUI

@Model
class Document {
    let id = UUID()
    var title: String
    var url: URL
    
    @Transient var thumbnailImage: Image {
        guard let page = PDFDocument(url: url)?.page(at: 0) else { return Image("") }
        return Image(uiImage: page.thumbnail(of: CGSize(width: 100, height: 100), for: .cropBox))
    }
    
    init(url: URL) {
        self.title = url.lastPathComponent
        self.url = url
    }
}
