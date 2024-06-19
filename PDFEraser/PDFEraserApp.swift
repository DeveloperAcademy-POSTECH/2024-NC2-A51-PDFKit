//
//  PDFEraserApp.swift
//  PDFEraser
//
//  Created by Anjin on 6/17/24.
//

import SwiftData
import SwiftUI

@main
struct PDFEraserApp: App {
    var modelContainer: ModelContainer {
        let schema = Schema([Document.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [configuration])
            return container
        } catch {
            fatalError("Model Create Fail")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
        }
        .modelContainer(modelContainer)
    }
}
