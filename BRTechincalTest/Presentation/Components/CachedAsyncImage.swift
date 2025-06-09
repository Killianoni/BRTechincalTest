//
//  CachedAsyncImage.swift
//  BRTechincalTest
//
//  Created by KILLIAN ADONAI on 09/06/2025.
//

import SwiftUI

struct CachedAsyncImage: View {
    //MARK: Private properties
    @State private var image: UIImage? = nil

    //MARK: Exposed properties
    let url: URL?

    //MARK: Body
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
            }
        }
        .task(id: url) {
            image = nil
            if let url = url {
                image = await ImageLoader.shared.loadImage(from: url)
            }
        }
    }
}
