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
    
    func addAnnotation(searchText: String, color: UIColor) {
        guard let document = pdfView.document else { return }
        
        let selections = document.findString(searchText, withOptions: .caseInsensitive)
        selections.forEach { selection in
            let selectionPages = selection.selectionsByLine()
            for lineSelection in selectionPages { //페이지 만큼 반복 (모든 페이지 제거)
                guard let page = lineSelection.pages.first else { continue }
                
                let bounds = lineSelection.bounds(for: page) // 영역 설정
                let annotation = PDFAnnotation(bounds: bounds, forType: .square, withProperties: nil)
                
                annotation.color = .clear // 주석 테두리 색상
                annotation.interiorColor = color // 주석 내부 색상
                
                annotation.setValue(searchText, forAnnotationKey: .contents) // 주석에 사용자 정의 값 추가
                
                page.addAnnotation(annotation) // 주석 추가
            }
        }
    }
    
    func clear(for searchText: String) {
        guard let document = pdfView.document else { return }
        
        let pageCount = document.pageCount
        for pageIndex in 0..<pageCount {
            guard let page = document.page(at: pageIndex) else { continue }
            let annotations = page.annotations
            
            for annotation in annotations {
                // 사용자 정의 속성을 확인하여 주석 삭제
                if let annotationText = annotation.value(forAnnotationKey: .contents) as? String, annotationText == searchText {
                    page.removeAnnotation(annotation)
                }
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
    //pdf img to img to pdf 변환
    func PDFConverter() -> PDFDocument {
        //pdfView.document가 없을 경우 빈 파일 반환
        guard let document = pdfView.document else { return PDFDocument() }
        //이미지로 변환 과정
        var images: [UIImage] = []
        
        //페이지 수만큼 반복
        for pageNum in 0..<document.pageCount {
            if let page = document.page(at: pageNum) {
                let pageSize = page.bounds(for: .mediaBox)
                let renderer = UIGraphicsImageRenderer(size: pageSize.size)
                
                let image = renderer.image { ctx in
                    UIColor.white.set()
                    ctx.fill(pageSize)
                    //core graphic으로 화면이 그려지는 방향
                    //상단부터 하단으로 그려져서 이미지가 위 아래 반대가 됨
                    ctx.cgContext.translateBy(x: 0.0, y: pageSize.size.height)
                    //y축으로 회전
                    ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                    
                    page.draw(with: .mediaBox, to: ctx.cgContext)
                }
                images.append(image)
            }
        }
        //반환 값 저장할 새 document 파일 생성
        let newDocument = PDFDocument()
        
        for (index, image) in images.enumerated() {
            if let pdfPage = PDFPage(image: image) {
                newDocument.insert(pdfPage, at: index)
            }
        }
       return newDocument
    }
}
