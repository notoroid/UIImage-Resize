//
//  UIImage+IDResize.m
//  QuestionEditor
//
//  Created by 能登 要 on 2016/10/20.
//  Copyright © 2016年 Irimasu Densan Planning. All rights reserved.
//

#import "UIImage+IDResize.h"
@import CoreImage;
@import AVFoundation;
#import "NSData+MD5.h"
@import MobileCoreServices;

NSOperationQueue *s_operationQueueIDPResize = nil;

@interface IDPResizeOption ()
{
    CGFloat _scale;
    CGSize _size;
}
@end

@implementation IDPResizeOption

- (instancetype _Nonnull) initWithSize:(CGSize)size scale:(CGFloat)scale
{
    self = [super init];
    if( self != nil ){
        _scale = scale;
        _size = size;
    }
    return self;
}

+ (instancetype _Nonnull)resizeOptionWithSize:(CGSize)size scale:(CGFloat)scale
{
    IDPResizeOption *resizeOption = [[IDPResizeOption alloc] initWithSize:size scale:scale];
    
    return resizeOption;
}

+ (instancetype _Nonnull)resizeOptionWithSize:(CGSize)size
{
    IDPResizeOption *resizeOption = [[IDPResizeOption alloc] initWithSize:size scale:[UIScreen mainScreen].scale];
    
    return resizeOption;
}

+ (NSString * _Nullable) mineWithImageFormatType:(IDPImageFormatType) imageFormatType
{
    NSString *mine = nil;
    switch (imageFormatType) {
        case IDPImageFormatTypeJpeg:
        {
            mine = (__bridge NSString *)kUTTypeJPEG;
        }
            break;
        case IDPImageFormatTypePng:
        {
            mine = (__bridge NSString *)kUTTypePNG;
        }
            break;
        default:
            break;
    }
    return mine;
}

+ (IDPImageFormatType) imageFormatTypeWithPath:(nonnull NSString *)path
{
    NSString *lowcaseExtension = path.pathExtension.lowercaseString;
    
    IDPImageFormatType imageFormatType = IDPImageFormatTypeJpeg;
    
    if( [lowcaseExtension isEqualToString:@"png"] ){
        imageFormatType = IDPImageFormatTypePng;
    }else if( lowcaseExtension == nil || [lowcaseExtension isEqualToString:@"jpg"] || [lowcaseExtension isEqualToString:@"jpeg"] ){
        imageFormatType = IDPImageFormatTypeJpeg;
    }
    return imageFormatType;
}

+ (NSString * _Nullable) filenameWithPath:(nonnull NSString *)path
{
    NSString *lowcaseExtension = path.pathExtension.lowercaseString;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    NSDictionary<NSFileAttributeKey, id> *attributes = [fileManager attributesOfItemAtPath:path error:&error];
    //            NSLog(@"attributes=%@",attributes);
    
    NSString *fileStamp = [@[path,attributes.description] componentsJoinedByString:@" "];
    //            NSLog(@"fileStamp=%@",fileStamp);
    
    NSData *dataFileStamp = [fileStamp dataUsingEncoding:NSUTF8StringEncoding];
    NSString *hash = dataFileStamp.encryptToMD5;
    
    return [hash stringByAppendingPathExtension:lowcaseExtension];
}

@end

@implementation UIImage (IDResize)

- (CGFloat) degreesToRadians:(CGFloat) degrees
{
    return degrees * M_PI / 180;
}

- (CGFloat) radiansToDegrees:(CGFloat) radians
{
    return radians * 180 / M_PI;
}

+ (void) resetAllResizing
{
    [s_operationQueueIDPResize cancelAllOperations];
}

