//
//  ToDoList.m
//  ToDoList
//
//  Created by Rong Yan on 9/6/14.
//  Copyright (c) 2014 Rong Yan. All rights reserved.
//

#import "ToDoList.h"


@implementation ToDoList

@dynamic itemName;
@dynamic completed;
@dynamic creationDate;
@dynamic image;

- (void)convert:(TestToDoItem*)item
{
    self.itemName = item.itemName;
    self.completed = [NSNumber numberWithBool:item.completed];
    self.creationDate = item.creationDate;
    self.image = item.image; 
}

@end
