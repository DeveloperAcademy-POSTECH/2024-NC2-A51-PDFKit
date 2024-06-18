//
//  EraserView.swift
//  PDFEraser
//
//  Created by seonu kim on 6/17/24.
//

import SwiftUI

struct EraserView: View {
    //찾을 텍스트
    @State private var searchText = ""
    //찾기 시작할 지 말지 저장
    @State private var searchInitiated = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("Search", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    searchInitiated = true
                }) {
                    Text("Search")
                }
                .padding()
                
                //모든 주석 지우는 버튼
                Button(action: {
                    searchText = ""
                    searchInitiated = false
                }) {
                    Text("Clear")
                }
                .padding()
            }
            
            //임시적으로 번들 내 sample 파일과 연결해줌
            if let pdfURL = Bundle.main.url(forResource: "sample", withExtension: "pdf"){
                PDFKitView(url: pdfURL, searchText: $searchText, searchInitiated: $searchInitiated)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("PDF not found")
            }
        }
    }
}

#Preview {
    EraserView()
}
