//
//  Bullet.h
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameEnum.h"

@interface Bullet : CCNode

@property enum BulletType bulletType;
@property CCSprite *bulletBody;
@property CGSize bodySize;
@property CGPoint startPos;
@property enum BulletState bulletState;

- (instancetype) init;
-(void) checkBulletState;
-(void) launchBullet;
-(void) forKilledEnemy;
-(CGRect) getBulletRect;

@end

@interface BulletCommon : Bullet

@property float moveOffset;
@property float ccMoveOffset;
@property float jumpOffset;
@property float ccJumpOffset;
@property bool isLand;

- (instancetype) init;

-(void) launchBullet;
-(void) forKilledEnemy;
-(void) commonBulletCollisionH;
-(void) commonBulletCollisionV;
-(void) showBoom;
-(void) autoClear;

@end

@interface BulletArrow : Bullet

@property float moveOffset;
@property float ccMoveOffset;

- (instancetype) init;

-(void) launchBullet;
-(void) forKilledEnemy;
-(void) arrowBulletCollisionH;
-(CGRect) getBulletRect;
-(void) autoClear;
-(void) broken;

@end

