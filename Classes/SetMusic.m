//
//  SetMusic.m
//  Super Mario
//
//  Created by 周新哲 on 2018/1/10.
//  Copyright © 2018年 master. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SetMusic.h"
#import "MainMenu.h"
#import "OALSimpleAudio.h"

@implementation SetMusic

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bMusic = YES;
        self.bSoundEffect = YES;
        CCSprite *pBg = [CCSprite spriteWithImageNamed:@"bg.png"];
        CGPoint origin = [[CCDirector sharedDirector] accessibilityActivationPoint];
        CGSize visibleSize = [[CCDirector sharedDirector] viewSize] ;

        [pBg setPosition:ccp(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2)];
        [self addChild:pBg z:0];

        CCSprite *pSetBg = [CCSprite spriteWithImageNamed:@"Set_Music.png"];
        [pSetBg setAnchorPoint:ccp(129.0/248, 71.0/132)];
        [pSetBg setPosition:ccp(origin.x+visibleSize.width/2, origin.y+visibleSize.height/2)];
        [self addChild:pSetBg z:1];

        CCSpriteFrame *pBackNormal = [CCSpriteFrame frameWithImageNamed:@"backA.png"];
        CCSpriteFrame *pBackSelect = [CCSpriteFrame frameWithImageNamed:@"backB.png"];
        CCButton *pBack = [CCButton buttonWithTitle:@"" spriteFrame:pBackNormal highlightedSpriteFrame:pBackNormal disabledSpriteFrame:pBackSelect];
        [pBack setPosition:ccp(origin.x+20, origin.y+visibleSize.height-20)];
        [pBack setTarget:self selector:@selector(menuBackMainMenu)];
        [self addChild:pBack z:2];
        [self initSwitch];
    }
    return self;
}

-(void)initSwitch{
    CGPoint origin = [[CCDirector sharedDirector] accessibilityActivationPoint];
    CGSize visibleSize = [[CCDirector sharedDirector] viewSize];
    
    self.pMusicOn = [CCSpriteFrame frameWithTextureFilename:@"music_on.png" rectInPixels:CGRectMake(0, 0, 70, 63) rotated:NO offset:CGPointZero originalSize:CGSizeMake(70, 63)];
    self.pMusicOff = [CCSpriteFrame frameWithTextureFilename:@"music_off.png" rectInPixels:CGRectMake(0, 0, 70, 63) rotated:NO offset:CGPointZero originalSize:CGSizeMake(70, 63)];
    self.pEffectOn = [CCSpriteFrame frameWithTextureFilename:@"sound_effect_on.png" rectInPixels:CGRectMake(0, 0, 70, 63) rotated:NO offset:CGPointZero originalSize:CGSizeMake(70, 63)];
    self.pEffectOff = [CCSpriteFrame frameWithTextureFilename:@"sound_effect_off.png" rectInPixels:CGRectMake(0, 0, 70, 63) rotated:NO offset:CGPointZero originalSize:CGSizeMake(70, 63)];
    
    self.pMusic = [CCSprite spriteWithSpriteFrame:self.pMusicOn];
    [self.pMusic setPosition:ccp(origin.x+visibleSize.width/2+80, origin.y+visibleSize.height/2-40)];
    [self addChild:self.pMusic z:3];
    
    self.pSoundEffect = [CCSprite spriteWithSpriteFrame:self.pEffectOn];
    [self.pSoundEffect setPosition:ccp(origin.x+visibleSize.width/2+80, origin.y+visibleSize.height/2+40)];
    [self addChild:self.pSoundEffect z:3];
    
    CCSpriteFrame *pSwitchBg = [CCSpriteFrame frameWithImageNamed:@"switchBg.png"];
    CCButton *pMusicMenu = [CCButton buttonWithTitle:@"" spriteFrame:pSwitchBg];
    [pMusicMenu setPosition:ccp(origin.x+visibleSize.width/2+80, origin.y+visibleSize.height/2-40)];
    [pMusicMenu setTarget:self selector:@selector(menuMusic)];
    [self addChild:pMusicMenu z:1];
    CCButton *pEffectMenu = [CCButton buttonWithTitle:@"" spriteFrame:pSwitchBg];
    [pEffectMenu setPosition:ccp(origin.x+visibleSize.width/2+80, origin.y+visibleSize.height/2+40)];
    [pEffectMenu setTarget:self selector:@selector(menuEffect)];
    [self addChild:pEffectMenu z:1];
}
-(void)menuBackMainMenu{
    CCScene *pMainMenue = [[MainMenu alloc]init];
    [[CCDirector sharedDirector] replaceScene:pMainMenue];
}
-(void)menuMusic{
    if (self.bMusic)
    {
        self.bMusic = NO;
        [self.pMusic setSpriteFrame:self.pMusicOff];
        [[OALSimpleAudio sharedInstance] setBgVolume:0.0f];
        [[NSUserDefaults standardUserDefaults] setObject:@"off" forKey:@"Music"];
    }else
    {
        self.bMusic = YES;
        [self.pMusic setSpriteFrame:self.pMusicOn];
        [[OALSimpleAudio sharedInstance] setBgVolume:1.0f];
        [[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"Music"];
    }
}
-(void)menuEffect{
    if (self.bSoundEffect)
    {
        self.bSoundEffect = NO;
        [self.pSoundEffect setSpriteFrame:self.pEffectOff];
        [[OALSimpleAudio sharedInstance] setEffectsVolume:0.0f];
        [[NSUserDefaults standardUserDefaults] setObject:@"off" forKey:@"SoundEffect"];
    }else
    {
        self.bSoundEffect = YES;
        [self.pSoundEffect setSpriteFrame:self.pEffectOn];
        [[OALSimpleAudio sharedInstance] setEffectsVolume:1.0f];
        [[NSUserDefaults standardUserDefaults] setObject:@"on" forKey:@"SoundEffect"];
    }
}
-(void)onEnter{
    [super onEnter];
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"Music"];
    if ([str isEqualToString:@"on"])
    {
        self.bMusic = YES;
        [self.pMusic setSpriteFrame:self.pMusicOn];
        [[OALSimpleAudio sharedInstance] setBgVolume:1.0f];
    }else if ([str isEqualToString:@"off"])
    {
        self.bMusic = NO;
        [self.pMusic setSpriteFrame:self.pMusicOff];
        [[OALSimpleAudio sharedInstance] setBgVolume:0.0f];
    }
    
    str = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundEffect"];
    if ([str isEqualToString:@"on"])
    {
        self.bSoundEffect = YES;
        [self.pSoundEffect setSpriteFrame:self.pEffectOn];
        [[OALSimpleAudio sharedInstance] setEffectsVolume:1.0f];
    }else if ([str isEqualToString:@"off"])
    {
        self.bSoundEffect = NO;
        [self.pSoundEffect setSpriteFrame:self.pEffectOff];
        [[OALSimpleAudio sharedInstance] setEffectsVolume:0.0f];
    }
}
@end

