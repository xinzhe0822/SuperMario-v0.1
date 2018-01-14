//
//  Enemy.h
//
//  Created by : Mr.Right
//  Project    : Super Mario
//  Date       : 2018/1/6
//
//  Copyright (c) 2018年 master.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameEnum.h"

// -----------------------------------------------------------------

@interface Enemy : CCNode

// -----------------------------------------------------------------
// properties
@property enum EnemyType enemyType;
@property CCSprite *enemyBody;
@property CGSize bodySize;
@property CCSpriteFrame *enemyLifeOver;
@property CCSpriteFrame *overByArrow;

@property CGPoint tileCoord;
@property CGPoint enemyPos;

@property enum marioDirection startFace;

@property float moveOffset;
@property float ccMoveOffset;

@property float jumpOffset;
@property float ccJumpOffset;
@property(nonatomic) enum EnemyState enemyState;

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;
- (void)launchEnemy;
- (CGRect)getEnemyRect;
- (void)enemyCollistionH;
- (void)enemyCollistionV;
- (void)checkState;
- (void)stopEnemyUpdate;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)setNonVisibleForKilledByHero;

- (void)forKilledByBullet;
- (void)setNonVisibleForKilledByBullet;

// -----------------------------------------------------------------

@end

@interface EnemyMushroom : Enemy
// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
- (void)launchEnemy;

//void enemyCollistionH();
//void enemyCollistionV();


@end

@interface EnemyFlower : Enemy
// -----------------------------------------------------------------
// properties
@property CGPoint startPos;
// -----------------------------------------------------------------
// methods
- (void)launchEnemy;


- (enum EnemyVSHero)checkCollisionWithHero;
- (CGRect)getEnemyRect;
@end

@interface EnemyTortoise : Enemy
// -----------------------------------------------------------------
// properties
@property CCSpriteFrame *leftFace;
@property CCSpriteFrame *rightFace;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithStartface:(int)startface;
- (void)launchEnemy;
- (void)enemyCollistionH;

@end

@interface EnemyTortoiseRound : Enemy
// -----------------------------------------------------------------
// properties
@property float roundDis;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithRoundDis:(float)dis;
- (void)launchEnemy;

@end

@interface EnemyTortoiseFly : Enemy
// -----------------------------------------------------------------
// properties
@property float flyDis;

// -----------------------------------------------------------------
// methods
- (instancetype)initWithFlyDis:(float)dis;
- (void)launchEnemy;

@end

@interface EnemyFireString : Enemy
// -----------------------------------------------------------------
// properties
@property CCSprite *enemyBody2;
@property CCSprite *enemyBody3;

@property CGSize fireSize;
@property NSMutableArray *pArrayFire;

@property float begAngle;
@property float time;

@property double angle;
@property double PI;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithBegAngle:(float)begAngle AndTime:(float)time;
- (void)launchEnemy;
- (void)stopEnemyUpdate;
- (enum EnemyVSHero)checkCollisionWithHero;

@end

@interface EnemyFlyFish : Enemy
// -----------------------------------------------------------------
// properties
@property float offsetH;
@property float offsetV;
@property float offsetDuration;
@property bool isFlying;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithoffsetH:(float)offsetH andOffsetV:(float)offsetV andDuration:(float)duration;
- (void)launchEnemy;
- (void)checkState;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
@end

@interface EnemyBoss : Enemy
// -----------------------------------------------------------------
// properties
@property float leftSide;
@property float rightSide;
// -----------------------------------------------------------------
// methods
- (void)launchEnemy;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)forKilledByBullet;
- (void)enemyCollistionH;
@end

@interface EnemyBossFire : Enemy
// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
- (void)launchEnemy;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)forKilledByBullet;
@end

@interface EnemyAddMushroom : Enemy
// -----------------------------------------------------------------
// properties
@property int addNums;
@property bool isAddable;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithNum:(int)addnum;
- (void)launchEnemy;
- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
@end

@interface EnemyBattery : Enemy
// -----------------------------------------------------------------
// properties
@property BOOL isFireable;
@property float fireDelay;
@property CGPoint firePos;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithDelay:(float)delay;
- (void)launchEnemy;

- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)forKilledByBullet;
@end

@interface EnemyBatteryBullet : Enemy
// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
- (void)launchEnemy;

- (enum EnemyVSHero)checkCollisionWithHero;
- (void)forKilledByHero;
- (void)forKilledByBullet;
@end

@interface EnemyDarkCloud : Enemy
// -----------------------------------------------------------------
// properties
@property float dropRegion;
@property float leftSide;
@property float rightSide;
@property BOOL isDropable;
@property float delay;
@property int type;
@property CCSpriteFrame *dark;
@property CCSpriteFrame *normal;
// -----------------------------------------------------------------
// methods
- (instancetype)initWithDelay:(float)delay andType:(int)type;
- (void)launchEnemy;

- (void)forKilledByHero;
- (void)forKilledByBullet;
@end

@interface EnemyLighting : Enemy
// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
- (void)launchEnemy;

- (enum EnemyVSHero)checkCollisionWithHero;
- (void)checkState;
@end




