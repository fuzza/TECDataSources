//
//  TECCustomCell.m
//  DataSources
//
//  Created by Alexey Fayzullov on 1/27/16.
//  Copyright © 2016 Alexey Fayzullov. All rights reserved.
//

#import "TECCustomCell.h"

@implementation TECCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.backgroundColor = [UIColor greenColor];
}

@end
