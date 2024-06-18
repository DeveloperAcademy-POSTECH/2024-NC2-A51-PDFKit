//
//  EraserView.swift
//  PDFEraser
//
//  Created by seonu kim on 6/17/24.
//

import SwiftUI
import PDFKit

struct EraserView: View {
    let url: URL
    @State private var pdfKitView: PDFKitView?
    @State private var searchText = "" //찾을 텍스트
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    pdfKitView?.addAnnotation(searchText: searchText)
                } label: {
                    Text("Search")
                }
                
                //모든 주석 지우는 버튼
                Button {
                    pdfKitView?.clearAll()
                } label: {
                    Text("Clear")
                }
            }
            
            if let pdfKitView {
                pdfKitView
                    .edgesIgnoringSafeArea(.all)
            } else {
                VStack {
                    Spacer()
                    Text("PDF not found")
                    Spacer()
                }
            }
        }
        .navigationTitle("\(url.lastPathComponent)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    saveAndSharePDF()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .tint(Color.ioowRed)
                }
            }
        }
        .onAppear {
            pdfKitView = PDFKitView(url: url)
        }
    }
    
    func saveAndSharePDF() {
        guard let pdfDocument = pdfKitView?.pdfView.document else { return }
        
        // PDF 파일 저장 경로 설정
        let fileManager = FileManager.default
        guard let outputURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("AnnotatedPDF.pdf") else { return }
        
        // PDF 문서 저장
        pdfDocument.write(to: outputURL)
        
        // 공유 시트 표시
        let activityViewController = UIActivityViewController(activityItems: [outputURL], applicationActivities: nil)
        
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(activityViewController, animated: true, completion: nil)
        }
    }
}
