//
//  DocumentBrowserViewController.swift
//  cs193p-2017-fall-assignment6
//
//  Created by Ksenia Surikova on 22.09.2021.
//

import UIKit

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        // only allow document creation on iPad
        // since that's the only place with multitasking
        // that allows us to set images to gallery
        if UIDevice.current.userInterfaceIdiom == .pad {
            // create a blank document in our Application Support directory
            // this template will be copied to Documents directory for new docs
            // see didRequestDocumentCreationWithHandler delegate method
            template = try? FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
                //              ).appendingPathComponent("Untitled.json")
            ).appendingPathComponent("Untitled.imagegallery")
            if template != nil {
                // if we can't create the template
                // don't enable the Create Document button in the UI
                allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
            }
        }
    }

    var template: URL? // blank template for new documents

    // MARK: UIDocumentBrowserViewControllerDelegate
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didRequestDocumentCreationWithHandler importHandler:
                         @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }

    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately,
        // e.g., by presenting an error message to the user.
        if let error = error {
            print("failed to open document \(error.localizedDescription)")
        }
    }

    // MARK: Document Presentation
    func presentDocument(at documentURL: URL) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        // get the VC(s) we're going to use to show our EmojiArt document
        let documentVC = storyBoard.instantiateViewController(withIdentifier: "ImageDocumentVC")
        // configure our GalleryCollectionViewController with a new GalleryDocument
        // at the requested documentURL
        // note that we must use the documentVC's .contents (defined in StaticsAndExtensions.swift)
        // to look inside the navigation controller that is wrapped around our GalleryCollectionViewController
        if let galleryViewController = documentVC.contents as? GalleryCollectionViewController {
            galleryViewController.document = GalleryDocument(fileURL: documentURL)
        }
        // now present the MVC to show a document modally
        // this will take over the entire screen until it dismisses itself
        present(documentVC, animated: true)
    }
}
