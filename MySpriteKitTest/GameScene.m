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

// template
#if false

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#else

#if false
//sample game
- (id)initWithSize:(CGSize)size {
    
    if(self = [super initWithSize:size]) {
        
        self.monsters = [NSMutableArray array];
        self.projectiles = [NSMutableArray array];
        
        self.projectileSoundEffectAction = [SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO];
        
        NSString *bgmPath = [ [NSBundle mainBundle] pathForResource:@"background-music-aac" ofType:@"caf" ];
        self.bgmPlayer = [ [AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:bgmPath] error:NULL ];
        self.bgmPlayer.numberOfLoops = -1;
        [self.bgmPlayer play];
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
        self.player.position = CGPointMake(_player.size.width/2, size.height/2);
        [self addChild:self.player];
        
        SKAction *actionAddMonster = [SKAction runBlock:^{
            [self addMonster];
        }];
        SKAction *actionWaitNextMonster = [SKAction waitForDuration:1];
        [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[actionAddMonster, actionWaitNextMonster]]]];

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

#else
-(void)didMoveToView:(SKView *)view {
    
    self.monsters = [NSMutableArray array];
    self.projectiles = [NSMutableArray array];
    
    self.projectileSoundEffectAction = [SKAction playSoundFileNamed:@"pew-pew-lei.caf" waitForCompletion:NO];
    
    NSString *bgmPath = [ [NSBundle mainBundle] pathForResource:@"background-music-aac" ofType:@"caf" ];
    self.bgmPlayer = [ [AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:bgmPath] error:NULL ];
    self.bgmPlayer.numberOfLoops = -1;
    [self.bgmPlayer play];
    
    self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    self.player = [SKSpriteNode spriteNodeWithImageNamed:@"player"];
    self.player.position = CGPointMake(_player.size.width/2, self.size.height/2);
    [self addChild:self.player];
    
    SKAction *actionAddMonster = [SKAction runBlock:^{
        [self addMonster];
    }];
    SKAction *actionWaitNextMonster = [SKAction waitForDuration:1];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[actionAddMonster, actionWaitNextMonster]]]];
    
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
    
    //method3: UIButton
#ifdef UIBUTTON_METHOD
    SKSpriteNode *shutDownSprite = [SKSpriteNode spriteNodeWithImageNamed:@"CloseNormal"];
    UIButton *shutDownButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shutDownButton.frame = CGRectMake(shutDownSprite.frame.size.width/2, shutDownSprite.frame.size.height/2, shutDownSprite.frame.size.width, shutDownSprite.frame.size.height);
    NSLog(@"UIButton x is %f, y is %f, width is %f, height is %f\n", shutDownButton.frame.origin.x, shutDownButton.frame.origin.y, shutDownButton.frame.size.width, shutDownButton.frame.size.height);
    [shutDownButton setImage:[UIImage imageNamed:@"CloseNormal.png"] forState:UIControlStateNormal];
    [self.view addSubview:shutDownButton];
#endif
}
#endif
 
-(void) DoShutDown {
    exit(0);
}

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

-(void) update:(NSTimeInterval)currentTime {
    
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

-(void) changeToResultSceneWithWon:(BOOL)won {
    
    [self.bgmPlayer stop];
    self.bgmPlayer = nil;
    ResultScene *rs = [ [ResultScene alloc] initWithSize:self.size won:won];
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:1.0];
    [self.scene.view presentScene:rs transition:reveal];
}

#endif


@end
