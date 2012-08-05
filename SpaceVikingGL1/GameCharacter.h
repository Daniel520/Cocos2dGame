//
//  GameCharacter.h
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-5.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject {
    int characterHealth;
    CharacterStates characterState;
}

- (void) checkAndClampSpritePosition;
- (int) getWeaponDamage;

@property (readwrite) int characterHealth;
@property (readwrite) CharacterStates characterSate;


@end
