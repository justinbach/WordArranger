//
//  MyScene.m
//  WordArranger
//
//  Created by Justin Bachorik on 2/16/14.
//  Copyright (c) 2014 Insanely Awesome. All rights reserved.
//

#import "MyScene.h"
#import "WordPartNode.h"

const float kSpacing = 20;

@interface MyScene ()

@property (nonatomic, strong) NSMutableArray *wordParts;
@property (nonatomic, strong) SKSpriteNode *container;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        
        _container = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithWhite:0.0 alpha:1.0] size:CGSizeZero];
        
        NSArray *wordList = @[@"this", @"is", @"a", @"test"];
        // initialize the words
        _wordParts = [[NSMutableArray alloc] init];
        for (NSString *word in wordList) {
            WordPartNode *wp = [[WordPartNode alloc] initWithText:word];
            wp.delegate = self;
            [_wordParts addObject:wp];
            [_container addChild:wp];
        }
        
        // lay out the words inside the container
        [self reorderWordParts:nil];
        
        [_container setPosition:CGPointMake(self.size.width / 2 - _container.size.width / 2 , self.size.height / 2 - _container.size.height / 2)];
        [self addChild:_container];

    }
    return self;
}

-(void)reorderWordParts:(WordPartNode *)movedPart
{
    float cumX = 0;
    for (WordPartNode *wp in _wordParts) {
        CGPoint canonicalPosition = CGPointMake(cumX + wp.size.width / 2, 0);
        if (!CGPointEqualToPoint(canonicalPosition, wp.position)) {
            SKAction *moveAction = [SKAction moveTo:canonicalPosition duration:0.5];
            moveAction.timingMode = SKActionTimingEaseInEaseOut;
            [wp runAction:moveAction];
        }
        cumX += wp.size.width + kSpacing;
        NSLog(@"cumX: %f", cumX);
    }
    [_container setSize:CGSizeMake(cumX, ((WordPartNode *)[_wordParts objectAtIndex:0]).size.height)];
}

-(void)wordPartTouchesMoved:(WordPartNode *)wordPartNode withTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    [wordPartNode logText];
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:_container];
    CGPoint previousPosition = [touch previousLocationInNode:_container];
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    wordPartNode.position = CGPointMake(wordPartNode.position.x + translation.x, wordPartNode.position.y + translation.y);
}

-(void)wordPartTouchesEnded:(WordPartNode *)wordPartNode withTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches ended...");
    [self reorderWordParts:wordPartNode];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
