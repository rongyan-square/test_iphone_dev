//
//  TestAddToDoItemViewController.h
//  ToDoList
//
//  Created by Rong Yan on 9/4/14.
//  Copyright (c) 2014 Rong Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestToDoItem.h"

@interface TestAddToDoItemViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property TestToDoItem *addItem;
@property TestToDoItem *inputAddItem;
@property long updateRow;

- (IBAction)takePhoto:(id)sender;
- (IBAction)selectPhoto:(id)sender;

@end
