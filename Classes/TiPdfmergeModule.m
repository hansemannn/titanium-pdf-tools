/**
 * titanium-pdf-merge
 *
 * Created by Hans Knoechel
 * Copyright (c) 2021 Hans Knöchel. All rights reserved.
 */

#import <PDFKit/PDFKit.h>
#import "TiPdfmergeModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiBlob.h"

const static CGFloat A4_WIDTH = 595.2;
const static CGFloat A4_HEIGHT = 841.8;

@implementation TiPdfmergeModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"c336ac00-86fb-4700-b851-353fd5cbb1f2";
}

- (NSString *)moduleId
{
  return @"ti.pdfmerge";
}

#pragma mark Public API's

- (TiBlob *)mergedPDF:(id)paths
{
  ENSURE_SINGLE_ARG(paths, NSArray);

  PDFDocument *fullDocument = [PDFDocument new];

  for (NSString *pdfPath in paths) {
    PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:[TiUtils toURL:pdfPath proxy:self]];

    NSUInteger index = 0; // Use this index to have straight counts 1-2-3-4-...-n
    NSUInteger pageCount = pdfDocument.pageCount; // Use this index to loop the pages (some can be nil)

    while (pageCount > 0) {
      PDFPage *pdfPage = [pdfDocument pageAtIndex:index];
      if (pdfPage != nil) {
        [fullDocument insertPage:pdfPage atIndex:index];
        index++;
      }
      pageCount--;
    }
  }

  return [[TiBlob alloc] initWithData:[fullDocument dataRepresentation] mimetype:@"application/pdf"];
}

- (TiBlob *)pdfFromImage:(id)args
{
  ENSURE_SINGLE_ARG(args, NSDictionary);

  UIImage *image = [TiUtils toImage:args[@"image"] proxy:nil];
  BOOL resizeImage = [TiUtils boolValue:args[@"resizeImage"] def:NO];

  // Handle image resize in A4 container
  if (resizeImage) {
    CGFloat padding = [TiUtils floatValue:args[@"padding"] def:80];

    // Prepare the raw data
    NSMutableData *pdfData = [NSMutableData new];
    CGDataConsumerRef pdfConsumer = CGDataConsumerCreateWithCFData((CFMutableDataRef)pdfData);

    // Calculate the aspect ratio
    CGFloat imageWidth = A4_WIDTH - (padding * 2);
    CGFloat imageHeight = round(imageWidth * (image.size.height / image.size.width));

    // Calculate the bounces
    CGRect mediaBox = CGRectMake(0, 0, A4_WIDTH, A4_HEIGHT); // A4
    CGRect imageBox = CGRectMake((A4_WIDTH / 2) - (imageWidth / 2), (A4_HEIGHT / 2) - (imageHeight / 2), imageWidth, imageHeight);

    // Create the context to draw in
    CGContextRef pdfContext = CGPDFContextCreate(pdfConsumer, &mediaBox, NULL);

    // Perform the drawing
    CGContextBeginPage(pdfContext, &mediaBox);
    CGContextDrawImage(pdfContext, imageBox, image.CGImage);
    CGContextEndPage(pdfContext);

    // Cleanup
    CGDataConsumerRelease(pdfConsumer);
    CGContextRelease(pdfContext);
    
    return [[TiBlob alloc] initWithData:pdfData mimetype:@"application/pdf"];
  }

  // Default case: Generate a fitting PDF
  PDFDocument *fullDocument = [PDFDocument new];
  PDFPage *page = [[PDFPage alloc] initWithImage:image];

  [fullDocument insertPage:page atIndex:0];

  return [[TiBlob alloc] initWithData:fullDocument.dataRepresentation mimetype:@"application/pdf"];
}

@end
