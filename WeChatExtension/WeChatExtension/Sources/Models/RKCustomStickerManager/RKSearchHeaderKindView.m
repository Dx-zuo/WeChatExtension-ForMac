//
//  RKSearchHeaderKindView.m
//  WeChatExtension
//
//  Created by 乐 y on 2021/3/17.
//  Copyright © 2021 MustangYM. All rights reserved.
//

#import "RKSearchHeaderKindView.h"
#import "NSViewLayoutTool.h"

@implementation RKSearchHeaderKindView

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchField = [[objc_getClass("MMCustomSearchField") class] new];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _searchField.delegate = self;
    _searchField.placeholderString = @"搜索表情";
    [self addSubview:_searchField];
    
    [self addSubViewsConstraint];
}

- (void)addSubViewsConstraint {
    [_searchField addConstraint:NSLayoutAttributeWidth sibling:self attribute:NSLayoutAttributeWidth constant:-30];
    [_searchField addConstraint:NSLayoutAttributeHeight sibling:self attribute:NSLayoutAttributeHeight constant:-30];
    [_searchField addConstraint:NSLayoutAttributeCenterX sibling:self attribute:NSLayoutAttributeCenterX constant:0];
    [_searchField addConstraint:NSLayoutAttributeCenterY sibling:self attribute:NSLayoutAttributeCenterY constant:0];
//    [self layoutGuides];
    [self layout];
}

- (void)onSearchFiledDidEnd:(NSView *)arg1 {
    
}

- (void)onSearchFiledWillBegin:(NSView *)arg1 {
    
}

- (void)onSearchFiledTextDidChange:(NSView *)arg1 {
    
}

- (BOOL)onSearchiledControl:(NSView *)arg1 aCommandSelector:(SEL)arg2 {
    return NOw;
}

- (void)onSearchFiledTextDidEndEditing:(NSView *)arg1 info:(NSNotification *)arg2 {
    
}
@end
