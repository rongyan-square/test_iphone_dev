//
//  TestToDoItem.h
//  ToDoList
//
//  Created by Rong Yan on 9/5/14.
//  Copyright (c) 2014 Rong Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestToDoItem : NSObject

// Definition of the property 
@property NSString *itemName;
@property BOOL completed;
@property NSDate *creationDate;
@property NSData *image;

- (id)init:(NSString*)string;
+ (NSString *)getCreationDateString:(NSDate*)creationDate;


@end
