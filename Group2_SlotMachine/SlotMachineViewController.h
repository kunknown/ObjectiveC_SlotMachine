//
//  SlotMachineViewController.h
//  Group2_SlotMachine
//
//  Created by Kaushal Patel on 7/16/14.
//  Copyright (c) 2014 University of Cincinnati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

@interface SlotMachineViewController : UIViewController
<UIPickerViewDataSource, UIPickerViewDelegate, UIAccelerometerDelegate>
{
    AVAudioPlayer* player1;
    AVAudioPlayer* player2;
    AVAudioPlayer* player3;
    NSArray* iconList;
    NSString* slotOneValue;
    NSString* slotTwoValue;
    NSString* slotThreeValue;
    NSInteger tempSlotOneValue, tempSlotTwoValue, tempSlotThreeValue;
}

@property (weak, nonatomic) IBOutlet UIPickerView *slotOne;
@property (weak, nonatomic) IBOutlet UIPickerView *slotTwo;
@property (weak, nonatomic) IBOutlet UIPickerView *slotThree;

@property (weak, nonatomic) IBOutlet UILabel *lblBalance;
@property int balance;

@property(strong, nonatomic) CMMotionManager* motionManager;
@property double filteredX;
@property double filteredY;
@property double filteredZ;
@property double xVelocity;

- (IBAction)betIncrease;
- (IBAction)betDecrease;
- (IBAction)betMAX;
@property (weak, nonatomic) IBOutlet UIButton *btnBetIncrease;
@property (weak, nonatomic) IBOutlet UIButton *btnBetDecrease;
@property (weak, nonatomic) IBOutlet UIButton *btnBetMax;
@property (weak, nonatomic) IBOutlet UILabel *lblBetAmount;
@property int betAmount;


@end
