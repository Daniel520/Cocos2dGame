//
//  GameplayLayer.m
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-1.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#import "GameplayLayer.h"

@implementation GameplayLayer

#define kVikingSprite 10

-(void) dealloc
{
    [leftJoystick release];
    [jumpButton release];
    [attackButton release];
    [super dealloc];
}

- (void)initJoystickAndButtons
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGRect joystickBaseDimensions = CGRectMake(0, 0, 128.0f, 128.0f);
    CGRect jumpButtonBaseDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGRect attackButtonBaseDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGPoint joystickBasePosition;
    CGPoint jumpButtonBasePosition;
    CGPoint attackButtonBasePosition;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        joystickBasePosition = ccp(screenSize.width * 0.0625f, 
                                   screenSize.height * 0.052f);
        
        jumpButtonBasePosition = ccp(screenSize.width * 0.946f, 
                                     screenSize.height * 0.052f);
        
        attackButtonBasePosition = ccp(screenSize.width * 0.946f, 
                                       screenSize.height * 0.169f);
    
    }else{
        joystickBasePosition = ccp(screenSize.width * 0.07f, 
                                   screenSize.height * 0.11f);
        
        jumpButtonBasePosition = ccp(screenSize.width * 0.93f, 
                                     screenSize.height * 0.11f);
        
        attackButtonBasePosition = ccp(screenSize.width * 0.93f, 
                                       screenSize.height * 0.35f);
    }
    
    SneakyJoystickSkinnedBase *joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    joystickBase.position = joystickBasePosition;
    joystickBase.backgroundSprite = [CCSprite spriteWithFile:@"dpadDown.png"];
    joystickBase.thumbSprite = [CCSprite spriteWithFile:@"joystickDown.png"];
    joystickBase.joystick = [[SneakyJoystick alloc] initWithRect:joystickBaseDimensions];
    leftJoystick = [joystickBase.joystick retain];
    [self addChild:joystickBase];
    
    SneakyButtonSkinnedBase *jumpButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    jumpButtonBase.position = jumpButtonBasePosition;
    jumpButtonBase.defaultSprite = [CCSprite spriteWithFile:@"jumpUp.png"];
    jumpButtonBase.activatedSprite = [CCSprite spriteWithFile:@"jumpDown.png"];
    jumpButtonBase.pressSprite = [CCSprite spriteWithFile:@"jumpDown.png"];
    jumpButtonBase.button = [[SneakyButton alloc] initWithRect:jumpButtonBaseDimensions];
    jumpButton = [jumpButtonBase.button retain];
    jumpButton.isToggleable = NO;
    [self addChild:jumpButtonBase];
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    attackButtonBase.position = attackButtonBasePosition;
    attackButtonBase.defaultSprite = [CCSprite spriteWithFile:@"handUp.png"];
    attackButtonBase.activatedSprite = [CCSprite spriteWithFile:@"handDown.png"];
    attackButtonBase.pressSprite = [CCSprite spriteWithFile:@"handDown.png"];
    attackButtonBase.button = [[SneakyButton alloc] initWithRect:attackButtonBaseDimensions];
    attackButton = [attackButtonBase.button retain];
    attackButton.isToggleable = NO;
    [self addChild:attackButtonBase];
    
}

//- (void)applyJoystick:(SneakyJoystick *)aJoystick toNode:(CCNode *)tempNode forTimeDelta:(float)deltaTime
//{
//    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 1024.0f);
//    
//    
//    CGPoint newPosition = ccp(tempNode.position.x + scaledVelocity.x * deltaTime, tempNode.position.y + scaledVelocity.y * deltaTime);
//    
//    tempNode.position = newPosition;
//    
//    if (jumpButton.active == YES) {
//        CCLOG(@"JumpButton is pressed");
//    }
//    
//    if(attackButton.active == YES) {
//        CCLOG(@"AttackButton is pressed");
//    }
//}

#pragma mark -
#pragma mark Update Method
- (void)update:(ccTime)deltaTime
{
//    [self applyJoystick:leftJoystick toNode:vikingSprite forTimeDelta:deltaTime];
    CCArray *listOfGameObjects = [sceneSpriteBatchNode children];
    for (GameCharacter *tempChar in listOfGameObjects) {
        [tempChar updateStateWithDeltaTime:deltaTime andListOfGameObjects:listOfGameObjects];
    }
}

