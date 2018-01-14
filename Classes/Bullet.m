//
//  Bullet.m
//  Super Mario
//
//  Created by 周新哲 on 2018/1/6.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bullet.h"
#import "AnimationManager.h"
#import "Hero.h"
#import "GameMap.h"
#import "GameScene.h"

@implementation Bullet

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bulletBody = nil;
        CGPoint heroPos = [[Hero getHeroInstance] position];
        CGSize heroSize = [[Hero getHeroInstance] contentSize];
        self.startPos = ccp(heroPos.x, heroPos.y + heroSize.height/2);
    }
    return self;
}

-(void) checkBulletState{}
-(void) launchBullet{}
-(void) forKilledEnemy{}
-(CGRect) getBulletRect{
    CGPoint pos = [self position];
    return CGRectMake(pos.x - self.bodySize.width/2, pos.y, self.bodySize.width, self.bodySize.height);
}

@end

@implementation BulletCommon

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bulletType = eBullet_common;
        self.bulletState = eBulletState_active;
        self.isLand = NO;
        
        self.bodySize = CGSizeMake(10, 10);
        self.bulletBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"fireRight.png"] rect:CGRectMake(0, 0, 10, 10)];
        [self.bulletBody setAnchorPoint:ccp(0, 0)];
        [self setContentSize:self.bodySize];
        [self addChild:self.bulletBody];
        [self setAnchorPoint:ccp(0.5f, 0.0f)];
        
        self.moveOffset = 0.0f;
        self.ccMoveOffset = 5.0f;
        self.jumpOffset = 0.0f;
        self.ccJumpOffset = 0.3f;
        
        switch ([[Hero getHeroInstance] face])
        {
            case eRight:
                self.moveOffset = self.ccMoveOffset;
                break;
            case eLeft:
                self.moveOffset = -self.ccMoveOffset;
                break;
            default:
                break;
        }
    }
    return self;
}

-(void)launchBullet{
    [self.bulletBody runAction: [CCActionRepeatForever actionWithAction:[[AnimationManager getInstance] createAnimateWithType:eAniRotatedFireBall]]];
    //[self schedule:@selector(update:) interval:1/[[CCDirector sharedDirector] secondsPerFrame]];
}

-(void)commonBulletCollisionH{
    CGPoint currentPos = [self position];

    float leftSide = currentPos.x - self.bodySize.width/2;
    float rightSide = currentPos.x + self.bodySize.width/2;
    float mapMaxH = [GameScene getMapMaxH];
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    if (fabs(leftSide - mapMaxH) <= 8)
    {
        [self showBoom];
        return ;
    }

    float mapRightSide = [[GameMap getGameMap] mapSize].width* [[GameMap getGameMap] tileSize].width;
    if (fabs(rightSide - mapRightSide) <= 8)
    {
        [self showBoom];
        return ;
    }

    if (leftSide - mapMaxH >= winSize.width)
    {
        [self.bulletBody stopAllActions];
        //[self unschedule:@selector(update:)];
        [self autoClear];
    }

    CGPoint rightCollision = ccp(currentPos.x + self.bodySize.width/2, currentPos.y + self.bodySize.height/2);
    CGPoint rightTilecoord = [[GameMap getGameMap] positionToTileCoord:rightCollision];
    enum TileType tileType = [[GameMap getGameMap] tileTypeforPos:rightTilecoord];
    switch (tileType)
    {
        case eTile_Land:
        case eTile_Pipe:
        case eTile_Block:
        case eTile_Flagpole:
            [self showBoom];
            return;
            break;
        default:
            break;
    }

    CGPoint leftCollision = ccp(currentPos.x - self.bodySize.width/2, currentPos.y + self.bodySize.height/2);
    CGPoint leftTilecoord = [[GameMap getGameMap] positionToTileCoord:leftCollision];
    tileType = [[GameMap getGameMap] tileTypeforPos:leftTilecoord];
    switch (tileType)
    {
        case eTile_Land:
        case eTile_Pipe:
        case eTile_Block:
        case eTile_Flagpole:
            [self showBoom];
            return;
            break;
        default:
            break;
    }
}

-(void)commonBulletCollisionV{
    CGPoint currentPos = [self position];

    CGPoint downCollision = currentPos;
    CGPoint downTilecoord = [[GameMap getGameMap] positionToTileCoord:downCollision];
    downTilecoord.y += 1;
    CGPoint downPos = [[GameMap getGameMap] tilecoordToPosition:downTilecoord];
    downPos = ccp(currentPos.x, downPos.y + [[GameMap getGameMap] tileSize].height);

    enum TileType tileType = [[GameMap getGameMap] tileTypeforPos:downTilecoord];
    switch (tileType)
    {
        case eTile_Land:
            self.isLand = YES;
            self.jumpOffset = 3.0f;
            [self setPosition:downPos];
            return;
            break;
        case eTile_Pipe:
        case eTile_Block:
            [self showBoom];
            return;
            break;
        case eTile_Trap:
        {
            [self.bulletBody stopAllActions];
            [self autoClear];
            return ;
            break;
        }
        default:
            break;
    }

    self.jumpOffset -= self.ccJumpOffset;
}

