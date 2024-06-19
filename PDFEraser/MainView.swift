//
//  MainView.swift
//  PDFEraser
//
//  Created by Anjin on 6/18/24.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var documents: [Document] // 모든 documents
    @State private var selectedDocument: Document? // 새 작업 document
    @State private var showDocumentPicker = false // 문서 불러오기
    
    @State private var isOnSelection: Bool = false
    @State private var selectedDocuments: [Document] = []
    
    var body: some View {
        VStack(spacing: 30) {
            HStack {
                Image(systemName: "square.and.arrow.down.on.square")
                    .font(.system(size: 24)).bold()
                    .foregroundStyle(Color.ioowRed)
                
                Text("PDF Eraser")
                    .font(.title2).bold()
                
                Spacer()
                
                if isOnSelection {
                    Button {
                        // 삭제 기능
                    } label: {
                        Text("삭제")
                            .font(.body)
                            .foregroundStyle(Color.ioowRed)
                    }
                    
                    Button {
                        isOnSelection = false
                        selectedDocuments.removeAll()
                    } label: {
                        Text("완료")
                            .font(.body)
                            .foregroundStyle(Color.ioowRed)
                    }
                } else {
                    Button {
                        isOnSelection = true
                    } label: {
                        Text("선택")
                            .font(.body)
                            .foregroundStyle(Color.ioowRed)
                    }
                }
                
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 0) {
                    Button {
                        showDocumentPicker = true
                    } label: {
                        newTaskButtonView
                    }
                    .sheet(isPresented: $showDocumentPicker) {
                        DocumentPicker { url in
                            let newDocument: Document = Document(url: url)
                            selectedDocument = newDocument
                            modelContext.insert(newDocument)
                        }
                        .ignoresSafeArea()
                    }
                    
                    ForEach(documents) { document in
                        VStack(spacing: 8) {
                            Button {
                                if isOnSelection {
                                    if let index = selectedDocuments.firstIndex(of: document) {
                                        selectedDocuments.remove(at: index)
                                    } else {
                                        selectedDocuments.append(document)
                                    }
                                } else {
                                    selectedDocument = document
                                }
                            } label: {
                                ZStack(alignment: .top) {
                                    DocumentItem(document: document)
                                    
                                    if isOnSelection {
                                        if selectedDocuments.contains(document) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundStyle(Color.ioowRed)
                                                .background(Color.white)
                                                .clipShape(RoundedRectangle(cornerRadius: 100))
                                                .padding(.top, 50)
                                        } else {
                                            Image(systemName: "circle")
                                                .font(.system(size: 20))
                                                .foregroundStyle(Color.white)
                                                .shadow(color: .black.opacity(0.4), radius: 0, x: 0, y: 2)
                                                .padding(.top, 50)
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .navigationDestination(item: $selectedDocument) { document in
                    EraserView(url: document.url)
                }
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
                .font(.subheadline)
            
            Spacer()
        }
    }
}

#Preview {
//    MainView()
    VStack {
        Spacer()
        Image(systemName: "checkmark.circle.fill")
            .font(.largeTitle)
            .foregroundStyle(Color.ioowRed)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 100))
        Spacer()
        HStack { Spacer()}
    }
    .background(Color.gray.opacity(0.6))
}
