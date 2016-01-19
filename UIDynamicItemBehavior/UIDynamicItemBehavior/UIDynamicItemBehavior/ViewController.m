//
//  ViewController.m
//  UIDynamicItemBehavior
//
//  Created by 李朝 on 16/1/19.
//  Copyright © 2016年 lizhao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/**  */
@property (strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIView *) newViewWithCenter:(CGPoint)paramCenter  backgroundColor:(UIColor *)paramBackgroundColor{
    UIView *newView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    newView.backgroundColor = paramBackgroundColor;
    newView.center = paramCenter;
    return newView;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIView *topView = [self newViewWithCenter:CGPointMake(100.0f, 0.0f)
                              backgroundColor:[UIColor greenColor]];
    UIView *bottomView = [self newViewWithCenter:CGPointMake(100.0f, 50.0f)
                                 backgroundColor:[UIColor redColor]];
    
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    
    //构造动画
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //gravity
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]
                                  initWithItems:@[topView, bottomView]];
    [self.animator addBehavior:gravity];
    
    //collision
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]
                                      initWithItems:@[topView, bottomView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    
    //指派不同特性值  弹性bounce
    UIDynamicItemBehavior *moreElasticItem = [[UIDynamicItemBehavior alloc]
                                              initWithItems:@[bottomView]];
    moreElasticItem.elasticity = 1.0f;
    
    UIDynamicItemBehavior *lessElasticItem = [[UIDynamicItemBehavior alloc]
                                              initWithItems:@[topView]];
    lessElasticItem.elasticity = 0.5f;
    [self.animator addBehavior:moreElasticItem];
    [self.animator addBehavior:lessElasticItem];
    
}

@end
