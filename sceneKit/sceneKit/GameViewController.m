//
//  GameViewController.m
//  sceneKit
//
//  Created by CoderXu on 16/9/3.
//  Copyright (c) 2016年 CoderXu. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create a new scene创建一个新的场景
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.scn"];

    // create and add a camera to the scene创建并添加一个相机到场景上
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera旋转相机
    cameraNode.position = SCNVector3Make(0, 0, 15);
    
    // create and add a light to the scene创建并添加一个光源到场景上
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene创建并添加一个环境光源到场景上
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // retrieve the ship node拿到ship节点
    SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
    
    // animate the 3d object添加动画
    [ship runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:1]]];
    
    // retrieve the SCNView拿到SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view设置场景到view上
    scnView.scene = scene;
    
    // allows the user to manipulate the camera允许用户控制相机
    scnView.allowsCameraControl = YES;
        
    // show statistics such as fps and timing information展示统计信息如fps和时间信息
    scnView.showsStatistics = YES;

    // configure the view配置view的背景色
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView拿到SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped检查哪个节点被点击了
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object检查被点击的最新的一个物体
    if([hitResults count] > 0){
        // retrieved the first clicked object拿到被点击的第一个物体
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material得到要材质
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it高亮显示
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight取消高亮
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
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
