//
//  PDFKitView.swift
//  PDFEraser
//
//  Created by seonu kim on 6/17/24.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    //pdfURL
    let url: URL
    // 찾아야할 문자열
    @Binding var searchText : String
    // 찾을지 할말 bool
    @Binding var searchInitiated: Bool
    
    //PDF 보는 View 그리기
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        // Update the view if needed
        guard let document = pdfView.document else { return }
        
        if searchInitiated && !searchText.isEmpty {
            //대소문자 구분 안함
            let selections = document.findString(searchText, withOptions: .caseInsensitive)
            selections.forEach { selection in
                let selectionPages = selection.selectionsByLine()
                //페이지 만큼 반복 (모든 페이지 제거)
                for lineSelection in selectionPages {
                    guard let page = lineSelection.pages.first else { continue }
                    //영역 설정
                    let bounds = lineSelection.bounds(for: page)
                    let annotation = PDFAnnotation(bounds: bounds, forType: .square, withProperties: nil)
                    //주석 테두리 색상
                    annotation.color = .clear
                    //주석 내부 색상
                    annotation.interiorColor = .white
                    //주석 추가
                    page.addAnnotation(annotation)
                }
            }
        } else {
            //모든 페이지 화면 주석 지워주기
            pdfView.clearSelection()
            let pageCount = document.pageCount
            for pageIndex in 0..<pageCount {
                guard let page = document.page(at: pageIndex) else { continue }
                let annotations = page.annotations

                for annotation in annotations {
                    page.removeAnnotation(annotation)
                }
            }
        }
    }
}


