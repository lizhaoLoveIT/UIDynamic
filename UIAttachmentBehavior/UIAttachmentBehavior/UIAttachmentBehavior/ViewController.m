//
//  ViewController.m
//  UIAttachmentBehavior
//
//  Created by 李朝 on 16/1/19.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *lightBlueView;

/** 仿真器 */
@property (strong, nonatomic) UIDynamicAnimator *animator;
/**  */
@property (strong, nonatomic) UIAttachmentBehavior *attach;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
}

- (IBAction)handleAttachmentGesture:(UIPanGestureRecognizer *)pan
{
    
    // 在手势开始时添加 物理仿真行为
    if (pan.state == UIGestureRecognizerStateBegan) {
        // 首先要移除物理仿真行为
        [self.animator removeAllBehaviors];
        
        // 获取手势在 view 容器中的位置
        CGPoint location = [pan locationInView:self.view];
        // 获取手势在 lightBlueView 中的位置
        CGPoint boxLocation = [pan locationInView:self.lightBlueView];
        
        // 以 lightBlueView 为参考坐标系，计算触摸点到 lightBlueView 中点的偏移量
        UIOffset offset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.lightBlueView.bounds), boxLocation.y - CGRectGetMidY(self.lightBlueView.bounds));
        
        
        // 创建物理仿真行为
        self.attach = [[UIAttachmentBehavior alloc] initWithItem:self.lightBlueView offsetFromCenter:offset attachedToAnchor:location];
        
//        self.attach.damping = 10000;
//        self.attach.frequency = 10000;
//        self.attach.length = 100;
        self.attach.frictionTorque = 100;
        
        [self.animator addBehavior:self.attach];
    }
    
    [self.attach setAnchorPoint:[pan locationInView:self.view]];
    
}


@end
