//
//  GameScene.h
//  MySpriteKitTest
//

//  Copyright (c) 2014年 test. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

#define AGSPRITEBUTTON_METHOD
//#define SKSPRITE_METHOD
//#define UIBUTTON_METHOD

@interface GameScene : SKScene

@property (nonatomic) SKSpriteNode* player;
@property (nonatomic, strong) NSMutableArray *monsters;
@property (nonatomic, strong) NSMutableArray *projectiles;
@property (nonatomic, strong) SKAction *projectileSoundEffectAction;
@property (nonatomic, strong) AVAudioPlayer *bgmPlayer;
@property (nonatomic, assign) int monstersDestroyed;

@end
