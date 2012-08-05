//
//  GameCharacter.m
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-5.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#import "GameCharacter.h"

@implementation GameCharacter

@synthesize characterHealth;
@synthesize characterSate;

- (void) dealloc
{
    [super dealloc];
}

- (int)getWeaponDamage
{
    //Default to zero damage
    CCLOG(@"getWeaponDamage should be oerridden");
    return 0;
}

- (void)checkAndClampSpritePosition
{
    CGPoint currentSpritePosition = [self position];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Clamp for the ipad
        if (currentSpritePosition.x < 30.0f) {
            [self setPosition:ccp(30.0f, currentSpritePosition.y)];
        } else if (currentSpritePosition.x > 1000.0f) {
            [self setPosition:ccp(1000.0f, currentSpritePosition.y )];
        }
    } else {
        //Clamp for iPhone, iPhone4, or iPod touch
        if (currentSpritePosition.x < 24.0f) {
            [self setPosition:ccp(24.0f, currentSpritePosition.y)];
        } else if (currentSpritePosition.x > 456.0f){
            [self setPosition:ccp(456.0f, currentSpritePosition.y)];
        }
    }
    
    
}

@end
