//
//  MainView.swift
//  PDFEraser
//
//  Created by Anjin on 6/18/24.
//

import SwiftUI
import PDFKit

struct MainView: View {
    @State private var showDocumentPicker = false
    @State private var selectedUrl: URL?
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 0) {
                Button {
                    showDocumentPicker = true
                } label: {
                    newTaskButtonView
                }
                .sheet(isPresented: $showDocumentPicker) {
                    DocumentPicker { url in
                        selectedUrl = url
                    }
                    .ignoresSafeArea()
                }
                
                ForEach(0 ..< 27) { index in
                    VStack(spacing: 8) {                    
                        DocumentListView()
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
            .navigationDestination(item: $selectedUrl) { url in
                EraserView(url: url)
            }
        }
    }
    
    private var newTaskButtonView: some View {
        VStack(spacing: 8) {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 100, height: 100)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 1)
                            .stroke(Color.ioowRed, style: StrokeStyle(lineWidth: 2, dash: [4, 4]))
                    )
                
                Image(systemName: "plus")
                    .font(.system(size: 40))
                    .foregroundStyle(Color.ioowRed)
            }
            
            Text("새로운 작업")
                .foregroundStyle(Color.black)
            
            Spacer()
        }
    }
}

#Preview {
    MainView()
}
