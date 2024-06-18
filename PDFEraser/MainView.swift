//
//  MainView.swift
//  PDFEraser
//
//  Created by Anjin on 6/18/24.
//

import SwiftUI

struct MainView: View {
    let colums: [GridItem] = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: colums, spacing: 0) {
                Button {
                    
                } label: {
                    newTaskButtonView
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
