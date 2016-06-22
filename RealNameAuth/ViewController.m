//
//  ViewController.m
//  RealNameAuth
//
//  Created by 马浩哲 on 16/6/13.
//  Copyright © 2016年 junanxin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *IDCardTF;
- (IBAction)AuthBtnAction:(UIButton *)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AuthBtnAction:(UIButton *)sender {
    
    [self showMessage:[self IDCardAuth:_IDCardTF.text]];
    
//    [self userNameAuth:_nameTF.text];
    
}

-(void)showMessage:(BOOL)isSucceed
{
    NSString *isOK;
    if (isSucceed) {
        isOK = @"验证通过";
    }else
    {
        isOK = @"验证失败";
    }
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"提示" message:isOK delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    message.delegate = self;
    [message show];
}

//身份证号验证 1900+/2000+的年份日期的正则表达式经过修改，目前不知道是否正确
//返回yes位表示格式正确，否则为错误
-(BOOL)IDCardAuth:(NSString *)value
{
    //stringByTrimmingCharactersInSet ：去除字符串中的特殊字符
    //[NSCharacterSet whitespaceAndNewlineCharacterSet] 空格
    //自定义要去除的特殊字符
    //NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    
    if (!value) {
        
        return NO;
        
    }else {
        
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    
    BOOL areaFlag =NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            
            areaFlag =YES;
            
            break;
            
        }
        
    }
    
    if (!areaFlag) {
        
        return false;
        
    }
    //生日部分的编码
    NSRegularExpression *regularExpression;
    
    NSUInteger numberofMatch;
    
    NSInteger year =0;
    
    switch (length) {
            
        case 15:
            
            year = [value substringWithRange:NSMakeRange(8,2)].intValue +1900;
            
            if (year %400 ==0 || (year %100 !=0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }
            //numberofMatch:匹配到得字符串的个数
            numberofMatch = [regularExpression numberOfMatchesInString:value
                             
                                                              options:NSMatchingReportProgress
                             
                                                                range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                
                return YES;
                
            }else {
                
                return NO;
                
            }
            
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %400 ==0 || (year %100 !=0 && year %4 ==0)) {
                
                //原来的@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                //现在的@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                     
                                                                       options:NSRegularExpressionCaseInsensitive
                                     
                                                                         error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                             
                                                              options:NSMatchingReportProgress
                             
                                                                range:NSMakeRange(0, value.length)];
            //验证校验位
            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                
                NSString *M =@"F";
                
                NSString *JYM =@"10X98765432";
                
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    
                    return YES;// 检测ID的校验位
                    
                }else {
                    
                    return NO;
                    
                }
                
            }else {
                
                return NO;
                
            }
            
        default:
            
            return false;
    }
}
-(void)userNameAuth:(NSString *)nameStr
{
    NSRegularExpression *regularExpression;
    regularExpression = [[NSRegularExpression alloc]initWithPattern:@"[^·\u4e00-\u9fa5]([·\u4e00-\u9fa5]+?)[^·\u4e00-\u9fa5]"
                                                            options:NSRegularExpressionCaseInsensitive
                         
                                                              error:nil];
    NSArray *arr = [regularExpression matchesInString:nameStr options:0 range:NSMakeRange(0, nameStr.length)];
    for (NSTextCheckingResult *match in arr) {
        NSRange range = [match range];
        NSString *mStr = [nameStr substringWithRange:range];
        NSLog(@"%@", mStr);
    }
    
}
@end
