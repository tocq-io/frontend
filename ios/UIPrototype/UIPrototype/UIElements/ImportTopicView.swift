//
//  ImportTopicView.swift
//  UIPrototype
//
//  Created by Philipp on 27.05.21.
//

import SwiftUI
import URKit

struct ImportTopicView: View {
    
    @Environment(\.presentationMode) private var presentation
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var scannedCode: String?
    @State var verified: Bool = false
    @State var name: String?
    @State var id: String?
    @State var signature: Data?
    @State var pubCert: Data?
    
    @State var selection: Int? = nil
    
    var body: some View {
        BaseBackView {
            if self.verified {
                VStack(spacing: 32.0){
                    funkyTitle(text: "Add \(name!) to your topics?", size: 36)
                    NavigationLink(destination: StartView(), tag: 1, selection: $selection) {
                        Button(action: saveQRData) {
                            funkyButton(text: "Oh Yes!", imageName: "dot.radiowaves.left.and.right")
                        }
                    }
                    Spacer()
                }
            } else {
                Text(scannedCode ?? "no scanned data")
                Text("Could not verify signature of this QR code")
            }
        }
        .onAppear(perform: loadQRData)
    }
    
    func saveQRData(){
        if self.verified {
            let newSignature = Signature(context: viewContext)
            let newTopic = Topic(context: viewContext)
            newTopic.name = self.name!
            newTopic.pubCert = self.pubCert!
            
            newSignature.signature = self.signature!
            newSignature.sharedTopicID = KeyManager.getB58(signature: self.signature!)
            newSignature.topic = newTopic
            newTopic.addToSignatures(newSignature)
            print(newSignature.sharedTopicID)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        self.selection = 1
    }
    
    func loadQRData() {
        let ur : UR = try! UR(urString: scannedCode!)
        let receivedCBOR : CBOR = try! CBOR.decode(Array(ur.cbor))!
        if case let CBOR.byteString(signature) = receivedCBOR["s"]!,
           case let CBOR.utf8String(name) = receivedCBOR["n"]!,
           case let CBOR.byteString(pubCert) = receivedCBOR["p"]!  {
            
            self.pubCert = Data(pubCert)
            self.signature = Data(signature)
            self.name = name
            
            let pubMgr = PubKeyManager(data: self.pubCert!)
            self.verified = pubMgr.verify(text: self.name!, signature: self.signature!)
        }
    }
}

struct ImportTopicView_Previews: PreviewProvider {
    static var previews: some View {
        ImportTopicView()
    }
}
