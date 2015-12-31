//
//  FollowViewController.m
//  GroupFollowBack
//
//  Created by Osama Rabie on 12/31/15.
//  Copyright © 2015 Osama Rabie. All rights reserved.
//

#import "FollowViewController.h"
#import <STTwitter.h>
#import "UICKeyChainStore.h"

@import GoogleMobileAds;


@interface FollowViewController ()

@end

@implementation FollowViewController
{
    __weak IBOutlet UIImageView *userPicImageView;
    __weak IBOutlet UILabel *usernameLabel;
    __weak IBOutlet UIActivityIndicatorView *busy;
    __weak IBOutlet UIButton *followButton;
    __weak IBOutlet GADBannerView *squareBannerView;
    NSDictionary* currentUserServer;
    NSDictionary* currentUserTwitter;
    NSString* cons;
    NSString* sec;
    __weak IBOutlet UILabel *limitLabel;
    UICKeyChainStore* wrapper;
}

@synthesize account;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:[account username]];
    [busy setAlpha:0.0];
    wrapper = [UICKeyChainStore keyChainStore];
    
    squareBannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    squareBannerView.rootViewController = self;
    [squareBannerView setAdSize:kGADAdSizeMediumRectangle];
    [squareBannerView loadRequest:[GADRequest request]];
    [self loadProfile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadProfile
{
    dispatch_async( dispatch_get_main_queue(), ^{
        [busy setAlpha:1.0];
        [followButton setAlpha:0.0];
    });
    
    
    NSArray* tokens = [@"NC8lwe5di4ACp90lx3oilTavG##TK7VIkRlk40SER6DjIivFeNSFiYaX1qn5nRttHiozctMBaBvxD##ROUQ3Mibuu8ddJT7Y2k4KbKEF##0Oba6hbh0KnvaUmqXm9yLQg7ImvcHOqFXWxTWPPIXWP2vOBdsk##q2b7JceThNS1I9YZ9oTqg##R21QyuxRuVmoRCUvLRMwZPMlMHVi7VFq8YzpZHpaN38##g7Fs6RQDNvxi0FGOWaIfOeLmB##rUfmp5Ptmqk5AFsfImmDuLAlCOy1CqjKpoO2m02QnMFOVGGGYq##VtJMjqvvjWBaIl28ouQOix8Zj##R1WDTgpk6bLuwC4tVc0vKEthCAReFajNevYNhJ6e8OFrBpfSAh##ptpLmbMHWDt1NLW7N0AfGeFQu##61UJdH443a2mlCC9D7dhZQIiHmDTosRNtGIzjQQuUGWef3X7ge##LX4rAiSkk3g4QF73sAnEwJ88Q##D2NxdgfV3fJshYgWUUx9T2ShxwKXyQp0xZKqgu0I0NRjDvYu7b##TPpyD684axOw2kJhw1iwQ##Eamt1KNJ93xBhjrTSpltaqagEQXCKd9VlXqyIEo##FBCY6rqEJ3qx2CKeEHqWw##hYTuQ9wzhdcpv7Rq3kDHXlUU6EqBvL4dLZFOILpxDh4##yvey189T4CdnFWDvYaXA##LuEqQl69kiUfK1nQOoZtjWX1qCRYbeHflQZcz2zE" componentsSeparatedByString:@"##"];
    
    NSString* access = @"";
    NSString* secret = @"";
    NSString* table = @"";
    NSInteger randomNumber = arc4random() % 3000;
    
    if(randomNumber <= 1000)
    {
        table = @"U11S";
        access = [tokens objectAtIndex:0];
        secret = [tokens objectAtIndex:1];
    }else if(randomNumber <= 2000)
    {
        table = @"U66S";
        access = [tokens objectAtIndex:10];
        secret = [tokens objectAtIndex:11];
    }else if(randomNumber <= 3000)
    {
        table = @"U77S";
        access = [tokens objectAtIndex:12];
        secret = [tokens objectAtIndex:13];
    }
    
    cons = access;
    sec = secret;

    NSString* url = [NSString stringWithFormat:@"%@%@%@",@"http://osamalogician.com/arabDevs/DefneAdefak/V2/autoFollow/profilesNormal",table,@".php"];
    
    NSString *requestString = url;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc]initWithURL:[NSURL URLWithString: requestString]]
                                       queue:queue
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (!error && httpResponse.statusCode >= 200 && httpResponse.statusCode <300) {
             NSError* error2;
             NSArray* users = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error2];
             if(!error2)
             {
                 if([users count] > 0)
                 {
                     currentUserServer = [users objectAtIndex:0];
                     SLRequest *twitterInfoRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"] parameters:[NSDictionary dictionaryWithObject:[currentUserServer objectForKey:@"name"] forKey:@"screen_name"]];
                     [twitterInfoRequest setAccount:account];
                     [twitterInfoRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             if ([urlResponse statusCode] == 429) {
                                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:@"لقد وصلت للحد المسموح للمتاعبة من تويتر، رجاء المحاولة بعد ٣٠ دقيقة" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                 [alert show];
                                 return;
                             }
                             if (error) {
                                 [self loadProfile];
                                 return;
                             }
                             if (responseData) {
                                 NSError *error = nil;
                                 currentUserTwitter = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                                 [self updateUI];
                             }else
                             {
                                 [self loadProfile];
                             }
                         });
                     }];
                 }else
                 {
                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:@"لا يوجد حسابات تتابعها الأن. جرب بعد فترة قليلة" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [alert show];
                 }
             }else
             {
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:@"حدث خطأ، رجاء التكرار بعد فترة قليلة" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }
         }else
         {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:@"حدث خطأ، رجاء التكرار بعد فترة قليلة" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
     }];
}

