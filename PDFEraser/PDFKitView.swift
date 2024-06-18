//
//  PDFKitView.swift
//  PDFEraser
//
//  Created by seonu kim on 6/17/24.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let url: URL //pdfURL
    @Binding var searchText : String // 찾아야할 문자열
    
    var pdfView = PDFView()
    
    //PDF 보는 View 그리기
    func makeUIView(context: Context) -> PDFView {
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: url)
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        // Update the view if needed
        
    }
    
    func addAnnotation() {
        guard let document = pdfView.document else { return }
        
        let selections = document.findString(searchText, withOptions: .caseInsensitive)
        selections.forEach { selection in
            let selectionPages = selection.selectionsByLine()
            for lineSelection in selectionPages { //페이지 만큼 반복 (모든 페이지 제거)
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
    }
    
    func clearAll() {
        guard let document = pdfView.document else { return }
        
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
