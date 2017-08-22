


//
//  StyleViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "StyleViewController.h"

@interface StyleViewController ()<switchCommonDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *scrollView;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UITableView *tableViewFrame;
@property (nonatomic,strong) UITableView *tableViewAxis;
@property (nonatomic,strong) UITableView *tableViewNeedle;
@property (nonatomic,strong) UITableView *tableViewRange;
@property (nonatomic,strong) NSMutableArray *FrameSectionSource;
@property (nonatomic,strong) NSMutableArray *AxisSectionSource;
@property (nonatomic,strong) NSMutableArray *NeedleSectionSource;
@property (nonatomic,strong) NSMutableArray *RangeSectionSource;

@end

@implementation StyleViewController
- (void)viewWillAppear:(BOOL)animated{
    [self initNavBarTitle:@"Style" andLeftItemImageName:@"back" andRightItemName:@"Cancel"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];
    StyleHeadView *HeadView = [[StyleHeadView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 237)];
    HeadView.delegate = self;
    [self.view addSubview:HeadView];
    //创建滚动视图
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 237, MSWidth, MSHeight)];
    scrollView.contentSize = CGSizeMake(MSWidth*4,0);
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    [self initWithUI];

  

    
}
- (void)initWithData{
    _FrameSectionSource = [[NSMutableArray alloc]initWithObjects:@"ANGLES",@"BACKGROUND COLOR",@"TITLE LABEL",@"VALUE LABEL",@"UNITS LABEL", nil];
    
    _AxisSectionSource = [[NSMutableArray alloc]initWithObjects:@"MAJOR TICKS",@"MINOR TICKS",@"LABELS", nil];
    _NeedleSectionSource = [[NSMutableArray alloc]initWithObjects:@"LABELS",@"KNOB", nil];
    
    _RangeSectionSource = [[NSMutableArray alloc]initWithObjects:@"FILL", nil];

}
- (void)initWithUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, MSHeight*10) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    self.selectStyleElement = SelectFrame;
    [scrollView addSubview:self.tableView];
    
    self.tableViewAxis = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth, 0, MSWidth, MSHeight*10) style:UITableViewStylePlain];
    self.tableViewAxis.dataSource = self;
    self.tableViewAxis.delegate = self;
    self.tableViewAxis.backgroundColor = [UIColor clearColor];
    self.tableViewAxis.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewAxis registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewAxis];
 
    
    self.tableViewNeedle = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth*2, 0, MSWidth, MSHeight*10) style:UITableViewStylePlain];
    self.tableViewNeedle.dataSource = self;
    self.tableViewNeedle.delegate = self;
    self.tableViewNeedle.backgroundColor = [UIColor clearColor];
    self.tableViewNeedle.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewNeedle registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewNeedle];
    
    self.tableViewFrame = [[UITableView alloc]initWithFrame:CGRectMake(MSWidth*3, 0, MSWidth, MSHeight*10) style:UITableViewStylePlain];
    self.tableViewFrame.dataSource = self;
    self.tableViewFrame.delegate = self;
    self.tableViewFrame.backgroundColor = [UIColor clearColor];
    self.tableViewFrame.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableViewFrame registerNib:[UINib nibWithNibName:@"StyleOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleOneTableViewCell"];
    [self.tableViewFrame registerNib:[UINib nibWithNibName:@"StyleTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleTwoTableViewCell"];
    [self.tableViewFrame registerNib:[UINib nibWithNibName:@"StyleThreeTableViewCell" bundle:nil] forCellReuseIdentifier:@"StyleThreeTableViewCell"];
    [scrollView addSubview:self.tableViewFrame];
 
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.selectStyleElement) {
        case SelectFrame:
        {
            return 5;
        }
            break;
        case SelectAxis:
        {
            return 3;
        }
            break;
        case SelectNeedle:
        {
            return 2;
        }
            break;
        case SelectRange:
        {
            return 1;
        }
            break;
        default:
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (self.selectStyleElement) {
        case SelectFrame:
        {
            if (section == 0 || section == 1) {
                return 2;
            }else if (section == 2 || section == 4){
                return 4;
            }else{
                return 3;
            }
        }
            break;
        case SelectAxis:
        {
            if (section == 0 || section == 1) {
                return 3;
            }else{
                return 4;
            }
        }
            break;
        case SelectNeedle:
        {
            if (section == 0 ) {
                return 4;
            }else{
                return 2;
            }        }
            break;
        case SelectRange:
        {
            return 4;
        }
            break;
        default:
            break;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 44)];
    headView.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, MSWidth-15, 30)];
    label.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
    label.font = [UIFont ToAdapFont:14.f];
    label.text = @"121";
