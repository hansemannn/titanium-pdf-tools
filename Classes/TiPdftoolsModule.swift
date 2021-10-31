//
//  TiPdftoolsModule.swift
//  titanium-pdf-tools
//
//  Created by Hans Knöchel
//  Copyright (c) 2021 Hans Knöchel. All rights reserved.
//

import UIKit
import PDFKit
import TitaniumKit

let A4_WIDTH: Float = 595.2
let A4_HEIGHT: Float = 841.8

@objc(TiPdftoolsModule)
class TiPdftoolsModule: TiModule {

  public let testProperty: String = "Hello World"
  
  func moduleGUID() -> String {
    return "08427de1-2112-471a-857b-357884da0f74"
  }
  
  override func moduleId() -> String! {
    return "ti.pdftools"
  }

  @objc(mergedPDF:)
  func mergedPDF(arguments: Array<Any>?) -> TiBlob? {
    guard let arguments = arguments, let paths = arguments[0] as? [String] else { return nil }

    let fullDocument = PDFDocument()
    var indexOfFullDocument = 0

    for pdfPath in paths {
      let pdfDocument = PDFDocument(url: TiUtils.toURL(pdfPath, proxy: self))
      var index = 0
      var pageCount = pdfDocument?.pageCount ?? 0

      while pageCount > 0 {
        if let pdfPage = pdfDocument?.page(at: index) {
          fullDocument.insert(pdfPage, at: indexOfFullDocument)
          index += 1
          indexOfFullDocument += 1
        }
        pageCount -= 1
      }
    }

    return TiBlob(data: fullDocument.dataRepresentation(), mimetype: "application/pdf")
  }
  
  @objc(pdfFromImage:)
  func pdfFromImage(arguments: Array<Any>?) -> TiBlob? {
    guard let arguments = arguments?.first as? [String: Any],
          let image = TiUtils.image(arguments["image"], proxy: self) else { return nil }

    let resizeImage = arguments["resizeImage"] as? Bool ?? false

    // Case 1: No options
    guard resizeImage else {
      let fullDocument = PDFDocument()
      if let page = PDFPage(image: image) {
        fullDocument.insert(page, at: 0)
      }

      return TiBlob(data: fullDocument.dataRepresentation(), mimetype: "application/pdf")
    }

    // Case 2: Resized image to ft into a A4 document
    let padding = arguments["padding"] as? Float ?? 80
    
    // Prepare raw data
    let pdfData = NSMutableData()
    let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
    
    // Calculate the aspect ratio
    let imageWidth = A4_WIDTH - (padding * 2)
    let imageHeight = round(CGFloat(imageWidth) * (image.size.height / image.size.width))

    // Calculate the bounces
    var mediaBox = CGRect(x: 0,
                          y: 0,
                          width: CGFloat(A4_WIDTH),
                          height: CGFloat(A4_HEIGHT)); // A4

    let imageBox = CGRect(x: CGFloat((A4_WIDTH / 2) - (imageWidth / 2)),
                          y: (CGFloat(A4_HEIGHT) / 2) - (imageHeight / 2),
                          width: CGFloat(imageWidth),
                          height: CGFloat(imageHeight))

    // Create the context to draw in
    let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
    
    // Perform the drawing
    pdfContext.beginPage(mediaBox: &mediaBox)
    pdfContext.draw(image.cgImage!, in: imageBox)
    pdfContext.endPage()
    pdfContext.closePDF()

    return TiBlob(data: pdfData as Data, mimetype: "application/pdf")
  }
}
