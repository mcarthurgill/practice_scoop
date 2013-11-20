//
//  SCGroupShowTableViewCell.m
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/20/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import "SCGroupShowTableViewCell.h"

@implementation SCGroupShowTableViewCell

@synthesize groupTitle; 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