-(void)update:(CCTime)delta{
    if (self.bulletState == eBulletState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.x += self.moveOffset;
        currentPos.y += self.jumpOffset;
        [self setPosition:currentPos];
        [self commonBulletCollisionH];
        [self commonBulletCollisionV];
    }
}

-(void)showBoom{
    [self.bulletBody stopAllActions];
    [self stopAllActions];
    [self.bulletBody runAction:[CCActionSequence actions:[sAnimationMgr createAnimateWithType:eAniRotatedFireBall],[CCActionCallFunc actionWithTarget:self selector:@selector(autoClear)], nil]];
}
-(void)autoClear{
    self.bulletState = eBulletState_nonactive;
    [self setVisible:NO];
}

-(void)forKilledEnemy{
    [self showBoom];
}

@end

@implementation BulletArrow

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bulletType = eBullet_arrow;
        self.bulletState = eBulletState_active;
        
        self.bodySize = CGSizeMake(16, 16);
        self.bulletBody = [CCSprite spriteWithImageNamed:@"arrow.png"];
        [self.bulletBody setAnchorPoint:ccp(0, 0)];
        [self setContentSize:self.bodySize];
        [self addChild:self.bulletBody];
        [self setAnchorPoint:ccp(0.5f, 0.5f)];
        
        self.ccMoveOffset = 6.0f;
        CCActionInstant *flipX = [CCActionFlipX actionWithFlipX:YES];
        
        switch ([[Hero getHeroInstance] face])
        {
            case eRight:
                self.moveOffset = self.ccMoveOffset;
                break;
            case eLeft:
                self.moveOffset = -self.ccMoveOffset;
                [self.bulletBody runAction:flipX];
                break;
            default:
                break;
        }
    }
    return self;
}

-(void)launchBullet{
    //[self update:0.1f];
}

-(void)arrowBulletCollisionH{
    CGPoint currentPos = [self position];

    float leftSide = currentPos.x - self.bodySize.width/2;
    float rightSide = currentPos.x + self.bodySize.width/2;
    float mapMaxH = [GameScene getMapMaxH];
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    if (fabs(leftSide - mapMaxH) <= 8)
    {
        [self broken];
        return;
    }
    float mapRightSide = [[GameMap getGameMap] mapSize].width * [[GameMap getGameMap] tileSize].width;
    if (fabs(rightSide - mapRightSide) <= 8)
    {
        [self broken];
        return ;
    }

    if (leftSide - mapMaxH >= winSize.width)
    {
        [self.bulletBody stopAllActions];
        [self stopAllActions];
        //[self unschedule:@selector(update:)];
        [self autoClear];
    }

    CGPoint rightCollision = ccp(currentPos.x + self.bodySize.width/2, currentPos.y);
    CGPoint rightTilecoord = [[GameMap getGameMap] positionToTileCoord:rightCollision];
    enum TileType tileType = [[GameMap getGameMap] tileTypeforPos:rightTilecoord];
    switch (tileType)
    {
        case eTile_Land:
        case eTile_Pipe:
        case eTile_Block:
        case eTile_Flagpole:
            [self broken];
            return;
            break;
        default:
            break;
    }

    CGPoint leftCollision = ccp(currentPos.x - self.bodySize.width/2, currentPos.y);
    CGPoint leftTilecoord = [[GameMap getGameMap] positionToTileCoord:leftCollision];
    tileType = [[GameMap getGameMap] tileTypeforPos:leftTilecoord];
    switch (tileType)
    {
        case eTile_Land:
        case eTile_Pipe:
        case eTile_Block:
        case eTile_Flagpole:
            [self broken];
            return ;
            break;
        default:
            break;
    }
}

-(void)forKilledEnemy{
    self.bulletState = eBulletState_nonactive;
    [self.bulletBody stopAllActions];
    [self stopAllActions];
    //[self unschedule:@selector(update:)];
    [self setVisible:NO];
}

-(void)update:(CCTime)delta{
    if (self.bulletState == eBulletState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.x += self.moveOffset;
        [self setPosition:currentPos];
        [self arrowBulletCollisionH];
    }
}

-(CGRect)getBulletRect{
    CGPoint pos = [self position];
    return CGRectMake(pos.x - 6, pos.y - 5, 12, 10);
}

-(void)autoClear{
    self.bulletState =eBulletState_nonactive;
    [self setVisible:NO];
}

-(void)broken{
    [self.bulletBody stopAllActions];
    [self stopAllActions];
    //[self unschedule:@selector(update:)];
    [self.bulletBody runAction:[CCActionSequence actions:[[AnimationManager getInstance] createAnimateWithType:eAniArrowBroken],[CCActionCallFunc actionWithTarget:self selector:@selector(autoClear)], nil]];
}

@end

