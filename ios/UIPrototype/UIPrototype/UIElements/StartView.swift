//
//  StartView.swift
//  UIPrototype
//
//  Created by Philipp on 27.05.21.
//

import SwiftUI

struct StartView: View {
    
    @FetchRequest(entity: Topic.entity(), sortDescriptors: []) var topics: FetchedResults<Topic>
    
    var body: some View {
        List {
            ForEach(topics, id: \.name) { topic in
                Text(topic.name)
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
