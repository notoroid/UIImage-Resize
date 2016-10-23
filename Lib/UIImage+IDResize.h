//
//  UIImage+IDResize.h
//  QuestionEditor
//
//  Created by 能登 要 on 2016/10/20.
//  Copyright © 2016年 Irimasu Densan Planning. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,IDPImageFormatType)
{
     IDPImageFormatTypeJpeg
    ,IDPImageFormatTypePng
};

@interface IDPResizeOption : NSObject

+ (instancetype _Nonnull)resizeOptionWithSize:(CGSize)size;
+ (instancetype _Nonnull)resizeOptionWithSize:(CGSize)size scale:(CGFloat)scale;
+ (IDPImageFormatType) imageFormatTypeWithPath:(nonnull NSString *)path;

@property (readonly,nonatomic) CGSize size;
@property (readonly,nonatomic) CGFloat scale;
//@property (copy,nonatomic,nullable) NSString *originalFilename;
@property (copy,nonatomic,nullable) NSString *filename;
@property (copy,nonatomic,nullable) NSString *mine;
@property (assign,nonatomic) IDPImageFormatType imageFormatType;
@property (assign,nonatomic) NSUInteger tag;
@end

@interface UIImage (IDResize)

- (void) resizeWithOptions:(NSArray<IDPResizeOption *> * _Nonnull)options completion: (void (^ __nonnull)(NSData * __nullable data,IDPResizeOption * __nonnull option))completion;
+ (void) resetAllResizing;

@end
