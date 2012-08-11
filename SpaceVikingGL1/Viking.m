//
//  Viking.m
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-8.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#import "Viking.h"

@implementation Viking

@synthesize joystick;
@synthesize jumpButton;
@synthesize attackButton;

// Standing, Breathing, Walking
@synthesize breathingAnim;
@synthesize breathingMalletAnim;
@synthesize walkingAnim;
@synthesize walkingMalletAnim;

// Crounching, Standing up, Jumping
@synthesize crouchingAnim;
@synthesize crouchMalletAnim;
@synthesize standingUpAnim;
@synthesize standingUpMalletAnim;
@synthesize jumpingAnim;
@synthesize jumpingMalletAnim;
@synthesize afterJumpingAnim;
@synthesize afterJumpingMalletAnim;

//Punching
@synthesize rightPunchAnim;
@synthesize leftPunchAnim;
@synthesize malletPunchAnim;

// Taking Damage and Death
@synthesize phaseShockAnim;
@synthesize deathAnim;


- (void) dealloc
{
    joystick = nil;
    jumpButton = nil;
    attackButton = nil;
    
    [breathingAnim release];
    [breathingMalletAnim release];
    [walkingAnim release];
    [walkingMalletAnim release];
    [crouchingAnim release];
    [crouchingMalletAnim release];
    [standingUpAnim release];
    [standingUpMalletAnim release];
    [jumpingAnim release];
    [jumpingMalletAnim release];
    [afterJumpingAnim release];
    [afterJumpingMalletAnim release];
    [rightPunchAnim release];
    [leftPunchAnim release];
    [malletPunchAnim release];
    [phaseShockAnim release];
    [deathAnim release];
    
    [super dealloc];
}

- (BOOL)isCarryingMallet
{
    return isCarryingMallet;
}

- (int) getWeaponDamage
{
    if (isCarryingMallet) {
        return kVikingMalletDamage;
    }
    
    return kVikingFistDamage;
}

- (void)applyJoystick:(SneakyJoystick *)aJoystick forTimeDelta:(float)deltaTime
{
    CGPoint scaleVelocity = ccpMult(aJoystick.velocity, 128.0f);
    CGPoint oldPosition = self.position;
    CGPoint newPosition = ccp(oldPosition.x + scaleVelocity.x * deltaTime, oldPosition.y);
    self.position = newPosition;
    //CCLOG(@"%f,%f",newPosition.x,newPosition.y);
    if (newPosition.x < oldPosition.x) {
        self.flipX = YES;
    } else {
        self.flipX = NO;
    }
}

- (void)checkAndClampSpritePosition
{
    if (self.characterState != kStateJumping) {
        if (self.position.y > 110.0f) {
            self.position = ccp(self.position.x, 110.0f);
        }
    }
    
    [super checkAndClampSpritePosition];
}

