//
//  SportsCarViewController.m
//  sceneKit
//
//  Created by CoderXu on 16/9/7.
//  Copyright © 2016年 CoderXu. All rights reserved.
//

#import "SportsCarViewController.h"
@import CoreMotion;

@interface SportsCarViewController()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet SCNView *scnView;

@property(strong,nonatomic)SCNNode *cameraHodlerNode;
@property(strong,nonatomic)SCNNode *cameraNode;

@property (strong,nonatomic) CMMotionManager  *motionManager;
@property (strong,nonatomic) NSOperationQueue *quene;

@property(nonatomic)BOOL isLeft;


@end
@implementation SportsCarViewController
-(void)viewDidLoad {
    [super viewDidLoad];
    _isLeft = true;
    
    // 创建一个scene
    SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/sportsCar/sportCar.scn"];
    
    self.cameraHodlerNode = [SCNNode node];
    
    // 创建并添加摄像机
    self.cameraNode = [SCNNode node];
    self.cameraNode.camera = [SCNCamera camera];
    [self.cameraHodlerNode addChildNode:self.cameraNode];
    [scene.rootNode addChildNode:self.cameraHodlerNode];
    
    // 放置摄像机
    self.cameraNode.position = SCNVector3Make(20, 5, 20);
    self.cameraNode.eulerAngles = SCNVector3Make(0,M_PI/4, 0);
    
    // 创建名叫OmniLight的光源
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    lightNode.name = @"OmniLight";
    
    // 创建名为ambientLight的环境光
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    ambientLightNode.name = @"ambientLight";
    
    // 将scene赋值到scnView的属性上
    self.scnView.scene = scene;
    
    // 允许控制摄像机位置
    self.scnView.allowsCameraControl = YES;
    
    // 显示统计
    self.scnView.showsStatistics = YES;
    
    // 设置scnView
    self.scnView.backgroundColor = [UIColor blackColor];
    // 添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:self.scnView.gestureRecognizers];
    self.scnView.gestureRecognizers = gestureRecognizers;
    
    
    [self rotateCameraNode];
    [self startMotion];

}
- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:@"模拟灯光", nil];
    [actionSheet showInView:self.view];
}
-(void)startMotion{
    
    _quene = [[NSOperationQueue alloc] init];
    
    _motionManager=[[CMMotionManager alloc]init];
    //判断加速计是否可用
    if ([_motionManager isAccelerometerAvailable]) {
        // 设置加速计频率
        [_motionManager setAccelerometerUpdateInterval:1.0f/60];
        //开始采样数据
        [_motionManager startAccelerometerUpdatesToQueue:_quene withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            
            //            NSLog(@"X:%f,Y:%f,Z:%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
            
        }];
        
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            
            if(motion.userAcceleration.z<-0.02)
                NSLog(@"X:%f,Y:%f,Z:%f",motion.userAcceleration.x,motion.userAcceleration.y,motion.userAcceleration.z);
            
            self.cameraNode.eulerAngles = SCNVector3Make(motion.attitude.roll-M_PI_2, motion.attitude.yaw,motion.attitude.pitch);
        }];
        
        [_motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
            
        }];
        
    } else {
        NSLog(@"加速计不可用");
    }
    
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            break;
        case 1:
            
            [self addLight];
            
            break;
        case 2:
            
            break;
        default:
            break;
    }
}

-(void)rotateCameraNode{
    
    
        float delay = 8.0f;
    
        [self.cameraHodlerNode runAction:[SCNAction rotateByX:0
                                                            y:_isLeft?-2:2
                                       z:0
                                duration:delay]];
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
            _isLeft = !_isLeft;
            [self rotateCameraNode];
        });
    
}
-(void)addLight{
    
    SCNScene *scene = [self.scnView scene];
    
    SCNNode *omniLightNode = [scene.rootNode childNodeWithName:@"OmniLight" recursively:YES];
    omniLightNode.hidden = !omniLightNode.hidden;
    //    [omniLightNode removeFromParentNode];
    
    SCNNode *ambientLightNode = [scene.rootNode childNodeWithName:@"ambientLight" recursively:YES];
    ambientLightNode.light.color = [UIColor colorWithWhite:0.2 alpha:1.0];
    //     ambientLightNode.light.color = [UIColor blackColor];
    
    SCNNode *spotLightNode = [scene.rootNode childNodeWithName:@"spot" recursively:YES];
    spotLightNode.hidden = !spotLightNode.hidden;
    
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
    
    return UIInterfaceOrientationMaskLandscapeLeft;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end