//
//  FFmpegMannagerViewController.m
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2023/12/31.
//
#import "WAVRecordAndPlayViewController.h"
#import "FFmoegPlayerViewController.h"
#import "FFmpegMannagerViewController.h"

@interface FFmpegMannagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSArray<NSString *> *dataSource;
@end

@implementation FFmpegMannagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    self.tableview.frame = self.view.bounds;
    
}

//MARK: UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[WAVRecordAndPlayViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[FFmoegPlayerViewController new] animated:YES];
            break;
        default:
            break;
    }
}

//MARK: getter&setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = UIColor.whiteColor;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    }
    return _tableview;
}

- (NSArray<NSString *> *)dataSource {
    if(!_dataSource) {
        _dataSource = @[@"音频录制和播放",@"视频播放器"];
    }
    return _dataSource;
}
@end
