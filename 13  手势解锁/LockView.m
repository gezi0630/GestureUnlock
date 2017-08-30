//
//  LockView.m
//  13  手势解锁
//
//  Created by MAC on 2017/8/30.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "LockView.h"

@interface LockView()

@property(nonatomic,assign)CGPoint curP;

/**选中的按钮的数组*/
@property(nonatomic,strong)NSMutableArray * selectedBtnArr;

@end

@implementation LockView

-(NSMutableArray *)selectedBtnArr
{
    if (_selectedBtnArr == nil) {
        _selectedBtnArr = [NSMutableArray array];
    }
    return _selectedBtnArr;
}



//storyBoard拖过来的pan手势
-(IBAction)pan:(UIPanGestureRecognizer*)pan
{
    //当前触摸点
    _curP = [pan locationInView:self];
    
    //判断触摸点在不在按钮上
    for (UIButton * btn in self.subviews) {
        if (CGRectContainsPoint(btn.frame, self.curP) && btn.selected == NO) {
            
            btn.selected = YES;
            
            //保存到数组中
            [self.selectedBtnArr addObject:btn];
        }
        
        
    }
    
    //重绘
    [self setNeedsDisplay];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        //创建可变字符串
        NSMutableString * strM = [NSMutableString string];
        //保存输入密码
        for (UIButton * btn in self.selectedBtnArr) {
            
            //取消所有按钮的选中
            btn.selected = NO;
            
            //拼接密码
            [strM appendFormat:@"%ld",btn.tag];
            
        }
        //打印密码
        NSLog(@"密码： %@",strM);
        
        //清除划线，把选中按钮清空
        [self.selectedBtnArr removeAllObjects];
        
    }
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //创建9个按钮
    for (int i = 0; i < 9; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //关闭交互，防止高亮
        btn.userInteractionEnabled = NO;
        //设置图片
        [btn setImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        //设置tag值
        btn.tag = i;
        
        [self addSubview:btn];
    }
}

//布局9个按钮
-(void)layoutSubviews

{
    [super layoutSubviews];
    
    NSUInteger count = self.subviews.count;
    //总列数
    int cols = 3;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 74;
    CGFloat h = 74;
    CGFloat margin = (self.bounds.size.width - cols * w) / (cols + 1);
    
    //第几列
    CGFloat col = 0;
    //第几行
    CGFloat row = 0;
    
    
    for (NSUInteger i = 0; i< count; i++) {
        UIButton * btn = self.subviews[i];
        
        //当前按钮在第几列
        col = i % cols;
        //当前按钮在第几行
        row = i / cols;
        
        x = margin + col * (margin + w);
        y = row * (margin + w);
        
        
        
        btn.frame = CGRectMake(x, y, w, h);
        
        
    }
    
    
}




//只要调用这个方法，就会把之前绘制的东西全部清掉，重新绘制
-(void)drawRect:(CGRect)rect
{
    //    NSLog(@"%s",__func__);
    //没有选中按钮就不需要连线
    if (self.selectedBtnArr.count == 0) return;
    
    
    //把所有选中按钮中心连线
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    NSUInteger count = self.selectedBtnArr.count;
    
    //所有选中选中按钮之间都连好线
    for (int i = 0; i < count; i++) {
        UIButton * btn = self.selectedBtnArr[i];
        if (i == 0) {
            //设置起点
            [path moveToPoint:btn.center];
            
        }else
        {
            [path addLineToPoint:btn.center];
        }
    }
    
    //所有触摸点间连线
    [path addLineToPoint:_curP];
    
    [[UIColor greenColor]set];
    path.lineWidth = 10;
    //线的转折点设置为圆状
    path.lineJoinStyle = kCGLineJoinRound;
    
    [path stroke];
}






@end
