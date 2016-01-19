//
//  ViewController.m
//  UISnapBehavior
//
//  Created by 李朝 on 16/1/19.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *purperView;
/** 物理仿真器 */
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 获取触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];

    // 需要两个参数，一个是物理仿真元素，一个是捕捉点
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.purperView snapToPoint:point];

    // 设置防震系数，数值越大，震动的幅度越小 范围 0 ~ 1
    snap.damping = arc4random_uniform(10) / 10.0;

    // 添加新的仿真行为前要删除以前的仿真行为
    [self.animator removeAllBehaviors];

    // 添加仿真行为
    [self.animator addBehavior:snap];
}

/**
 * 创建物理仿真器
 */
- (UIDynamicAnimator *)animator
{
    if (_animator == nil) {
        
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

@end
