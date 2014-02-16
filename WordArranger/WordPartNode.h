//
//  WordPartNode.h
//  WordArranger
//
//  Created by Justin Bachorik on 2/16/14.
//  Copyright (c) 2014 Insanely Awesome. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface WordPartNode : SKSpriteNode

- (id)delegate;
- (void)setDelegate:(id)newDelegate;

- (WordPartNode *)initWithText:(NSString *)text;
- (void)logText;

@property (nonatomic, strong) id delegate;

@end

@protocol WordPartNodeDelegate <NSObject>
@required
-(void)wordPartTouchesBegan:(WordPartNode *)wordPartNode withTouches:(NSSet *)touches withEvent:(UIEvent *)event;
@end