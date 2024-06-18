//
//  EraserView.swift
//  PDFEraser
//
//  Created by seonu kim on 6/17/24.
//

import SwiftUI

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
            
            if let pdfKitView {
                pdfKitView
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("PDF not found")
            }
        }
        .navigationTitle("\(url.lastPathComponent)")
        .onAppear {
            pdfKitView = PDFKitView(url: url, searchText: $searchText)
        }
    }
}
