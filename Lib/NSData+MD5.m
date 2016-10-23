//
//  UIImage+IDResize.m
//  QuestionEditor
//
//  Created by 能登 要 on 2016/10/20.
//  Copyright © 2016年 Irimasu Densan Planning. All rights reserved.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSData (IDPResize)

- (NSString*)encryptToMD5 {
    unsigned char md5digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes,(CC_LONG)self.length, md5digest);
    NSMutableArray<NSString *> *components = [NSMutableArray<NSString *> array];
    for( unsigned char *iterator = md5digest; iterator != md5digest + CC_MD5_DIGEST_LENGTH; iterator++ ){
        [components addObject:[NSString stringWithFormat:@"%02x",*iterator]];
    }
    return [components componentsJoinedByString:@""];
}

@end
