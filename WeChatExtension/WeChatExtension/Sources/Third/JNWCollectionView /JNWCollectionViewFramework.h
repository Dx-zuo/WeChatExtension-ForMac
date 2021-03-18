//
//  JNWCollectionViewFramework.h
//  WeChatExtension
//
//  Created by 乐 y on 2021/3/17.
//  Copyright © 2021 MustangYM. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@class JNWCollectionView;
@class JNWScrollView;
@class JNWCollectionViewLayout;

@interface JNWCollectionView : NSView

/// Calling this method will cause the collection view to clean up all the views and
/// recalculate item info. It will then perform a layout pass.
///
/// This method should be called after the data source has been set and initial setup on the collection
/// view has been completed.
- (void)reloadData;

/// In order for cell or supplementary view dequeueing to occur, a class must be registered with the appropriate
/// registration method.
///
/// The class passed in will be used to initialize a new instance of the view, as needed. The class
/// must be a subclass of JNWCollectionViewCell for the cell class, and JNWCollectionViewReusableView
/// for the supplementary view class, otherwise an exception will be thrown.
///
/// Registering a class or nib are exclusive: registering one will unregister the other.
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)registerClass:(Class)supplementaryViewClass forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)reuseIdentifier;

/// You can also register a nib instead of a class to be able to dequeue a cell or supplementary view.
///
/// The nib must contain a top-level object of a subclass of JNWCollectionViewCell for the cell, and
/// JNWCollectionViewReusableView for the supplementary view, otherwise an exception will be thrown when dequeuing.
///
/// Registering a class or nib are exclusive: registering one will unregister the other.
- (void)registerNib:(NSNib *)cellNib forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(NSNib *)supplementaryViewNib forSupplementaryViewOfKind:(NSString *)kind withReuseIdentifier:(NSString *)reuseIdentifier;
@end
