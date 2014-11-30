//
//  HNSection.m
//  Habari
//
//  Created by edwin bosire on 23/08/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNSection.h"

@implementation HNSection


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.identifier = [decoder decodeObjectForKey:@"identifier"];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.primaryColor = [decoder decodeObjectForKey:@"primaryColor"];
    self.secondaryColor = [decoder decodeObjectForKey:@"secondaryColor"];
    self.endpoint = [decoder decodeObjectForKey:@"endpoint"];
    self.enabled =[decoder decodeBoolForKey:@"enabled"];
    self.show = [decoder decodeBoolForKey:@"show"];
//    self.newsType = (NSInteger)[decoder decodeObjectForKey:@"newsType"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.identifier forKey:@"identifier"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.primaryColor forKey:@"primaryColor"];
    [encoder encodeObject:self.secondaryColor forKey:@"secondaryColor"];
    [encoder encodeObject:self.endpoint forKey:@"endpoint"];
    [encoder encodeBool:self.enabled forKey:@"enabled"];
    [encoder encodeBool:self.show forKey:@"show"];
    
}

@end
