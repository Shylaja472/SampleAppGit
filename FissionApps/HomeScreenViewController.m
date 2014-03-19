//
//  HomeScreenViewController.m
//  FissionApps
//
//  Created by Shylaja Mamidala on 2/6/14.
//  Copyright (c) 2014 Shylaja Mamidala. All rights reserved.
//

#import "HomeScreenViewController.h"
#import <QuartzCore/QuartzCore.h>
#define backgroundHeaderColor [UIColor colorWithRed:236/255.0f green:240/255.0f blue:241/255.0f alpha:1]
#import "labelCollectionCell.h"
#import "AFURLConnectionOperation.h"
#import "AppDelegate.h"
#import "othersProfileViewController.h"
#import <objc/runtime.h> // for objc_setAssociatedObject / objc_getAssociatedObject
#import "WritePostViewController.h"
@interface HomeScreenViewController ()

@end

labelCollectionCell *cell3;
NSString *cell2ID=@"cell2";
NSString *cell3ID=@"cell3";
NSMutableArray *itemAttributes;
NSMutableArray *feedDataArray;

double origin_Y_Value=0;
UIRefreshControl *refreshControl;
UIScrollView *scroller;
UIImageView* ivExpand;
@implementation HomeScreenViewController

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
    //    [self.topHeader setBackgroundColor:[UIColor colorWithRed:255/255.0 green:211/255.0 blue:224/255.0 alpha:1]];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateFeed)
             forControlEvents:UIControlEventValueChanged];
    [_feedCollectionView addSubview:refreshControl];
    _feedCollectionView.alwaysBounceVertical = YES;
    _nameLabel.text=[FCLUtilities getUserName];
    [self.feedCollectionView setBackgroundColor:backgroundHeaderColor];
    
    NSString *url=[[NSUserDefaults standardUserDefaults] objectForKey:@"myPicUrl"];
    NSLog(@"url value %@",url);
    
   
    // Configure layout
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(310, 300)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.flowLayout.minimumInteritemSpacing = 0.0f;
    self.flowLayout.minimumLineSpacing=13.0f;
    [self.feedCollectionView setCollectionViewLayout:self.flowLayout];
    self.feedCollectionView.bounces = YES;
    [self.feedCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.feedCollectionView setShowsVerticalScrollIndicator:NO];

    //---collection view cells
    cell3.postLabel3.textAlignment=NSTextAlignmentLeft;
    cell3.postLabel3.numberOfLines=0;
    cell3.postLabel3.lineBreakMode=NSLineBreakByWordWrapping;
    
   
    
    [self.view setBackgroundColor:backgroundHeaderColor];
    [self.myPic setClipsToBounds:YES];
    [self.myPic.layer setMasksToBounds:YES];
    [self.myPic.layer setCornerRadius:21.5];
    [self.myPic setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholderProfile.jpg"]];
    
    
    [self.topHeader setBackgroundColor:[UIColor whiteColor]];
    [self.topHeader.layer setCornerRadius:4.0];
    // border
    [_topHeader.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_topHeader.layer setBorderWidth:1.0f];
    
    //  drop shadow
//    [_topHeader.layer setShadowColor:[UIColor blackColor].CGColor];
//    [_topHeader.layer setShadowOpacity:0.8];
//    [_topHeader.layer setShadowRadius:3.0];
//    [_topHeader.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    _feedCollectionView.delegate=self;
    _feedCollectionView.dataSource=self;
    
//    NSLog(@"view origin %f",self.topHeader.frame.origin.y);
    
    [self updateFeed];
    
    
}

-(void)checkInternet{
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (![delegate isNetWorkAvailableMethod]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please check your Internet connection" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)updateFeed{
    [SVProgressHUD showWithStatus:@"Loading.." maskType:SVProgressHUDMaskTypeGradient];
    [self checkInternet];

    FclAPICleint *sharedClient=[FclAPICleint sharedClient];
    _feedResponse=[[NSMutableArray alloc]init];
//    _feedResponse=[[FCLUtilities getUtils] getMyFeed];
    
    NSURLRequest *request = [sharedClient requestWithMethod:@"get" path:@"getFeed" parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//       NSLog(@"json %@",JSON);
        _feedResponse=[[NSMutableArray alloc]init];
        _feedResponse=JSON;

        [SVProgressHUD dismiss];
        
        _feedResponse=JSON;
        
        NSArray *sortedArray =[_feedResponse sortedArrayUsingDescriptors:
                               [NSArray arrayWithObject:
                                [NSSortDescriptor sortDescriptorWithKey:@"TimeStamp" ascending:NO]]];
        feedDataArray=[[NSMutableArray alloc]init];
        feedDataArray =[self createMutableArray1:sortedArray];
        NSLog(@"feeeeeed %@",feedDataArray);
        

        [self.feedCollectionView reloadData];
        
//        NSLog(@"feed count %d",_feedResponse.count);
        [refreshControl endRefreshing];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failed ");
        [SVProgressHUD dismiss];
        [refreshControl endRefreshing];

        AppDelegate *delegate=[UIApplication sharedApplication].delegate;
        [delegate showErrorNotice:@"Could not connect to the server"];
    }];
    
    [operation start];
    

}
- (NSMutableArray *)createMutableArray1:(NSArray *)array
{
    return [NSMutableArray arrayWithArray:array];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:@"postFeed" object:nil];
}

