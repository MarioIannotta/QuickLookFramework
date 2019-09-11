#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#include <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>
#import "QuickLookFramework-Swift.h"

OSStatus GeneratePreviewForURL(void *thisInterface,
                               QLPreviewRequestRef preview,
                               CFURLRef url, CFStringRef contentTypeUTI,
                               CFDictionaryRef options);

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef
                               preview, CFURLRef
                               url, CFStringRef
                               contentTypeUTI,
                               CFDictionaryRef options) {
    @autoreleasepool {
        NSSize canvasSize = NSMakeSize(600, 600);
        CGContextRef cgContext = QLPreviewRequestCreateContext(preview, *(CGSize *)&canvasSize, false, NULL);
        if (cgContext) {
            NSGraphicsContext* context = [NSGraphicsContext graphicsContextWithCGContext:(void *)cgContext flipped:NO];
            if (context) {
                [NSGraphicsContext saveGraphicsState];
                [NSGraphicsContext setCurrentContext:context];
                [PreviewViewController showWithUrl:(__bridge NSURL *)url context:context];
                [NSGraphicsContext restoreGraphicsState];
            }
            QLPreviewRequestFlushContext(preview, cgContext);
            CFRelease(cgContext);
        }
    }
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview) { }
