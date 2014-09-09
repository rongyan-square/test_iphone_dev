//
//  ToDoList.h
//  ToDoList
//
//  Created by Rong Yan on 9/6/14.
//  Copyright (c) 2014 Rong Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TestToDoItem.h"

@interface ToDoList : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSData * image;

- (void)convert:(TestToDoItem*)item;
@end
