# Titanium iOS PDF Tools

Merges a given number of PDF files into one file using the `PDFKit` framework. Note: This module used to be `ti.pdfmerge`!

## API's

### Methods

- `mergedPDF(paths) -> Ti.Blob`: Returns a `Ti.Blob` that represents a merged PDF from the given PDF files
- `pdfFromImage({ image: yourImage, resizeImage: true|false, padding: 80 })`: Returns a `Ti.Blob` that represents a PDF created from an image

### Document Proxy (iOS)

- `findString(query|{ query }) -> Array<Object>`: Searches the current PDF for the given string and returns an array of matches containing `pageIndex`, `x`, `y`, `width`, `height` and `string` of the match.

## Example

See `example/app.js`

## Author

Hans Knöchel

## License

MIT
