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
    //앞으로 불러온다면 저장된 파일의 url 배열을 통해 반복 호출하면 될 듯함!
    
    var url = Bundle.main.url(forResource: "sample", withExtension: "pdf")
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .frame(width: 100, height: 100)
                
            } else {
                //fail 시 기본 doc 이미지 보여주기
                Image(systemName: "doc.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.ioowRed)
            }
            //URL 언랩
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
    //썸네일 만드는 func
    func generateThumbnail(url : URL) -> UIImage? {
        guard let document = PDFDocument(url: url) else { return nil }
        guard let page = document.page(at: 0) else { return nil }
        //사이즈 조절
        let image = page.thumbnail(of: CGSize(width: 100, height: 100), for: .cropBox)
        return image
    }
    
    //url을 통해 file 명을 불러오는 func
    func URLtoFileName(url : URL) -> String {
        //url을 문자열로 변환
        let urlString = "\(url)"
        //정규표현식
        // / 뒤에부터 .뒤에 3~4번 반복되는 문자열까지 제일 끝에서부터 읽음
        let pattern = "[^/]+\\.[a-zA-Z]{3,4}$"

        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: urlString, range: NSRange(urlString.startIndex..., in: urlString)) {
            let fileNameRange = Range(match.range, in: urlString)!
            let fileName = String(urlString[fileNameRange])

            return fileName // Output: sample.pdf
        } else {
            return "파일명을 불러오지 못했습니다."
        }
    }
}

#Preview {
    DocumentListView()
}
