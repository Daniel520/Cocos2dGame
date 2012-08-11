//
//  CommonProtocols.h
//  SpaceVikingGL1
//
//  Created by Daniel yu on 12-8-5.
//  Copyright (c) 2012年 广工. All rights reserved.
//

#ifndef SpaceVikingGL1_CommonProtocols_h
#define SpaceVikingGL1_CommonProtocols_h

typedef enum {
    kDirectionLeft,
    kDirectionRight
} PhaseDirection;

typedef enum {
    kStateSpawning,
    kStateIdle,
    kStateCrounching,
    kStateStandingUp,
    kStateWalking,
    kStateAttacking,
    kStateJumping,
    kStateBreathing,
    kStateTakingDamage,
    kStateDead,
    kStateTraveling,
    kStateRotating,
    kStateDrilling,
    kStateAfterJumping
} CharacterStates;

typedef enum {
    kObjectTypeNone,
    kPowerUpTypeHealth,
    kPowerUpTypeMallet,
    kEnemyTypeRadarDish,
    kEnemyTypeSpaceCargoShip,
    kEnemyTypeAlienRobot,
    kEnemyTypePhaser,
    kVikingType,
    kSkullType,
    kRockType,
    kMeteorType,
    kFronzenVikingType,
    kIceType,
    kLongBlockType,
    kCartType,
    kSpikesType,
    kDiggerType,
    kGroundType
} GameObjectType;

@protocol GameplayLayerDelegate

- (void)createObjectOfType:(GameObjectType)objectType 
                withHealth:(int)initialHealth 
                atLocation:(CGPoint)spawnLocation 
                withZValue:(int)ZValue;

- (void)createPhaserWithDirection:(PhaseDirection)phaserDirection 
                      andPosition:(CGPoint)spawnPosition;

@end

#endif
