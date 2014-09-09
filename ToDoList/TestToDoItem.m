//
//  TestToDoItem.m
//  ToDoList
//
//  Created by Rong Yan on 9/5/14.
//  Copyright (c) 2014 Rong Yan. All rights reserved.
//

#import "TestToDoItem.h"

@implementation TestToDoItem

- (id)init:(NSString*)string
{
    self = [super init];
    if (self)
    {
        // superclass successfully initialized, further
        // initialization happens here ...
        NSLog(@"%@", string);
        self.itemName = string;
        self.completed = FALSE;
        self.creationDate = [NSDate date];
        self.image = nil;
    }
    return self;
}

+ (NSString *)getCreationDateString:(NSDate*)creationDate
{
    if (creationDate) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        return [formatter stringFromDate:creationDate];
    } else {
        return @"Unknown";
    }
}

@end
