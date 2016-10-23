//
//  ViewController.m
//  UIImage-Resize
//
//  Created by 能登 要 on 2016/10/23.
//  Copyright © 2016年 Kaname Noto. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+IDResize.h"

@interface ViewController ()
{
    NSArray<NSString *> *_files;
    NSMutableArray<UIImage *> *_images;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _images = [NSMutableArray<UIImage *> array];
    
    NSArray<NSString *> *files = @[ [[NSBundle mainBundle] pathForResource:@"DSC05297" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"DSC05316" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"DSC05578" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"IMG_7768" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"IMG_9599" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"IMG_9626" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"IMG_9626" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"IMG_9565" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"IMG_9488" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"DSC05532" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"DSC05413" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"DSC05401" ofType:@"JPG"]
                                   ,[[NSBundle mainBundle] pathForResource:@"DSC05375" ofType:@"JPG"]
                                   ];
    
    [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IDPResizeOption *resizeOption = [IDPResizeOption resizeOptionWithSize:CGSizeMake(114,114)];
        resizeOption.tag = idx;
        
        NSData *data = [NSData dataWithContentsOfFile:obj];
        UIImage *imaeg = [UIImage imageWithData:data];
        [imaeg resizeWithOptions:@[resizeOption] progress:^(NSData * _Nullable data, IDPResizeOption * _Nonnull option) {
                UIImage *resizedImage = [UIImage imageWithData:data];
                [_images addObject:resizedImage];
            }
            completion:^{
                if( _images.count == files.count ){
                    _files = files;
                    [self.tableView reloadData];
                }
            }
         ];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *imageView = [cell viewWithTag:1];
    imageView.image = _images[indexPath.row];

    UILabel *label = [cell viewWithTag:2];
    label.text = [_files[indexPath.row] lastPathComponent];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