-(void)didReceiveNotification:(NSNotification *)noitf{
    if ([[noitf name]isEqualToString:@"postFeed"]) {
        NSLog(@"came here");
        [self updateFeed];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)composeBtnActn:(id)sender {
    
    [self performSegueWithIdentifier:@"postView" sender:self];
}

#pragma mark - UICollectionViewDelegate, DataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict=[feedDataArray objectAtIndex:indexPath.row];
    
        NSString *post=[NSString stringWithFormat:@"%@",[dict objectForKey:@"feedtext"]];
        NSString *timeMS=[dict objectForKey:@"TimeStamp"];
        NSString *time=[self timeAgoString:timeMS];
        NSString *name=[dict objectForKey:@"username"];
        NSString *url=[dict objectForKey:@"imageURL"];
    
        cell3=(labelCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cell3ID forIndexPath:indexPath];
        _tapOtherProfile=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeFriendProfile:)];
        _tapOtherProfile.delegate=self;
        cell3.namelabel3.tag=indexPath.row;
        cell3.namelabel3.userInteractionEnabled=YES;
        [cell3.namelabel3 addGestureRecognizer:_tapOtherProfile];

        UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 285, 20)];
    
        label.backgroundColor = [UIColor blueColor];
        [label setNumberOfLines:0];
        cell3.widthImage.constant=294;
    
    
        if (![url isEqualToString:@"null"]) {
            cell3.pic.contentMode= UIViewContentModeScaleAspectFill;
            cell3.pic.clipsToBounds=YES;
            [cell3.pic setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholder2.png"]];
            cell3.imageHeight.constant=218;
        }else{
            cell3.imageHeight.constant=0;
        }
    
    
        const CGFloat fontSize = 14;
        UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
        UIColor *foregroundColor = [UIColor blackColor];
    
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           foregroundColor, NSForegroundColorAttributeName
                           , nil];
    
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]
                                                 initWithString:post
                                                 attributes:attrs];
    
    
    
        label.attributedText = attributedText;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        CGSize maximumLabelSize = CGSizeMake(280,CGFLOAT_MAX);
        CGSize requiredSize = [label sizeThatFits:maximumLabelSize];
        CGRect labelFrame = label.frame;
        labelFrame.size.height = requiredSize.height;
        label.frame = labelFrame;
        cell3.heightConstant.constant=requiredSize.height;
        cell3.postLabel3.textAlignment=NSTextAlignmentLeft;
        cell3.postLabel3.numberOfLines=0;
        cell3.postLabel3.lineBreakMode=NSLineBreakByWordWrapping;

        cell3.postLabel3.text=post;
        cell3.namelabel3.text=name;
        cell3.timeLbl3.text=time;
        //    NSLog(@"cell3 label height %f",cell3.postLabel3.frame.size.height);
        cell3.backgroundColor=[UIColor whiteColor];
    
        return cell3;
}
-(void)seeFriendProfile:(UITapGestureRecognizer *)tgr{

    NSLog(@"row value %ld",(long)tgr.view.tag);
    _selectedIndex=tgr.view.tag;
    
    [self performSegueWithIdentifier:@"friendProfile" sender:self];    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"friendProfile"]) {

        othersProfileViewController *vc=(othersProfileViewController *)[segue destinationViewController];
        vc.userName=[[feedDataArray objectAtIndex:_selectedIndex] objectForKey:@"username"];
        NSLog(@"vc.username %@",vc.userName);
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return feedDataArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 13; // This is the minimum inter item spacing, can be more
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"did select row");
    UIApplication *app=[UIApplication sharedApplication];
    UIView *window=[app keyWindow];

    
    NSString *url=[[feedDataArray objectAtIndex:indexPath.row]objectForKey:@"imageURL"];
    
    if (![url isEqualToString:@"null"]) {
        UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        UIImageView* iv = cell.contentView.subviews.lastObject;
        ivExpand = [[UIImageView alloc] init];
        scroller= [[UIScrollView alloc]init];

        [ivExpand setImageWithURL:[NSURL URLWithString:[[feedDataArray objectAtIndex:indexPath.row]objectForKey:@"imageURL"]] placeholderImage:[UIImage imageNamed:@"placeholder2.png"]];
        scroller.backgroundColor=[UIColor blackColor];
        scroller.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        scroller.maximumZoomScale = 3;
        scroller.minimumZoomScale = 1;
        scroller.clipsToBounds = YES;
        scroller.delegate = self;

        ivExpand.contentMode = UIViewContentModeScaleAspectFit;
        scroller.contentMode = (UIViewContentModeScaleAspectFit);
        ivExpand.frame = [self.view convertRect: iv.frame fromView: iv.superview];
        scroller.frame = [self.view convertRect: iv.frame fromView: iv.superview];
        NSLog(@"scroller frame associated %f , %f , %f , %f",scroller.frame.origin.x,scroller.frame.origin.y,scroller.frame.size.width,scroller.frame.size.height);
        ivExpand.userInteractionEnabled = YES;
        ivExpand.clipsToBounds = YES;
        
        
        
        
        objc_setAssociatedObject( scroller,
                                 "original_frame",
                                 [NSValue valueWithCGRect: scroller.frame],
                                 OBJC_ASSOCIATION_RETAIN);
        
        [UIView transitionWithView: self.view
                          duration: 0.5
                           options: UIViewAnimationOptionAllowAnimatedContent
                        animations:^{
                            
                            
                            CGRect viewBounds=self.view.frame;
                            
                            
                            if (IOS_VERSION>=7.0) {
                                ivExpand.frame=viewBounds;
                            }else{
                                viewBounds.origin.y=20;
                                ivExpand.frame=viewBounds;
                            }
                            
                            
                            ivExpand.backgroundColor=[UIColor blackColor];
                            scroller.frame=ivExpand.frame;
                            [scroller addSubview:ivExpand];
                            
                            
                            //[[self view] addSubview:scroller];

                            [window addSubview:scroller];
//                            ivExpand.frame=CGRectMake(0, 0, 320, 480);
//                            ivExpand.backgroundColor=[UIColor blackColor];
//                            [self.view addSubview:ivExpand];

                            
                        } completion:^(BOOL finished) {
                            
                            UITapGestureRecognizer* tgr = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector( onTap: )];
                            [scroller addGestureRecognizer: tgr];
                        }];

    }
    
}

