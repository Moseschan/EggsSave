//
//  PersonalMessageViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 1/4/16.
//  Copyright © 2016 Adwan. All rights reserved.
//


#import "PersonalMessageViewController.h"
#import "ZHPickView.h"
#import "QrCodeView.h"
#import "CCLocationManager.h"
#import "LoginManager.h"
#import "CommonMethods.h"
#import "User.h"

@interface PersonalMessageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

- (IBAction)changeUserDetails:(id)sender;


@end

@implementation PersonalMessageViewController
{
    NSString*       _city;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = @"我的资料";
    self.nickNameTextField.delegate = self;
    
    //头像
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    DLog(@"imageFile->>%@",imageFilePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
    
    if (!selfPhoto) {
        selfPhoto = [UIImage imageNamed:@"icon_myheadr"];
    }
    
    self.avatarImageView.image = selfPhoto;
    [self.avatarImageView.layer setCornerRadius:CGRectGetHeight([self.avatarImageView bounds]) / 2];
    self.avatarImageView.layer.masksToBounds = YES;
    
    [self setUpUserInfo];
}

- (void)setUpUserInfo
{
    User* u = [User getInstance];
    
    if (u.nickName) {
        _nickNameTextField.text = u.nickName;
    }
    
    if (u.sex) {
        _sexLabel.text = u.sex;
    }
    
    if (u.birthDay) {
        _birthdayLabel.text = u.birthDay;
    }
    
    if (u.carrier) {
        _workLabel.text = u.carrier;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    //获取位置
    [self getCity];
    
    [self getAddress];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAddress
{
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getAddress:^(NSString *addressString) {
            DLog(@"市：%@",addressString);
            
            _city = addressString;
            
        }] ;
        
    }
}

-(void)getCity
{
//    __block __weak PersonalMessageViewController *wself = self;
    
    if (IS_IOS8) {
        
        [[CCLocationManager shareLocation]getCity:^(NSString *cityString) {
            DLog(@"省：%@",cityString);
//            [wself setLabelText:cityString];
            
        }];
    }
}

//从相册获取图片

-(void)takePictureClick
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"从相册选择",nil];
    [actionSheet showInView:self.view];
}

#pragma mark -

#pragma UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        default:
            
            break;
    }
}

#pragma mark -

#pragma UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    //    [picker dismissModalViewControllerAnimated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    
    DLog(@"imageFile->>%@",imageFilePath);
    
    success = [fileManager fileExistsAtPath:imageFilePath];
    
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    self.avatarImageView.image = selfPhoto;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    return newimage;
}

#pragma mark - UITextFieldDelegate

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nickNameTextField resignFirstResponder];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_nickNameTextField resignFirstResponder];
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"男",@"女"] title:@"选择性别"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr)
            {
                [_sexLabel setText:selectedStr];
            };
        }else if(indexPath.row == 3)
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDateViewWithTitle:@"选择日期"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr)
            {
                [_birthdayLabel setText:selectedStr];
            };
        }else if (indexPath.row == 4)
        {
            ZHPickView *pickView = [[ZHPickView alloc] init];
            [pickView setDataViewWithItem:@[@"学生", @"教师", @"上班族", @"老板", @"公务员", @"自由", @"退休", @"其他"] title:@"选择职业"];
            [pickView showPickView:self];
            pickView.block = ^(NSString *selectedStr)
            {
                [_workLabel setText:selectedStr];
            };
        }else if (indexPath.row == 0)
        {
            //生成二维码
            QrCodeView* qrview = [[QrCodeView alloc]initWithFrame:self.view.bounds];
            [self.view addSubview:qrview];
        }
    }else if(indexPath.section == 0)
    {
        //获取头像
        [self takePictureClick];
    }
}


- (IBAction)changeUserDetails:(id)sender {
    
    [[LoginManager getInstance] requestWithOsVersion:[NSString stringWithFormat:@"%f",[CommonMethods getIOSVersion]] IpAddress:[CommonMethods deviceIPAdress] CityName:_city NickName:_nickNameTextField.text Sex:_sexLabel.text BirthDay:_birthdayLabel.text Work:_workLabel.text];
    
}
@end
