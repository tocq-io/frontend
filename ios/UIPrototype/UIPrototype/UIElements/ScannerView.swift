//
//  ScannerView.swift
//  UIPrototype
//
//  Created by Philipp on 27.05.21.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    
    func onFoundQrCode(_ result: Result<String, CodeScannerView.ScanError>) {
        switch result {
        case .success(let code):
            self.scannedCode = code
            self.selection = true
        case .failure(let error):
            fatalError(error.localizedDescription)
        }
    }
    
    @State var scannedCode: String?
    @State var selection: Bool = false
    
    var body: some View {
        BaseBackView {
            NavigationLink(destination: ImportTopicView(scannedCode: scannedCode), isActive: $selection) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "UR:BYTES/OTHSJTJOISHSKOIHCXHSCXIOJLJLIECXJYINJNIHHSJKHDFGDYFYAOCXHEWZHGASADSSKGRYGRAOSALDDTLYZOLTJYOTPKATKNFDIOLREOWFGAQZHNISKTMSAOCXFRVOKBSAHYUTSSOYJEEYSGASLEROGAFZKOTTSBINMKDRLKTLAAAMBKONKGJERHBYHSJOHDFPAABGIMGAGRLPRFMNSGPSDMCTJTYADNIDTNHGRHNDGSHEDYNSTOWLBZPYURJEMTWTMTRSMDNYHNJTENDSMDTIDKNTWEPFJPFRLKPDHYJLRHGAEYPEBKLOYKIOTLGSBNJPBGKNJOJKGY", completion: onFoundQrCode)
            }
        }
    }
}
