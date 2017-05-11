//
//  ViewController.m
//  OpenGlES-02纹理
//
//  Created by ShiWen on 2017/5/9.
//  Copyright © 2017年 ShiWen. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"
#import "AGLKView.h"
/*
 1、为缓存生成一个独一无二的标识符
 2、为接下来的运算绑定缓存
 3、赋值数据到缓存中
 4、启动
 5、设置指针
 6、绘图
 
 */


typedef struct {
    GLKVector3 postionCoords;
    GLKVector2 textureCorrds;
}Scenvertex;

/*
 纹理的点和图形的点同时描述相同的点，才可以将完成的纹理放上去，否侧图形会乱
*/
static const Scenvertex vertices[] = {
    
    {{-0.5f,0.5f,0.0f},{0.0f,1.0f}},//第二象限
    {{0.5f,-0.5f,0.0f},{1.0f,0.0f}},//第四象限
    {{0.5f,0.5f,0.0f},{1.0f,1.0f}},//第一象限
    
    {{-0.5f,-0.5f,0.0f},{0.0f,0.0f}},//第三象限
    {{0.5f,-0.5f,0.0f},{1.0f,0.0f}},//第四象限
    {{-0.5f,0.5f,0.0f},{0.0f,1.0f}},//第二象限
    
    
    
};

@interface ViewController ()
@property (nonatomic,strong)GLKBaseEffect *mBaseffect;
@property(nonatomic,strong) AGLKVertexAttribArrayBuffer *mVertexBuffer;


@end

@implementation ViewController

- (void)viewDidLoad {
    GLKView *view = (GLKView *)self.view;
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    self.mBaseffect = [[GLKBaseEffect alloc] init];
    self.mBaseffect.useConstantColor = GL_TRUE;
    self.mBaseffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
//    此方法设置清晰（背景）RGBA颜色。setClearColor方法
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.mVertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(Scenvertex) numberOfVertices:sizeof(vertices)/sizeof(Scenvertex) bytes:vertices usage:GL_STATIC_DRAW];
    ///设置纹理
    CGImageRef imageRef = [[UIImage imageNamed:@"test.jpg"] CGImage];
    
    /**
     纹理坐标系是反的，应矫正一下
     */
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:options error:nil];
    self.mBaseffect.texture2d0.name = textureInfo.name;
    self.mBaseffect.texture2d0.target = textureInfo.target;

}
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.mBaseffect prepareToDraw];
    
    [(AGLKContext*)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.mVertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                            numberOfCoordinates:3
                                   attribOffset:offsetof(Scenvertex, postionCoords) shouldEnable:YES];
    
    [self.mVertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                            numberOfCoordinates:2
                                   attribOffset:offsetof(Scenvertex, textureCorrds) shouldEnable:YES];
    
    [self.mVertexBuffer drawArrayWithMode:GL_TRIANGLES
                         startVertexIndex:0
                         numberOfVertices:6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
