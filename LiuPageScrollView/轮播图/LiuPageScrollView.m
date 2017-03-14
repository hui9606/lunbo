//
//  LiuPageScrollView.m
//  LiuPageScrollView
//


#import "LiuPageScrollView.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"

#define   screenW [UIScreen mainScreen].bounds.size.width
#define   screenH [UIScreen mainScreen].bounds.size.height
#define   timeInterval 3
#define   animateDuration  0.5

@interface LiuPageScrollView ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl*pageControl;

@property  (nonatomic,strong) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *rightImageView;

@property (nonatomic,assign)NSInteger currentIndex;

//计时器
@property(strong,nonatomic)NSTimer *timer;
@end

@implementation LiuPageScrollView

//懒加载 scrollView
-(UIScrollView *)scrollView{
    if (_scrollView==nil) {
        
        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.bounces=NO;
        _scrollView.delegate=self;
        _scrollView.contentInset=UIEdgeInsetsZero;
        _scrollView.contentSize=CGSizeMake(screenW*3, 0);
        [_scrollView addSubview:self.leftImageView];
        [_scrollView addSubview:self.centerImageView];
        [_scrollView addSubview:self.rightImageView];
    }
    return _scrollView;
}

-(UIPageControl *)page{
    if (_pageControl==nil) {
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(self.width-100, self.height-40, 100, 40)];
        _pageControl.enabled=NO;
        _pageControl.centerX=self.width/2;
        _pageControl.y=self.height-40-5;
        
    }
    return _pageControl;
}

-(UIImageView*)leftImageView{
    
    if (_leftImageView==nil) {
        _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
       
        //添加单击手势
        [self addGestureRecognizerForImageView:_leftImageView];
    }
       return _leftImageView;
    
}
-(UIImageView*)centerImageView{
    
    if (_centerImageView==nil) {
        _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
        //添加单击手势
        [self addGestureRecognizerForImageView:_centerImageView];
    }
    return _centerImageView;
    
}

-(UIImageView*)rightImageView{
    
    if (_rightImageView==nil) {
        _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.width*2, 0, self.width, self.height)];
        //添加单击手势
        [self addGestureRecognizerForImageView:_rightImageView];
            }
   
    return _rightImageView;
    
}
//添加单击手势
-(void)addGestureRecognizerForImageView:(UIImageView*)imageView{
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    [imageView addGestureRecognizer:tap];
    imageView.userInteractionEnabled=YES;
    
}

-(void)tapClick:(UIGestureRecognizer*)gesture{
    
    UIView*view=gesture.view;
    NSInteger index=view.tag-100;
   
    if (self.didClickImg) {
        self.didClickImg(index);
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.page];
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self=[super initWithCoder:aDecoder]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.page];
    }
    return self;
}

-(void)setImgArr:(NSArray *)imgArr{
    
    _imgArr = imgArr;
    
    self.pageControl.numberOfPages = imgArr.count;
    
    [self reloadImage];
    
    [self timerStart];

}

-(void)timeChange{
    [UIView animateWithDuration:animateDuration animations:^{
        self.scrollView.contentOffset = CGPointMake(2 * screenW, 0);
    } completion:^(BOOL finished) {
      
        //相当于向右滑动
        _currentIndex ++;
        _currentIndex = [self indexEnableWithIndex:_currentIndex];
        _pageControl.currentPage = _currentIndex;
        [self reloadImage];
    }];
}

//重新加载图片
-(void)reloadImage{
    
    NSInteger index1=[self indexEnableWithIndex:_currentIndex-1];
    NSInteger index2=[self indexEnableWithIndex:_currentIndex];
    NSInteger index3=[self indexEnableWithIndex:_currentIndex+1];
    [self setImageForImageView:self.leftImageView andIndex:index1];
    [self setImageForImageView:self.centerImageView andIndex:index2];
    [self setImageForImageView:self.rightImageView andIndex:index3];
    
    //把图片拉到中间位置
    self.scrollView.contentOffset=CGPointMake(screenW, 0);
}
-(NSInteger)indexEnableWithIndex:(NSInteger)index{
    if (index < 0) {
        return self.imgArr.count - 1;
    }else if (index > self.imgArr.count - 1){
        return 0;
    }else{
        return index;
    }
}
-(void)setImageForImageView:(UIImageView*)imageView andIndex:(NSInteger)index{
   
    NSString *imgStr=self.imgArr[index];
    if ([imgStr containsString:@"http"]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
           }else{
        imageView.image=[UIImage imageNamed:imgStr];

    }
    imageView.tag=100+index;
}

#pragma mark - scrollView delegate

//用户拖拽的时候停止定时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self timerStop];                                                                        
}

//这个方法 在用户拖拽的时候会调用 自己设置contentoffset的时候不会调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < 0.5 *screenW) {
        _currentIndex --;
    }
    if (scrollView.contentOffset.x > 1.5 *screenW) {
        _currentIndex ++;
    }
    
    _currentIndex = [self indexEnableWithIndex:_currentIndex];
  
    _pageControl.currentPage = _currentIndex;
    
    //改变index的之后重新加载图片
    [self reloadImage];
    [self timerStart];

}

-(void)timerStart{
    
    if (_timer == nil) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    }

}
-(void)timerStop{

    [self.timer invalidate];
    self.timer=nil;
}



@end
