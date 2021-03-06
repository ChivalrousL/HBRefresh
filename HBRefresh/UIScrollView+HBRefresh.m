//
//  UIScrollView+HBRefresh.m
//  HBRefresh
//
//  Created by denghb on 02/02/2018.
//  Copyright © 2018 denghb. All rights reserved.
//

#define HB_Log(s, ...)     //NSLog(@"\n%s (%d)\n%@\n\n", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define HB_height          40
#define HB_refreshHeight   80
#define HB_contentOffset   @"contentOffset"

#define HB_backgroundColor [UIColor colorWithWhite:0.9 alpha:1]
#define HB_tinColor        [UIColor colorWithWhite:0.7 alpha:1]
#define HB_IMAGE(base64)   [UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:base64 options:(NSDataBase64DecodingIgnoreUnknownCharacters)]]
#define HB_textWidth(text, font) [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil].size.width

#import "UIScrollView+HBRefresh.h"
#import <objc/runtime.h>

NSString *const HB_imageRefresh = @"iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAEHElEQVR4Xu2aj1EVMRDGdytQKxA6sAOhArUCpQK1AqECsQKhAqUCoQKhArECtYJ1fkxu5ngml00uOZ7zbmfe8GZeSPJ9+yeb3ajsuOiO45eVgNUCdpyB1QV23ADWILiIC5jZnog8F5EDEeH7MxF5HLG+SxG5FZFrEblSVf5Wi5l9VtWjqQm6EWBmAHwtIm8C4BogkHEmIueqyne3AJ61VXUSY3MCgrY/BODuDTsGQsSJh4gBPHMuSoCZAfxdwrwdGF1DjkXkk6r+jo0eg1+MgKD1LzNM3YV8NIjYcLQZIzbBL0KAmb0UEfwtFtRKgZWMxwLeqyquITHw3QkwMwIc4D3yU0SI8l9FhM1fD2YcAiYnAwKhfJ56JsUSwgnDXv6RbjGgAPy5iJyWHmlmBiHEE06SaulCgJlxnn/L7OpKRI5VFa1XSyDiNGi5eJ7mBARz/ZHxeXyTTTeTAou7t2YPAtA8FhCTP/jvXK2nWAuWRwx55GW2KQEZLQD+oNTXvUCGcWZG1HfHhWYEOEz/laqinW5S4wYtCSADI9OLSXOf31ykBjxztCTgVyLw3ajqcIZ30X4t+GYEhGyPVDcmh72CHovNAd+SAHz7RQQ9d/bUiTDbGuaCb0mAJdB0C3wtwDchYCrrywWYWhNoBb4VAanof6GqXFqaSkvwrQhIJR5UZyDnv5ZsSczMuMxQ0NyUrtF/KVZXAnJMm9n3RKlr31OgzM3/0L/PsYCdJ2CNAT1T4KVcw+MCVHbeRja0M8fgoonQUpof1vFYAFddToKYPEl1aJYGUrtelgAmNjPq+LE6HN2Zu8bEQ0mmQp1VkJeAVDp8qaqHDwU+KCd1VXfdVbwEcOlJFUS6XYlzxIaeJCX6mLis00VAYJr+fKxddauq+7nN9vjdzFIleirUe574VELAVB+QdjVtrMXEzFjvY2JB9xFdQgDdX9rSqaaly+RaMBTaZamTya199uImILjBVCzgpCA9nvWuJ0dQAI/pp9rxRYooIiATdfn5Xs8+B6b0dwf44hJ9DQEwT0Cc6s/RFT4pBTg13sxIx6carkWmP6xVTECwArJDKkVTJEAS5tiiPU6wy5Xfq26nVQQ44sFYmRDAA4mLEosIGR5a9xRei/x+vI9qAgIJHI2YpbddTdbG5+7Nn6ryiIJUG4tiDh5RounhQaWHs2rwxadAbDdh8zl38AApHdOkHT/LAoYdh9Y5mo1Vj0uBecZjObwCLXo9Gpu4CQEjIkpdwgN2PAatc8I0e37TlIDgzxyTpKl8vLEhRwTAAU0wjb4QzU2Q+r05ARtuQQTHKmpdA1M/61lz6EbAmPEQI4jsRPvhPB+TchOySP6NVJo6Q9fnNrMSoVpz28b/W8QCthH4agGBgdUCttk8l9jbagFLsLzNa+y8BfwFdSmfUBzmFmIAAAAASUVORK5CYII=";

