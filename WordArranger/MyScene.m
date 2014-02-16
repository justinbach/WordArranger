//
//  MyScene.m
//  WordArranger
//
//  Created by Justin Bachorik on 2/16/14.
//  Copyright (c) 2014 Insanely Awesome. All rights reserved.
//

#import "MyScene.h"
#import "WordPartNode.h"

@interface MyScene ()

@property (nonatomic, strong) NSMutableArray *wordParts;

@end

@implementation MyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        
        SKSpriteNode *container = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithWhite:0.0 alpha:1.0] size:CGSizeZero];
        
        NSArray *wordList = @[@"this", @"is", @"a", @"test"];
        // initialize the words
        _wordParts = [[NSMutableArray alloc] init];
        for (NSString *word in wordList) {
            WordPartNode *wp = [[WordPartNode alloc] initWithText:word];
            wp.delegate = self;
            [_wordParts addObject:wp];
            [container addChild:wp];
        }
        
        // lay out the words inside the container
        float cumX = 0;
        for (WordPartNode *wp in _wordParts) {
            [wp setPosition:CGPointMake(cumX + wp.size.width / 2, wp.position.y)];
            cumX += wp.size.width;
            NSLog(@"cumX: %f", cumX);
        }
        
        [container setSize:CGSizeMake(cumX, ((WordPartNode *)[_wordParts objectAtIndex:0]).size.height)];
        [container setPosition:CGPointMake(self.size.width / 2 - container.size.width / 2 , self.size.height / 2 - container.size.height / 2)];
        
        [self addChild:container];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}

-(void)selectNodeForTouch:(CGPoint)touchLocation {
    WordPartNode *touchedNode = (WordPartNode *)[self nodeAtPoint:touchLocation];
    NSLog(@"%@", touchedNode);
}

-(void)wordPartTouchesBegan:(WordPartNode *)wordPartNode withTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    [wordPartNode logText];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
