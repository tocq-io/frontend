//
//  CreateTopicView.swift
//  UIPrototype
//
//  Created by Philipp on 27.05.21.
//

import SwiftUI

struct CreateTopicView: View {
    @ObservedObject private var topicCharCounter = TopicCharCounter(limit: 24)
    @Environment(\.managedObjectContext) private var viewContext
    
    private func createTopic(){
        let text = $topicCharCounter.limitedText.wrappedValue
        if !text.isEmpty {
            withAnimation {
                
                newSignature = Signature(context: viewContext)
                newTopic = Topic(context: viewContext)
                newTopic?.name = text
                let keyMgr = KeyManager(name: text)
                
                newTopic?.pubCert = keyMgr.pubKeyData
                
                newSignature?.signature = keyMgr.sign(text: text)!
                newSignature?.sharedTopicID = KeyManager.getB58(signature: newSignature!.signature)
                newSignature?.topic = newTopic!
                print(newSignature!.sharedTopicID)
                newTopic?.addToSignatures(newSignature!)
                
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                self.selection = 1
            }
        }
    }
    
    @State var newTopic: Topic? = nil
    @State var newSignature: Signature? = nil
    @State var selection: Int? = nil
    
    
    var body: some View {
        BaseBackView {
            funkyTitle(text: "Topic Name", size: 48)
            funkyTextField(defaultText: "max 24 characters", textCharCounter: $topicCharCounter.limitedText)
            NavigationLink(destination: ShareQRView(topic: newTopic, signature: newSignature), tag: 1, selection: $selection) {
                Button(action: createTopic) {
                    funkyButton(text: "Create", imageName: "tortoise.fill")
                }
            }
            Spacer()
                .frame(minHeight: 120, maxHeight: 240)
        }
    }
}

struct CreateTopicView_Previews: PreviewProvider {
    static var previews: some View {
        CreateTopicView()
    }
}
