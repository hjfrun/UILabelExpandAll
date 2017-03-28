//
//  ViewController.m
//  UILabelExpandAll
//
//  Created by HE Jianfeng on 2017/3/28.
//  Copyright © 2017年 hjfrun. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) NSDictionary *attrs;

@property (nonatomic, strong) NSString *string;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTap:)];
    
    [self.label addGestureRecognizer:self.tap];
    self.tap = nil;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 2;
    
    self.attrs = @{
                   NSFontAttributeName : self.label.font,
                   NSParagraphStyleAttributeName : style
                       };
    
    NSString *string = @"豫章故郡，洪都新府。星分翼轸，地接衡庐。襟三江而带五湖，控蛮荆而引瓯越。物华天宝，龙光射牛斗之墟；人杰地灵，徐孺下陈蕃之榻。雄州雾列，俊采星驰。台隍枕夷夏之交，宾主尽东南之美。都督阎公之雅望，棨戟遥临；宇文新州之懿范，襜帷暂驻。十旬休假，胜友如云；千里逢迎，高朋满座。腾蛟起凤，孟学士之词宗；紫电青霜，王将军之武库。家君作宰，路出名区；童子何知，躬逢胜饯。时维九月，序属三秋。潦水尽而寒潭清，烟光凝而暮山紫。俨骖騑于上路，访风景于崇阿；临帝子之长洲，得天人之旧馆。层峦耸翠，上出重霄；飞阁流丹，下临无地。鹤汀凫渚，穷岛屿之萦回；桂殿兰宫，即冈峦之体势。";
    self.string = string;
    
    NSArray *textChunks = [self splitWithString:string size:CGSizeMake(335, ceil(self.label.font.lineHeight))];
    
    
    NSMutableString *stringM = [NSMutableString string];
    [stringM appendString:textChunks[0]];
    [stringM appendString:textChunks[1]];
    
    NSString *expandText = @"...全文";
    
    CGFloat expandTextWidth = [self calculateLabelWidthWithString:expandText height:ceil(self.label.font.lineHeight)];
    
    CGFloat thirdLineTextWidth = 335 - expandTextWidth;
    NSArray *thirdLineArray = [self splitWithString:textChunks[2] size:CGSizeMake(thirdLineTextWidth, ceil(self.label.font.lineHeight))];
    [stringM appendString:thirdLineArray[0]];
    
    [stringM appendString:expandText];
    
    NSMutableAttributedString *mutableAttriString = [[NSMutableAttributedString alloc] initWithString:stringM attributes:self.attrs];
    [mutableAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[stringM rangeOfString:@"全文"]];
    
    self.label.attributedText = mutableAttriString;
    
    self.label.layer.borderColor = [UIColor greenColor].CGColor;
    self.label.layer.borderWidth = 1.f;
    
}

- (void)labelTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"label tap");
    
    self.label.attributedText = [[NSAttributedString alloc] initWithString:self.string attributes:self.attrs];
}

- (CGFloat)calculateLabelWidthWithString:(NSString *)string height:(CGFloat)height
{
    if (string.length == 0) {
        return 0.f;
    }
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:self.attrs context:nil].size;
    
    return ceil(size.width);
}

- (NSArray *)splitWithString:(NSString *)string size:(CGSize)size
{
    if (!string || string.length == 0) {
        return nil;
    }
    
    NSMutableAttributedString *attriStringM = [[NSMutableAttributedString alloc] initWithString:string attributes:self.attrs];
    
    NSMutableArray *textChunks = @[].mutableCopy;
    
    NSString *chunk = [NSString string];
    
    CTFramesetterRef frameSetter;
    CFRange fitRange;
    
    while (attriStringM.length) {
        
        frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attriStringM);
        
        CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL, size, &fitRange);
        CFRelease(frameSetter);
        
        chunk = [[attriStringM attributedSubstringFromRange:NSMakeRange(0, fitRange.length)] string];
        
        [textChunks addObject:chunk];
        
        [attriStringM setAttributedString:[attriStringM attributedSubstringFromRange:NSMakeRange(fitRange.length, attriStringM.string.length - fitRange.length)]];
        
    }
    
    return textChunks;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
