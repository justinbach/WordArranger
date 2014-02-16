//
//  WordPartNode.m
//  WordArranger
//
//  Created by Justin Bachorik on 2/16/14.
//  Copyright (c) 2014 Insanely Awesome. All rights reserved.
//

#import "WordPartNode.h"

@interface WordPartNode ()
@property (strong, nonatomic) SKLabelNode *wordLabel;
@end

@implementation WordPartNode

- (WordPartNode *)initWithText:(NSString *)text
{
    self = [super initWithColor:[SKColor colorWithWhite:0.2 alpha:1.0] size:CGSizeZero];
    if (self) {
        _wordLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _wordLabel.text = [text stringByAppendingString:@" "];
        _wordLabel.fontSize = 20;
        _wordLabel.position = CGPointZero;
        _wordLabel.fontColor = [SKColor colorWithWhite:1.0 alpha:1.0];
        _wordLabel.xScale = 1.0;
        _wordLabel.yScale = 1.0;
        
        self.size = _wordLabel.frame.size;
        self.userInteractionEnabled = YES;
        
        [self addChild:_wordLabel];
    }
    
    return self;
}

- (void)logText {
    NSLog(@"WordPartNode text: %@", _wordLabel.text);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_delegate wordPartTouchesBegan:self withTouches:touches withEvent:event];
}


@end
