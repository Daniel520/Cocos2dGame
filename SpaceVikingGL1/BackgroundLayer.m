//
//  BackgroundLayer.m
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-1.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer

- (id)init
{
    if (self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            background = [CCSprite spriteWithFile:@"background.png"];
            
        } else { 
            background = [CCSprite spriteWithFile:@"backgroundiPhone.png"];
            
        }
        
        background.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:background z:5 tag:0];
    }
    
    return self;
}

@end
