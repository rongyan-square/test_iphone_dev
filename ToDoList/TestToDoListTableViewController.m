//
//  TestToDoListTableViewController.m
//  ToDoList
//
//  Created by Rong Yan on 9/4/14.
//  Copyright (c) 2014 Rong Yan. All rights reserved.
//

#import "TestToDoListTableViewController.h"
#import "TestToDoItem.h"
#import "TestAddToDoItemViewController.h"
#import "ToDoList.h"

@interface TestToDoListTableViewController ()

// @property NSMutableArray *toDoItems;
// @property (nonatomic, strong) NSMutableArray *toDoItems;
@property (nonatomic, strong) NSArray *toDoItems;
- (IBAction)saveToDoList:(id)sender;
- (void)fetchData;
- (void)reloadData; 

@end

@implementation TestToDoListTableViewController
@synthesize managedObjectContext;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [self loadInitialData];
    [self fetchData];
    
    // Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                         action:@selector(reloadData)
                         forControlEvents:UIControlEventValueChanged];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)reloadData
{
    // Reload table data
    [self fetchData];
    [self.tableView reloadData];
    
    // End the refreshing
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}

- (void)fetchData
{
    // Read the data
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ToDoList"
                                   inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]; 
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entity];
    self.toDoItems = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // self.toDoItems = [NSMutableArray arrayWithArray:array];
    /* for (ToDoList *toDoItem in self.toDoItems) {
        NSLog(@"Name: %@", toDoItem.itemName);
    } */
}

- (void)loadInitialData {
    // self.toDoItems = [[NSMutableArray alloc] init];

    /* NSArray *items = @[@"Buy milk",@"Buy eggs", @"Read a book"];
    for (id item in items) {
        [self.toDoItems addObject:[[TestToDoItem alloc] init:item]];
    } */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.toDoItems count];
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    TestAddToDoItemViewController *source = [segue sourceViewController];
    TestToDoItem *addItem = source.addItem;

    if (addItem != nil) {
        // Add the new item to managed object context, but not yet to the toDoItems
        ToDoList *toDoItem;
        if (source.updateRow >= 0) {
            toDoItem = [self.toDoItems objectAtIndex:source.updateRow];
        } else {
            toDoItem = [NSEntityDescription
                        insertNewObjectForEntityForName:@"ToDoList"
                        inManagedObjectContext:managedObjectContext];
        }
        [toDoItem convert:addItem];
        
        // Now added to toDoItems
        // [self.toDoItems addObject:newToDoItem];
        [self fetchData];
        [self.tableView reloadData];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    ToDoList *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    
    // Set the background color
    if ([toDoItem.completed boolValue]) {
        cell.backgroundColor = [UIColor colorWithRed: 0.5 green: 1.0 blue: 0.5 alpha: 1.0];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    /* if ([toDoItem.completed boolValue]) {
     cell.accessoryType = UITableViewCellAccessoryCheckmark;
     } else {
     cell.accessoryType = UITableViewCellAccessoryNone;
     } */
    
    // Set the title and subtitle
    cell.textLabel.text = toDoItem.itemName;
    cell.detailTextLabel.text = [TestToDoItem getCreationDateString:toDoItem.creationDate];
    if (toDoItem.image) {
        cell.imageView.image = [UIImage imageWithData:toDoItem.image];
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        ToDoList *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:toDoItem];
        
        // Remove from the array
        // [self.toDoItems removeObjectAtIndex:indexPath.row];
        [self fetchData];
        
        // Remove from table view
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ToDoList *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    
    // toDoItem.completed = !toDoItem.completed;
    if ([toDoItem.completed boolValue] == YES) {
        toDoItem.completed = [NSNumber numberWithBool:NO];
    } else {
        toDoItem.completed = [NSNumber numberWithBool:YES];
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)saveToDoList:(id)sender {
    NSError *error = nil;
    if (managedObjectContext != nil) {
        NSString *alertTitle, *alertMessage;
        if (![managedObjectContext hasChanges]) {
            alertTitle = @"Warning";
            alertMessage = @"Nothing has changed!";
        } else if (![managedObjectContext save:&error]) {
            alertTitle = @"Error";
            alertMessage = [error localizedDescription];
        } else {
            alertTitle = @"Success";
            alertMessage = @"The ToDo List is saved!";
        }
        [[[UIAlertView alloc] initWithTitle:alertTitle
                              message:alertMessage
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UINavigationController *navigationController = [segue destinationViewController];
    TestAddToDoItemViewController *dest = (TestAddToDoItemViewController *)navigationController.topViewController;
    if ([segue.identifier isEqualToString:@"AddToList"]) {
        dest.updateRow = -1;
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if (!indexPath) {
        return;
    }
    
    ToDoList *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    dest.inputAddItem = [[TestToDoItem alloc] init];
    dest.inputAddItem.itemName = toDoItem.itemName;
    dest.inputAddItem.creationDate = toDoItem.creationDate;
    dest.inputAddItem.image = toDoItem.image;
    dest.updateRow = [self.tableView indexPathForSelectedRow].row;
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
