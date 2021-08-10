/**
 * titanium-pdf-merge
 *
 * Created by Hans Knoechel
 * Copyright (c) 2021 Hans Knöchel. All rights reserved.
 */

#import "TiModule.h"

@interface TiPdfmergeModule : TiModule;

- (TiBlob *)mergedPDF:(id)paths;

@end
