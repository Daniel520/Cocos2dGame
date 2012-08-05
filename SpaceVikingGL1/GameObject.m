//
//  GameObject.m
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-5.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject

@synthesize reactsToScreenBoundaries;
@synthesize screenSize;
@synthesize isActive;
@synthesize gameObjectType;

- (id)init
{
    if (self = [super init]) {
        CCLOG(@"GameObject init");
        screenSize = [CCDirector sharedDirector].winSize;
        isActive = TRUE;
        gameObjectType = kObjectTpeNone;
        
    }
    return  self;
}

// This method is used by the objects to trainsition from one state to another.The state change often triggers custom animations that represent each state.
- (void)changeState:(CharacterStates)newState
{
    CCLOG(@"GameObject->changeState method should be overridden");
}

// call by the GameplayerLayer to update game objeects on every frame
- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
{
    CCLOG(@"updateStateWithDeltaTime method should be overriden");
}

// This method adjusts the default sprite's bounding box to compensate for the transparent space. Becuause if not do this, the transparent space of the sprite will make the collision detection be inaccurate.
- (CGRect)adjustedBoundBox
{
    CCLOG(@"GameObject adjustedBoundingBox should be overridden");
    return [self boundingBox];
}

// Setting up the animations based on the data stored in the plist files.
- (CCAnimation*)loadPlistForAnimationWithName:(NSString *)animationName andClassName:(NSString *)className
{
    CCAnimation *animationToReturn = nil;
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    
    // 1 : Get the Path to the plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:className ofType:@"plist"];
    }
    
    // 2: Read in the plist file
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 3: If the plistDictionary was null, the file was not file
    if (plistDictionary == nil) {
        CCLOG(@"Errr reading plist: %@.plist",className);
        return nil;
    }
    
    // 4: Get just the mini-dictionaray for this animation
    NSDictionary *animationSettings = [plistDictionary objectForKey:animationName];
    if (animationSettings == nil) {
        CCLOG(@"Counld not locate AnimationWithName:%@",animationName);
        return nil;
    }
    
    // 5: Get the delay value for the animation
    float animationDelay = [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelay:animationDelay];
    
    // 6: Add the frames to the animation
    NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFramesNumbers = [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFramesNumbers) {
        NSString *frameName = [NSString stringWithFormat:@"%@%@.png", animationFramePrefix, frameNumber];
        [animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    
    return animationToReturn;
}

@end
