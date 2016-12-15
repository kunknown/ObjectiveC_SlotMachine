//
//  SlotMachineViewController.m
//  Group2_SlotMachine
//
//  Created by Kaushal Patel on 7/16/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import "SlotMachineViewController.h"
#define MAX_INT 45;

@interface SlotMachineViewController ()

@end

@implementation SlotMachineViewController
@synthesize slotOne, slotTwo, slotThree;
@synthesize xVelocity, filteredX, filteredY, filteredZ;
@synthesize balance, lblBalance;
@synthesize lblBetAmount, betAmount;
@synthesize btnBetIncrease, btnBetDecrease, btnBetMax;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    player1 = [AVAudioPlayer alloc];
    player2 = [AVAudioPlayer alloc];
    player3 = [AVAudioPlayer alloc];
    
    NSBundle* bundle =[NSBundle mainBundle];
    NSString* fileName=[NSString stringWithFormat:@"music1"];
    NSString* filePath=[bundle pathForResource:fileName ofType:@".mp3"];
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    player1=[player1 initWithContentsOfURL:fileURL error:nil];
    
    slotOne.userInteractionEnabled = NO;
    slotTwo.userInteractionEnabled = NO;
    slotThree.userInteractionEnabled = NO;
    
    [slotOne setDataSource:self];
    [slotTwo setDataSource:self];
    [slotThree setDataSource:self];
    [slotOne setDelegate:self];
    [slotTwo setDelegate:self];
    [slotThree setDelegate:self];
    
    balance = 100;
    NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
    [lblBalance setText:sBalance];
    
    betAmount = 5;
    NSString* sBetAmount = [NSString stringWithFormat:@"$ %d",betAmount];
    [lblBetAmount setText:sBetAmount];
    
    [self playGame];
}

