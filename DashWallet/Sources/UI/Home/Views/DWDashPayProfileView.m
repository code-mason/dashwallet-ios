//
//  Created by Andrew Podkovyrin
//  Copyright © 2020 Dash Core Group. All rights reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://opensource.org/licenses/MIT
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DWDashPayProfileView.h"

#import "DWBadgeView.h"
#import "DWDPAvatarView.h"
#import "DWUIKit.h"

NS_ASSUME_NONNULL_BEGIN

static CGSize const AVATAR_SIZE = {72.0, 72.0};

@interface DWDashPayProfileView ()

@property (readonly, nonatomic, strong) DWDPAvatarView *avatarView;
@property (readonly, nonatomic, strong) UIImageView *bellImageView;
@property (readonly, nonatomic, strong) DWBadgeView *badgeView;

@end

NS_ASSUME_NONNULL_END

@implementation DWDashPayProfileView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dw_dashBlueColor];

        DWDPAvatarView *avatarView = [[DWDPAvatarView alloc] init];
        avatarView.translatesAutoresizingMaskIntoConstraints = NO;
        avatarView.backgroundMode = DWDPAvatarBackgroundMode_Random;
        avatarView.userInteractionEnabled = NO;
        [self addSubview:avatarView];
        _avatarView = avatarView;

        UIImageView *bellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bell"]];
        bellImageView.translatesAutoresizingMaskIntoConstraints = NO;
        bellImageView.userInteractionEnabled = NO;
        [self addSubview:bellImageView];
        _bellImageView = bellImageView;

        DWBadgeView *badgeView = [[DWBadgeView alloc] initWithFrame:CGRectZero];
        badgeView.translatesAutoresizingMaskIntoConstraints = NO;
        badgeView.hidden = YES;
        [self addSubview:badgeView];
        _badgeView = badgeView;

        [NSLayoutConstraint activateConstraints:@[
            [avatarView.topAnchor constraintEqualToAnchor:self.topAnchor],
            [avatarView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
            [avatarView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
            [avatarView.widthAnchor constraintEqualToConstant:AVATAR_SIZE.width],
            [avatarView.heightAnchor constraintEqualToConstant:AVATAR_SIZE.height],

            [bellImageView.trailingAnchor constraintEqualToAnchor:avatarView.trailingAnchor],
            [bellImageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],

            [badgeView.centerXAnchor constraintEqualToAnchor:self.avatarView.trailingAnchor],
            [badgeView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        ]];
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];

    [self dw_pressedAnimation:DWPressedAnimationStrength_Medium pressed:highlighted];
}

- (void)setUsername:(NSString *)username {
    _username = username;

    self.avatarView.username = username;
}

- (void)setUnreadCount:(NSUInteger)unreadCount {
    _unreadCount = unreadCount;

    self.badgeView.text = [NSString stringWithFormat:@"%ld", unreadCount];

    self.bellImageView.hidden = unreadCount > 0;
    self.badgeView.hidden = unreadCount == 0;
}

@end
