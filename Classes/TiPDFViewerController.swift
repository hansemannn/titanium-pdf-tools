//
//  PDFViewerController.swift
//  pdf_test
//
//  Created by Hans Knöchel on 11.08.25.
//

import UIKit
import PDFKit

class PDFViewerController: UIViewController {
    var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Add close button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))

        // Create PDFView
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        // Add constraints
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Configure PDFView
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
    }
    
    func openPDF(at url: URL, pageNumber: Int = 0) {
        if let document = PDFDocument(url: url) {
            pdfView.document = document
            // Set navigation bar title from PDF metadata or filename
            var title: String? = nil
            if let attrs = document.documentAttributes,
               let t = attrs[PDFDocumentAttribute.titleAttribute] as? String,
               !t.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                title = t
            }
            self.title = title ?? url.deletingPathExtension().lastPathComponent
            
            // Jump to specific page and align the top of the page
            if let page = document.page(at: pageNumber) {
                let bounds = page.bounds(for: .cropBox)
                let topLeft = CGPoint(x: bounds.minX, y: bounds.maxY)
                let dest = PDFDestination(page: page, at: topLeft)
                pdfView.go(to: dest)
            }
        }
    }
    
    func goToSearchResult(_ selection: PDFSelection) {
        pdfView.currentSelection = selection
        pdfView.go(to: selection)
    }

    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
