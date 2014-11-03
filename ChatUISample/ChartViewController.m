//
//  ChartViewController.m
//  ChatUISample
//
//  Created by akaikeyuto on 2014/10/26.
//  Copyright (c) 2014年 RedPond. All rights reserved.
//

#import "ChartViewController.h"

@interface ChartViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTextViewHeight;

- (IBAction)tapButton:(id)sender;
@property bool isObserving;

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView.delegate = self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //キーボド開閉の通知登録
    if (!_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [noticication addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        //Observerになってるフラグをたてとく
        _isObserving = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //キーボード開閉の通知解除
    if (_isObserving) {
        NSNotificationCenter *noticication = [NSNotificationCenter defaultCenter];
        [noticication removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [noticication removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        //Observerになってるフラグをおとす
        _isObserving = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//キーボード表示
-(void) keyboardWillShow:(NSNotification *) notification{
    
    // キーボードのサイズを取得
    CGRect rect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // キーボード表示アニメーションのdurationを取得
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // キーボード表示と同じdurationのアニメーションでViewを移動させる
    [UIView animateWithDuration:duration animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -rect.size.height);
        self.view.transform = transform;
    } completion:NULL];
}

//キーボード非表示
-(void) keyboardWillHide:(NSNotification *)notification{
    
    // キーボード表示アニメーションのduration
    NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Viewを元に戻す
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
    } completion:NULL];
}



//TextViewの入力や変更が終わると呼ばれる
- (void)textViewDidChange:(UITextView *)textView {
    
    //高さを広げる上限を指定
    float maxHeight = 80.0;
    
    if(_textView.frame.size.height < maxHeight){
        
        //高さを変更
        CGSize size = [_textView sizeThatFits:_textView.frame.size];
        _constraintTextViewHeight.constant = size.height;
    }
}

//TextViewの入力が始まると呼ばれる
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //カーソルの位置へスクロールさせる
    [_textView scrollRangeToVisible:_textView.selectedRange];
    
    return YES;
}

- (IBAction)tapButton:(id)sender {
    
    //TextViewを元に戻す
    _textView.text = nil;
    CGSize size = [_textView sizeThatFits:_textView.frame.size];
    _constraintTextViewHeight.constant = size.height;
    
    //キーボードを閉じる
    [_textView resignFirstResponder];
}
@end
