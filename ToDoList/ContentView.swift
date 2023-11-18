//
//  ContentView.swift
//  ToDoList
//
//  Created by Ayush Narwal on 18/11/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var inputText: String = ""
    @State private var showingAlert: Bool = false
    
    @StateObject private var notificationManager = NotificationManager()
    
    var body: some View {
        NavigationView {
            if items.isEmpty{
                Text("No tasks added. Add using the above the button.")
                    .navigationTitle("ToDo List App")
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                showingAlert = true
                            }) {
                                Label("Add Item", systemImage: "plus")
                            }
                        }
                        ToolbarItem{
                            EditButton()
                        }
                    }
                    .alert(Text("Enter text"), isPresented: $showingAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("OK") {
                            addItem(text: inputText)
                        }
                        TextField("Add Item", text: $inputText)
                    } message: {}
            } else {
                List {
                    ForEach(items) { item in
                        Text(item.text ?? "")
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("ToDo List App")
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            showingAlert = true
                        }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    ToolbarItem{
                        EditButton()
                    }
                }
                .alert(Text("Enter text"), isPresented: $showingAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("OK") {
                        addItem(text: inputText)
                    }
                    TextField("Add Item", text: $inputText)
                        .textContentType(.creditCardNumber)
                } message: {}
                
            }
        }
        .onAppear {
            notificationManager.requestPermission()
            notificationManager.setItems(items: Array(items))
            notificationManager.scheduleNotifications()
        }
    }
    
    private func addItem(text: String) {
        let newItem = Item(context: viewContext)
        newItem.timestamp = Date()
        newItem.text = text
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
