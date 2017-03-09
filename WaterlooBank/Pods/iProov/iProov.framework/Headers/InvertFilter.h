//
//  InvertFilter.h
//  Pods
//
//  Created by Jonathan Ellis on 01/02/2017.
//
//

#import <GPUImage/GPUImageFilter.h>

@interface InvertFilter : GPUImageFilter
{
    GLint invertedUniform;
}

@property(readwrite, nonatomic) BOOL inverted;

@end
