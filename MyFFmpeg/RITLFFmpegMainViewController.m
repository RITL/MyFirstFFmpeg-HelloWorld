//
//  ViewController.m
//  MyFFmpeg
//
//  Created by YueWen on 2016/10/17.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLFFmpegMainViewController.h"
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavfilter/avfilter.h>

@interface RITLFFmpegMainViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation RITLFFmpegMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //注册
    avcodec_register_all();
    
    //缓存数组
    char info[10000] = {0};
    printf("%s\n",avcodec_configuration());
    
    
    sprintf(info, "%s\n",avcodec_configuration());
    NSString * info_ns = [NSString stringWithFormat:@"%s",info];
    
    //文本打印
    self.contentTextView.text = info_ns;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Protocol

- (IBAction)protocolBtnDidTap:(id)sender
{
    //缓冲数组
    char info[40000] = {0};
    
    //register
    avcodec_register_all();
    
    //
    struct URLProtocol * pup = NULL;
    
    //input
    struct URLProtocol **p_temp = &pup;
    
    avio_enum_protocols((void**)p_temp, 0);
    
    while((*p_temp) != NULL)
    {
        sprintf(info, "%s[In][%10s]\n",info,avio_enum_protocols((void**)p_temp, 0));
    }
    
    pup = NULL;
//    *p_temp = NULL;
    
    //output
    avio_enum_protocols((void**)p_temp, 1);
    while((*p_temp) != NULL)
    {
        sprintf(info, "%s[Out][%10s]\n",info,avio_enum_protocols((void**)p_temp, 1));
    }
    
    NSString * info_ns = [NSString stringWithFormat:@"%s",info];
    self.contentTextView.text = info_ns;
}


- (IBAction)formatBtnDidTap:(id)sender
{
    //catche array
    char info[40000] = {0};
    
    av_register_all();
    
    AVInputFormat * if_temp = av_iformat_next(NULL);
    AVOutputFormat * out_temp = av_oformat_next(NULL);
    
    //Input
    while (if_temp != NULL)
    {
        sprintf(info, "%s[In ]%10s\n",info,if_temp->name);
        if_temp = if_temp->next;
    }
    
    //Output
    while (out_temp != NULL)
    {
        sprintf(info, "%s[Out ]%10s\n",info,out_temp->name);
        out_temp = out_temp->next;
    }
    
    NSString * info_ns = [NSString stringWithFormat:@"%s",info];
    
    self.contentTextView.text = info_ns;
    
    av_free(if_temp);
    av_free(out_temp);
}


- (IBAction)codecButtonDidTap:(id)sender
{
    char info[40000] = {0};
    
    av_register_all();
    
    AVCodec * c_temp = av_codec_next(NULL);
    
    while (c_temp != NULL)
    {
        if (c_temp->decode !=  NULL)
        {
            sprintf(info, "%s[Dec]",info);
        }else{
            
            sprintf(info, "%s[Enc]",info);
        }
        
        switch (c_temp->type)
        {
            case AVMEDIA_TYPE_VIDEO:
                sprintf(info, "%s[Video]",info);
                break;
                
            case AVMEDIA_TYPE_AUDIO:
                sprintf(info, "%s[Audio]",info);
                break;
                
            default:
                sprintf(info, "%s[Other]",info);
                break;
        }
        sprintf(info, "%s%10s\n",info,c_temp->name);
        
        c_temp = c_temp->next;
    }
    
    NSString * info_ns = [NSString stringWithFormat:@"%s",info];
    self.contentTextView.text = info_ns;
    
    av_free(c_temp);
}

- (IBAction)filterButtonDidTap:(id)sender
{
    char info[40000] = {0};
    
    avfilter_register_all();
    
    AVFilter * origin = avfilter_get_by_name("hello world");
    
    AVFilter * f_temp = (AVFilter *)avfilter_next(origin);
    
    while (f_temp != NULL)
    {
        sprintf(info, "%s[%10s]\n",info,f_temp->name);
        f_temp = f_temp->next;
    }
    
    NSString * info_ns = [NSString stringWithFormat:@"%s",info];
    self.contentTextView.text = info_ns;
    
//    avfilter_free(f_temp);
}



- (IBAction)configButtonDidTap:(id)sender
{
    char info[40000] = {0};
    
    av_register_all();
    
    sprintf(info, "%s\n",avcodec_configuration());
    
    NSString * info_ns = [NSString stringWithFormat:@"%s",info];
    
    self.contentTextView.text = info_ns;
}

@end
