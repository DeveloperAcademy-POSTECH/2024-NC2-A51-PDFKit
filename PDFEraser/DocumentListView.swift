//
//  DocumentListView.swift
//  PDFEraser
//
//  Created by seonu kim on 6/18/24.
//

import SwiftUI
import PDFKit

struct DocumentListView: View {
    let document: Document
    
    var body: some View {
        VStack(spacing: 8) {
            document.thumbnailImage // Image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .shadow(color: .black.opacity(0.1), radius: 12)
            
            Text(document.title)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 100)
        }
    }
}

/*
 // fail 시 기본 doc 이미지 보여주기
 Image(systemName: "doc.fill")
     .resizable()
     .scaledToFit()
     .frame(width: 100, height: 100)
     .foregroundColor(.ioowRed)
 */
