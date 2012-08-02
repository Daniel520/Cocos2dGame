//
//  GameplayScene.m
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-1.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#import "GameplayScene.h"

@implementation GameplayScene

- (id)init
{
    if (self = [super init]) {
        
        //Background Layer
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        
        //Gameplay Layer
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        
        [self addChild:backgroundLayer z:0];
        [self addChild:gameplayLayer z:5];
    }
    
    return self;
}

@end