#pragma mark - changeState
-(void)changeState:(CharacterStates)newState
{
    [self stopAllActions];
    id action = nil;
    id movementAction = nil;
    CGPoint newPosition;
    [self setCharacterState:newState];
    
    switch (newState) {
        case kStateIdle:
            if (isCarryingMallet) {
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_mallet_1.png"]];
            } else {
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_anim_1.png"]];
            }
            break;
        
        case kStateWalking:
            if (isCarryingMallet) {
                action = [CCAnimate actionWithAnimation:walkingMalletAnim restoreOriginalFrame:NO];
            } else {
                action = [CCAnimate actionWithAnimation:walkingAnim restoreOriginalFrame:NO];
            }
            break;
        
        case kStateCrounching:
            if (isCarryingMallet) {
                action = [CCAnimate actionWithAnimation:crouchingMalletAnim restoreOriginalFrame:NO];
            } else {
                action = [CCAnimate actionWithAnimation:crouchingAnim restoreOriginalFrame:NO];
            }
            break;
            
        case kStateStandingUp:
            if (isCarryingMallet) {
                action = [CCAnimate actionWithAnimation:standingUpMalletAnim restoreOriginalFrame:NO];
            } else {
                action = [CCAnimate actionWithAnimation:standingUpAnim restoreOriginalFrame:NO];
            }
            break;
            
        case kStateBreathing:
            if (isCarryingMallet) {
                action = [CCAnimate actionWithAnimation:breathingMalletAnim restoreOriginalFrame:YES];
            } else {
                action = [CCAnimate actionWithAnimation:breathingAnim restoreOriginalFrame:YES];
            }
            break;
        
        case kStateJumping:
            newPosition = ccp(screenSize.width * 0.2f, 0.0f);
            if (self.flipX) {
                newPosition = ccp(newPosition.x * -1.0f, 0.0f);
            }
            
            movementAction = [CCJumpBy actionWithDuration:0.5f position:newPosition height:160.0f jumps:1];
            
            if (isCarryingMallet) {
                action = [CCSequence actions:
                          [CCSpawn actions:
                           [CCAnimate actionWithAnimation:jumpingMalletAnim restoreOriginalFrame:YES],movementAction, nil],
                          [CCAnimate actionWithAnimation:afterJumpingMalletAnim restoreOriginalFrame:NO], nil];
            } else {
                action = [CCSequence actions:[CCSpawn actions:[CCAnimate actionWithAnimation:jumpingAnim restoreOriginalFrame:YES],movementAction, nil],[CCAnimate actionWithAnimation:afterJumpingAnim restoreOriginalFrame:NO] ,nil];
            }
            
            break;
            
        case kStateAttacking:
            if (isCarryingMallet) {
                action = [CCAnimate actionWithAnimation:malletPunchAnim restoreOriginalFrame:YES];
            } else {
                if (kLeftHook == myLastPunch) {
                    // Excute a right hook
                    myLastPunch = kRightHook;
                    action = [CCAnimate actionWithAnimation:rightPunchAnim restoreOriginalFrame:NO];
                } else {
                    // Excute a left hook
                    myLastPunch = kLeftHook;
                    action = [CCAnimate actionWithAnimation:leftPunchAnim restoreOriginalFrame:NO];
                }
            }
            
            break;
        
        case kStateTakingDamage:
            self.characterHealth = self.characterHealth - 10.0f;
            action = [CCAnimate actionWithAnimation:phaseShockAnim restoreOriginalFrame:YES];
            break;
        
        case kStateDead:
            action = [CCAnimate actionWithAnimation:deathAnim restoreOriginalFrame:NO];
            break;
        default:
            break;
    }
    
    if (action) {
        [self runAction:action];
    }
}

#pragma mark - updateStateWithDeltaTime
-(void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    if (self.characterState == kStateDead)
        return; // Nothing to do if the Viking is dead
    
    if ((self.characterState == kStateTakingDamage) && (self.numberOfRunningActions > 0))
        return; // Currently playing the taking damage animation
    
    // Check for collisions
    // Change this to keep the object count from querying it each time
    CGRect myBoundingBox = [self adjustedBoundBox];
    for (GameCharacter *character in listOfGameObjects) {
        // This is Ole Viking himself
        // No need to check collision with one's self
        if ([character tag] == kVikingSpriteTagValue) {
            continue;
        }
        
        CGRect characterBox = [character adjustedBoundBox];
        if (CGRectIntersectsRect(myBoundingBox, characterBox)) {
            if (character.gameObjectType == kEnemyTypePhaser) {
                [self changeState:kStateTakingDamage];
                [character changeState:kStateDead];
            } else if(character.gameObjectType == kPowerUpTypeMallet) {
                // Update the frame to indicate Viking is carrying the mallet
                isCarryingMallet = YES;
                [self changeState:kStateIdle];
                // Remove the Mallet from the scene
                [character changeState:kStateDead];
            } else if(character.gameObjectType == kPowerUpTypeHealth) {
                [self setCharacterHealth:100.0f];
                // Remove the health power-up from the scene
                [character changeState:kStateDead];
            }
        }
    }
    
    [self checkAndClampSpritePosition];
    if ((self.characterState == kStateIdle) || 
        (self.characterState == kStateWalking) ||
        (self.characterState == kStateCrounching) ||
        (self.characterState == kStateStandingUp) ||
        (self.characterState == kStateBreathing)) {
        
        if (jumpButton.active) {
            [self changeState:kStateJumping];
        } else if (attackButton.active) {
            [self changeState:kStateAttacking];
        } else if ((joystick.velocity.x == 0.0f) && (joystick.velocity.y == 0.0f)) {
            if (self.characterState == kStateCrounching) {
                [self changeState:kStateStandingUp];
            }
        } else if (joystick.velocity.y < -0.45f) {
            if (self.characterState != kStateCrounching) {
                [self changeState:kStateCrounching];
            }
        } else if (joystick.velocity.x != 0.0f) {
            // dpad moving
            if (self.characterState != kStateWalking) {
                [self changeState:kStateWalking];
            }
            
            [self applyJoystick:joystick forTimeDelta:deltaTime];
        }
    }
    
    if (self.numberOfRunningActions == 0) {
        // Not playing an animation
        if (self.characterHealth <= 0.0f) {
            [self changeState:kStateDead];
        } else if (self.characterState == kStateIdle) {
            millisecondsStayingIdle = millisecondsStayingIdle + deltaTime;
            if (millisecondsStayingIdle > kVikingIdleTimer) {
                [self changeState:kStateBreathing];
            }
        } else if ((self.characterState != kStateCrounching) && (self.characterState != kStateIdle)) {
            millisecondsStayingIdle = 0.0f;
            [self changeState:kStateIdle];
        }
    }
    
}