-(void) playGame
{
    self.motionManager = [[CMMotionManager alloc] init];
    xVelocity = 0.0;
    self.motionManager.accelerometerUpdateInterval = 0.1;
    [self.motionManager startAccelerometerUpdatesToQueue: [NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
     {
         double rawX = accelerometerData.acceleration.x;
         double rawY = accelerometerData.acceleration.y;
         double rawZ = accelerometerData.acceleration.z;
         filteredX = rawX - ((rawX * 0.1)+ filteredX * 0.9);
         filteredY = rawY - ((rawY * 0.1)+ filteredY * 0.9);
         filteredZ = rawZ - ((rawZ * 0.1)+ filteredZ * 0.9);
         
         if (rawY <= -1.5)
         {
             NSBundle* bundle =[NSBundle mainBundle];
             NSString* fileName=[NSString stringWithFormat:@"music2"];
             NSString* filePath=[bundle pathForResource:fileName ofType:@".m4a"];
             NSURL* fileURL = [NSURL fileURLWithPath:filePath];
             player2=[player2 initWithContentsOfURL:fileURL error:nil];
             [player2 play];
             
             balance = balance - betAmount;
             NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
             [lblBalance setText:sBalance];
             [self.motionManager stopAccelerometerUpdates];
             [btnBetMax setEnabled:false];
             [btnBetIncrease setEnabled:false];
             [btnBetDecrease setEnabled:false];
             [btnBetMax setAlpha:0.0];
             [btnBetIncrease setAlpha:0.0];
             [btnBetDecrease setAlpha:0.0];
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 NSInteger slotOneValueInteger = (arc4random()%[slotOne numberOfRowsInComponent:0]);//[NSString stringWithFormat:@"Icon %d", [slotOne selectedRowInComponent:0]];
                 slotOneValue = [NSString stringWithFormat:@"Icon %d",slotOneValueInteger];
                 NSLog(@"%@",slotOneValue);
                 [slotOne selectRow:slotOneValueInteger inComponent:0 animated:YES];
             });
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 NSInteger slotTwoValueInteger = (arc4random()%[slotTwo numberOfRowsInComponent:0]);//[NSString stringWithFormat:@"Icon %d", [slotTwo selectedRowInComponent:0]];
                 slotTwoValue = [NSString stringWithFormat:@"Icon %d",slotTwoValueInteger];
                 NSLog(@"%@",slotTwoValue);
                 [slotTwo selectRow:slotTwoValueInteger inComponent:0 animated:YES];
             });
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 NSInteger slotThreeValueInteger = (arc4random()%[slotThree numberOfRowsInComponent:0]);//[NSString stringWithFormat:@"Icon %d", [slotThree selectedRowInComponent:0]];
                 slotThreeValue = [NSString stringWithFormat:@"Icon %d",slotThreeValueInteger];
                 NSLog(@"%@",slotThreeValue);
                 [slotThree selectRow:slotThreeValueInteger inComponent:0 animated:YES];
             });
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self updateBalance];
                 
             });
         }
     }];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return MAX_INT;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //row = row % 45;//(arc4random() % 45);
    NSBundle* bundle = [NSBundle mainBundle];
    NSString* fileName = [NSString stringWithFormat:@"Icon %d",row+1];
    NSString* filePath = [bundle pathForResource:fileName ofType:@"jpg"];
    UIImage* image = [UIImage imageWithContentsOfFile:filePath];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    [imageView setImage:image];
    return imageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)organizeSlotOne
{
    if ([slotOneValue isEqualToString:@"Icon 0"]) {
        tempSlotOneValue = 1;
    }
    else if ([slotOneValue isEqualToString:@"Icon 2"]||[slotOneValue isEqualToString:@"Icon 1"]) {
        tempSlotOneValue = 2;
    }
    else if ([slotOneValue isEqualToString:@"Icon 3"]||[slotOneValue isEqualToString:@"Icon 5"]||[slotOneValue isEqualToString:@"Icon 4"]) {
        tempSlotOneValue = 3;
    }
    else if ([slotOneValue isEqualToString:@"Icon 7"]||[slotOneValue isEqualToString:@"Icon 8"]||[slotOneValue isEqualToString:@"Icon 9"]||[slotOneValue isEqualToString:@"Icon 6"]) {
        tempSlotOneValue = 4;
    }
    else if ([slotOneValue isEqualToString:@"Icon 10"]||[slotOneValue isEqualToString:@"Icon 12"]||[slotOneValue isEqualToString:@"Icon 13"]||[slotOneValue isEqualToString:@"Icon 14"]||[slotOneValue isEqualToString:@"Icon 11"]) {
        tempSlotOneValue = 5;
    }
    else if ([slotOneValue isEqualToString:@"Icon 15"]||[slotOneValue isEqualToString:@"Icon 17"]||[slotOneValue isEqualToString:@"Icon 18"]||[slotOneValue isEqualToString:@"Icon 19"]||[slotOneValue isEqualToString:@"Icon 20"]||[slotOneValue isEqualToString:@"Icon 16"]) {
        tempSlotOneValue = 6;
    }
    else if ([slotOneValue isEqualToString:@"Icon 21"]||[slotOneValue isEqualToString:@"Icon 23"]||[slotOneValue isEqualToString:@"Icon 24"]||[slotOneValue isEqualToString:@"Icon 25"]||[slotOneValue isEqualToString:@"Icon 26"]||[slotOneValue isEqualToString:@"Icon 27"]||[slotOneValue isEqualToString:@"Icon 22"]) {
        tempSlotOneValue = 7;
    }
    else if ([slotOneValue isEqualToString:@"Icon 28"]||[slotOneValue isEqualToString:@"Icon 30"]||[slotOneValue isEqualToString:@"Icon 31"]||[slotOneValue isEqualToString:@"Icon 32"]||[slotOneValue isEqualToString:@"Icon 33"]||[slotOneValue isEqualToString:@"Icon 34"]||[slotOneValue isEqualToString:@"Icon 35"]||[slotOneValue isEqualToString:@"Icon 29"]) {
        tempSlotOneValue = 8;
    }
    else if ([slotOneValue isEqualToString:@"Icon 36"]||[slotOneValue isEqualToString:@"Icon 38"]||[slotOneValue isEqualToString:@"Icon 39"]||[slotOneValue isEqualToString:@"Icon 40"]||[slotOneValue isEqualToString:@"Icon 41"]||[slotOneValue isEqualToString:@"Icon 42"]||[slotOneValue isEqualToString:@"Icon 43"]||[slotOneValue isEqualToString:@"Icon 44"]||[slotOneValue isEqualToString:@"Icon 37"]) {
        tempSlotOneValue = 9;
    }
}

