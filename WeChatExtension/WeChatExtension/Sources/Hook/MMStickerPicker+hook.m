//
//  MMStickerPicker+hook.m
//  WeChatExtension
//
//  Created by 乐 y on 2021/3/11.
//  Copyright © 2021 MustangYM. All rights reserved.
//

#import "MMStickerPicker+hook.h"
#import "NSViewLayoutTool.h"
#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
static NSObject* assobject = nil;
static BOOL isTag;
@implementation NSObject (MMStickerPicker)

+ (void)hookMMSticker {
    hookMethod(objc_getClass("MMStickerPickerToolbar"), @selector(setSelectedIndex:), [self class], @selector(hook_setSelectedIndex:));
//    hookMethod(objc_getClass("MMStickerPickerToolbar"), @selector(initWithFrame:), [self class], @selector(hook_initWithFrame:));
    
    hookMethod(objc_getClass("MMStickerPickerToolbar"), @selector(updateGroupButton:), [self class], @selector(hook_updateGroupButton:));
    hookMethod(objc_getClass("MMStickerPickerToolbar"), @selector(_layoutButtons), [self class], @selector(hook_layoutButtons));
    hookMethod(objc_getClass("MMStickerPickerToolbar"), @selector(set_GroupButtons:), [self class], @selector(hook_set_GroupButtons:));
    
    hookMethod(objc_getClass("EmoticonMgr"), @selector(getAllEmoticonGroupsEmoji), [self class], @selector(hook_getAllEmoticonGroups));
    hookMethod(objc_getClass("EmoticonMgr"), @selector(setAllEmoticonGroupsWithoutEmoji:), [self class], @selector(hook_setAllEmoticonGroups:));

//    hookMethod(objc_getClass("MMStickerPickerToolbarButton"), @selector(setIndex:), [self class], @selector(hook_setIndex:));

    hookMethod(objc_getClass("MMStickerPicker"), @selector(popoverWillShow:), [self class], @selector(hook_popoverWillShow:));
    hookMethod(objc_getClass("MMStickerPicker"), @selector(popoverWillClose:), [self class], @selector(hook_popoverWillClose:));
    hookMethod(objc_getClass("MMStickerPicker"), @selector(hide), [self class], @selector(hook_hide));

    hookMethod([NSPopover class], @selector(showRelativeToRect:ofView:preferredEdge:), [self class], @selector(hook_showRelativeToRect:ofView:preferredEdge:));
}

- (BOOL)hook_updateGroupButton:(NSArray *)array {
    if (array.count) {
        MMStickerPickerToolbar * toolbar = self;
        NSMutableArray *newArray = array;
        for (NSInteger i = array.count - 1; i >= 3; i--) {
            [newArray removeObjectAtIndex:i];
        }
//        NSArray [self valueForKey:@"_groupButtons"];
        if (!isTag) {
            isTag = YES;
//            [RACObserve(self, @"_groupButtons") ]
//            [RACObserve(self, _groupButtons) subscribeNext:^(id  _Nullable x) {
//
//            }];
//            self.hash
        }
        return [self hook_updateGroupButton:newArray];
    }
    return [self hook_updateGroupButton:array];
}

- (void)hook_groupButtonPressed:(id)argv {
    [self hook_groupButtonPressed:argv];
}

//- (instancetype)hook_initWithFrame:(id)argv {
//    return [self hook_initWithFrame:argv];
//}
- (void)hook_setSelectedIndex:(NSInteger)index {
    // 进入自定义表情选项
    
    if (index == 1) {
        if ([self lastView]) {
            [self.lastView setHidden:NO];
        } else {
            MMStickerPicker *stickerPicker = [objc_getClass("MMStickerPicker") performSelector:@selector(sharedPicker)];
            MMStickerPickerEventView *container = [stickerPicker stickerPickerView];
            NSView * view = [NSView new];
            [self setLastView:view];
            view.frame = CGRectMake(300, 0, 400, 423);
            NSView *contentView = [[NSApplication sharedApplication].keyWindow contentView];
            NSTextField *txtField = [NSTextField new];
            txtField.frame = view.frame;
            txtField.backgroundColor = NSColor.redColor;
            [view addSubview:txtField];
            [contentView addSubview:view];
            if ([self positioningView]) {
//                [view addConstraint:NSLayoutAttributeBottom sibling:[self positioningView] attribute:NSLayoutAttributeTop constant:0];
            }

//            [[NSApp keyWindow] contentView]
        }
    }
    [self hook_setSelectedIndex:index];
}

- (void)hook_showRelativeToRect:(NSRect)positioningRect ofView:(NSView *)positioningView preferredEdge:(NSRectEdge)preferredEdge {
    // (NSRect) positioningRect = (origin = (x = 16, y = 117), size = (width = 24, height = 24))
    // <NSView: 0x7fd4f9261fc0> (12 subviews) wantsLayer 1 isOpaque 0 isHidden 0 bounds {{0, 0}, {651, 157}} frame {{0, 0}, {651, 157}}
    if (!assobject) {
        assobject = [NSObject new];
    }
    if (positioningView.subviews.count == 12) {
        [self setpositioningView:positioningView];
    }
    [self hook_showRelativeToRect:positioningRect ofView:positioningView preferredEdge:preferredEdge];
}

- (void)hook_popoverWillShow:(id)arg {
    [self hook_popoverWillShow:arg];
}

- (void)hook_popoverWillClose:(id)arg {
    [self.lastView setHidden:YES];
    [self hook_popoverWillClose:arg];
}

static char lastView;

- (nullable NSView *)lastView {
    return objc_getAssociatedObject(assobject, &lastView);
}
- (void)setLastView:(NSView *)view {
    objc_setAssociatedObject(assobject, &lastView, view, OBJC_ASSOCIATION_RETAIN);
}
static char positioningView;

- (nullable NSView *)positioningView {
    return objc_getAssociatedObject(assobject, &positioningView);
}
- (void)setpositioningView:(NSView *)view {
    objc_setAssociatedObject(assobject, &positioningView, view, OBJC_ASSOCIATION_RETAIN);
}
- (void)hook_hide {
    return;
}

- (BOOL)hook_layoutButtons {
    [[NSDictionary new] count];
    MMStickerPicker *stickerPicker = [objc_getClass("MMStickerPicker") performSelector:@selector(sharedPicker)];
    id dix = [objc_getClass("MMServiceCenter") performSelector: @selector(defaultCenter)];
    EmoticonMgr *mgr = [dix performSelector:@selector(getService:) withObject:objc_getClass("EmoticonMgr")];
    MMStickerPickerEventView *container = [stickerPicker stickerPickerView];
    return [self hook_layoutButtons];
}

//- (void)hook_setIndex:(id)argv {
//    [self hook_setIndex:argv];
//}
- (NSArray *)hook_getAllEmoticonGroups {
    return [self hook_getAllEmoticonGroups];
}

- (void)hook_setAllEmoticonGroups:(NSArray *)argv {
    [self hook_setAllEmoticonGroups:argv];
}
@end


