//
//  DocumentListView.swift
//  PDFEraser
//
//  Created by seonu kim on 6/18/24.
//

import SwiftUI
import PDFKit

struct DocumentListView: View {
    @State private var image: UIImage?
    //url 경로 변수
    //지금은 번들로 예시 작성
    var url = Bundle.main.url(forResource: "sample", withExtension: "pdf")
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .frame(width: 100, height: 100)
            } else {
                Text("Failed to generate thumbnail")
            }
            
            if let unwrapedURL = url {
                Text("\(URLtoFileName(url: unwrapedURL))")
                    .lineLimit(2)
                    .frame(width: 100)
            }
        }
        .onAppear {
            if let unwrapedURL = url {
                image = generateThumbnail(url: unwrapedURL)
            }
        }
    }
    func generateThumbnail(url : URL) -> UIImage? {
        guard let document = PDFDocument(url: url) else { return nil }
        guard let page = document.page(at: 0) else { return nil }
        let image = page.thumbnail(of: CGSize(width: 100, height: 100), for: .cropBox)
        return image
    }
    
    func URLtoFileName(url : URL) -> String {
        let urlString = "\(url)"
        let pattern = "[^/]+\\.[a-zA-Z]{3,4}$"

        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: urlString, range: NSRange(urlString.startIndex..., in: urlString)) {
            let fileNameRange = Range(match.range, in: urlString)!
            let fileName = String(urlString[fileNameRange])

            return fileName // Output: document.pdf
        } else {
            return "파일명을 불러오지 못했습니다."
        }
    }
}

#Preview {
    DocumentListView()
}
