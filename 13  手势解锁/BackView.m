//
//  BackView.m
//  13  手势解锁
//
//  Created by MAC on 2017/8/30.
//  Copyright © 2017年 GuoDongge. All rights reserved.
//

#import "BackView.h"

@implementation BackView

- (void)drawRect:(CGRect)rect {
    //绘制一个背景图
    UIImage * image = [UIImage imageNamed:@"Home_refresh_bg"];
    
    [image drawInRect:rect];
    
    
    
}
@end

