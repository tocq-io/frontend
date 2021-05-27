//
//  ShareQRView.swift
//  UIPrototype
//
//  Created by Philipp on 27.05.21.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import URKit

struct ShareQRView: View {
    var topic: Topic? = nil
    var signature: Signature? = nil
    @State private var qrImage: Image?
    
    let qrFilter = CIFilter.qrCodeGenerator()
    let ciContext = CIContext()
    
    var body: some View {
        VStack() {
            VStack(alignment: .center) {
                qrImage?
                    .resizable()
                    .scaledToFit()
                    .frame(height: CGFloat(272))
                    .background(funkySuperDarkGrey(opacity: 1.0))
                Spacer()
            }
            VStack(alignment: .leading, spacing: 23) {
                NavigationLink(
                    destination: StartView()
                ) {
                    funkyButton(text: "Publish Topic Code", imageName: "sparkles")
                }
                NavigationLink(
                    destination: StartView()
                ) {
                    funkyButton(text: "Get Topic Code", imageName: "square.and.arrow.down.fill")
                }
                NavigationLink(
                    destination: StartView()
                ) {
                    funkyButton(text: "Skip for later", imageName: "hare.fill")
                }
                Spacer()
                
            }
        }
        .background(funkyBackground())
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: loadQRImage)
    }
    
    func loadQRImage() {
        let topicCBOR : CBOR = [
            "n": CBOR.utf8String(topic!.name),
            "s": CBOR.byteString(Array(signature!.signature)),
            "p": CBOR.byteString(Array(topic!.pubCert))
        ]
        
        let ur : UR = try! UR(type: "bytes", cbor: topicCBOR)
        print(ur.qrString)
        
        qrFilter.setValue(ur.qrData, forKey: "inputMessage")
        
        if let ciImage = qrFilter.outputImage {
            
            let invertFilter = CIFilter.colorInvert()
            invertFilter.setValue(ciImage, forKey: kCIInputImageKey)
            
            let alphaFilter = CIFilter.maskToAlpha()
            alphaFilter.setValue(invertFilter.outputImage, forKey: kCIInputImageKey)
            
            if let outputImage = alphaFilter.outputImage {
                let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent)
                
                let uiImage = UIImage(cgImage: cgImage!)
                
                qrImage = Image(uiImage: uiImage).interpolation(.none)
            }
        }
    }
}

struct ShareQRView_Previews: PreviewProvider {
    static var previews: some View {
        ShareQRView()
    }
}