NSString *const HB_imageOK = @"iVBORw0KGgoAAAANSUhEUgAAAB4AAAAeCAMAAAAM7l6QAAAAaVBMVEVMaXF3d3f///+CgoJ3d3d3d3d3d3ekpKR3d3d3d3d6enp3d3f///93d3f///99fX3///////+zs7N3d3d3d3d3d3f////9/f3////+/v7////W1tZ3d3f///+RkZHc3Nzr6+vPz8+kpKRZlpGxAAAAHHRSTlMAMqz+RIIZCMfW/qtbm+poTM/86yRWPocimCrSqMGl/wAAATJJREFUeF6N0t12gyAQBGAJEEAi/iVN0gyoff+H7ILFUO1F90Y532GYi63+PUxqDWgt2R94M9jG3HZ4jfekYJViojGAPpcqRuj2fZQGoygUsKoMUxZgW/KIZl+lwZjzNeyxqoVe9QatjqwMRGKD9mCM+sGsvfRezwYyvslSCXnUyDKBATvq1z3H1lBH9cRncAKAgDXil57oikKd2QJip8SchMfwFtFLzeEhVjstNXmpsVogHmL/zkdvS60kBuJX6n9JXmql8SJ4crTZS5UId+Juoeur8+GtymD5iF8XYFf3b60sQp9+LjNHk9w9N23A5y6x6qeafLdM9dT/HD4debmKrQaf3CMfOz+HtMhXWjwhNRBmT702d1Qb24TFu0Ipv/d+GkIgCsPkff8oNdX227hLhm+Lfx2VWvyS+gAAAABJRU5ErkJggg==";

@implementation HBRefresh

+ (instancetype)initWithTarget:(id)target action:(SEL)action
{
    HBRefresh *refresh = [[self alloc] init];
    [refresh addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    return refresh;
}

- (void)beginRefreshing
{
    NSAssert(1 != 1, @"Unimplemented");
}

- (void)endRefreshing
{
    NSAssert(1 != 1, @"Unimplemented");
}

@end

@implementation HBRefreshHeader
{
    UIActivityIndicatorView *_activityIndicatorView;// 菊花
    UIImageView *_innerImageView;// 水滴图片
    UILabel *_tipLabel;// 结束提示
    
    BOOL _refreshing;// 刷新中
    CGFloat _width;// 整个宽度
    CGFloat _height;// 动态高度
    
    UIScrollView *_scrollView;// 当前视图
    NSUInteger _refreshIndex;// 刷新次数
    BOOL _canRefresh;// 能刷新
    BOOL _inseted;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [newSuperview addObserver:self forKeyPath:HB_contentOffset options:NSKeyValueObservingOptionNew context:nil];
    
    _refreshing = NO;
    _refreshIndex = 0;
    _canRefresh = YES;
    _width = newSuperview.bounds.size.width;
    _inseted = NO;
    
    self.frame = CGRectMake(0, -HB_height, _width, HB_height);
    self.backgroundColor = HB_backgroundColor;
    // 初始化
    _innerImageView = [[UIImageView alloc]initWithImage:HB_IMAGE(HB_imageRefresh)];
    [_innerImageView setContentMode:(UIViewContentModeScaleAspectFit)];
    [self addSubview:_innerImageView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((_width - 30)/2, 5, 30, 30)];
    [_activityIndicatorView setHidden:YES];
    [_activityIndicatorView setColor:HB_tinColor];
    [self addSubview:_activityIndicatorView];
    
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, HB_height)];
    _tipLabel.font = [UIFont systemFontOfSize:12];
    [_tipLabel setTextColor:HB_tinColor];
    [_tipLabel setHidden:YES];
    NSString *title = @" 刷新成功";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:title];
    NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
    attachment.image = HB_IMAGE(HB_imageOK);
    attachment.bounds = CGRectMake(0, 0, 12, 12);
    [attr insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
    [attr addAttribute:NSBaselineOffsetAttributeName value:@(1) range:NSMakeRange(1, title.length)];
    [_tipLabel setAttributedText:attr];
    [_tipLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self addSubview:_tipLabel];
}

- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:HB_contentOffset];
    [super removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:HB_contentOffset]) {
        return;
    }
    _scrollView = object;
    
    CGFloat h = _scrollView.contentOffset.y;
//    HB_Log(@"%.2f", h);
    if (h >= 0) {
        if (!_refreshing) {
            _canRefresh = YES;
        }
        return;
    }
    
    _height = MAX(-h, HB_height);
    self.frame = CGRectMake(0, -_height, _width, _height);
    
    // 下拉达到刷新点
    if (!_refreshing && _canRefresh && _height > HB_refreshHeight) {
        _canRefresh = NO;
        [self beginRefreshing];
    }
    // 绘制
    [self setNeedsDisplay];
    
    // 如果是刷新中回到最低高度
    if (_refreshing && _height <= HB_height && !_inseted) {
        _inseted = YES;
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.top = inset.top + HB_height;
        [_scrollView setContentInset:inset];
    }
}

- (void)drawRect:(CGRect)rect
{
    _innerImageView.hidden = NO;
    [_tipLabel setHidden:YES];
    if (!_canRefresh) {
        _innerImageView.hidden = YES;
        return;
    }
    // 上面大圆&下面小圆&一个倒梯形；在一个位置开始按比例缩放
    
    // 算个下拉比例
    CGFloat h = _height - HB_height;
    BOOL canStart = h > 0;
    CGFloat scale = 1;
    if (canStart) {
        scale = (100 - h) / 100.0;// 简单得到一个比例
//        HB_Log(@"%.2f", scale);
    }
    
    // 大圆
    CGFloat y = 5;
    CGFloat diam = (HB_height - y * 2) * scale;// 直径
    CGFloat r = diam / 2;// 半径
    CGFloat x = (_width - diam)/2;
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, diam, diam) cornerRadius:r];
    [HB_tinColor setFill];
    [circle fill];
    
    // 中间图标
    [_innerImageView setFrame:CGRectMake(0, 10, _width, diam - 10 * scale)];
    
    // 未到可以下拉高度
    if (!canStart) {
        return;
    }
    
    y += r;
    
    // 倒梯形
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x, y)];// 左上
    [path addLineToPoint:CGPointMake(x + diam, y)];// 右上
    
    CGFloat diam2 = diam * scale;// 在原来的基础上再缩小一次
    CGFloat x2 = x + (diam - diam2) / 2;
    [path addLineToPoint:CGPointMake(x2 + diam2, y + h)];// 右下
    [path addLineToPoint:CGPointMake(x2, y + h)];// 左下
    [path closePath];// 关闭路径
    [HB_tinColor setFill];// 设置填充颜色
    [path fill];
    
    // 小圆
    r = diam2 / 2;
    UIBezierPath *circle2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x2, h + y - r, diam2, diam2) cornerRadius:r];
    [HB_tinColor setFill];
    [circle2 fill];
    
}

- (void)beginRefreshing
{
    if (_refreshing) {
        return;
    }
    HB_Log(@"header beginRefreshing (%lu)", ++_refreshIndex);
    _refreshing = YES;
    [_activityIndicatorView startAnimating];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)endRefreshing
{
    if (!_refreshing) {
        return;
    }
    HB_Log(@"header endRefreshing (%lu)", _refreshIndex);
    _refreshing = NO;
    [_tipLabel setHidden:NO];
    [_activityIndicatorView stopAnimating];
    
    if (_inseted) {
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.top = inset.top - HB_height;
        [UIView animateWithDuration:0.5 animations:^{
            [_scrollView setContentInset:inset];
        } completion:^(BOOL finished) {
            _inseted = NO;
        }];
    }
}


@end

