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
  PDFDocument *fullDocument = [PDFDocument new];
  [fullDocument insertPage:[[PDFPage alloc] initWithImage:image] atIndex:0];

  return [[TiBlob alloc] initWithData:fullDocument.dataRepresentation mimetype:@"application/pdf"];
}

@end
