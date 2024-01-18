//
//  OpenGLMetalKitView.m
//  FFmpeg-iOS
//
//  Created by 陈晶泊 on 2024/1/15.
//
@import MetalKit;
#import "LYShaderTypes.h"
#import "OpenGLMetalKitView.h"
@interface OpenGLMetalKitView()<MTKViewDelegate>
@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLTexture> yTexture;
@property (nonatomic, strong) id<MTLTexture> uTexture;
@property (nonatomic, strong) id<MTLTexture> vTexture;

@property (nonatomic, assign) vector_uint2 viewportSize;

// reader
@property (nonatomic, assign) CVMetalTextureCacheRef textureCache;

@property (nonatomic, strong) id<MTLBuffer> vertices;
@property (nonatomic, strong) id<MTLBuffer> convertMatrix;
@property (nonatomic, assign) NSUInteger numVertices;


@end
@implementation OpenGLMetalKitView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _device = MTLCreateSystemDefaultDevice();
        _mtkView = [[MTKView alloc] initWithFrame:self.bounds device:self.device];
        _mtkView.delegate = self;
        _mtkView.clearColor = MTLClearColorMake(1, 1, 1, 1.0f);
        _viewportSize = (vector_uint2){_mtkView.drawableSize.width, _mtkView.drawableSize.height};
        
        [self addSubview:self.mtkView];
        
        CVMetalTextureCacheCreate(NULL, NULL, _mtkView.device, NULL, &_textureCache);
        
        [self customInit];
    }
    return self;
}

- (void)customInit {
    [self setupPipeline];
    [self setupVertex];
    [self setupMatrix];
}

// 设置顶点
- (void)setupVertex {
    static const LYVertex quadVertices[] =
    {   // 顶点坐标，分别是x、y、z、w；    纹理坐标，x、y；
        { {  1.0, -1.0, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -1.0, -1.0, 0.0, 1.0 },  { 0.f, 1.f } },
        { { -1.0,  1.0, 0.0, 1.0 },  { 0.f, 0.f } },
        
        { {  1.0, -1.0, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -1.0,  1.0, 0.0, 1.0 },  { 0.f, 0.f } },
        { {  1.0,  1.0, 0.0, 1.0 },  { 1.f, 0.f } },
    };
    self.vertices = [self.mtkView.device newBufferWithBytes:quadVertices
                                                     length:sizeof(quadVertices)
                                                    options:MTLResourceStorageModeShared]; // 创建顶点缓存
    self.numVertices = sizeof(quadVertices) / sizeof(LYVertex); // 顶点个数
}

/**
 
 // BT.601, which is the standard for SDTV.
 matrix_float3x3 kColorConversion601Default = (matrix_float3x3){
 (simd_float3){1.164,  1.164, 1.164},
 (simd_float3){0.0, -0.392, 2.017},
 (simd_float3){1.596, -0.813,   0.0},
 };
 
 //// BT.601 full range (ref: http://www.equasys.de/colorconversion.html)
 matrix_float3x3 kColorConversion601FullRangeDefault = (matrix_float3x3){
 (simd_float3){1.0,    1.0,    1.0},
 (simd_float3){0.0,    -0.343, 1.765},
 (simd_float3){1.4,    -0.711, 0.0},
 };
 
 //// BT.709, which is the standard for HDTV.
 matrix_float3x3 kColorConversion709Default[] = {
 (simd_float3){1.164,  1.164, 1.164},
 (simd_float3){0.0, -0.213, 2.112},
 (simd_float3){1.793, -0.533,   0.0},
 };
 */
- (void)setupMatrix { // 设置好转换的矩阵
    matrix_float3x3 kColorConversion601FullRangeMatrix = (matrix_float3x3){
        (simd_float3){1.0,    1.0,    1.0},
        (simd_float3){0.0,    -0.343, 1.765},
        (simd_float3){1.4,    -0.711, 0.0},
    };
    
    vector_float3 kColorConversion601FullRangeOffset = (vector_float3){ -(16.0/255.0), -0.5, -0.5}; // 这个是偏移
    
    LYConvertMatrix matrix;
    // 设置参数
    matrix.matrix = kColorConversion601FullRangeMatrix;
    matrix.offset = kColorConversion601FullRangeOffset;
    
    self.convertMatrix = [self.mtkView.device newBufferWithBytes:&matrix
                                                          length:sizeof(LYConvertMatrix)
                                                         options:MTLResourceStorageModeShared];
}