- (void) onTap: (UITapGestureRecognizer*) tgr
{
    scroller.zoomScale=1.0;
    scroller.backgroundColor=[UIColor clearColor];
    ivExpand.backgroundColor=[UIColor clearColor];
    [UIView animateWithDuration: 0.5
                     animations:^{
                         
                         CGRect rect=[objc_getAssociatedObject( tgr.view,
                                                               "original_frame" ) CGRectValue];
                         tgr.view.frame = rect;
                        
                     } completion:^(BOOL finished) {
                         [tgr.view removeFromSuperview];

                         
                     }];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return ivExpand;
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *str=[NSString stringWithFormat:@"%@",[[feedDataArray objectAtIndex:indexPath.row] objectForKey:@"feedtext"]];
    
    
    
    UILabel  *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 280, 20)];
    
    label.backgroundColor = [UIColor blueColor];
    [label setNumberOfLines:0];
    
    const CGFloat fontSize = 14;
    UIFont *regularFont = [UIFont systemFontOfSize:fontSize];
    UIColor *foregroundColor = [UIColor blackColor];
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
             regularFont, NSFontAttributeName,
             foregroundColor, NSForegroundColorAttributeName
             , nil];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]
                                                 initWithString:str
                                                 attributes:attrs];
    
    label.attributedText = attributedText;
    label.lineBreakMode=NSLineBreakByWordWrapping;
    CGSize maximumLabelSize = CGSizeMake(280,CGFLOAT_MAX);
    CGSize requiredSize = [label sizeThatFits:maximumLabelSize];
    CGRect labelFrame = label.frame;
    labelFrame.size.height = requiredSize.height;
    label.frame = labelFrame;
    
//    NSLog(@"label height %f",requiredSize.height);
//    NSLog(@"str value%@",str);
//    NSLog(@"str length %d",str.length);
    
    NSString *url=[NSString stringWithFormat:@"%@",[[feedDataArray objectAtIndex:indexPath.row] objectForKey:@"imageURL"]];
    double defaultImgHeight=40;

    if ([url isEqualToString:@"null"]) {
        cell3.imageHeight.constant=0;
        defaultImgHeight=50;
    }else{
        cell3.imageHeight.constant=218;
        defaultImgHeight=270;

    }

    double length=0;
    CGSize returnSize;
    returnSize.width=310;
    length=label.frame.size.height;
