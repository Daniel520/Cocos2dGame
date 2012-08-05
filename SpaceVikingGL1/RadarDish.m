//
//  RadarDish.m
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-5.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#import "RadarDish.h"

@implementation RadarDish

@synthesize titltingAnim;
@synthesize transmittingAnim;
@synthesize takingAHitAnim;
@synthesize blowingUpAnim;

- (void)dealloc
{
    [titltingAnim release];
    [transmittingAnim release];
    [takingAHitAnim release];
    [blowingUpAnim release];
    [super dealloc];
}


- (void)changeState:(CharacterStates)newState
{
    [self stopAllActions];
    id action = nil;
    [self setCharacterSate:newState];
    
    switch (newState) {
        case kStateSpawning:
            CCLOG(@"RadarDish->Starting the Spawning Animation");
            action = [CCAnimate actionWithAnimation:titltingAnim restoreOriginalFrame:NO];
            break;
        
        case kStateIdle:
            CCLOG(@"RadarDish->Changing State to Idle");
            action = [CCAnimate actionWithAnimation:transmittingAnim restoreOriginalFrame:NO];
            break;
        
        case kStateTakingDamage:
            CCLOG(@"RadarDish->Changing State to TakingDamage");
            characterHealth = characterHealth - [vikingCharacter getWeaponDamage];
            if (characterHealth <= 0.0f) {
                [self changeState:kStateDead];
            } else {
                action = [CCAnimate actionWithAnimation:takingAHitAnim restoreOriginalFrame:NO];
            }
            break;
        
        case kStateDead:
            CCLOG(@"RadarDish->Changing State to Dead");
            action = [CCAnimate actionWithAnimation:blowingUpAnim restoreOriginalFrame:NO];
            break;
            
        default:
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    if (characterState == kStateDead) {
        return;
    }
    
    // get the vikingCharacter from his parent(here is SpriteBatchNode)
    vikingCharacter = (GameCharacter *) [[self parent] getChildByTag:kVikingSpriteTagValue];
    
    CGRect vikingBoundingBox = [vikingCharacter adjustedBoundBox];
    
    CharacterStates vikingState = [vikingCharacter characterSate];
    
    //Calculate if the Viking is attacking and nearby
    if ((vikingState == kStateAttacking) && (CGRectIntersectsRect([self adjustedBoundBox], vikingBoundingBox))) {
        if (characterState != kStateTakingDamage) {
            // If RadarDish is NOT already taking Damage
            [self changeState:kStateTakingDamage];
            return;
        }
    }
    
    if (([self numberOfRunningActions] == 0) && (characterState != kStateDead)) {
        CCLOG(@"Going to Idle");
        [self changeState:kStateIdle];
        return;
    }
}

@end