//    switch (self.selectStyleElement) {
//        case SelectFrame:
//        {
//        
//        }
//            break;
//        case SelectAxis:
//        {
//            
//        }
//            break;
//        case SelectFrame:
//        {
//            
//        }
//            break;
//        case SelectFrame:
//        {
//            
//        }
//            break;
//        default:
//            break;
//    }
    [headView addSubview:label];
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.selectStyleElement) {
        case SelectFrame:
        {
            if (indexPath.section == 1 ) {
                return 44.f;
            }else if (indexPath.section == 2 && indexPath.row == 0 ){
                return 44.f;
            }else if (indexPath.section == 3 && (indexPath.row==0 || indexPath.row==1)){
                return 44.f;
            }else if (indexPath.section == 4 && indexPath.row==0){
                return 44.f;
            }else{
                return 65.f;
            }
        }
            break;
        case SelectAxis:
        {
            if (indexPath.section == 0 && indexPath.row == 2 ){
                return 44.f;
            }else if (indexPath.section == 2 && (indexPath.row==0 || indexPath.row==1)){
                return 44.f;
            }else if (indexPath.section == 1 && indexPath.row==2){
                return 44.f;
            }else{
                return 65.f;
            }
        }
            break;
        case SelectNeedle:
        {
            if (indexPath.section == 0 && (indexPath.row==0 || indexPath.row==3)){
                return 44.f;
            }else if (indexPath.section == 1 && indexPath.row==1){
                return 44.f;
            }else{
                return 65.f;
            }
        }
            break;
        case SelectRange:
        {
            if (indexPath.section == 0 && (indexPath.row==0 || indexPath.row==3)){
                return 44.f;
            }else{
                return 65.f;
            }
        }
            break;
        default:
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *resultCell = [[UITableViewCell alloc]init];
    resultCell.backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    StyleOneTableViewCell *StyleOneCell = [tableView dequeueReusableCellWithIdentifier:@"StyleOneTableViewCell"];
     StyleOneCell.selectionStyle = UITableViewCellSelectionStyleNone;
     StyleTwoTableViewCell *StyleTwoCell = [tableView dequeueReusableCellWithIdentifier:@"StyleTwoTableViewCell"];
    StyleTwoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    StyleThreeTableViewCell *StyleThreeCell = [tableView dequeueReusableCellWithIdentifier:@"StyleThreeTableViewCell"];
    StyleThreeCell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (self.selectStyleElement) {
        case SelectFrame:
        {
            if (indexPath.section == 1 ) {
                  resultCell = StyleTwoCell;
            }else if ((indexPath.section == 2 || indexPath.section == 4)  && indexPath.row==0  ){
                resultCell = StyleTwoCell;
            }else if (indexPath.section == 3 && ( indexPath.row==1)){
                resultCell = StyleTwoCell;
            }else if (indexPath.section == 3 && ( indexPath.row==0)){
                resultCell = StyleTwoCell;
            }else{
                resultCell = StyleOneCell;
            }
        }
            break;
        case SelectAxis:
        {
            if ((indexPath.section == 0 || indexPath.section == 1)&& indexPath.row == 2 ){
                resultCell = StyleTwoCell;
            }else if (indexPath.section == 2 && (indexPath.row==0 || indexPath.row==1)){
                resultCell = StyleThreeCell;
            }else {
                resultCell = StyleOneCell;
              }
        }
            break;
        case SelectNeedle:
        {
            if (indexPath.section == 0 && indexPath.row==0 ){
                resultCell = StyleThreeCell;
            }else if (  indexPath.section == 0 && indexPath.row==3){
                resultCell = StyleTwoCell;
            }else if(indexPath.section == 1 && indexPath.row==1)
            {
                resultCell = StyleTwoCell;
            }else{
                resultCell = StyleThreeCell;
            }
        }
            break;
        case SelectRange:
        {
            if (indexPath.section == 0 && indexPath.row==0 ){
                resultCell = StyleThreeCell;
            }else if( indexPath.section == 0 &&indexPath.row==3){
                resultCell = StyleTwoCell;
            }else{
                resultCell = StyleOneCell;
            }
        }
            break;
        default:
            break;
    }
    return resultCell;
    
}

#pragma mark 头部的点击事件
- (void)switchWithIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    scrollView.contentOffset = CGPointMake(index*MSWidth, 0);
    
    switch (index) {
        case 0:
        {
            self.selectStyleElement = SelectFrame;
        }
            break;
        case 1:
        {
            self.selectStyleElement = SelectAxis;

        }
            break;
        case 2:
        {
            self.selectStyleElement = SelectNeedle;

        }
            break;
        case 3:
        {
            self.selectStyleElement = SelectRange;
        }
            break;
        default:
            break;
    }

}
//当滚动视图发生位移，就会进入下方代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
@end
