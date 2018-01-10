//
//  Item.h
//  Super Mario
//
//  Created by 周新哲 on 2018/1/10.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameEnum.h"

@interface Item : CCNode

@property CCSprite* itemBody;
@property enum ItemType itemType;

-(instancetype) init;
-(instancetype) initWithItemType:(enum ItemType)itemType;
+(instancetype) itemWithItemType:(enum ItemType)itemType;
@end

@interface Gadget : CCNode

@property CCSprite* gadgetBody;
@property CGSize bodySize;
@property enum GadgetType gadgetType;
@property enum GadgetState gadgetState;

@property float moveOffset;
@property float ccMoveOffset;
@property float jumpOffset;
@property float ccJumpOffset;

@property CGPoint startPos;
@property int startFace;

-(instancetype)init;

-(void) gadgetUpdateH;
-(void) gadgetUpdateV;
-(void) launchGadget;

-(CGRect) getGadgetRect;
-(void) checkGadgetState;

@end

@interface GadgetLadderLR : Gadget

@property float leftSide;
@property float rightSide;
@property float lrDis;

-(instancetype) init;
-(instancetype) initWithDis:(float)dis;

-(void) gadgetUpdateH;
-(void) launchGadget;

@end

@interface GadgetLadderUD : Gadget

@property float upSide;
@property float downSide;
@property float udDis;

-(instancetype) init;
-(instancetype) initWithDis:(float)dis;

-(void) gadgetUpdateV;
-(void) launchGadget;

@end

