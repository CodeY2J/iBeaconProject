//
//  ReportVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/9/23.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "ReportVC.h"
#import "ReportMessage.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "CacheManager.h"

@interface ReportVC () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *photo1Button;
@property (weak, nonatomic) IBOutlet UIButton *photo2Button;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation ReportVC {
    NSInteger _buttonIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendButtonPressed:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    ReportMessage *reportMessage = [[ReportMessage alloc] init];
    
    if (self.photo1Button.imageView.image) {
        NSString *savedImagePath=[CacheManager cacheFile:[NSString stringWithFormat:@"%f.png",[[NSDate date] timeIntervalSince1970]]];
        NSData *imagedata=UIImagePNGRepresentation(self.photo1Button.imageView.image);
        [imagedata writeToFile:savedImagePath atomically:YES];
        reportMessage.photoImage1 = savedImagePath;
    }
    if (self.photo2Button.imageView.image) {
        NSString *savedImagePath= [CacheManager cacheFile:[NSString stringWithFormat:@"%f.png",[[NSDate date] timeIntervalSince1970] + 1]];        NSData *imagedata=UIImagePNGRepresentation(self.photo2Button.imageView.image);
        [imagedata writeToFile:savedImagePath atomically:YES];
        reportMessage.photoImage2 = savedImagePath;
    }
    
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    reportMessage.content = self.textView.text;
    reportMessage.time = currentTime;
    if(![self.locationLabel.text isEqualToString:@"所在位置"]) {
        reportMessage.location = self.locationLabel.text;
    }
    
    NSMutableArray *mutableArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[CacheManager cacheFile:@"reportMessage"]];
    if (!mutableArray) {
        mutableArray = [NSMutableArray arrayWithCapacity:5];
    }
    [mutableArray addObject:reportMessage];
    
    NSInteger unreadCount = 0;
    for (ReportMessage *reportMessage in mutableArray) {
        if (![reportMessage.isRead boolValue]) {
            unreadCount ++;
        }
    }
    self.parentViewController.tabBarController.childViewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)unreadCount];
    
    [NSKeyedArchiver archiveRootObject:mutableArray toFile:[CacheManager cacheFile:@"reportMessage"]];
    [SVProgressHUD show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}


- (IBAction)takePhotoButtonPressed:(UIButton *)sender {
    UIActionSheet *sheet;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"图像选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"图像选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.tag = 255;
    [sheet showInView:self.view];
    _buttonIndex = sender.tag;
}

- (IBAction)unwindSegueToViewController:(UIStoryboardSegue *)segue {
    NSString *location = [segue.sourceViewController valueForKey:@"location"];
    self.locationLabel.text = location;
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 255) {
        UIImagePickerControllerSourceType sourceType = 0;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        } else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - ImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    switch (_buttonIndex) {
        case 0:
            [self.photo1Button setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
            break;
        case 1:
            [self.photo2Button setImage:[info objectForKey:UIImagePickerControllerEditedImage] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