@implementation HBRefreshFooter
{
    
    UIActivityIndicatorView *_activityIndicatorView;// 菊花
    UILabel *_label;// 提示
    BOOL _refreshing;// 刷新中
    
    UIScrollView *_scrollView;// 当前视图
    NSUInteger _refreshIndex;// 刷新次数
    BOOL _inseted;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [newSuperview addObserver:self forKeyPath:HB_contentOffset options:NSKeyValueObservingOptionNew context:nil];
    CGFloat width = newSuperview.frame.size.width;
    _inseted = NO;
    
    self.frame = CGRectMake(0, -HB_height, width, HB_height);
    self.backgroundColor = HB_backgroundColor;
    
    // 初始化
    UIFont *font = [UIFont systemFontOfSize:13];
    NSString *text = @"  加载中..";
    CGFloat textWidth = HB_textWidth(text, font);
    
    CGFloat loadingDiam = HB_height - 10;// 菊花直径
    CGFloat margeWidth = textWidth + loadingDiam;
    CGFloat x = (width - margeWidth) / 2;
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, margeWidth, HB_height)];
    [_label setText:text];
    [_label setTextAlignment:(NSTextAlignmentRight)];
    [_label setFont:font];
    [_label setTextColor:HB_tinColor];
    [self addSubview:_label];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(x, 5, loadingDiam, loadingDiam)];
    [_activityIndicatorView setHidden:YES];
    [_activityIndicatorView setColor:HB_tinColor];
    [self addSubview:_activityIndicatorView];
}

- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:HB_contentOffset];
    [super removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (![keyPath isEqualToString:HB_contentOffset]) {
        return;
    }
    
    _scrollView = object;
    if (_scrollView.frame.size.height > _scrollView.contentSize.height || self.hidden) {
        return;
    }
    
    CGFloat h = _scrollView.contentSize.height - _scrollView.frame.size.height - _scrollView.contentOffset.y;
    
//    HB_Log(@"%.f", h);
    if (h >= 0) {
        return;
    }
    self.frame = CGRectMake(0, _scrollView.contentSize.height, _scrollView.frame.size.width, MAX(-h, HB_height));
    if (!_refreshing) {
        [self beginRefreshing];
        if (!_inseted) {
            _inseted = YES;
            UIEdgeInsets inset = _scrollView.contentInset;
            inset.bottom = inset.bottom + HB_height;
            [_scrollView setContentInset:inset];
        }
    }
}

- (void)beginRefreshing
{
    if (_refreshing) {
        return;
    }
    HB_Log(@"footer beginRefreshing (%lu)", ++_refreshIndex);
    _refreshing = YES;
    [_activityIndicatorView startAnimating];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setAlpha:1];
}

- (void)endRefreshing
{
    if (!_refreshing) {
        return;
    }
    _refreshing = NO;
    HB_Log(@"footer endRefreshing (%lu)", _refreshIndex);
    [_activityIndicatorView stopAnimating];
    [self setAlpha:0];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if (hidden && _inseted) {
        _inseted = NO;
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.bottom = inset.bottom - HB_height;
        [_scrollView setContentInset:inset];
    }
}

@end

@implementation UIScrollView (HBRefresh)

static const char HBRefreshHeaderKey = '\0';
static const char HBRefreshFooterKey = '\0';

- (void)setHb_header:(HBRefreshHeader *)hb_header
{
    if (hb_header != self.hb_header) {
        [self.hb_header removeFromSuperview];
        [self insertSubview:hb_header atIndex:0];
        [self willChangeValueForKey:@"hb_header"];
        objc_setAssociatedObject(self, &HBRefreshHeaderKey, hb_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"hb_header"];
    }
}

- (HBRefreshHeader *)hb_header
{
    return objc_getAssociatedObject(self, &HBRefreshHeaderKey);
}

- (void)setHb_footer:(HBRefreshFooter *)hb_footer
{
    if (hb_footer != self.hb_footer) {
        [self.hb_footer removeFromSuperview];
        [self insertSubview:hb_footer atIndex:0];
        [self willChangeValueForKey:@"hb_footer"];
        objc_setAssociatedObject(self, &HBRefreshFooterKey, hb_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"hb_footer"];
    }
}

- (HBRefreshFooter *)hb_footer
{
    return objc_getAssociatedObject(self, &HBRefreshFooterKey);
}

@end

