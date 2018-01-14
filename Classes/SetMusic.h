//
//  SetMusic.h
//  Super Mario
//
//  Created by 周新哲 on 2018/1/10.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameEnum.h"

@interface SetMusic : CCScene

@property BOOL bSoundEffect;
@property BOOL bMusic;
@property CCSprite* pMusic;
@property CCSprite* pSoundEffect;
@property CCSpriteFrame* pMusicOn;
@property CCSpriteFrame* pMusicOff;
@property CCSpriteFrame* pEffectOn;
@property CCSpriteFrame* pEffectOff;

-(instancetype) init;
-(void) initSwitch;

-(void) menuBackMainMenu;
-(void) menuMusic;
-(void) menuEffect;

@end
