//
//  ResultScene.m
//  MySpriteKitTest
//
//  Created by m-wang on 2014/07/11.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "ResultScene.h"
#import "GameScene.h"

@implementation ResultScene

- (instancetype)initWithSize:(CGSize)size won:(BOOL)won {

    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        SKLabelNode *resultLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        resultLabel.text = won ? @"You win!" : @"You lose";
        resultLabel.fontSize = 30;
        resultLabel.fontColor = [SKColor blackColor];
        resultLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:resultLabel];
        
        SKLabelNode *retryLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryLabel.text = @"Try again";
        retryLabel.fontSize = 20;
        retryLabel.fontColor = [SKColor blueColor];
        retryLabel.position = CGPointMake(resultLabel.position.x, resultLabel.position.y * 0.8);
        retryLabel.name = @"retryLabel";
        [self addChild:retryLabel];
    }
    
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:touchLocation];
        
        if ([node.name isEqualToString:@"retryLabel"]) {
            [self changeToGameScene];
        }
    }
}

-(void) changeToGameScene {
    GameScene *gs = [GameScene sceneWithSize:self.size];
    SKTransition *reveal = [SKTransition revealWithDirection:SKTransitionDirectionDown duration:1.0];
    [self.scene.view presentScene:gs transition:reveal];
}

@end
