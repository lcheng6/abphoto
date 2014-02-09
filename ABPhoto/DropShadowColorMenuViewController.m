//
//  DropShadowColorMenuViewController.m
//  ABPhoto
//
//  Created by Liang Cheng on 2/9/14.
//  Copyright (c) 2014 Liang Cheng. All rights reserved.
//

#import "DropShadowColorMenuViewController.h"

@interface DropShadowColorMenuViewController ()

@end

@implementation DropShadowColorMenuViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIColor * ) getShadowColor {
    return [UIColor whiteColor];
}

+ (CGSize) recommededSize
{
    CGSize size;
    size.height = 80;
    //5 images and 6 gaps of 10 units between each
    size.width = 65 * 5 + 10 * 5;
    
    return size;
}

@end
