//
//  EraserView.swift
//  PDFEraser
//
//  Created by seonu kim on 6/17/24.
//

import SwiftUI
import PDFKit

struct EraserView: View {
    @Environment(\.dismiss) var dismiss
    
    let url: URL
    @State private var pdfKitView: PDFKitView?
    
    @State private var searchTexts: [String] = []
    @State private var searchText = "" //찾을 텍스트
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                TextField("가려줄 텍스트", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button {
                    pdfKitView?.addAnnotation(searchText: searchText)
                    searchTexts.append(searchText)
                    searchText = ""
                } label: {
                    Text("지우기")
                }
            }
            .padding(.horizontal, 20)
            
            if searchTexts.isEmpty == false {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(0 ..< searchTexts.count, id: \.self) { index in
                            Button {
                                pdfKitView?.clear(for: searchTexts[index])
                                searchTexts.remove(at: index)
                            } label: {
                                HStack(spacing: 4) {
                                    Text(searchTexts[index])
                                        .font(.body)
                                    
                                    Image(systemName: "xmark")
                                        .font(.caption2)
                                }
                                .foregroundStyle(Color.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.ioowRed.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
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
            ToolbarItem(placement: .navigationBarTrailing) { shareButton }
            ToolbarItem(placement: .navigationBarTrailing) { completeButton }
        }
        .alert("사본으로 저장", isPresented: $showAlert, actions: {
            Button {
                dismiss()
            } label: {
                Text("예")
                    .tint(Color.ioowRed)
            }
            
            Button {
                dismiss()
            } label: {
                Text("아니오")
                    .tint(Color.ioowRed)
            }
        }, message: {
            Text("사본으로 저장하지 않으면\n원본에 변경 사항이 반영됩니다")
        })
        .onAppear {
            pdfKitView = PDFKitView(url: url)
        }
    }
    
    // 공유 버튼
    private var shareButton: some View {
        Button {
            saveAndSharePDF()
        } label: {
            Image(systemName: "square.and.arrow.up")
                .tint(Color.ioowRed)
        }
    }
    
    // 완료 버튼
    private var completeButton: some View {
        Button {
            showAlert = true
        } label: {
            Text("완료")
                .tint(Color.ioowRed)
        }
    }
    
    // 공유하기
    private func saveAndSharePDF() {
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