-(void)updateUI
{
    [self getImagesAsync];
    NSString* string = [wrapper stringForKey:@"ff"];
    dispatch_async( dispatch_get_main_queue(), ^{
        [busy setAlpha:0.0];
        [followButton setAlpha:1.0];
        [usernameLabel setText:[currentUserTwitter objectForKey:@"screen_name"]];
        [limitLabel setText:[NSString stringWithFormat:@"You have %@ follows remaining in this hour.",[[string componentsSeparatedByString:@"###"] objectAtIndex:1]]];
        
    });
}


-(void)getImagesAsync {
    
    // Fetch using GCD
    dispatch_queue_t downloadThumbnailQueue = dispatch_queue_create("Get Photo Thumbnail", NULL);
    
    dispatch_async(downloadThumbnailQueue, ^{
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[currentUserTwitter objectForKey:@"profile_image_url_https"]]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [userPicImageView setImage:image];
        });
    });
    
}

- (IBAction)followButtonClicked:(id)sender {
    
    NSString* string = [wrapper stringForKey:@"ff"];
    NSTimeInterval lastInterval = [[[string componentsSeparatedByString:@"###"] objectAtIndex:0] floatValue];
    NSDate* lastDate = [NSDate dateWithTimeIntervalSince1970:lastInterval];
    NSDate * originalDate = [NSDate date];
    int followedAction = [[[string componentsSeparatedByString:@"###"] objectAtIndex:1] intValue];
    NSTimeInterval space = [originalDate timeIntervalSinceDate:lastDate];
    
    if(space < 3600)
    {
        followedAction--;
        if(followedAction <= 0)
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:[NSString stringWithFormat:@"لقد وصلت للحد المسموح للمتاعبة، رجاء المحاولة بعد %i دقيقة",(int)((3600-space)/60)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }else
    {
        [wrapper setString:[NSString stringWithFormat:@"%f###30",[[NSDate date] timeIntervalSince1970]]  forKey:@"f"];
        [wrapper synchronize];
    }
    
    
    [wrapper setString:[NSString stringWithFormat:@"%f###%i",lastInterval,followedAction] forKey:@"ff"];
    [wrapper synchronize];
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:cons consumerSecret:sec oauthToken:[currentUserServer objectForKey:@"access"] oauthTokenSecret:[currentUserServer objectForKey:@"secret"]];
    
    [twitter postFriendshipsCreateForScreenName:[account username] orUserID:nil successBlock:^(NSDictionary* frd)
     {
         SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friendships/create.json"] parameters:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[currentUserServer objectForKey:@"name"], @"false", nil] forKeys:[NSArray arrayWithObjects:@"screen_name", @"follow", nil]]];
         [request setAccount:account];
         [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
             if ([urlResponse statusCode] == 429) {
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"عفواً" message:@"لقد وصلت للحد المسموح للمتاعبة من تويتر، رجاء المحاولة بعد ٣٠ دقيقة" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
             }else
             {
                 if(responseData) {
                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
                     if(responseDictionary) {
                         [self loadProfile];
                     }else
                     {
                         [self loadProfile];
                     }
                 } else {
                     [self loadProfile];
                 }
             }
         }];
     }errorBlock:^(NSError *error) {
         [self loadProfile];
     }];
}

@end
