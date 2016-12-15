//
//  ViewController.m
//  Group2_SlotMachine
//
//  Created by Kaushal Patel on 7/16/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    player1 = [AVAudioPlayer alloc];
    
    
    NSBundle* bundle =[NSBundle mainBundle];
    NSString* fileName=[NSString stringWithFormat:@"music1"];
    NSString* filePath=[bundle pathForResource:fileName ofType:@".mp3"];
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    player1=[player1 initWithContentsOfURL:fileURL error:nil];
    player1.numberOfLoops = -1;
    [player1 play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