-(void)organizeSlotThree
{
    if ([slotThreeValue isEqualToString:@"Icon 0"]) {
        tempSlotThreeValue = 1;
    }
    else if ([slotThreeValue isEqualToString:@"Icon 2"]||[slotThreeValue isEqualToString:@"Icon 1"]) {
        tempSlotThreeValue = 2;
    }
    else if ([slotThreeValue isEqualToString:@"Icon 3"]||[slotThreeValue isEqualToString:@"Icon 5"]||[slotThreeValue isEqualToString:@"Icon 4"]) {
        tempSlotThreeValue = 3;
    }
    else if ([slotThreeValue isEqualToString:@"Icon 6"]||[slotThreeValue isEqualToString:@"Icon 8"]||[slotThreeValue isEqualToString:@"Icon 9"]||[slotThreeValue isEqualToString:@"Icon 7"]) {
        tempSlotThreeValue = 4;
    }
    else if ([slotThreeValue isEqualToString:@"Icon 10"]||[slotThreeValue isEqualToString:@"Icon 12"]||[slotThreeValue isEqualToString:@"Icon 13"]||[slotThreeValue isEqualToString:@"Icon 14"]||[slotThreeValue isEqualToString:@"Icon 11"]) {
        tempSlotThreeValue = 5;
    }
    else if ([slotThreeValue isEqualToString:@"Icon 15"]||[slotThreeValue isEqualToString:@"Icon 17"]||[slotThreeValue isEqualToString:@"Icon 18"]||[slotThreeValue isEqualToString:@"Icon 19"]||[slotThreeValue isEqualToString:@"Icon 20"]||[slotThreeValue isEqualToString:@"Icon 16"]) {
        tempSlotThreeValue = 6;
    }
    else if ([slotThreeValue isEqualToString:@"Icon 21"]||[slotThreeValue isEqualToString:@"Icon 23"]||[slotThreeValue isEqualToString:@"Icon 24"]||[slotThreeValue isEqualToString:@"Icon 25"]||[slotThreeValue isEqualToString:@"Icon 26"]||[slotThreeValue isEqualToString:@"Icon 27"]||[slotThreeValue isEqualToString:@"Icon 22"]) {
        tempSlotThreeValue = 7;
    }
    else if ([slotThreeValue isEqualToString:@"Icon 29"]||[slotThreeValue isEqualToString:@"Icon 30"]||[slotThreeValue isEqualToString:@"Icon 31"]||[slotThreeValue isEqualToString:@"Icon 32"]||[slotThreeValue isEqualToString:@"Icon 33"]||[slotThreeValue isEqualToString:@"Icon 34"]||[slotThreeValue isEqualToString:@"Icon 35"]||[slotThreeValue isEqualToString:@"Icon 28"]) {
        tempSlotThreeValue = 8;
    }
    else if ([slotThreeValue isEqualToString:@"Icon 37"]||[slotThreeValue isEqualToString:@"Icon 38"]||[slotThreeValue isEqualToString:@"Icon 39"]||[slotThreeValue isEqualToString:@"Icon 40"]||[slotThreeValue isEqualToString:@"Icon 41"]||[slotThreeValue isEqualToString:@"Icon 42"]||[slotThreeValue isEqualToString:@"Icon 43"]||[slotThreeValue isEqualToString:@"Icon 44"]||[slotThreeValue isEqualToString:@"Icon 36"]) {
        tempSlotThreeValue = 9;
    }
}

