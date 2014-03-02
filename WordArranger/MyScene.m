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
@property (nonatomic, strong) NSMutableArray *tmpWordParts; // state manipulated during drag
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
        
        [_container setAnchorPoint:CGPointMake(0, 0)];
        [_container setPosition:CGPointMake(self.size.width / 2 - _container.size.width / 2, self.size.height / 2 - _container.size.height / 2)];
        
        
        [self addChild:_container];

    }
    return self;
}

-(void)reorderWordParts:(WordPartNode *)movedPart {
    if ([_tmpWordParts count] == [_wordParts count]) { // TODO: more complex validation logic
        // word was re-integrated into the flow
        _wordParts = _tmpWordParts;
    }
    [self refreshOrderFromArray:_wordParts];
    _tmpWordParts = [NSMutableArray arrayWithArray:_wordParts];
}

-(void)updateWordParts:(WordPartNode *)movedPart {
    
    // figure out if the word's position has changed in the flow
    if ([_container intersectsNode:movedPart]) {
        int curIndex  = [_tmpWordParts indexOfObject:movedPart];
        int newIndex = curIndex;
        for (WordPartNode *wp in _tmpWordParts) {
            int tmpIndex = [_tmpWordParts indexOfObject:wp];
            if (movedPart.position.x < wp.position.x && tmpIndex < curIndex) {
                newIndex = [_tmpWordParts indexOfObject:wp];
                break;
            }
            if (movedPart.position.x > wp.position.x && tmpIndex > curIndex) {
                newIndex = [_tmpWordParts indexOfObject:wp];
                break;
            }
        }
        
        if (newIndex != curIndex) {
            [_tmpWordParts removeObject:movedPart];
            [_tmpWordParts insertObject:movedPart atIndex:newIndex];
            [self refreshOrderFromArray:_tmpWordParts withFocusItem:movedPart];
        }
    }
   
}

-(void)refreshOrderFromArray:(NSMutableArray *)wordPartArray {
    [self refreshOrderFromArray:wordPartArray withFocusItem:nil];
}

-(void)refreshOrderFromArray:(NSMutableArray *)wordPartArray withFocusItem:(WordPartNode *)focusNode {
    float cumX = 0, maxHeight = 0;
    for (WordPartNode *wp in wordPartArray) {
        CGPoint canonicalPosition = CGPointMake(cumX, 0);
        if (!CGPointEqualToPoint(canonicalPosition, wp.position) && focusNode != wp) {
            SKAction *moveAction = [SKAction moveTo:canonicalPosition duration:0.5];
            moveAction.timingMode = SKActionTimingEaseOut;
            [wp runAction:moveAction];
        }
        
        cumX += wp.size.width;
        if ([wordPartArray objectAtIndex:[wordPartArray count] - 1] != wp) // spacing unless it's the last item
        {
            cumX += kSpacing;
        }
        
        if (wp.size.height > maxHeight) {
            maxHeight = wp.size.height;
        }
    }
    [_container setSize:CGSizeMake(cumX, maxHeight)];
}

-(void)wordPartTouchesMoved:(WordPartNode *)wordPartNode withTouches:(NSSet *)touches withEvent:(UIEvent *)event {

    // drag the moved item
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:_container];
    CGPoint previousPosition = [touch previousLocationInNode:_container];
    CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
    wordPartNode.position = CGPointMake(wordPartNode.position.x + translation.x, wordPartNode.position.y + translation.y);
    
    // and update the other parts as a result
    [self updateWordParts:wordPartNode];
}

-(void)wordPartTouchesEnded:(WordPartNode *)wordPartNode withTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches ended...");
    [self reorderWordParts:wordPartNode];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
