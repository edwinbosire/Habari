

#import <UIKit/UIKit.h>

@interface UIImage (Utilities)

+ (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)size;

+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

+ (UIImage *)tintImage:(UIImage *)image withColor:(UIColor *)tintColor;

+ (UIImage *)drawNavigationBarWithColor:(UIColor *)color;

+ (UIImage *)drawToolBarWithColor:(UIColor *)color;

- (UIImage *)blendImageWithColor:(UIColor *)color;

-(UIImage*)resizedImageToSize:(CGSize)dstSize;

-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;
@end