#pragma  mark - adjustedBoundBox Need a Debug for this method, don't understand the formula
-(CGRect) adjustedBoundBox
{
    // Adjust the bounding box to the size of the sprite
    // without the transparent space
    CGRect vikingBoundingBox = [self boundingBox];
    float xOffset;
    float xCropAmount = vikingBoundingBox.size.width * 0.5482f;
    float yCropAmount = vikingBoundingBox.size.height * 0.095f;
    
    if ([self flipX] == NO) {
        // Viking is facing to the right, back is on the left
        xOffset = vikingBoundingBox.size.width * 0.1566f;
    } else {
        // Viking is facing to the left; back is facing right
        xOffset = vikingBoundingBox.size.width * 0.4217f;
    }
    
    vikingBoundingBox = CGRectMake(vikingBoundingBox.origin.x + xOffset, 
                                   vikingBoundingBox.origin.y, 
                                   vikingBoundingBox.size.width - xCropAmount, 
                                   vikingBoundingBox.size.height - yCropAmount);
    
    if (characterState == kStateCrounching) {
        // Shrink the bounding box to 56% of height
        // 88 pixels on top on iPad
        vikingBoundingBox = CGRectMake(vikingBoundingBox.origin.x, 
                                       vikingBoundingBox.origin.y, 
                                       vikingBoundingBox.size.width, 
                                       vikingBoundingBox.size.height * 0.56f);
    }
    
    return vikingBoundingBox;
    
}

#pragma mark - initAnimations
-(void) initAnimations
{
    [self setBreathingAnim:[self loadPlistForAnimationWithName:@"breathingAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setBreathingMalletAnim:[self loadPlistForAnimationWithName:@"breathingMalletAnim" andClassName:NSStringFromClass([self class])]];
                                  
    [self setWalkingAnim:[self loadPlistForAnimationWithName:@"walkingAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setWalkingMalletAnim:[self loadPlistForAnimationWithName:@"walkingMalletAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setCrouchingAnim:[self loadPlistForAnimationWithName:@"crouchingAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setCrouchMalletAnim:[self loadPlistForAnimationWithName:@"crouchingMalletAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setStandingUpAnim:[self loadPlistForAnimationWithName:@"standingUpAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setStandingUpMalletAnim:[self loadPlistForAnimationWithName:@"standingUpMalletAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setJumpingAnim:[self loadPlistForAnimationWithName:@"jumpingAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setJumpingMalletAnim:[self loadPlistForAnimationWithName:@"jumpingMalletAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setAfterJumpingAnim:[self loadPlistForAnimationWithName:@"afterJumpingAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setAfterJumpingMalletAnim:[self loadPlistForAnimationWithName:@"afterJumpingMalletAnim" andClassName:NSStringFromClass([self class])]];
    
    // Punches
    [self setRightPunchAnim:[self loadPlistForAnimationWithName:@"rightPunchAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setLeftPunchAnim:[self loadPlistForAnimationWithName:@"leftPunchAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setMalletPunchAnim:[self loadPlistForAnimationWithName:@"malletPunchAnim" andClassName:NSStringFromClass([self class])]];
    
    // Taking Damage and Death
    [self setPhaseShockAnim:[self loadPlistForAnimationWithName:@"phaserShockAnim" andClassName:NSStringFromClass([self class])]];
    
    [self setDeathAnim:[self loadPlistForAnimationWithName:@"vikingDeathAnim" andClassName:NSStringFromClass([self class])]];
}

#pragma  mark - init
-(id) init
{
    if (self = [super init]) {
        joystick = nil;
        jumpButton = nil;
        attackButton = nil;
        self.gameObjectType = kVikingType;
        millisecondsStayingIdle = 0.0f;
        isCarryingMallet = NO;
        [self initAnimations];
    }
    
    return self;
}

@end
