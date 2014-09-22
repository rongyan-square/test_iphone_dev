//
//  TestAddToDoItemViewController.m
//  ToDoList
//
//  Created by Rong Yan on 9/4/14.
//  Copyright (c) 2014 Rong Yan. All rights reserved.
//

#import "TestAddToDoItemViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TestAddToDoItemViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UITextField *creationDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UINavigationItem *addItemTitle;
@property (weak, nonatomic) IBOutlet UISwitch *saveToAlbum;
@property MPMoviePlayerController *videoController;

@end

@implementation TestAddToDoItemViewController
// @synthesize textField;

#pragma mark - Helper

- (void)showAlert:(NSString*)title message:(NSString*)msg
{
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
    
    [myAlertView show];
}

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField.delegate = self;
    if (self.inputAddItem) {
        [self.textField setText:self.inputAddItem.itemName];
        NSString* date = [TestToDoItem getCreationDateString:self.inputAddItem.creationDate];
        [self.creationDate setText:date];
        UIImage* image = [UIImage imageWithData:self.inputAddItem.image];
        [self.imageView setImage:image];
        [self.addItemTitle setTitle:@"Update ToDo Item"];
        
    } else {
        [self.textField setText:nil];
        NSString* date = [TestToDoItem getCreationDateString:[NSDate date]];
        [self.creationDate setText:date];
        [self.imageView setImage:nil];
        [self.addItemTitle setTitle:@"Add ToDo Item"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender != self.doneButton) return;
    if (self.textField.text.length > 0) {
        self.addItem = [[TestToDoItem alloc] init:self.textField.text];
        if (self.imageView.image) {
          self.addItem.image = UIImagePNGRepresentation(self.imageView.image);
        }
    }
}

// Keyboard delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Photo delegate
- (IBAction)takePhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self showAlert:@"Error" message:@"Device has no camera"];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self showAlert:@"Error" message:@"Device has no photo library"];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)saveImageToAlbum:(UIImage*)image finishedSavingWithError:(NSError *) error contextInfo:(void *)contextInfo {
    if (error) {
        [self showAlert:@"Error" message:[error localizedDescription]];
    } else {
        [self showAlert:@"Success" message:@"This image is saved to your album"];
    }
}

- (void)saveVideoToAlbum:(NSURL*)videoPath finishedSavingWithError:(NSError *) error contextInfo:(void *)contextInfo {
    if (error) {
        [self showAlert:@"Error" message:[error localizedDescription]];
    } else {
        [self showAlert:@"Success" message:@"This video is saved to your album"];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ( [mediaType isEqualToString:@"public.movie" ]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        self.videoController = [[MPMoviePlayerController alloc] init];
        // This line must be placed before the setContentURL line
        self.videoController.movieSourceType = MPMovieSourceTypeStreaming;
        
        [self.videoController setContentURL:videoURL];
        [self.videoController.view setFrame:self.imageView.frame];
        [self.view addSubview:self.videoController.view];
        
        [self.videoController play];
        
        if ([self.saveToAlbum isOn] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            NSString *videoPath = [videoURL path];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(videoPath,
                                                    self,
                                                    @selector(saveVideoToAlbum:finishedSavingWithError:contextInfo:),
                                                    nil);
            }
        }
    } else {
        UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
        self.imageView.image = chosenImage;
        // save the image to album
        if ([self.saveToAlbum isOn] && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(chosenImage,
                                           self,
                                           @selector(saveImageToAlbum:finishedSavingWithError:contextInfo:),
                                           nil);
        }
    }
    
    /* NSURL *videoURl = [NSURL fileURLWithPath:videoPath];
     AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURl options:nil];
     AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
     generate.appliesPreferredTrackTransform = YES;
     NSError *err = NULL;
     CMTime time = CMTimeMake(1, 60);
     CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
     
     UIImage *img = [[UIImage alloc] initWithCGImage:imgRef];
     [YourImageView setImage:img]; */
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
