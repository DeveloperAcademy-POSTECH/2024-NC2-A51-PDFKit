//
//  MainView.swift
//  PDFEraser
//
//  Created by Anjin on 6/18/24.
//

import SwiftUI

struct MainView: View {
    @State private var showDocumentPicker = false
    @State private var showEraserView = false
    
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
                        showEraserView = true
                    }
                    .ignoresSafeArea()
                }
                
                ForEach(0 ..< 27) { index in
                    VStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                        
                        Text("엄청나게 제목이 길어도 두 줄까지만 보여줘")
                            .lineLimit(2)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
            .navigationDestination(isPresented: $showEraserView) {
                if let selectedUrl {
                    EraserView(url: selectedUrl)
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
            
            Spacer()
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var onPicked: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPicked: onPicked)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onPicked: (URL) -> Void
        
        init(onPicked: @escaping (URL) -> Void) {
            self.onPicked = onPicked
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            onPicked(url)
        }
    }
}

#Preview {
    MainView()
}
