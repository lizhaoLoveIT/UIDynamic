//
//  ViewController.m
//  UIPushBehavior
//
//  Created by 李朝 on 16/1/19.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "ViewController.h"

// 设置一个速度阀值
static const CGFloat ThrowingThreshold = 1000;
// 它将对抛掷 view 的快慢产生影响
static const CGFloat ThrowingVelocityPadding = 35;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIView *redSquare;
@property (weak, nonatomic) IBOutlet UIView *blueSquare;

@property (nonatomic, assign) CGRect originalBounds;
@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIPushBehavior *pushBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehavior;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.originalBounds = self.image.bounds;
    self.originalCenter = self.image.center;
}


- (IBAction) handleAttachmentGesture:(UIPanGestureRecognizer*)gesture
{
    
    CGPoint location = [gesture locationInView:self.view];
    CGPoint boxLocation = [gesture locationInView:self.image];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            NSLog(@"you touch started position %@",NSStringFromCGPoint(location));
            NSLog(@"location in image started is %@",NSStringFromCGPoint(boxLocation));
            
            
            // 1
            [self.animator removeAllBehaviors];
            
            // 2
            UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.image.bounds),
                                                 boxLocation.y - CGRectGetMidY(self.image.bounds));
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.image
                                                                offsetFromCenter:centerOffset
                                                                attachedToAnchor:location];
            // 3
            self.redSquare.center = self.attachmentBehavior.anchorPoint;
            self.blueSquare.center = location;
            
            // 4
            [self.animator addBehavior:self.attachmentBehavior];
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.animator removeBehavior:self.attachmentBehavior];
            
            //1
            // 获取拖拽 view 的速度
            CGPoint velocity = [gesture velocityInView:self.view];
            // 计算当前的切线速度
            CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
            
            // 设置一个速度阀值 如果速度超过了阀值，就创建一个 pushBehavior
            if (magnitude > ThrowingThreshold) {
                //2
                // UIPushBehaviorModeInstantaneous 表示瞬间push 还有一个枚举 UIPushBehaviorModeContinuous 表示持续 push
                UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]
                                                initWithItems:@[self.image]
                                                mode:UIPushBehaviorModeInstantaneous];
                
                // vector 矢量
                pushBehavior.pushDirection = CGVectorMake((velocity.x / 10) , (velocity.y / 10));
                // magnitude 的属性控制 push 的快慢 必须慢慢试才能找出最合适的值
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding;
                
                self.pushBehavior = pushBehavior;
                [self.animator addBehavior:self.pushBehavior];
                
                //3
                NSInteger angle = arc4random_uniform(20) - 10;
                
                self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.image]];
                self.itemBehavior.friction = 0.2;
                self.itemBehavior.allowsRotation = YES;
                [self.itemBehavior addAngularVelocity:angle forItem:self.image];
                [self.animator addBehavior:self.itemBehavior];
                
                //4
                [self performSelector:@selector(resetDemo) withObject:nil afterDelay:0.4];
            }
            
            else {
                [self resetDemo];
            }
            
            break;
        }
            default:
            break;
    }
    
    
    [self.attachmentBehavior setAnchorPoint:[gesture locationInView:self.view]];
    self.redSquare.center = self.attachmentBehavior.anchorPoint;
}


- (void)resetDemo
{
    [self.animator removeAllBehaviors];
    
    [UIView animateWithDuration:0.45 animations:^{
        self.image.bounds = self.originalBounds;
        self.image.center = self.originalCenter;
        self.image.transform = CGAffineTransformIdentity;
    }];
}
@end
