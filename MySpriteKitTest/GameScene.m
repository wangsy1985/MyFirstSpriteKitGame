//
//  GameScene.m
//  MySpriteKitTest
//
//  Created by m-wang on 2014/07/09.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "GameScene.h"
#import "ResultScene.h"
#import "AGSpriteButton.h"

@implementation GameScene

/**
 *　サイズで初期化
 */
- (id)initWithSize:(CGSize)size {
    
    if(self = [super initWithSize:size]) {
        
        //モンスター配列初期化
        self.monsters = [NSMutableArray array];
        
        //手裏剣配列初期化
        self.projectiles = [NSMutableArray array];
        
        //手裏剣を投げるサウンド
        self.projectileSoundEffectAction = [SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO];
        
        //BGMを再生
        NSString *bgmPath = [ [NSBundle mainBundle] pathForResource:@"background-music-aac" ofType:@"caf" ];
        self.bgmPlayer = [ [AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:bgmPath] error:NULL ];
        self.bgmPlayer.numberOfLoops = -1;
        [self.bgmPlayer play];
        
        //背景色を変更（白）
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        //Player描画
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        self.player.position = CGPointMake(_player.size.width/2, size.height/2);
        [self addChild:self.player];
        
        //Action：一秒ごとでモンスターが出る
        SKAction *actionAddMonster = [SKAction runBlock:^{
            [self addMonster];
        }];
        SKAction *actionWaitNextMonster = [SKAction waitForDuration:1];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[actionAddMonster, actionWaitNextMonster]]]];

        //退出ボタン
        //三つの方法で実装してみた
        //１.AGSpriteButton  ：SKSpriteNodeを継承し、ボタンの属性とメソードを加えたクラス（ネットで調べた資料を参考した）
        //２.SKSpriteNode    ：touchesBegin関数内でタッチ判定を処理する
        //３.UIButton        ：UIKitを利用して直接Viewに追加するので、Sceneが変わっても影響がない
#ifdef AGSPRITEBUTTON_METHOD
        //method1: AGSpriteButton
        AGSpriteButton *shutDownButton = [AGSpriteButton buttonWithImageNamed:@"CloseNormal"];
        shutDownButton.normalImage = @"CloseNormal";
        shutDownButton.selectedImage = @"CloseSelected";
        shutDownButton.position = CGPointMake(shutDownButton.size.width/2, shutDownButton.size.height/2);
        NSLog(@"AGSpriteButton x is %f, y is %f, width is %f, height is %f\n", shutDownButton.position.x, shutDownButton.position.y, shutDownButton.frame.size.width, shutDownButton.frame.size.height);
        [shutDownButton addTarget:self selector:@selector(DoShutDown) withObject:[NSValue valueWithCGPoint:CGPointMake(self.size.width/2, self.size.height/2)] forControlEvent:AGButtonControlEventTouchUpInside];
        [self addChild:shutDownButton];
#endif
#ifdef SKSPRITE_METHOD
        //method2: SKSpriteNode
        SKSpriteNode* shutDownNode = [SKSpriteNode spriteNodeWithImageNamed:@"CloseNormal"];
        shutDownNode.position = CGPointMake(shutDownNode.size.width/2, shutDownNode.size.height/2);
        shutDownNode.name = @"shutDownNode";
        [self addChild:shutDownNode];
#endif
    }
    
    return self;
}

/**
 *　viewの初期化
 */
-(void)didMoveToView:(SKView *)view {
    //method3: UIButton
#ifdef UIBUTTON_METHOD
    SKSpriteNode *shutDownSprite = [SKSpriteNode spriteNodeWithImageNamed:@"CloseNormal"];
    UIButton *shutDownButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shutDownButton.frame = CGRectMake( 0, self.size.height - shutDownSprite.frame.size.height, shutDownSprite.frame.size.width, shutDownSprite.frame.size.height);
    NSLog(@"UIButton x is %f, y is %f, width is %f, height is %f\n", shutDownButton.frame.origin.x, shutDownButton.frame.origin.y, shutDownButton.frame.size.width, shutDownButton.frame.size.height);
    [shutDownButton setImage:[UIImage imageNamed:@"CloseNormal.png"] forState:UIControlStateNormal];
    [shutDownButton addTarget:self action:@selector(DoShutDown) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shutDownButton];
#endif
}

