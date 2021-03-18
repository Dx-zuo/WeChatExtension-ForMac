//
//  MMStickerMessageCellView+hook.m
//  WeChatExtension
//
//  Created by WeChatExtension on 2018/2/23.
//  Copyright © 2018年 WeChatExtension. All rights reserved.
//

#import "MMStickerMessageCellView+hook.h"
#import "WeChatPlugin.h"

@implementation NSObject (MMStickerMessageCellView)

+ (void)hookMMStickerMessageCellView
{
    hookMethod(objc_getClass("MMStickerMessageCellView"), @selector(contextMenu), [self class], @selector(hook_contextMenu));
    hookMethod([NSMenuItem class], @selector(initWithTitle:action:keyEquivalent:), [self class], @selector(HOOK_initWithTitle:action:keyEquivalent:));
    if (LargerOrEqualVersion(@"2.3.22")) {
         hookMethod(objc_getClass("MMStickerMessageCellView"), @selector(contextMenuExport), [self class], @selector(hook_contextMenuExport));
    }
}

- (id)hook_contextMenu
{
    NSMenu *menu = [self hook_contextMenu];
    if ([self.className isEqualToString:@"MMStickerMessageCellView"]) {
        NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:WXLocalizedString(@"Message.Menu.Copy") action:@selector(contextMenuCopyEmoji) keyEquivalent:@""];
        NSMenuItem *exportItem = [[NSMenuItem alloc] initWithTitle:WXLocalizedString(@"Message.Menu.Export") action:@selector(contextMenuExport) keyEquivalent:@""];
        NSMenuItem *addCustomItem = [[NSMenuItem alloc] initWithTitle:@"添加到自定义视图" action:@selector(addCustomEmoji) keyEquivalent:@""];
        [menu addItem:[NSMenuItem separatorItem]];
        [menu addItem:copyItem];
        [menu addItem:exportItem];
        [menu addItem:addCustomItem];
    }
    return menu;
}

- (void)contextMenuExport
{
    [self exportEmoji];
}

- (void)hook_contextMenuExport
{
    if (![self.className isEqualToString:@"MMStickerMessageCellView"]) {
        [self hook_contextMenu];
        return;
    }
    [self exportEmoji];
}
- (instancetype)HOOK_initWithTitle:(NSString *)string action:(nullable SEL)selector keyEquivalent:(NSString *)charCode {
    if ([string isEqualToString:@"添加到表情"]) {
        NSLog(@"");
    }
    return [self HOOK_initWithTitle:string action:selector keyEquivalent:charCode];
}
- (void)exportEmoji
{
    MMStickerMessageCellView *currentCellView = (MMStickerMessageCellView *)self;
    MMMessageTableItem *item = currentCellView.messageTableItem;
    if (!item.message || !item.message.m_nsEmoticonMD5) {
        return;
    }
    EmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("EmoticonMgr")];
    NSData *imageData = [emoticonMgr getEmotionDataWithMD5:item.message.m_nsEmoticonMD5];
    if (!imageData) {
         return;
    }
    
    NSSavePanel *savePanel = ({
        NSSavePanel *panel = [NSSavePanel savePanel];
        [panel setDirectoryURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Pictures"]]];
        [panel setNameFieldStringValue:item.message.m_nsEmoticonMD5];
        [panel setAllowedFileTypes:@[[NSObject getTypeForImageData:imageData]]];
        [panel setAllowsOtherFileTypes:YES];
        [panel setExtensionHidden:NO];
        [panel setCanCreateDirectories:YES];
        
        panel;
    });
    [savePanel beginSheetModalForWindow:currentCellView.delegate.view.window completionHandler:^(NSInteger result) {
        if (result == NSModalResponseOK) {
            [imageData writeToFile:[[savePanel URL] path] atomically:YES];
        }
    }];
}
- (void)addCustomEmoji
{
    id toolbar = NSClassFromString(@"MMStickerPickerToolbar");
//    toolbar presel
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"");
    });
    return;
}

- (void)hook_setShouldShowEmoji:(id)arg1 {
    [self hook_setShouldShowEmoji:arg1];
}

- (void)hook_setIsOpenIMChat:(id)arg1 {
    [self hook_setIsOpenIMChat:arg1];
}

- (void)hook_updateGroupButton:(NSArray *)array {
    if (array.count) {
        NSMutableArray *newItem = [array mutableCopy];
//        array[1];
//        [newItem insertObject:array[1] atIndex:1];
        MMEmotionGroupInfo *info = array[1];
//        NSMutableArray *children = [info.children mutableCopy];
        info.children = [NSArray new];
//        info.type = 3;
//        info.title = @"自定义表情包";
//        info.identifier = @"com.tencent.xin.emoticon.person.stiker_1486296219b2e284d17089e7c6";
//        info.icon = ((MMEmotionGroupInfo *)array[1]).icon;
//        [newItem insertObject:info atIndex:0];
//        [newItem insertObject:array.lastObject atIndex:2];
        
        [self hook_updateGroupButton:newItem];
        return;
    }
    [self hook_updateGroupButton:array];
}

- (void)hook_groupButtonPressed:(id)arg1 {
    [self hook_groupButtonPressed:arg1];
}
- (void)contextMenuCopyEmoji
{
    if ([self.className isEqualToString:@"MMStickerMessageCellView"]) {
        MMMessageTableItem *item = [self valueForKey:@"messageTableItem"];
        if (!item.message || !item.message.m_nsEmoticonMD5) {
            return;
        }
        EmoticonMgr *emoticonMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("EmoticonMgr")];
        NSData *imageData = [emoticonMgr getEmotionDataWithMD5:item.message.m_nsEmoticonMD5];
        if (!imageData) {
             return;
        }

        NSString *imageType = [NSObject getTypeForImageData:imageData];
        NSString *imageName = [NSString stringWithFormat:@"temp_paste_image_%@.%@", item.message.m_nsEmoticonMD5, imageType];
        NSString *tempImageFilePath = [NSTemporaryDirectory() stringByAppendingString:imageName];
        NSURL *imageUrl = [NSURL fileURLWithPath:tempImageFilePath];
        [imageData writeToURL:imageUrl atomically:YES];
        
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard clearContents];
        [pasteboard declareTypes:@[NSFilenamesPboardType] owner:nil];
        [pasteboard writeObjects:@[imageUrl]];
    }
}

+ (NSString *)getTypeForImageData:(NSData *)data
{
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        default:
            return @"jpg";
    }
    return nil;
}
@end