- (void) resizeWithOptions:(NSArray<IDPResizeOption *> * _Nonnull)options progress: (void (^ __nonnull)(NSData * __nullable data,IDPResizeOption * __nonnull option))progress completion:(void (^ __nullable)())completion
{
    @autoreleasepool {
        CIImage *sourceImage = [[CIImage alloc] initWithCGImage:self.CGImage options:nil];
        
        switch (self.imageOrientation) {
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                if( self.imageOrientation == UIImageOrientationUpMirrored ){
                    sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeScale(1.0f, -1.0f)];
                }
                break;
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
            {
                sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeRotation([self degreesToRadians:180.0f])];
                if( self.imageOrientation == UIImageOrientationDownMirrored ){
                    sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeScale(1.0f, -1.0f)];
                }
                CGPoint offset = [sourceImage extent].origin;
                sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeTranslation(-offset.x,-offset.y)];
                //                NSLog(@"[sourceImage extent]=%@",[NSValue valueWithCGRect:[sourceImage extent]]);
            }
                break;
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
            {
                sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeRotation([self degreesToRadians:-90.0f])];
                if( self.imageOrientation == UIImageOrientationRightMirrored ){
                    sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeScale(-1.0f, 1.0f)];
                }
                CGPoint offset = [sourceImage extent].origin;
                sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeTranslation(-offset.x,-offset.y)];
                //                    NSLog(@"[sourceImage extent]=%@",[NSValue valueWithCGRect:[sourceImage extent]]);
            }
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            {
                sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeRotation([self degreesToRadians:90.0f])];
                if( self.imageOrientation == UIImageOrientationLeftMirrored ){
                    sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeScale(-1.0f, 1.0f)];
                }
                CGPoint offset = [sourceImage extent].origin;
                sourceImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeTranslation(-offset.x,-offset.y)];
            }
                break;
            default:
                break;
        }
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            s_operationQueueIDPResize = [[NSOperationQueue alloc] init];
            s_operationQueueIDPResize.maxConcurrentOperationCount = 1;
        });
        
        
        [options enumerateObjectsUsingBlock:^(IDPResizeOption * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
                CGRect contentArea = AVMakeRectWithAspectRatioInsideRect(self.size,(CGRect){CGPointZero,CGSizeMake(obj.size.width * obj.scale,obj.size.height * obj.scale) });
                double ratioWidth = round(contentArea.size.width) / self.size.width;
                double ratioHeight = round(contentArea.size.height) / self.size.height;
                
                @autoreleasepool {
                    UIImage *resizedImage = nil;
                    {
                        CIImage *filteredImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeScale(ratioWidth, ratioHeight)];
                        CIContext *ciContext = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:@NO forKey:kCIContextUseSoftwareRenderer]];
                        
                        CGRect extent = [filteredImage extent];
                        CGImageRef imageRef = [ciContext createCGImage:filteredImage fromRect:extent];
                        resizedImage = [UIImage imageWithCGImage:imageRef scale:1.0f orientation: UIImageOrientationUp];
                        CGImageRelease(imageRef);
                    }
                    
                    @autoreleasepool {
                        NSData *data = nil;
                        
                        switch (obj.imageFormatType) {
                            case IDPImageFormatTypeJpeg:
                            {
                                data = UIImagePNGRepresentation(resizedImage);
                            }
                                break;
                            case IDPImageFormatTypePng:
                                data = UIImageJPEGRepresentation(resizedImage, 0.8 );
                                break;
                            default:
                                break;
                        }
                        
                        // ファイル名を決定
                        NSString *filename = [data encryptToMD5];
                        NSString *mine = nil;
                        switch (obj.imageFormatType) {
                            case IDPImageFormatTypeJpeg:
                            {
                                filename = [filename stringByAppendingPathExtension:@"jpg"];
                                mine = (__bridge NSString *)kUTTypeJPEG;
                            }
                                break;
                            case IDPImageFormatTypePng:
                            {
                                filename = [filename stringByAppendingPathExtension:@"png"];
                                mine = (__bridge NSString *)kUTTypePNG;
                            }
                                break;
                            default:
                                break;
                        }
                        if( obj.filename == nil ){
                            obj.filename = filename;
                        }
                        obj.mine = mine;
                        
                        if( progress != nil ){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                progress(data,obj);
                            });
                        }
                    }
                }
            }];
            
            [s_operationQueueIDPResize addOperation:blockOperation];
        }];
        
        if( completion != nil ){
            [s_operationQueueIDPResize addOperationWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion();
                });
            }];
        }
        
        
        
        
    }
    
}

@end