#pragma mark - createObjectType
-(void)createObjectOfType:(GameObjectType)objectType withHealth:(int)initialHealth atLocation:(CGPoint)spawnLocation withZValue:(int)ZValue
{
    if (objectType == kEnemyTypeRadarDish) {
        CCLOG(@"Creating the Radar Enemy");
        RadarDish *radarDish = [[RadarDish alloc] initWithSpriteFrameName:@"radar_1.png"];
        [radarDish setCharacterHealth:100];
        [radarDish setPosition:spawnLocation];
        [sceneSpriteBatchNode addChild:radarDish z:ZValue tag:kRadarDishTagValue];
        [radarDish release];
    }
}


-(void)createPhaserWithDirection:(PhaseDirection)phaserDirection andPosition:(CGPoint)spawnPosition
{
    CCLOG(@"Placeholder for Chapter 5, see below");
    return;
}

- (id)init
{
    if (self = [super init]) {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        self.isTouchEnabled = YES;
        
        srandom(time(NULL));
        
        //vikingSprite = [CCSprite spriteWithFile:@"sv_anim_1.png"];
        
        //Create a Sprite Batch Node to load the SpriteFrames PNG file
        //CCSpriteBatchNode *chapter2SpriteBatchNode;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene1atlas.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlas.png"];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scene1atlasiPhone.plist"];
            sceneSpriteBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"scene1atlasiPhone.png"];
        }
        [self addChild:sceneSpriteBatchNode z:0];
        [self initJoystickAndButtons];
        Viking *viking = [[Viking alloc] initWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_anim_1.png"]];
        [viking setJoystick:leftJoystick];
        [viking setJumpButton:jumpButton];
        [viking setAttackButton:attackButton];
        [viking setPosition:ccp(screenSize.width * 0.35f, 
                                screenSize.height * 0.14f)];
        [viking setCharacterHealth:100];
        
        [sceneSpriteBatchNode addChild:viking z:kVikingSpriteZValue tag:kVikingSpriteTagValue];
        
        [self createObjectOfType:kEnemyTypeRadarDish withHealth:100 atLocation:ccp(screenSize.width * 0.878f, screenSize.height * 0.13f) withZValue:10];
        
        [self scheduleUpdate];
        
// Delete previous Chapter Example Code        
//        //Use the SpriteFrameName to create a CCSprite instance
//        vikingSprite = [CCSprite spriteWithSpriteFrameName:@"sv_anim_1.png"];
//        
//        //add the CCSprite vikingSprite to SpriteBatchNode instance.
//        [chapter2SpriteBatchNode addChild:vikingSprite];
//        
//        [self addChild:chapter2SpriteBatchNode];
//        
//        vikingSprite.position = ccp(screenSize.width/2, screenSize.height * 0.17f);
//        
//        //[self addChild:vikingSprite z:0 tag:kVikingSprite];
//
//// Use the CCSpriteBatchNode and had handle to use which size Ole png for the vikingSprite.
////        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad){
////            [vikingSprite setScaleX:screenSize.width/1024.0f];
////            [vikingSprite setScaleY:screenSize.height/768.0f];
////            
////        }
//        
//        // Start Animation Example Code
//        CCSprite *animatingRobot = [CCSprite spriteWithFile:@"an1_anim1.png"];
//        [animatingRobot setPosition:ccp(vikingSprite.position.x + 50.0f, vikingSprite.position.y)];
//        [self addChild:animatingRobot];
//        CCAnimation *robotAnim = [CCAnimation animation];
//        [robotAnim addFrameWithFilename:@"an1_anim2.png"];
//        [robotAnim addFrameWithFilename:@"an1_anim3.png"];
//        [robotAnim addFrameWithFilename:@"an1_anim4.png"];
//        
//        id robotAnimationAction = [CCAnimate actionWithDuration:0.5f animation:robotAnim restoreOriginalFrame:YES];
//        
//        id repeatRobotAnimation = [CCRepeatForever actionWithAction:robotAnimationAction];
//        
//        [animatingRobot runAction:repeatRobotAnimation];
//        
//        CCAnimation *exampleAnim = [CCAnimation animation];
//        [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_anim_2.png"]];
//        [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_anim_3.png"]];
//        [exampleAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_anim_4.png"]];
//        
//        id animationAction = [CCAnimate actionWithDuration:0.5f animation:exampleAnim restoreOriginalFrame:NO];
//        id repeatAction = [CCRepeatForever actionWithAction:animationAction];
//        
//        [vikingSprite runAction:repeatAction];
//        // End Animation Example Code
//        
//        [self initJoystickAndButtons];
//        [self scheduleUpdate];
// End Delete
    }
    
    return self;
}

@end
