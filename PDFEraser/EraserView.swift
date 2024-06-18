//
//  EraserView.swift
//  PDFEraser
//
//  Created by seonu kim on 6/17/24.
//

import SwiftUI

struct EraserView: View {
    @State private var pdfKitView: PDFKitView?
    @State private var searchText = "" //찾을 텍스트
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    pdfKitView?.addAnnotation()
                }) {
                    Text("Search")
                }
                .padding()
                
                //모든 주석 지우는 버튼
                Button(action: {
                    pdfKitView?.clearAll()
                }) {
                    Text("Clear")
                }
                .padding()
            }
            
            //임시적으로 번들 내 sample 파일과 연결해줌
            if let pdfURL = Bundle.main.url(forResource: "sample", withExtension: "pdf") {
                pdfKitView?
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("PDF not found")
            }
        }
        .onAppear {
            if let pdfURL = Bundle.main.url(forResource: "sample", withExtension: "pdf") {
                pdfKitView = PDFKitView(url: pdfURL, searchText: $searchText)
            }
        }
    }
}

#Preview {
    EraserView()
}
