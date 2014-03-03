//
//  DSSettingsViewController.m
//  Clock
//
//  Created by darcystudio on 3/3/14.
//  Copyright (c) 2014 darcystudio. All rights reserved.
//

#import "DSSettingsViewController.h"

@interface DSSettingsViewController ()

@end

@implementation DSSettingsViewController

@synthesize settingsCallback;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        self.title = @"Settings";
        
        keepScreenOn = NO;
        pomodoroClockOn = NO;
        settingsCallback = nil;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBackButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
    // 讀取使用者的設定，使用NSUserDefaults元件來達成此功能
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	keepScreenOn = [userDefaults boolForKey:@"user.keepScreenOn"];
    pomodoroClockOn = [userDefaults boolForKey:@"user.pomodoroClockOn"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UISwitch *theSwitch = nil;
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        
        theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(255, 7, 55, 31)];
        theSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [cell.contentView addSubview:theSwitch];
        [theSwitch addTarget:self action:@selector(clickSwitchButton:) forControlEvents:UIControlEventValueChanged];
    }
    
    // Configure the cell...
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Keep Screen On";
            cell.detailTextLabel.text = @"";
            theSwitch.tag = 1000;
            [theSwitch setOn:keepScreenOn];
            break;
            
        case 1:
            cell.textLabel.text = @"Pomodoro Clock On";
            cell.detailTextLabel.text = @"Ring at 0-25-30-55 minutes each hour.";
            theSwitch.tag = 1001;
            [theSwitch setOn:pomodoroClockOn];
            break;
            
        default:
            break;
    }
    
    
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

- (IBAction)clickBackButton:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)clickSwitchButton:(id)sender
{
    UISwitch *theSwitch = sender;
    //NSLog(@"%d %d", theSwitch.tag, theSwitch.isOn);
    
    if(theSwitch.tag == 1000)
    {
        keepScreenOn = theSwitch.isOn;
    }
    else if(theSwitch.tag == 1001)
    {
        pomodoroClockOn = theSwitch.isOn;
    }
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:keepScreenOn forKey:@"user.keepScreenOn"];
    [userDefaults setBool:pomodoroClockOn forKey:@"user.pomodoroClockOn"];
    [userDefaults synchronize];
    
    
    if(settingsCallback != nil)
    {
        [settingsCallback performSelector:@selector(onSettingsCallback) withObject:self];
    }

}


@end
