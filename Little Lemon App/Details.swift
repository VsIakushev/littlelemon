//
//  Details.swift
//  Little Lemon App
//
//  Created by Vitaliy Iakushev on 30.01.2023.
//

import SwiftUI

struct Details: View {
    var title: String
    var price: String
    var image: String
    var description: String
    
    var body: some View {
        VStack{
            Text(title)
            Text(price)
            Text(description)
            AsyncImage(url: URL(string: image))
                .frame(maxWidth: 300, maxHeight: 300)

        }
        
        

    }
}

struct Details_Previews: PreviewProvider {
    static var previews: some View {
        Details(title: "title", price: "price", image: "image", description: "description")
        
    }
}