//        NSLog(@"length %f",length);
    
    returnSize.height=(defaultImgHeight+length);
    cell3.heightConstant.constant=returnSize.height;
//    NSLog(@"return %f",returnSize.height);
    return returnSize;
}

//// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

//    return UIEdgeInsetsMake(5, -10, 120, 9.5);
    return UIEdgeInsetsMake(5, 0, 120, 0);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if (self.lastContentOffset > scrollView.contentOffset.y)
//    {
//       // NSLog(@"value bottom %f",self.lastContentOffset-scrollView.contentOffset.y);
//        
//        
//        long int bottomDiff=self.lastContentOffset-scrollView.contentOffset.y;
//        
//        if (bottomDiff>4) {
//            self.collectionVSpace.constant=67;
//            [self.feedCollectionView setNeedsUpdateConstraints];  // 2
//            self.viewVSpace.constant=5;
//            [UIView animateWithDuration:0.4 animations:^{
//                [self.feedCollectionView layoutIfNeeded]; // 3
//            }];
//        }
//        
//
//       // NSLog(@"bottom");
//    }
//    else if (self.lastContentOffset < scrollView.contentOffset.y){
////        NSLog(@"top");
////        NSLog(@"value top %f",self.lastContentOffset-scrollView.contentOffset.y);
//        
//        long int topDifference=scrollView.contentOffset.y-self.lastContentOffset;
//        
//        if (topDifference>4) {
//            self.collectionVSpace.constant=0;
//            [self.feedCollectionView setNeedsUpdateConstraints];  // 2
//            
//            self.viewVSpace.constant=-70;
//            [UIView animateWithDuration:0.4 animations:^{
//                [self.feedCollectionView layoutIfNeeded]; // 3
//            }];
//
//        }
//       
//    }
//    
//    self.lastContentOffset = scrollView.contentOffset.y;
    
    // do whatever you need to with scrollDirection here.
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView!=scroller) {
        NSLog(@"hiii");
        NSArray *indexPathsOfVisibleStories = [self.feedCollectionView indexPathsForVisibleItems];
        NSArray *sortedIndexPaths = [indexPathsOfVisibleStories sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *path1 = (NSIndexPath *)obj1;
            NSIndexPath *path2 = (NSIndexPath *)obj2;
            return [path1 compare:path2];
        }];
        NSLog(@"sorted index %@",sortedIndexPaths);
        
        if(indexPathsOfVisibleStories.count!=0){
            NSLog(@"index path first %@",[sortedIndexPaths objectAtIndex:0]);
            
            [self.feedCollectionView scrollToItemAtIndexPath:[sortedIndexPaths objectAtIndex:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
        }

    }
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}


- (NSString*)timeAgoString:(NSString *)timestampString

{
    
    double eventSecondsSince1970 =
    
    [timestampString doubleValue] / 1000.0; // milliseconds to seconds
    
    NSDate *eventDate =
    
    [NSDate dateWithTimeIntervalSince1970:eventSecondsSince1970];
    
    NSCalendar *gregorian =
    
    [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    int unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    NSDateComponents *comps =
    
    [gregorian components:unitFlags
     
                 fromDate:eventDate toDate:[NSDate date] options:0];
    
    
    NSString *timeAgoString = [NSString string];
    
    if ([comps year] > 0) {
        
        timeAgoString =
        
        [NSString stringWithFormat:@"%li yrs ago", (long)[comps year]];
        
    }
    
    else if ([comps month] > 0) {
        
        timeAgoString =
        
        [NSString stringWithFormat:@"%li month ago", (long)[comps month]];
        
    }
    
    else if ([comps day] > 0) {
        
        if ([comps day] ==1)
            
        {
            
            timeAgoString =@"a day ago";
            
        }
        
        else {
            
            timeAgoString =
            
            [NSString stringWithFormat:@"%li days ago", (long)[comps day]];
            
        }
        
    }
    
    
    
    
    
    else if ([comps hour] > 0) {
        
        if ([comps hour] ==1)
            
        {
            timeAgoString =@"an hr ago";
        }
        else
            
        {
            timeAgoString =[NSString stringWithFormat:@"%i hrs ago", [comps hour]];
        }
        
    }
    else if ([comps minute] > 0) {
        
        if ([comps minute] ==1)
        {
            timeAgoString =@"a min ago";
        }
        
        else {
            timeAgoString =
            [NSString stringWithFormat:@"%i mins ago", [comps minute]];
        }
    }
    else if ([comps second] > 1) {
        timeAgoString =
        [NSString stringWithFormat:@"%i secs ago", [comps second]];
    }
    
    else if ([comps second] <=1 ) {
        timeAgoString =@"a sec ago";
        
    }
    return timeAgoString;
    
}


//}
@end
