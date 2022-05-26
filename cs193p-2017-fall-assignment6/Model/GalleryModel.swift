//
//  GalleryModel.swift
//  cs193p-2017-fall-assignment6
//
//  Created by Ksenia Surikova on 17.08.2021.
//

import Foundation
import UIKit


struct ImageElement: Codable, Equatable {
    var aspectRatio: CGFloat
    var imageUrl : URL
    var isImageFetched : Bool?
}

struct Gallery: Codable{
    
    var images: [ImageElement]
    
    init() {
        self.images = [ImageElement]()
    }
    
    // this object is Codable with no other effort
    // than saying it implements Codable
    // since all of its vars' data types are Codable
    // if that weren't true, you could still make it Codable
    // by adding init and encode methods
    
    // if you wanted the JSON keys for this to be different
    // you'd uncomment this out (as an example) ...
    // private enum CodingKeys: String, CodingKey {
    //    case url = "background_url"
    //    case emojis
    // }
    
    
    init?(json: Data) // take some JSON and try to init an Gallery from it
    {
        if let newValue = try? JSONDecoder().decode(Gallery.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? // return this Gallery as a JSON data
    {
        return try? JSONEncoder().encode(self)
    }
}


