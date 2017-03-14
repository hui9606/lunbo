//
//  LiuPageScrollView.h
//  LiuPageScrollView


#import <UIKit/UIKit.h>

@interface LiuPageScrollView : UIView

/**传入的图片数组*/
@property(nonatomic,strong)NSArray*imgArr;

/**图片的点击事件*/
@property(nonatomic,copy)void(^didClickImg)(NSInteger);


@end