-(void)organizeSlotTwo
{
    if ([slotTwoValue isEqualToString:@"Icon 0"]) {
        tempSlotTwoValue = 1;
    }
    else if ([slotTwoValue isEqualToString:@"Icon 2"]||[slotTwoValue isEqualToString:@"Icon 1"]) {
        tempSlotTwoValue = 2;
    }
    else if ([slotTwoValue isEqualToString:@"Icon 4"]||[slotTwoValue isEqualToString:@"Icon 5"]||[slotTwoValue isEqualToString:@"Icon 3"]) {
        tempSlotTwoValue = 3;
    }
    else if ([slotTwoValue isEqualToString:@"Icon 7"]||[slotTwoValue isEqualToString:@"Icon 8"]||[slotTwoValue isEqualToString:@"Icon 9"]||[slotTwoValue isEqualToString:@"Icon 6"]) {
        tempSlotTwoValue = 4;
    }
    else if ([slotTwoValue isEqualToString:@"Icon 11"]||[slotTwoValue isEqualToString:@"Icon 12"]||[slotTwoValue isEqualToString:@"Icon 13"]||[slotTwoValue isEqualToString:@"Icon 14"]||[slotTwoValue isEqualToString:@"Icon 10"]) {
        tempSlotTwoValue = 5;
    }
    else if ([slotTwoValue isEqualToString:@"Icon 16"]||[slotTwoValue isEqualToString:@"Icon 17"]||[slotTwoValue isEqualToString:@"Icon 18"]||[slotTwoValue isEqualToString:@"Icon 19"]||[slotTwoValue isEqualToString:@"Icon 20"]||[slotTwoValue isEqualToString:@"Icon 15"]) {
        tempSlotTwoValue = 6;
    }
    else if ([slotTwoValue isEqualToString:@"Icon 22"]||[slotTwoValue isEqualToString:@"Icon 23"]||[slotTwoValue isEqualToString:@"Icon 24"]||[slotTwoValue isEqualToString:@"Icon 25"]||[slotTwoValue isEqualToString:@"Icon 26"]||[slotTwoValue isEqualToString:@"Icon 27"]||[slotTwoValue isEqualToString:@"Icon 21"]) {
        tempSlotTwoValue = 7;
    }
    else if ([slotTwoValue isEqualToString:@"Icon 29"]||[slotTwoValue isEqualToString:@"Icon 30"]||[slotTwoValue isEqualToString:@"Icon 31"]||[slotTwoValue isEqualToString:@"Icon 32"]||[slotTwoValue isEqualToString:@"Icon 33"]||[slotTwoValue isEqualToString:@"Icon 34"]||[slotTwoValue isEqualToString:@"Icon 35"]||[slotTwoValue isEqualToString:@"Icon 28"]) {
        tempSlotTwoValue = 8;
    }
    else if ([slotTwoValue isEqualToString:@"Icon 37"]||[slotTwoValue isEqualToString:@"Icon 38"]||[slotTwoValue isEqualToString:@"Icon 39"]||[slotTwoValue isEqualToString:@"Icon 40"]||[slotTwoValue isEqualToString:@"Icon 41"]||[slotTwoValue isEqualToString:@"Icon 42"]||[slotTwoValue isEqualToString:@"Icon 43"]||[slotTwoValue isEqualToString:@"Icon 44"]||[slotTwoValue isEqualToString:@"Icon 36"]) {
        tempSlotTwoValue = 9;
    }
}

