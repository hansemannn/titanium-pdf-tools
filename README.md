# Titanium iOS PDF Tools

Merges a given number of PDF files into one file using the `PDFKit` framework. Note: This module used to be `ti.pdfmerge`!

## Requirements

- [x] iOS 11+
- [x] Titanium SDK 9+

## API's

### Methods

- `mergedPDF(paths) -> Ti.Blob`: Returns a `Ti.Blob` that represents a merged PDF from the given PDF files
- `pdfFromImage({ image: yourImage, resizeImage: true|false, padding: 80 })`: Returns a `Ti.Blob` that represents a PDF created from an image

## Example

See `example/app.js`

## Author

Hans Knöchel

## License

MIT
