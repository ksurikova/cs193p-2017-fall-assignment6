//
//  GalleryDocument.swift
//  cs193p-2017-fall-assignment6
//
//  Created by Ksenia Surikova on 22.09.2021.
//

import UIKit

class GalleryDocument: UIDocument {
    
    var gallery: Gallery?  // the Model for this Document
    var thumbnail: UIImage?
    
    // turn the Model into a JSON Data
    // the return value is an Any (not Data)
    // because it's allowed to be a FileWrapper
    // if an application would rather represent its documents that way
    // the forType: argument is a UTI (e.g. "public.json" or "surik.ksanti.imagegallery")
    
    override func contents(forType typeName: String) throws -> Any {
        return gallery?.json ?? Data()
    }
    
    // turn a JSON Data into the Model

    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            gallery = Gallery(json: json)
        }
    }
    
    // overridden to add a key-value pair
    // to the dictionary of "file attributes" on the file UIDocument writes
    // the added key-value pair sets a thumbnail UIImage for the UIDocument
    
    override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
        var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
        if let thumbnail = self.thumbnail {
            attributes[URLResourceKey.thumbnailDictionaryKey] = [URLThumbnailDictionaryItem.NSThumbnail1024x1024SizeKey:thumbnail]
        }
        return attributes
    }

}

