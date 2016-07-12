//
//  ChoiceView.m
//  test
//
//  Created by Mr.Yang on 16/5/25.
//  Copyright © 2016年 Mr.Yang. All rights reserved.
//

#import "ChoiceView.h"
//#import "MZImage.h"
#import <UIImageView+WebCache.h>

#import "MZCollectionViewCell.h"

@interface ChoiceView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, assign)CGFloat cellHeigh;
//@property (nonatomic, assign)CGFloat cellWidth;

//@property (nonatomic, strong)UIImageView * imageVIew;
@property (nonatomic, assign)BOOL isLoading;

@end

@implementation ChoiceView



-(NSMutableArray *)array{
    if (!_array) {
        _array = [[NSMutableArray alloc] initWithCapacity:0];
        MZImageItem * image = [[MZImageItem alloc] init];
        image.isPlaceHolder = 1;
        image.image = [UIImage imageNamed:@"add"];
        [_array addObject:image];
    }
    return _array;
}

-(void)setImageURL:(NSString *)imageURL{
    _imageURL = imageURL;
    [self.collection reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
}
-(void)setIsDefault:(BOOL)isDefault{
    [self.array removeObjectAtIndex:0];
    MZImageItem * image = [[MZImageItem alloc] init];
    image.isPlaceHolder = 1;
    image.image = [UIImage imageNamed:@"add"];
    [self.array addObject:image];
    self.isFlower = 0;
    [self.collection reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    
}
- (instancetype)initWithFrame:(CGRect)frame withController:(UIViewController *)controller{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.controller = controller;
        self.isFlower = 0;
        
        self.cellHeigh = frame.size.height - 40;

        
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        self.collection.backgroundColor = [UIColor whiteColor];
        self.collection.delegate = self;
        self.collection.dataSource = self;
        [self.collection registerNib:[UINib nibWithNibName:@"MZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MZCollectionViewCellID"];
        
        [self addSubview:self.collection];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 10)];
        self.title.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.title];
    }
    
    return self;
}

#pragma collect的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MZCollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MZCollectionViewCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (!self.imageURL) {
        MZImageItem * image = self.array[indexPath.row];
//        image.isPlaceHolder = 0;
        cell.image.image = image.image;
    }
    
    else{
//        [cell.image sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:[UIImage imageNamed:@"headImage"]];
        WS(weakSelf, self);
        self.isLoading = 1;
        [cell.image sd_setImageWithURL:[NSURL URLWithString:self.imageURL] placeholderImage:[UIImage imageNamed:@"headImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
               [weakSelf complanDownImage:cell];
            });
        }];
    }
    
    return cell;
}
//设置每个单元格的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size=CGSizeMake(75, 75);
    return size;
}
//选中移除
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.isLoading) {
        [MyTool showWarningInformationTitle:@"提示" message:@"图片正在下载中，请稍后操作！" intoView:self.controller];
        return;
    }
    
    
    MZImageItem * image = self.array[indexPath.row];
    if (image.isPlaceHolder) {
        //拍照
        UIActionSheet * actionsheet = [[UIActionSheet alloc]
                                       initWithTitle:nil
                                       delegate:self
                                       cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                       otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
        
        [actionsheet showInView:self];
    }else{
        //删除
        [self.array removeObjectAtIndex:indexPath.row];
        if (self.isFlower) {
            MZImageItem * image = [[MZImageItem alloc] init];
            image.isPlaceHolder = 1;
            image.image = [UIImage imageNamed:@"add"];
            self.isFlower = 0;
           
            [self.array addObject:image];
             NSLog(@"-----------%@", self.array);
        }
        
        [self.collection reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
    }
}
//能否被选中
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
        return 1;
}
////移动
//- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath
//{
//    
//    NSMutableArray * tempArray=[_array mutableCopy];
//    [_array removeObjectAtIndex:fromIndexPath.item];
//    [_array insertObject:tempArray[fromIndexPath.item] atIndex:toIndexPath.item];
//    
//}
//- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath
//{
//    if (toIndexPath.item==0) {
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
//}
////某个能否移动
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
//{
//        return YES;
//}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (DEVICE_WIDTH - 265)/ 3.0;
}

//定义每组UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(25, 10, 10, 10);//上，左，下， 右整体的相对位置
}

#pragma 拍照等
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}
- (void)takePhoto//开始拍照
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.controller presentViewController:picker animated:1 completion:^{
            nil;
        }];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
- (void)LocalPhoto//打开本地相册
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self.controller presentViewController:picker animated:1 completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info//选择图片后进入

{
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    // 设置时间格式
    //    formatter.dateFormat = @"yyyyMMddHHmmss";
    //    NSString *str = [formatter stringFromDate:[NSDate date]];
    //    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@", prefixName, str, type];
    //
    //    NSString * imageName=[MyTool randomNameType:@"jpg" prefixName:@"avart"];
    //
    //
    
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];//修改后图片
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        
        [picker dismissViewControllerAnimated:1 completion:^{}];
        
        MZImageItem * imageItem = [[MZImageItem alloc] init];
        imageItem.isPlaceHolder = 0;
        imageItem.image = [UIImage imageWithData:data];
        [self.array insertObject:imageItem atIndex:self.array.count - 1];
        if (self.array.count == 2) {
            [self.array removeObjectAtIndex:self.array.count - 1];
            self.isFlower = 1;
        }
        self.isXiuGai = 1;
        [self.collection reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
        
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:1 completion:^{}];
}


- (void)complanDownImage:(MZCollectionViewCell *)cell{
    
    self.isLoading = 0;
    
    
    MZImageItem * imageItem = [[MZImageItem alloc] init];
    imageItem.isPlaceHolder = 1;
    imageItem.image = cell.image.image;
    [self.array insertObject:imageItem atIndex:self.array.count - 1];
    if (self.array.count == 2) {
        [self.array removeObjectAtIndex:self.array.count - 1];
        self.isFlower = 1;
    }
    self.imageURL = nil;
}

@end
