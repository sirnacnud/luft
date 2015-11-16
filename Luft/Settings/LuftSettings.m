//
//  LuftSettings.m
//  Luft
//
//  Created by Emil Bogren on 15/11/15.
//  Copyright © 2015 Hugo Tunius. All rights reserved.
//

#import "LuftSettings.h"

NSString *const LuftSettingsChangedNotification = @"LuftSettingsChangedNotification";

static NSString *const kGoodColor = @"luft.goodColor";
static NSString *const kWarningColor = @"luft.warningColor";
static NSString *const kBadColor = @"luft.badColor";
static NSString *const kOnlyViewControllers = @"luft.onlyViewControllers";
static NSString *const kLowerLimit = @"luft.lowerLimit";
static NSString *const kUpperLimit = @"luft.upperLimit";

@interface LuftSettings()
- (void)postSettingsChangedNotification;
@end

@implementation LuftSettings

+ (LuftSettings *)sharedSettings {
    static dispatch_once_t once;
    static LuftSettings *sharedSettings;
    dispatch_once(&once, ^ {
        sharedSettings = [[LuftSettings alloc] init];
        NSDictionary *defaults = @{kOnlyViewControllers: @YES,
                                   kLowerLimit: @150,
                                   kUpperLimit: @300};
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    });
    return sharedSettings;
}

#pragma mark - Setters

- (void)setGoodColor:(NSColor *)color {
    [self _setColor:color forKey:kGoodColor];
    [self postSettingsChangedNotification];
}

- (void)setWarningColor:(NSColor *)color {
    [self _setColor:color forKey:kWarningColor];
    [self postSettingsChangedNotification];
}

- (void)setBadColor:(NSColor *)color {
    [self _setColor:color forKey:kBadColor];
    [self postSettingsChangedNotification];
}

- (void)setOnlyViewControllers:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kOnlyViewControllers];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self postSettingsChangedNotification];
}

- (void)setLowerLimit:(NSUInteger)limit {
    [[NSUserDefaults standardUserDefaults] setInteger:limit forKey:kLowerLimit];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self postSettingsChangedNotification];
}

- (void)setUpperLimit:(NSUInteger)limit {
    [[NSUserDefaults standardUserDefaults] setInteger:limit forKey:kUpperLimit];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self postSettingsChangedNotification];
}

#pragma mark - Getters

- (NSColor *)goodColor {
    NSColor *color = [self _getColorForKey:kGoodColor];
    return color ? color : [self _defaultGoodColor];
}

- (NSColor *)warningColor {
    NSColor *color =  [self _getColorForKey:kWarningColor];
    return color ? color : [self _defaultWarningColor];
}

- (NSColor *)badColor {
    NSColor *color = [self _getColorForKey:kBadColor];
    return color ? color : [self _defaultBadColor];
}

- (BOOL)onlyViewController {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kOnlyViewControllers];
}

- (NSUInteger)lowerLimit {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kLowerLimit];
}

- (NSUInteger)upperLimit {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUpperLimit];
}

#pragma mark - Private

- (void)postSettingsChangedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:LuftSettingsChangedNotification object:nil];
}

- (void)_setColor:(NSColor *)color forKey:(NSString *)key {
    NSData *colorData = [NSArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSColor *)_getColorForKey:(NSString *)key {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(colorData){
        return [NSUnarchiver unarchiveObjectWithData:colorData];
    }

    return nil;
}


- (NSColor *)_defaultGoodColor {
    return [NSColor colorWithCalibratedRed:0.2 green:0.51 blue:0.0471 alpha:0.5];
}

- (NSColor *)_defaultWarningColor {
    return [NSColor colorWithCalibratedRed:0.49 green:0.51 blue:0.0471 alpha:0.5];
}

- (NSColor *)_defaultBadColor {
    return [NSColor colorWithCalibratedRed:0.51 green:0.0471 blue:0.0471 alpha:0.5];
}

@end
