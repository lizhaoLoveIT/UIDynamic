//
//  ViewController.m
//  UIDynamic
//
//  Created by 李朝 on 16/1/19.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *purperView;
@property (weak, nonatomic) IBOutlet UIProgressView *block1;
@property (weak, nonatomic) IBOutlet UISegmentedControl *block2;
/** 物理仿真器 */
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置红色view的角度
    self.purperView.transform=CGAffineTransformMakeRotation(M_PI_4);
}

/**
 * 创建物理仿真器
 */
-  (UIDynamicAnimator *)animator
{
    if (_animator == nil) {
        
        // 创建物理仿真器（ReferenceView:参照视图，设置仿真范围）
        UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator = animator;
    }
    return _animator;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
}

/**
 * 自定义碰撞边界
 */
- (void)customBounds
{
    // 1.重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.purperView];
    
    // 2.碰撞检测行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    [collision addItem:self.purperView];
    
    // 添加一个椭圆为碰撞边界 被矩形包裹的圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 320, 320)];
    // 注意：标识符不能写空。可以写字符串，因为需要标识符需要遵守NSCopying协议，而字符串满足要求。
    [collision addBoundaryWithIdentifier:@"circle" forPath:path];
    
    // 3.开始仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}

/**
 * 绘制碰撞边界曲线
 */
- (void)makeBoundsPath
{
    // 1.重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    [gravity addItem:self.purperView];
    
    // 2.碰撞检测行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    [collision addItem:self.purperView];
    CGPoint startP = CGPointMake(0, 160);
    CGPoint endP = CGPointMake(320, 400);
    [collision addBoundaryWithIdentifier:@"line1" fromPoint:startP toPoint:endP];
    CGPoint startP1 = CGPointMake(320, 0);
    [collision addBoundaryWithIdentifier:@"line2" fromPoint:startP1 toPoint:endP];
    //    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // 3.开始仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}

/**
 * 检测重力属性
 */
- (void)gravityProperty
{
    // 1.重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]init];
    // 设置重力的方向（角度）x 轴正方向为0点，顺时针为正，逆时针为负
    //        gravity.angle = (M_PI_4);
    // 设置重力的加速度,重力的加速度越大，碰撞就越厉害
    gravity.magnitude = 100;
    // 设置重力的方向（是一个二维向量）
    gravity.gravityDirection=CGVectorMake(1, 1);
    [gravity addItem:self.purperView];
    
    // 碰撞检测行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    [collision addItem:self.purperView];
    [collision addItem:self.block1];
    [collision addItem:self.block2];
    
    // 让参照视图的边框成为碰撞检测的边界
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    //3.执行仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
}

/**
 * 重力和碰撞行为
 */
- (void)gravityAndCollision
{
    // 重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    
    [gravity addItem:self.purperView];
    
    // 碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] init];
    [collision addItem:self.purperView];
    [collision addItem:self.block1];
    [collision addItem:self.block2];
    
    // 让参照视图的边框成为碰撞边界
    collision.translatesReferenceBoundsIntoBoundary = YES;
    
    // 执行仿真
    [self.animator addBehavior:gravity];
    [self.animator addBehavior:collision];
    
}

/**
 * 重力行为
 */
- (void)gravity
{
    // 1.创建重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];

    // 2.添加仿真元素
    [gravity addItem:self.purperView];

    // 3.让物理仿真元素执行仿真行为
    [self.animator addBehavior:gravity];
}

@end
