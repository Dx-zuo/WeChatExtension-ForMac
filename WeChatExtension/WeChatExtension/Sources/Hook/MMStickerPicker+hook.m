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
#import "JNWCollectionViewReusableView.h"
#import "JNWCollectionViewFramework.h"
#import "RKSearchHeaderKindView.h"
@implementation NSObject (MMStickerPicker)

+ (void)hookMMSticker {
    hookMethod(objc_getClass("MMStickerPickerToolbar"), @selector(setSelectedIndex:), [self class], @selector(hook_setSelectedIndex:));

    hookMethod(objc_getClass("EmoticonMgr"), @selector(allEmoticonGroups), [self class], @selector(hook_getAllEmoticonGroups));
    hookMethod(objc_getClass("EmoticonMgr"), @selector(AllEmoticonGroupsWithoutEmoji:), [self class], @selector(hook_setAllEmoticonGroups:));

//    hookMethod(objc_getClass("MMStickerPickerToolbarButton"), @selector(setIndex:), [self class], @selector(hook_setIndex:));

    hookMethod(objc_getClass("MMStickerPicker"), @selector(popoverWillShow:), [self class], @selector(hook_popoverWillShow:));
    hookMethod(objc_getClass("MMStickerPicker"), @selector(popoverWillClose:), [self class], @selector(hook_popoverWillClose:));
    hookMethod(objc_getClass("MMStickerPicker"), @selector(hide), [self class], @selector(hook_hide));

    hookMethod(objc_getClass("MMStickerCollectionViewController"), @selector(collectionView:heightForHeaderInSection:), [self class], @selector(hook_collectionView:heightForHeaderInSection:));
    hookMethod(objc_getClass("MMStickerCollectionViewController"), @selector(collectionView:heightForFooterInSection:), [self class], @selector(hook_collectionView:heightForFooterInSection:));
    hookMethod(objc_getClass("MMStickerCollectionViewController"), @selector(collectionView), [self class], @selector(hook_collectionView));

    hookMethod(objc_getClass("MMStickerCollectionViewController"), @selector(collectionView:viewForSupplementaryViewOfKind:inSection:), [self class], @selector(hook_collectionView:viewForSupplementaryViewOfKind:inSection:));
    hookMethod([NSPopover class], @selector(showRelativeToRect:ofView:preferredEdge:), [self class], @selector(hook_showRelativeToRect:ofView:preferredEdge:));
}


- (void)hook_setSelectedIndex:(NSInteger)index {
    // 进入自定义表情选项
    MMStickerPicker *stickerPicker = [objc_getClass("MMStickerPicker") performSelector:@selector(sharedPicker)];
    id dix = [objc_getClass("MMServiceCenter") performSelector: @selector(defaultCenter)];
    EmoticonMgr *mgr = [dix performSelector:@selector(getService:) withObject:objc_getClass("EmoticonMgr")];
    MMStickerPickerEventView *container = [stickerPicker stickerPickerView];
    [self hook_setSelectedIndex:index];
}

- (void)hook_hide {
    return;
}

- (BOOL)hook_layoutButtons {
    return [self hook_layoutButtons];
}

//- (void)hook_setIndex:(id)argv {
//    [self hook_setIndex:argv];
//}
- (NSArray *)hook_getAllEmoticonGroups {
    NSArray *arr = [self hook_getAllEmoticonGroups];
    if (arr) {
        NSMutableArray *newArray = [arr mutableCopy];
//        [newArray addObject:<#(nonnull id)#>];
        // MMEmotionGroupInfo
        // children
        MMEmotionGroupInfo *info = [[objc_getClass("MMEmotionGroupInfo") class] new];
        info.title = @"自定义表情";
        info.identifier = @"TheCustom";
        info.type = 3;
        info.icon = kImageWithName(@"icons_outlined_search.png");
        info.storeIconURL = @"http://mmbiz.qpic.cn/mmemoticon/dx4Y70y9Xct1aEicvWKZ5yQia5MPZ0XNKRw8JmUtfOaakdpEdaMwCd6ibAIHDgGEziblwaZuPI9wGFs/0";
        info.children = ((MMEmotionGroupInfo *)newArray[1]).children;
        [newArray insertObject:info atIndex:0];
        return newArray;
    }
    return @[];
}

- (void)hook_setAllEmoticonGroups:(NSArray *)argv {
    [self hook_setAllEmoticonGroups:argv];
}


- (CGFloat)hook_collectionView:(NSView *)collectionView heightForHeaderInSection:(NSInteger)index
{
    if (index == 0) {
        return 56.0f;
    }
    return [self hook_collectionView:collectionView heightForHeaderInSection:index];
}

- (CGFloat)hook_collectionView:(NSView *)collectionView heightForFooterInSection:(NSInteger)index
{
    return [self hook_collectionView:collectionView heightForFooterInSection:index];
}

- (JNWCollectionViewReusableView *)collectionView:(NSView *)collectionView viewForSupplementaryViewOfKind:(NSString *)kind inSection:(NSInteger)section {
    JNWCollectionViewReusableView *view = [[objc_getClass("JNWCollectionViewReusableView") alloc] initWithFrame:NSMakeRect(0, 0, collectionView.width, 56.0f)];
    RKSearchHeaderKindView *searchHeaderKindView = [[RKSearchHeaderKindView alloc] init];
    searchHeaderKindView.frame = view.frame;
    [view addSubview:searchHeaderKindView];
    return view;
}

- (NSView *)hook_collectionView {
    JNWCollectionView *view = [self hook_collectionView];
    [view registerClass:[objc_getClass("JNWCollectionViewReusableView") class] forSupplementaryViewOfKind:@"JNWCollectionViewGridLayoutHeader" withReuseIdentifier:@"com.dd"];
    NSLog(@"ddddddxxxdd : %@: %@", view, view.debugDescription);
    return view;
}
@end