-(void) updateBalance
{
    [self organizeSlotOne];
    [self organizeSlotTwo];
    [self organizeSlotThree];
    
    if (tempSlotOneValue == tempSlotTwoValue) {
        if (tempSlotTwoValue == tempSlotThreeValue) {
            NSBundle* bundle =[NSBundle mainBundle];
            NSString* fileName=[NSString stringWithFormat:@"music3"];
            NSString* filePath=[bundle pathForResource:fileName ofType:@".mp3"];
            NSURL* fileURL = [NSURL fileURLWithPath:filePath];
            player3=[player3 initWithContentsOfURL:fileURL error:nil];
            
            
            if (tempSlotOneValue == 1) {
                balance = balance + (betAmount*50);
                NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
                [lblBalance setText:sBalance];
                [player3 play];
            }else if (tempSlotOneValue == 2) {
                balance = balance + (betAmount*40);
                NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
                [lblBalance setText:sBalance];
                [player3 play];
            }else if (tempSlotOneValue == 3) {
                balance = balance + (betAmount*35);
                NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
                [lblBalance setText:sBalance];
                [player3 play];
            }else if (tempSlotOneValue == 4) {
                balance = balance + (betAmount*30);
                NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
                [lblBalance setText:sBalance];
                [player3 play];
            }else if (tempSlotOneValue == 5) {
                balance = balance + (betAmount*25);
                NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
                [lblBalance setText:sBalance];
                [player3 play];
            }else if (tempSlotOneValue == 6) {
                balance = balance + (betAmount*20);
                NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
                [lblBalance setText:sBalance];
                [player3 play];
            }else if (tempSlotOneValue == 7) {
                balance = balance + (betAmount*15);
                NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
                [lblBalance setText:sBalance];
                [player3 play];
            }else if (tempSlotOneValue == 8) {
                balance = balance + (betAmount*10);
                NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
                [lblBalance setText:sBalance];
                [player3 play];
            }else if (tempSlotOneValue == 9) {
                balance = balance + (betAmount*5);
                NSString* sBalance = [NSString stringWithFormat:@"$ %d",balance];
                [lblBalance setText:sBalance];
                [player3 play];
            }
            
        }
    }
    
    if (balance > 0) {
        betAmount = 5;
        NSString* sBetAmount = [NSString stringWithFormat:@"$ %d",betAmount];
        [lblBetAmount setText:sBetAmount];
        [self playGame];
        [btnBetMax setEnabled:true];
        [btnBetIncrease setEnabled:true];
        [btnBetDecrease setEnabled:true];
        [btnBetMax setAlpha:1.0];
        [btnBetIncrease setAlpha:1.0];
        [btnBetDecrease setAlpha:1.0];
        
    }else if (balance <= 0)
    {
        UIAlertView* error = [UIAlertView alloc];
        error = [error initWithTitle:@"Game Over" message:@"Your balance is $0." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [error show];
    }
    
}

- (IBAction)betIncrease
{
    if (betAmount < balance)
    {
        betAmount = betAmount + 5;
        NSString* sBetAmount = [NSString stringWithFormat:@"$ %d",betAmount];
        [lblBetAmount setText:sBetAmount];
        
    }else if (betAmount == balance)
    {
        UIAlertView* error = [UIAlertView alloc];
        error = [error initWithTitle:@"Error!" message:@"Bet amount cannot exceed your balance." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [error show];
    }
}

- (IBAction)betDecrease
{
    if (betAmount > 5) {
        betAmount = betAmount - 5;
        NSString* sBetAmount = [NSString stringWithFormat:@"$ %d",betAmount];
        [lblBetAmount setText:sBetAmount];
    }else if (betAmount == 5)
    {
        UIAlertView* error = [UIAlertView alloc];
        error = [error initWithTitle:@"Error!" message:@"Bet amount cannot be lower than $5." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [error show];
    }
}

- (IBAction)betMAX {
    betAmount = balance;
    NSString* sBetAmount = [NSString stringWithFormat:@"$ %d",betAmount];
    [lblBetAmount setText:sBetAmount];
}

@end
