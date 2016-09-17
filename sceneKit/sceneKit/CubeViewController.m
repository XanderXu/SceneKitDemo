//
//  CubeViewController.m
//  sceneKit
//
//  Created by CoderXu on 16/9/7.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

#import "CubeViewController.h"
@interface CubeViewController()
@property (weak, nonatomic) IBOutlet SCNView *scnView;

@end
@implementation CubeViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    // 实例化一个空的SCNScene类，接下来要用它做更多的事
    SCNScene *scene = [[SCNScene alloc] init];
    // 定义一个SCNBox类的几何实例然后创建盒子，并将其作为根节点的子节点，根节点就是scene
    SCNBox *boxGeometry = [SCNBox boxWithWidth:10.0 height:10.0 length:10.0 chamferRadius:1.0];
    SCNNode *boxNode = [SCNNode nodeWithGeometry:boxGeometry];
    [scene.rootNode addChildNode:boxNode];
    // 将场景放进sceneView中显示
    self.scnView.scene = scene;
    //添加灯泡效果
    self.scnView.autoenablesDefaultLighting = YES;
    //允许切换方位
    /*
     一只手指滑动：旋转你的观察点。
     两只手指滑动：移动观察点。
     双指挤压：缩放/放大场景。
     */
    self.scnView.allowsCameraControl = YES;
    
    //添加环境光，灰绿光
    SCNNode *ambientLightNode = [[SCNNode alloc] init];
    ambientLightNode.light = [[SCNLight alloc] init];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor colorWithRed:0.1 green:0.2 blue:0.1 alpha:1];
    [scene.rootNode addChildNode:ambientLightNode];
    //修改摄像机位置
    SCNNode *cameraNode = [[SCNNode alloc] init];
    cameraNode.camera = [[SCNCamera alloc] init];
    cameraNode.position = SCNVector3Make(0, 0, 25);
    [scene.rootNode addChildNode:cameraNode];
}

-(void)dealloc {
    NSLog(@"%s",__func__);
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