// 设置渲染管道
-(void)setupPipeline {
    id<MTLLibrary> defaultLibrary = [self.mtkView.device newDefaultLibrary]; // .metal
    id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"]; // 顶点shader，vertexShader是函数名
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"samplingShader"]; // 片元shader，samplingShader是函数名
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat; // 设置颜色格式
    
    self.pipelineState = [self.mtkView.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                             error:NULL]; // 创建图形渲染管道，耗性能操作不宜频繁调用
    self.commandQueue = [self.mtkView.device newCommandQueue]; // CommandQueue是渲染指令队列，保证渲染指令有序地提交到GPU
}


- (void)updateYUVData:(NSData *)yuvData width:(int)width hegiht:(int)height {
    
    self.viewportSize = (vector_uint2){width, height};
    MTLTextureDescriptor *yDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR8Unorm width:width height:height mipmapped:NO];
    MTLTextureDescriptor *uyDescriptor = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatR8Unorm width:width/2 height:height/2 mipmapped:NO];
    self.yTexture = [self.device newTextureWithDescriptor:yDescriptor];
    self.uTexture = [self.device newTextureWithDescriptor:uyDescriptor];
    self.vTexture = [self.device newTextureWithDescriptor:uyDescriptor];

    // Upload YUV data to textures
    [self.yTexture replaceRegion:MTLRegionMake2D(0, 0, width, height) mipmapLevel:0 withBytes:yuvData.bytes bytesPerRow:width];
    [self.uTexture replaceRegion:MTLRegionMake2D(0, 0, width/2, height/2) mipmapLevel:0 withBytes:yuvData.bytes + width * height bytesPerRow:width/2];
    [self.vTexture replaceRegion:MTLRegionMake2D(0, 0, width/2, height/2) mipmapLevel:0 withBytes:yuvData.bytes + width * height * 5 / 4 bytesPerRow:width / 2];
}

//MARK: MTKViewDelegate
- (void)drawInMTKView:(MTKView *)view {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    view.currentRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1.0f); // 设置默认颜色
    if (self.yTexture && self.uTexture && self.vTexture) {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:view.currentRenderPassDescriptor];
        [renderEncoder setRenderPipelineState:self.pipelineState];
        // Set vertex and fragment shader resources
        [renderEncoder setViewport:self.viewPortFrame];
        [renderEncoder setRenderPipelineState:self.pipelineState]; // 设置渲染管道，以保证顶点和片元两个shader会被调用
        
        [renderEncoder setVertexBuffer:self.vertices
                                offset:0
                               atIndex:LYVertexInputIndexVertices]; // 设置顶点缓存
        [renderEncoder setFragmentTexture:self.yTexture atIndex:LYFragmentTextureIndexTextureY];
        [renderEncoder setFragmentTexture:self.uTexture atIndex:LYFragmentTextureIndexTextureU];
        [renderEncoder setFragmentTexture:self.vTexture atIndex:LYFragmentTextureIndexTextureV];
        
        [renderEncoder setFragmentBuffer:self.convertMatrix
                                  offset:0
                                 atIndex:LYFragmentInputIndexMatrix];
         //Draw call
        
        [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:self.numVertices];
        [renderEncoder endEncoding];
        
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    [commandBuffer commit];
}


- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    self.viewportSize = (vector_uint2){size.width, size.height};
}

- (MTLViewport)viewPortFrame {
    int dx = 0,dy = 0,
    w = self.mtkView.drawableSize.width,h = self.mtkView.drawableSize.height,
    dw = self.viewportSize.x,dh = self.viewportSize.y;
    
    // 计算目标尺寸
    if (dw * h > w * dh) {
        dh = w * dh / dw;
        dw = w;
    } else {
        dw = h * dw / dh;
        dh = h;
    }
    dx = (w - dw) >> 1;
    dy = (h - dh) >> 1;
    return (MTLViewport){dx, dy, dw, dh, 0, 10.0 };
}

- (void)dealloc {
    NSLog(@"____%s",__func__);
}
@end
