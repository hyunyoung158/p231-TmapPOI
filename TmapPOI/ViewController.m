//
//  ViewController.m
//  TmapPOI
//
//  Created by SDT-1 on 2014. 1. 17..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"
#import "TMapView.h"

#define APP_KEY @"693b0d6b-de1f-3499-8283-ace081027e4f"
#define TOOLBAR_HIGHT 64

@interface ViewController ()<UISearchBarDelegate, TMapViewDelegate>

@property (strong, nonatomic) TMapView *mapView;
@end

@implementation ViewController


// 검색 버튼 클릭시
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    //새로 작성하기 전에 마커 지우기
    [self.mapView clearCustomObjects];
    
    NSString *keyword = searchBar.text;
    TMapPathData *path = [[TMapPathData alloc] init];
    NSArray *result = [path requestFindTitlePOI:keyword];
    NSLog(@"number of POI : %d", (int)result.count);
    
    int i = 0;
    for (TMapPOIItem *item in result) {
        NSLog(@"name : %@ - point : %@", [item getPOIName], [item getPOIPoint]);
        
        NSString *markerID = [NSString stringWithFormat:@"marker_%d", i++];
        TMapMarkerItem *marker = [[TMapMarkerItem alloc] init];
        [marker setTMapPoint:[item getPOIPoint]];
        [marker setIcon:[UIImage imageNamed:@"marker.png"]];
        
        [marker setCanShowCallout:YES];
        [marker setCalloutTitle:[item getPOIName]];
        [marker setCalloutSubtitle:[item getPOIAddress]];
        
        [self.mapView addCustomObject:marker ID:markerID];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = CGRectMake(0, TOOLBAR_HIGHT, self.view.frame.size.width, self.view.frame.size.height - TOOLBAR_HIGHT);
    
    self.mapView = [[TMapView alloc] initWithFrame:rect];
    [self.mapView setSKPMapApiKey:APP_KEY];
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
