//
//  Viking.h
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-8.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"
#import "SneakyButton.h"
#import "SneakyJoystick.h"


typedef enum {
    kLeftHook,
    kRightHook
} LastPunchType;

@interface Viking : GameCharacter {
    LastPunchType myLastPunch;
    BOOL isCarryingMallet;
    CCSpriteFrame *standingFrame;
    
    // Standing, breathing, and walking
    CCAnimation *breathingAnim;
    CCAnimation *breathingMalletAnim;
    CCAnimation *walkingAnim;
    CCAnimation *walkingMalletAnim;
    // Crouching, standing up, and Jumping
    CCAnimation *crouchingAnim;
    CCAnimation *crouchingMalletAnim;
    CCAnimation *standingUpAnim;
    CCAnimation *standingUpMalletAnim;
    CCAnimation *jumpingAnim;
    CCAnimation *jumpingMalletAnim;
    CCAnimation *afterJumpingAnim;
    CCAnimation *afterJumpingMalletAnim;
    
    //Punching
    CCAnimation *rightPunchAnim;
    CCAnimation *leftPunchAnim;
    CCAnimation *malletPunchAnim;
    
    //Taking Damage and Death
    CCAnimation *phaseShockAnim;
    CCAnimation *deathAnim;
    
    SneakyJoystick *joystick;
    SneakyButton *jumpButton;
    SneakyButton *attackButton;
    
    float millisecondsStayingIdle;
}

// Standing,Breathing, Walking
@property (nonatomic,retain) CCAnimation *breathingAnim;
@property (nonatomic,retain) CCAnimation *breathingMalletAnim;
@property (nonatomic,retain) CCAnimation *walkingAnim;
@property (nonatomic,retain) CCAnimation *walkingMalletAnim;

// Counching, Standing up, and Jumping
@property (nonatomic,retain) CCAnimation *crouchingAnim;
@property (nonatomic,retain) CCAnimation *crouchMalletAnim;
@property (nonatomic,retain) CCAnimation *standingUpAnim;
@property (nonatomic,retain) CCAnimation *standingUpMalletAnim;
@property (nonatomic,retain) CCAnimation *jumpingAnim;
@property (nonatomic,retain) CCAnimation *jumpingMalletAnim;
@property (nonatomic,retain) CCAnimation *afterJumpingAnim;
@property (nonatomic,retain) CCAnimation *afterJumpingMalletAnim;

// Punching
@property (nonatomic,retain) CCAnimation *rightPunchAnim;
@property (nonatomic,retain) CCAnimation *leftPunchAnim;
@property (nonatomic,retain) CCAnimation *malletPunchAnim;

// Taking Damage and Death
@property (nonatomic,retain) CCAnimation *phaseShockAnim;
@property (nonatomic,retain) CCAnimation *deathAnim;

@property (nonatomic,assign) SneakyJoystick *joystick;
@property (nonatomic,assign) SneakyButton *jumpButton;
@property (nonatomic,assign) SneakyButton *attackButton;

@end
