//
//  Item.m
//  Super Mario
//
//  Created by 周新哲 on 2018/1/10.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "GameScene.h"

@implementation Item

- (instancetype)init
{
    return [self initWithItemType:eBlinkCoin];
}

- (instancetype)initWithItemType:(enum ItemType)itemType
{
    self = [super init];
    if (self) {
        self.itemType = itemType;
        switch (self.itemType)
        {
            case eBlinkCoin:
                self.itemBody = [CCSprite spriteWithTexture:[CCTexture textureWithFile:@"coinani.png"] rect:CGRectMake(0, 0, 8, 14)];
                break;
            default:
                break;
        }
        [self.itemBody setAnchorPoint:ccp(0, 0)];
        [self addChild:self.itemBody];
        [self setContentSize:CGSizeMake(8, 14)];
        [self setAnchorPoint:ccp(0.5, 0)];
    }
    return self;
}

+(instancetype)itemWithItemType:(enum ItemType)itemType{
    return [[self alloc] initWithItemType:itemType];
}

@end

@implementation Gadget

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gadgetBody = nil;
        self.gadgetState = eGadgetState_nonactive;
        self.moveOffset = 0.0f;
        self.ccMoveOffset = 0.0f;
        self.jumpOffset = 0.0f;
        self.ccJumpOffset = 0.0f;
        self.startPos = CGPointZero;
    }
    return self;
}

-(void)gadgetUpdateH{}
-(void)gadgetUpdateV{}
-(void)launchGadget{}
-(CGRect)getGadgetRect{
    CGPoint pos = [self position];
    return CGRectMake(pos.x-self.bodySize.width/2, pos.y, self.bodySize.width, self.bodySize.height);
}

-(void)checkGadgetState{
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    float tempMaxH = [GameScene getMapMaxH];
    CGPoint pos = [self position];
    
    if ( (pos.x + self.bodySize.width/2 - tempMaxH >= 0) &&
        (pos.x - self.bodySize.width/2 - tempMaxH) <= winSize.width )
    {
        self.gadgetState = eGadgetState_active;
    }
    else
    {
        if (pos.x + self.bodySize.width/2 - tempMaxH < 0)
        {
            self.gadgetState = eGadgetState_over;
            [self.gadgetBody stopAllActions];
            [self stopAllActions];
            //[self unschedule:@selector(update:)];
            [self setVisible:NO];
        }
        else
        {
            self.gadgetState = eGadgetState_nonactive;
        }
    }
}

@end

@implementation GadgetLadderLR

- (instancetype)init
{
    return [self initWithDis:1.0f];
}

- (instancetype)initWithDis:(float)dis
{
    self = [super init];
    if (self) {
        self.gadgetType = eGadget_LadderLR;
        self.gadgetBody = [CCSprite spriteWithImageNamed:@"ladder.png"];
        self.bodySize = CGSizeMake(48.0f, 8.0f);
        [self.gadgetBody setAnchorPoint:ccp(0, 0)];
        [self setContentSize:self.bodySize];
        [self addChild:self.gadgetBody];
        [self setAnchorPoint:ccp(0.5f, 0.0f)];
        
        self.ccMoveOffset = 0.6f;
        self.leftSide = 0.0f;
        self.rightSide = 0.0f;
        self.lrDis = dis;
    }
    return self;
}

-(void)gadgetUpdateH{
    CGPoint pos = [self position];
    if (pos.x <= self.leftSide || pos.x >= self.rightSide)
    {
        self.moveOffset *= -1;
    }
}

-(void)launchGadget{
    self.leftSide = self.startPos.x - self.lrDis;
    self.rightSide = self.startPos.x + self.lrDis;
    switch (self.startFace)
    {
        case 0:
            self.moveOffset = -self.ccMoveOffset;
            break;
        case 1:
            self.moveOffset = self.ccMoveOffset;
            break;
        default:
            break;
    }
    //[self schedule:@selector(update:) interval:1/[[CCDirector sharedDirector] secondsPerFrame]];
}

-(void)update:(CCTime)delta{
    [self checkGadgetState];
    if (self.gadgetState == eGadgetState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.x += self.moveOffset;
        [self setPosition:currentPos];
        [self gadgetUpdateH];
    }
}

@end

@implementation GadgetLadderUD

- (instancetype)init
{
    return [self initWithDis:1.0f];
}

- (instancetype)initWithDis:(float)dis
{
    self = [super init];
    if (self) {
        self.gadgetType = eGadget_LadderUD;
        self.gadgetBody = [CCSprite spriteWithImageNamed:@"ladder.png"];
        self.bodySize = CGSizeMake(48.0f, 8.0f);
        [self.gadgetBody setAnchorPoint:ccp(0, 0)];
        [self setContentSize:self.bodySize];
        [self addChild:self.gadgetBody];
        [self setAnchorPoint:ccp(0.5f, 0.0f)];
        
        self.ccJumpOffset = 0.5f;
        self.upSide = 0.0f;
        self.downSide = 0.0f;
        self.udDis = dis;
    }
    return self;
}

-(void)gadgetUpdateV{
    CGPoint pos = [self position];
    if (pos.y <= self.downSide || pos.y >= self.upSide)
    {
        self.jumpOffset *= -1;
    }
}

-(void)launchGadget{
    self.upSide = self.startPos.y - self.udDis;
    self.downSide = self.startPos.y + self.udDis;
    switch (self.startFace)
    {
        case 0:
            self.jumpOffset = -self.ccJumpOffset;
            break;
        case 1:
            self.jumpOffset = self.ccJumpOffset;
            break;
        default:
            break;
    }
    //[self schedule:@selector(update:) interval:1/[[CCDirector sharedDirector] secondsPerFrame]];
}

-(void)update:(CCTime)delta{
    [self checkGadgetState];
    if (self.gadgetState == eGadgetState_active)
    {
        CGPoint currentPos = [self position];
        currentPos.y += self.jumpOffset;
        [self setPosition:currentPos];
        [self gadgetUpdateV];
    }
}

@end