/**
 *　退出
 */
-(void) DoShutDown {
    exit(0);
}

/**
 *　モンスター追加
 */
-(void) addMonster {
    
    SKSpriteNode *monster = [SKSpriteNode spriteNodeWithImageNamed:@"monster"];
    
    CGSize winSize = self.size;
    int minY = monster.size.height / 2;
    int maxY = winSize.height - monster.size.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    monster.position = CGPointMake(winSize.width + monster
                                   .size.width/2, actualY);
    [self addChild:monster];
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    SKAction * actionMove = [SKAction moveTo:CGPointMake(-monster.size.width/2, actualY) duration:actualDuration];
    SKAction * actionMoveDone = [SKAction runBlock:^{
        [self.monsters removeObject:monster];
        [monster removeFromParent];
        
        [self changeToResultSceneWithWon:NO];
    }];
    [monster runAction:[SKAction sequence:@[actionMove, actionMoveDone]]];
    
    [self.monsters addObject:monster];
}

/**
 *　タッチ処理
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for(UITouch *touch in touches) {

#ifdef SKSPRITE_METHOD
        //method2: SKSprite
        CGPoint touchLocation = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:touchLocation];
        
        if ([node.name isEqualToString:@"shutDownNode"]) {
            [self DoShutDown];
            return;
        }
#endif
        
        CGSize winSize = self.size;
        SKSpriteNode *projectile = [SKSpriteNode spriteNodeWithImageNamed:@"projectile"];
        projectile.position = CGPointMake(projectile.size.width/2, winSize.height/2);
        
        CGPoint location = [touch locationInNode:self];
        CGPoint offset = CGPointMake(location.x - projectile.position.x, location.y - projectile.position.y);
        if(offset.x <= 0) return;
        [self addChild:projectile];
        
        int realX = winSize.width + (projectile.size.width/2);
        float ratio = (float)offset.y / (float)offset.x;
        int realY = (realX * ratio) + projectile.position.y;
        CGPoint realDest = CGPointMake(realX, realY);
        
        int offRealX = realX - projectile.position.x;
        int offRealY = realY - projectile.position.y;
        float length = sqrtf( (offRealX*offRealX)+(offRealY*offRealY) );
        float velocity = self.size.width/1;
        float realMoveDuration = length/velocity;
        
        SKAction *moveAction = [SKAction moveTo:realDest duration:realMoveDuration];
        SKAction *projectileCastAction = [SKAction group:@[moveAction, self.projectileSoundEffectAction]];
        
        [projectile runAction:projectileCastAction completion:^{
            [self.projectiles removeObject:projectile];
            [projectile removeFromParent];
            
        }];
        
        [self.projectiles addObject:projectile];
    }
}

/**
 *　アップデート（毎フレーム）
 */
-(void) update:(NSTimeInterval)currentTime {
    
    //コリジョン処理
    NSMutableArray *projectilesToDelete = [ [NSMutableArray alloc] init ];
    for(SKSpriteNode *projectile in self.projectiles) {
        
        NSMutableArray *monstersToDelete = [ [NSMutableArray alloc] init ];
        for(SKSpriteNode *monster in self.monsters) {
            
            if(CGRectIntersectsRect(projectile.frame, monster.frame)) {
                [monstersToDelete addObject:monster];
            }
        }
        
        for (SKSpriteNode *monster in monstersToDelete) {
            [self.monsters removeObject:monster];
            [monster removeFromParent];
        }
        
        if (monstersToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
        }
    }
    
    for (SKSpriteNode *projectile in projectilesToDelete) {
        [self.projectiles removeObject:projectile];
        [projectile removeFromParent];
        
        self.monstersDestroyed++;
        NSLog(@"monstersDestroyed is %i", self.monstersDestroyed);
        if (self.monstersDestroyed >= 30) {
            [self changeToResultSceneWithWon:YES];
        }
    }
}

/**
 *　リザルトシーンへ変更
 */
-(void) changeToResultSceneWithWon:(BOOL)won {
    
    [self.bgmPlayer stop];
    self.bgmPlayer = nil;
    ResultScene *rs = [ [ResultScene alloc] initWithSize:self.size won:won];
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1.0];
    [self.scene.view presentScene:rs transition:reveal];
}

@end
