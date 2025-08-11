//
//  TiPdftoolsDocumentProxy.swift
//  titanium-pdf-tools
//
//  Created by Hans Knöchel
//

import TitaniumKit
import PDFKit

@objc(TiPdftoolsDocumentProxy)
public class TiPdftoolsDocumentProxy : TiProxy {
  var document: PDFDocument?
  
  public func _init(withPageContext context: (any TiEvaluator)!, url: String) -> Self? {
    super._init(withPageContext: context)

    self.document = PDFDocument(url: TiUtils.toURL(url, proxy: self))

    return self
  }
  
  @objc(toBlob:)
  func toBlob(unused: Any?) -> TiBlob? {
    guard let document else { return nil }
    return TiBlob(data: document.dataRepresentation(), mimetype: "application/pdf")
  }

  @objc(findString:)
  func findString(arguments: [Any]) -> [[String: Any]]{
    guard let document else { return [] }

    var query: String?

    if let first = arguments.first as? String {
      query = first
    } else if let dict = arguments.first as? [String: Any] {
      query = dict["query"] as? String
    }

    guard let query = query, !query.isEmpty else { return [] }

    let selections = document.findString(query, withOptions: .caseInsensitive)
    var results: Array<[String: Any]> = []

    for selection in selections {
      guard let page = selection.pages.first else { continue }
      let rect = selection.bounds(for: page)
      let pageIndex = document.index(for: page)

      var result: [String: Any] = [
        "pageNumber": pageIndex,
        "x": rect.origin.x,
        "y": rect.origin.y,
        "width": rect.size.width,
        "height": rect.size.height
      ]

      if let matched = selection.string {
        result["selection"] = matched
      }

      results.append(result)
    }

    return results
  }
}
