package native.gl;


import native.display.BitmapData;
import native.utils.ArrayBuffer;
import native.utils.ArrayBufferView;
import native.utils.ByteArray;
import native.utils.Float32Array;
import native.utils.IMemoryRange;
import native.geom.Matrix3D;
import native.Lib;
import native.Loader;


class GL {
	
	
	/* ClearBufferMask */
	public static inline var DEPTH_BUFFER_BIT               = 0x00000100;
	public static inline var STENCIL_BUFFER_BIT             = 0x00000400;
	public static inline var COLOR_BUFFER_BIT               = 0x00004000;

	/* BeginMode */
	public static inline var POINTS                         = 0x0000;
	public static inline var LINES                          = 0x0001;
	public static inline var LINE_LOOP                      = 0x0002;
	public static inline var LINE_STRIP                     = 0x0003;
	public static inline var TRIANGLES                      = 0x0004;
	public static inline var TRIANGLE_STRIP                 = 0x0005;
	public static inline var TRIANGLE_FAN                   = 0x0006;

	/* AlphaFunction (not supported in ES20) */
	/*      NEVER */
	/*      LESS */
	/*      EQUAL */
	/*      LEQUAL */
	/*      GREATER */
	/*      NOTEQUAL */
	/*      GEQUAL */
	/*      ALWAYS */

	/* BlendingFactorDest */
	public static inline var ZERO                           = 0;
	public static inline var ONE                            = 1;
	public static inline var SRC_COLOR                      = 0x0300;
	public static inline var ONE_MINUS_SRC_COLOR            = 0x0301;
	public static inline var SRC_ALPHA                      = 0x0302;
	public static inline var ONE_MINUS_SRC_ALPHA            = 0x0303;
	public static inline var DST_ALPHA                      = 0x0304;
	public static inline var ONE_MINUS_DST_ALPHA            = 0x0305;

	/* BlendingFactorSrc */
	/*      ZERO */
	/*      ONE */
	public static inline var DST_COLOR                      = 0x0306;
	public static inline var ONE_MINUS_DST_COLOR            = 0x0307;
	public static inline var SRC_ALPHA_SATURATE             = 0x0308;
	/*      SRC_ALPHA */
	/*      ONE_MINUS_SRC_ALPHA */
	/*      DST_ALPHA */
	/*      ONE_MINUS_DST_ALPHA */

	/* BlendEquationSeparate */
	public static inline var FUNC_ADD                       = 0x8006;
	public static inline var BLEND_EQUATION                 = 0x8009;
	public static inline var BLEND_EQUATION_RGB             = 0x8009;   /* same as BLEND_EQUATION */
	public static inline var BLEND_EQUATION_ALPHA           = 0x883D;

	/* BlendSubtract */
	public static inline var FUNC_SUBTRACT                  = 0x800A;
	public static inline var FUNC_REVERSE_SUBTRACT          = 0x800B;

	/* Separate Blend Functions */
	public static inline var BLEND_DST_RGB                  = 0x80C8;
	public static inline var BLEND_SRC_RGB                  = 0x80C9;
	public static inline var BLEND_DST_ALPHA                = 0x80CA;
	public static inline var BLEND_SRC_ALPHA                = 0x80CB;
	public static inline var CONSTANT_COLOR                 = 0x8001;
	public static inline var ONE_MINUS_CONSTANT_COLOR       = 0x8002;
	public static inline var CONSTANT_ALPHA                 = 0x8003;
	public static inline var ONE_MINUS_CONSTANT_ALPHA       = 0x8004;
	public static inline var BLEND_COLOR                    = 0x8005;

	/* Buffer Objects */
	public static inline var ARRAY_BUFFER                   = 0x8892;
	public static inline var ELEMENT_ARRAY_BUFFER           = 0x8893;
	public static inline var ARRAY_BUFFER_BINDING           = 0x8894;
	public static inline var ELEMENT_ARRAY_BUFFER_BINDING   = 0x8895;

	public static inline var STREAM_DRAW                    = 0x88E0;
	public static inline var STATIC_DRAW                    = 0x88E4;
	public static inline var DYNAMIC_DRAW                   = 0x88E8;

	public static inline var BUFFER_SIZE                    = 0x8764;
	public static inline var BUFFER_USAGE                   = 0x8765;

	public static inline var CURRENT_VERTEX_ATTRIB          = 0x8626;

	/* CullFaceMode */
	public static inline var FRONT                          = 0x0404;
	public static inline var BACK                           = 0x0405;
	public static inline var FRONT_AND_BACK                 = 0x0408;

	/* DepthFunction */
	/*      NEVER */
	/*      LESS */
	/*      EQUAL */
	/*      LEQUAL */
	/*      GREATER */
	/*      NOTEQUAL */
	/*      GEQUAL */
	/*      ALWAYS */

	/* EnableCap */
	/* TEXTURE_2D */
	public static inline var CULL_FACE                      = 0x0B44;
	public static inline var BLEND                          = 0x0BE2;
	public static inline var DITHER                         = 0x0BD0;
	public static inline var STENCIL_TEST                   = 0x0B90;
	public static inline var DEPTH_TEST                     = 0x0B71;
	public static inline var SCISSOR_TEST                   = 0x0C11;
	public static inline var POLYGON_OFFSET_FILL            = 0x8037;
	public static inline var SAMPLE_ALPHA_TO_COVERAGE       = 0x809E;
	public static inline var SAMPLE_COVERAGE                = 0x80A0;

	/* ErrorCode */
	public static inline var NO_ERROR                       = 0;
	public static inline var INVALID_ENUM                   = 0x0500;
	public static inline var INVALID_VALUE                  = 0x0501;
	public static inline var INVALID_OPERATION              = 0x0502;
	public static inline var OUT_OF_MEMORY                  = 0x0505;

	/* FrontFaceDirection */
	public static inline var CW                             = 0x0900;
	public static inline var CCW                            = 0x0901;

	/* GetPName */
	public static inline var LINE_WIDTH                     = 0x0B21;
	public static inline var ALIASED_POINT_SIZE_RANGE       = 0x846D;
	public static inline var ALIASED_LINE_WIDTH_RANGE       = 0x846E;
	public static inline var CULL_FACE_MODE                 = 0x0B45;
	public static inline var FRONT_FACE                     = 0x0B46;
	public static inline var DEPTH_RANGE                    = 0x0B70;
	public static inline var DEPTH_WRITEMASK                = 0x0B72;
	public static inline var DEPTH_CLEAR_VALUE              = 0x0B73;
	public static inline var DEPTH_FUNC                     = 0x0B74;
	public static inline var STENCIL_CLEAR_VALUE            = 0x0B91;
	public static inline var STENCIL_FUNC                   = 0x0B92;
	public static inline var STENCIL_FAIL                   = 0x0B94;
	public static inline var STENCIL_PASS_DEPTH_FAIL        = 0x0B95;
	public static inline var STENCIL_PASS_DEPTH_PASS        = 0x0B96;
	public static inline var STENCIL_REF                    = 0x0B97;
	public static inline var STENCIL_VALUE_MASK             = 0x0B93;
	public static inline var STENCIL_WRITEMASK              = 0x0B98;
	public static inline var STENCIL_BACK_FUNC              = 0x8800;
	public static inline var STENCIL_BACK_FAIL              = 0x8801;
	public static inline var STENCIL_BACK_PASS_DEPTH_FAIL   = 0x8802;
	public static inline var STENCIL_BACK_PASS_DEPTH_PASS   = 0x8803;
	public static inline var STENCIL_BACK_REF               = 0x8CA3;
	public static inline var STENCIL_BACK_VALUE_MASK        = 0x8CA4;
	public static inline var STENCIL_BACK_WRITEMASK         = 0x8CA5;
	public static inline var VIEWPORT                       = 0x0BA2;
	public static inline var SCISSOR_BOX                    = 0x0C10;
	/*      SCISSOR_TEST */
	public static inline var COLOR_CLEAR_VALUE              = 0x0C22;
	public static inline var COLOR_WRITEMASK                = 0x0C23;
	public static inline var UNPACK_ALIGNMENT               = 0x0CF5;
	public static inline var PACK_ALIGNMENT                 = 0x0D05;
	public static inline var MAX_TEXTURE_SIZE               = 0x0D33;
	public static inline var MAX_VIEWPORT_DIMS              = 0x0D3A;
	public static inline var SUBPIXEL_BITS                  = 0x0D50;
	public static inline var RED_BITS                       = 0x0D52;
	public static inline var GREEN_BITS                     = 0x0D53;
	public static inline var BLUE_BITS                      = 0x0D54;
	public static inline var ALPHA_BITS                     = 0x0D55;
	public static inline var DEPTH_BITS                     = 0x0D56;
	public static inline var STENCIL_BITS                   = 0x0D57;
	public static inline var POLYGON_OFFSET_UNITS           = 0x2A00;
	/*      POLYGON_OFFSET_FILL */
	public static inline var POLYGON_OFFSET_FACTOR          = 0x8038;
	public static inline var TEXTURE_BINDING_2D             = 0x8069;
	public static inline var SAMPLE_BUFFERS                 = 0x80A8;
	public static inline var SAMPLES                        = 0x80A9;
	public static inline var SAMPLE_COVERAGE_VALUE          = 0x80AA;
	public static inline var SAMPLE_COVERAGE_INVERT         = 0x80AB;

	/* GetTextureParameter */
	/*      TEXTURE_MAG_FILTER */
	/*      TEXTURE_MIN_FILTER */
	/*      TEXTURE_WRAP_S */
	/*      TEXTURE_WRAP_T */

	public static inline var COMPRESSED_TEXTURE_FORMATS     = 0x86A3;

	/* HintMode */
	public static inline var DONT_CARE                      = 0x1100;
	public static inline var FASTEST                        = 0x1101;
	public static inline var NICEST                         = 0x1102;

	/* HintTarget */
	public static inline var GENERATE_MIPMAP_HINT            = 0x8192;

	/* DataType */
	public static inline var BYTE                           = 0x1400;
	public static inline var UNSIGNED_BYTE                  = 0x1401;
	public static inline var SHORT                          = 0x1402;
	public static inline var UNSIGNED_SHORT                 = 0x1403;
	public static inline var INT                            = 0x1404;
	public static inline var UNSIGNED_INT                   = 0x1405;
	public static inline var FLOAT                          = 0x1406;

	/* PixelFormat */
	public static inline var DEPTH_COMPONENT                = 0x1902;
	public static inline var ALPHA                          = 0x1906;
	public static inline var RGB                            = 0x1907;
	public static inline var RGBA                           = 0x1908;
	public static inline var LUMINANCE                      = 0x1909;
	public static inline var LUMINANCE_ALPHA                = 0x190A;

	/* PixelType */
	/*      UNSIGNED_BYTE */
	public static inline var UNSIGNED_SHORT_4_4_4_4         = 0x8033;
	public static inline var UNSIGNED_SHORT_5_5_5_1         = 0x8034;
	public static inline var UNSIGNED_SHORT_5_6_5           = 0x8363;

	/* Shaders */
	public static inline var FRAGMENT_SHADER                  = 0x8B30;
	public static inline var VERTEX_SHADER                    = 0x8B31;
	public static inline var MAX_VERTEX_ATTRIBS               = 0x8869;
	public static inline var MAX_VERTEX_UNIFORM_VECTORS       = 0x8DFB;
	public static inline var MAX_VARYING_VECTORS              = 0x8DFC;
	public static inline var MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
	public static inline var MAX_VERTEX_TEXTURE_IMAGE_UNITS   = 0x8B4C;
	public static inline var MAX_TEXTURE_IMAGE_UNITS          = 0x8872;
	public static inline var MAX_FRAGMENT_UNIFORM_VECTORS     = 0x8DFD;
	public static inline var SHADER_TYPE                      = 0x8B4F;
	public static inline var DELETE_STATUS                    = 0x8B80;
	public static inline var LINK_STATUS                      = 0x8B82;
	public static inline var VALIDATE_STATUS                  = 0x8B83;
	public static inline var ATTACHED_SHADERS                 = 0x8B85;
	public static inline var ACTIVE_UNIFORMS                  = 0x8B86;
	public static inline var ACTIVE_ATTRIBUTES                = 0x8B89;
	public static inline var SHADING_LANGUAGE_VERSION         = 0x8B8C;
	public static inline var CURRENT_PROGRAM                  = 0x8B8D;

	/* StencilFunction */
	public static inline var NEVER                          = 0x0200;
	public static inline var LESS                           = 0x0201;
	public static inline var EQUAL                          = 0x0202;
	public static inline var LEQUAL                         = 0x0203;
	public static inline var GREATER                        = 0x0204;
	public static inline var NOTEQUAL                       = 0x0205;
	public static inline var GEQUAL                         = 0x0206;
	public static inline var ALWAYS                         = 0x0207;

	/* StencilOp */
	/*      ZERO */
	public static inline var KEEP                           = 0x1E00;
	public static inline var REPLACE                        = 0x1E01;
	public static inline var INCR                           = 0x1E02;
	public static inline var DECR                           = 0x1E03;
	public static inline var INVERT                         = 0x150A;
	public static inline var INCR_WRAP                      = 0x8507;
	public static inline var DECR_WRAP                      = 0x8508;

	/* StringName */
	public static inline var VENDOR                         = 0x1F00;
	public static inline var RENDERER                       = 0x1F01;
	public static inline var VERSION                        = 0x1F02;

	/* TextureMagFilter */
	public static inline var NEAREST                        = 0x2600;
	public static inline var LINEAR                         = 0x2601;

	/* TextureMinFilter */
	/*      NEAREST */
	/*      LINEAR */
	public static inline var NEAREST_MIPMAP_NEAREST         = 0x2700;
	public static inline var LINEAR_MIPMAP_NEAREST          = 0x2701;
	public static inline var NEAREST_MIPMAP_LINEAR          = 0x2702;
	public static inline var LINEAR_MIPMAP_LINEAR           = 0x2703;

	/* TextureParameterName */
	public static inline var TEXTURE_MAG_FILTER             = 0x2800;
	public static inline var TEXTURE_MIN_FILTER             = 0x2801;
	public static inline var TEXTURE_WRAP_S                 = 0x2802;
	public static inline var TEXTURE_WRAP_T                 = 0x2803;

	/* TextureTarget */
	public static inline var TEXTURE_2D                     = 0x0DE1;
	public static inline var TEXTURE                        = 0x1702;

	public static inline var TEXTURE_CUBE_MAP               = 0x8513;
	public static inline var TEXTURE_BINDING_CUBE_MAP       = 0x8514;
	public static inline var TEXTURE_CUBE_MAP_POSITIVE_X    = 0x8515;
	public static inline var TEXTURE_CUBE_MAP_NEGATIVE_X    = 0x8516;
	public static inline var TEXTURE_CUBE_MAP_POSITIVE_Y    = 0x8517;
	public static inline var TEXTURE_CUBE_MAP_NEGATIVE_Y    = 0x8518;
	public static inline var TEXTURE_CUBE_MAP_POSITIVE_Z    = 0x8519;
	public static inline var TEXTURE_CUBE_MAP_NEGATIVE_Z    = 0x851A;
	public static inline var MAX_CUBE_MAP_TEXTURE_SIZE      = 0x851C;

	/* TextureUnit */
	public static inline var TEXTURE0                       = 0x84C0;
	public static inline var TEXTURE1                       = 0x84C1;
	public static inline var TEXTURE2                       = 0x84C2;
	public static inline var TEXTURE3                       = 0x84C3;
	public static inline var TEXTURE4                       = 0x84C4;
	public static inline var TEXTURE5                       = 0x84C5;
	public static inline var TEXTURE6                       = 0x84C6;
	public static inline var TEXTURE7                       = 0x84C7;
	public static inline var TEXTURE8                       = 0x84C8;
	public static inline var TEXTURE9                       = 0x84C9;
	public static inline var TEXTURE10                      = 0x84CA;
	public static inline var TEXTURE11                      = 0x84CB;
	public static inline var TEXTURE12                      = 0x84CC;
	public static inline var TEXTURE13                      = 0x84CD;
	public static inline var TEXTURE14                      = 0x84CE;
	public static inline var TEXTURE15                      = 0x84CF;
	public static inline var TEXTURE16                      = 0x84D0;
	public static inline var TEXTURE17                      = 0x84D1;
	public static inline var TEXTURE18                      = 0x84D2;
	public static inline var TEXTURE19                      = 0x84D3;
	public static inline var TEXTURE20                      = 0x84D4;
	public static inline var TEXTURE21                      = 0x84D5;
	public static inline var TEXTURE22                      = 0x84D6;
	public static inline var TEXTURE23                      = 0x84D7;
	public static inline var TEXTURE24                      = 0x84D8;
	public static inline var TEXTURE25                      = 0x84D9;
	public static inline var TEXTURE26                      = 0x84DA;
	public static inline var TEXTURE27                      = 0x84DB;
	public static inline var TEXTURE28                      = 0x84DC;
	public static inline var TEXTURE29                      = 0x84DD;
	public static inline var TEXTURE30                      = 0x84DE;
	public static inline var TEXTURE31                      = 0x84DF;
	public static inline var ACTIVE_TEXTURE                 = 0x84E0;

	/* TextureWrapMode */
	public static inline var REPEAT                         = 0x2901;
	public static inline var CLAMP_TO_EDGE                  = 0x812F;
	public static inline var MIRRORED_REPEAT                = 0x8370;

	/* Uniform Types */
	public static inline var FLOAT_VEC2                     = 0x8B50;
	public static inline var FLOAT_VEC3                     = 0x8B51;
	public static inline var FLOAT_VEC4                     = 0x8B52;
	public static inline var INT_VEC2                       = 0x8B53;
	public static inline var INT_VEC3                       = 0x8B54;
	public static inline var INT_VEC4                       = 0x8B55;
	public static inline var BOOL                           = 0x8B56;
	public static inline var BOOL_VEC2                      = 0x8B57;
	public static inline var BOOL_VEC3                      = 0x8B58;
	public static inline var BOOL_VEC4                      = 0x8B59;
	public static inline var FLOAT_MAT2                     = 0x8B5A;
	public static inline var FLOAT_MAT3                     = 0x8B5B;
	public static inline var FLOAT_MAT4                     = 0x8B5C;
	public static inline var SAMPLER_2D                     = 0x8B5E;
	public static inline var SAMPLER_CUBE                   = 0x8B60;

	/* Vertex Arrays */
	public static inline var VERTEX_ATTRIB_ARRAY_ENABLED        = 0x8622;
	public static inline var VERTEX_ATTRIB_ARRAY_SIZE           = 0x8623;
	public static inline var VERTEX_ATTRIB_ARRAY_STRIDE         = 0x8624;
	public static inline var VERTEX_ATTRIB_ARRAY_TYPE           = 0x8625;
	public static inline var VERTEX_ATTRIB_ARRAY_NORMALIZED     = 0x886A;
	public static inline var VERTEX_ATTRIB_ARRAY_POINTER        = 0x8645;
	public static inline var VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;

	/* Shader Source */
	public static inline var COMPILE_STATUS                 = 0x8B81;

	/* Shader Precision-Specified Types */
	public static inline var LOW_FLOAT                      = 0x8DF0;
	public static inline var MEDIUM_FLOAT                   = 0x8DF1;
	public static inline var HIGH_FLOAT                     = 0x8DF2;
	public static inline var LOW_INT                        = 0x8DF3;
	public static inline var MEDIUM_INT                     = 0x8DF4;
	public static inline var HIGH_INT                       = 0x8DF5;

	/* Framebuffer Object. */
	public static inline var FRAMEBUFFER                    = 0x8D40;
	public static inline var RENDERBUFFER                   = 0x8D41;

	public static inline var RGBA4                          = 0x8056;
	public static inline var RGB5_A1                        = 0x8057;
	public static inline var RGB565                         = 0x8D62;
	public static inline var DEPTH_COMPONENT16              = 0x81A5;
	public static inline var STENCIL_INDEX                  = 0x1901;
	public static inline var STENCIL_INDEX8                 = 0x8D48;
	public static inline var DEPTH_STENCIL                  = 0x84F9;

	public static inline var RENDERBUFFER_WIDTH             = 0x8D42;
	public static inline var RENDERBUFFER_HEIGHT            = 0x8D43;
	public static inline var RENDERBUFFER_INTERNAL_FORMAT   = 0x8D44;
	public static inline var RENDERBUFFER_RED_SIZE          = 0x8D50;
	public static inline var RENDERBUFFER_GREEN_SIZE        = 0x8D51;
	public static inline var RENDERBUFFER_BLUE_SIZE         = 0x8D52;
	public static inline var RENDERBUFFER_ALPHA_SIZE        = 0x8D53;
	public static inline var RENDERBUFFER_DEPTH_SIZE        = 0x8D54;
	public static inline var RENDERBUFFER_STENCIL_SIZE      = 0x8D55;

	public static inline var FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE           = 0x8CD0;
	public static inline var FRAMEBUFFER_ATTACHMENT_OBJECT_NAME           = 0x8CD1;
	public static inline var FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL         = 0x8CD2;
	public static inline var FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;

	public static inline var COLOR_ATTACHMENT0              = 0x8CE0;
	public static inline var DEPTH_ATTACHMENT               = 0x8D00;
	public static inline var STENCIL_ATTACHMENT             = 0x8D20;
	public static inline var DEPTH_STENCIL_ATTACHMENT       = 0x821A;

	public static inline var NONE                           = 0;

	public static inline var FRAMEBUFFER_COMPLETE                      = 0x8CD5;
	public static inline var FRAMEBUFFER_INCOMPLETE_ATTACHMENT         = 0x8CD6;
	public static inline var FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
	public static inline var FRAMEBUFFER_INCOMPLETE_DIMENSIONS         = 0x8CD9;
	public static inline var FRAMEBUFFER_UNSUPPORTED                   = 0x8CDD;

	public static inline var FRAMEBUFFER_BINDING            = 0x8CA6;
	public static inline var RENDERBUFFER_BINDING           = 0x8CA7;
	public static inline var MAX_RENDERBUFFER_SIZE          = 0x84E8;

	public static inline var INVALID_FRAMEBUFFER_OPERATION  = 0x0506;

	/* WebGL-specific enums */
	public static inline var UNPACK_FLIP_Y_WEBGL            = 0x9240;
	public static inline var UNPACK_PREMULTIPLY_ALPHA_WEBGL = 0x9241;
	public static inline var CONTEXT_LOST_WEBGL             = 0x9242;
	public static inline var UNPACK_COLORSPACE_CONVERSION_WEBGL = 0x9243;
	public static inline var BROWSER_DEFAULT_WEBGL          = 0x9244;
	
	
	public static var drawingBufferHeight (get_drawingBufferHeight, null):Int;
	public static var drawingBufferWidth (get_drawingBufferWidth, null):Int;
	public static var version (get_version, null):Int;
	
	
	
	public static function activeTexture (texture:Int):Void { nme_gl_active_texture (texture); }
	
	
	public static function attachShader (program:Program, shader:Shader):Void {
		
		program.attach (shader);
		nme_gl_attach_shader (program.id, shader.id);
		
	}
	
	
	public static function bindAttribLocation (program:Program, index:Int, name:String):Void {
		
		nme_gl_bind_attrib_location (program.id, index, name);
		
	}
	
	
	public static function bindBitmapDataTexture (texture:BitmapData):Void {
		
		nme_gl_bind_bitmap_data_texture (texture.nmeHandle);
		
	}
	
	
	public static function bindBuffer (target:Int, buffer:Buffer):Void {
		
		nme_gl_bind_buffer (target, buffer == null ? 0 : buffer.id);
		
	}
	
	
	public static function bindFramebuffer (target:Int, framebuffer:Framebuffer):Void {
		
		nme_gl_bind_framebuffer (target, framebuffer == null ? 0 : framebuffer.id);
		
	}
	
	
	public static function bindRenderbuffer (target:Int, renderbuffer:Renderbuffer):Void {
		
		nme_gl_bind_renderbuffer (target, renderbuffer == null ? 0 : renderbuffer.id);
		
	}
	
	
	public static function bindTexture (target:Int, texture:Texture):Void {
		
		nme_gl_bind_texture (target, texture == null ? 0 : texture.id);
		
	}
	
	
	public static function blendColor (red:Float, green:Float, blue:Float, alpha:Float):Void {
		
		nme_gl_blend_color (red, green, blue, alpha);
		
	}
	
	
	public static function blendEquation (mode:Int):Void {
		
		nme_gl_blend_equation (mode);
		
	}
	
	
	public static function blendEquationSeparate (modeRGB:Int, modeAlpha:Int):Void {
		
		nme_gl_blend_equation_separate (modeRGB, modeAlpha);
		
	}
	
	
	public static function blendFunc (sfactor:Int, dfactor:Int):Void {
		
		nme_gl_blend_func (sfactor, dfactor);
		
	}
	
	
	public static function blendFuncSeparate (srcRGB:Int, dstRGB:Int, srcAlpha:Int, dstAlpha:Int):Void {
		
		nme_gl_blend_func_separate (srcRGB, dstRGB, srcAlpha, dstAlpha);
		
	}
	
	
	public static function bufferData (target:Int, data:IMemoryRange, usage:Int):Void {
		
		nme_gl_buffer_data (target, data.getByteBuffer (), data.getStart (), data.getLength (), usage);
		
	}
	
	
	public static function bufferSubData (target:Int, offset:Int, data:IMemoryRange):Void {
		
		nme_gl_buffer_sub_data (target, offset, data.getByteBuffer (), data.getStart (), data.getLength ());
		
	}
	
	
	public static function checkFramebufferStatus (target:Int):Int {
		
		return nme_gl_check_framebuffer_status (target);
		
	}
	
	
	public static function clear (mask:Int):Void {
		
		nme_gl_clear (mask);
		
	}
	
	
	public static function clearColor (red:Float, green:Float, blue:Float, alpha:Float):Void {
		
		nme_gl_clear_color (red, green, blue, alpha);
		
	}
	
	
	public static function clearDepth (depth:Float):Void {
		
		nme_gl_clear_depth (depth);
		
	}
	
	
	public static function clearStencil (s:Int):Void {
		
		nme_gl_clear_stencil (s);
		
	}
	
	
	public static function colorMask (red:Bool, green:Bool, blue:Bool, alpha:Bool):Void {
		
		nme_gl_color_mask (red, green, blue, alpha);
		
	}
	
	
	public static function compileShader (shader:Shader):Void {
		
		nme_gl_compile_shader (shader.id);
		
	}
	
	
	public static function compressedTexImage2D (target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, data:IMemoryRange):Void {
		
		nme_gl_compressed_tex_image_2d (target, level, internalformat, width, height, border, data == null ? null : data.getByteBuffer (), data == null ? null : data.getStart ());
		
	}
	
	
	public static function compressedTexSubImage2D (target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, data:IMemoryRange):Void {
		
		nme_gl_compressed_tex_sub_image_2d (target, level, xoffset, yoffset, width, height, format, data == null ? null : data.getByteBuffer (), data == null ? null : data.getStart ());
		
	}
	
	
	public static function copyTexImage2D (target:Int, level:Int, internalformat:Int, x:Int, y:Int, width:Int, height:Int, border:Int):Void {
		
		nme_gl_copy_tex_image_2d (target, level, internalformat, x, y, width, height, border);
		
	}
	
	
	public static function copyTexSubImage2D (target:Int, level:Int, xoffset:Int, yoffset:Int, x:Int, y:Int, width:Int, height:Int):Void {
		
		nme_gl_copy_tex_sub_image_2d (target, level, xoffset, yoffset, x, y, width, height);
		
	}
	
	
	public static function createBuffer ():Buffer {
		
		return new Buffer (version, nme_gl_create_buffer ());
		
	}
	
	
	public static function createFramebuffer ():Framebuffer {
		
		return new Framebuffer (version, nme_gl_create_framebuffer ());
		
	}
	
	
	public static function createProgram ():Program {
		
		return new Program (version, nme_gl_create_program ());
		
	}
	
	
	public static function createRenderbuffer ():Renderbuffer {
		
		return new Renderbuffer (version, nme_gl_create_render_buffer ());
		
	}
	
	
	public static function createShader (type:Int):Shader {
		
		return new Shader (version, nme_gl_create_shader (type));
		
	}
	
	
	public static function createTexture ():Texture {
		
		return new Texture (version, nme_gl_create_texture ());
		
	}
	
	
	public static function cullFace (mode:Int):Void {
		
		
		
	}
	
	
	public static function deleteBuffer (buffer:Buffer):Void {
		
		nme_gl_delete_buffer (buffer.id);
		buffer.invalidate ();
		
	}
	
	
	public static function deleteFramebuffer (framebuffer:Framebuffer):Void {
		
		
		
	}
	
	
	public static function deleteProgram (program:Program):Void {
		
		nme_gl_delete_program (program.id);
		program.invalidate ();
		
	}
	
	
	public static function deleteRenderbuffer (renderbuffer:Renderbuffer):Void {
		
		
		
	}
	
	
	public static function deleteShader (shader:Shader):Void {
		
		nme_gl_delete_shader (shader.id);
		shader.invalidate ();
		
	}
	
	
	public static function deleteTexture (texture:Texture):Void {
		
		nme_gl_delete_texture (texture.id);
		texture.invalidate ();
		
	}
	
	
	public static function depthFunc (func:Int):Void {
		
		nme_gl_depth_func (func);
		
	}
	
	
	public static function depthMask (flag:Bool):Void {
		
		nme_gl_depth_mask (flag);
		
	}
	
	
	public static function depthRange (zNear:Float, zFar:Float):Void {
		
		nme_gl_depth_range (zNear, zFar);
		
	}
	
	
	public static function detachShader (program:Program, shader:Shader):Void {
		
		nme_gl_detach_shader (program.id, shader.id);
		
	}
	
	
	public static function disable (cap:Int):Void {
		
		nme_gl_disable (cap);
		
	}
	
	
	public static function disableVertexAttribArray (index:Int):Void {
		
		nme_gl_disable_vertex_attrib_array (index);
		
	}
	
	
	public static function drawArrays (mode:Int, first:Int, count:Int):Void {
		
		nme_gl_draw_arrays (mode, first, count);
		
	}
	
	
	public static function drawElements (mode:Int, count:Int, type:Int, offset:Int):Void {
		
		nme_gl_draw_elements (mode, count, type, offset);
		
	}
	
	
	public static function enable (cap:Int):Void {
		
		nme_gl_enable (cap);
		
	}
	
	
	public static function enableVertexAttribArray (index:Int):Void {
		
		nme_gl_enable_vertex_attrib_array (index);
		
	}
	
	
	public static function finish ():Void {
		
		nme_gl_finish ();
		
	}
	
	
	public static function flush ():Void {
		
		nme_gl_flush ();
		
	}
	
	
	public static function framebufferRenderbuffer (target:Int, attachment:Int, renderbuffertarget:Int, renderbuffer:Renderbuffer):Void {
		
		nme_gl_framebuffer_renderbuffer (target, attachment, renderbuffertarget, renderbuffer.id);
		
	}
	
	
	public static function framebufferTexture2D (target:Int, attachment:Int, textarget:Int, texture:Texture, level:Int):Void {
		
		nme_gl_framebuffer_texture2D (target, attachment, textarget, texture.id, level);
		
	}
	
	
	public static function frontFace (mode:Int):Void {
		
		nme_gl_front_face (mode);
		
	}
	
	
	public static function generateMipmap (target:Int):Void {
		
		nme_gl_generate_mipmap (target);
		
	}
	
	
	public static function getActiveAttrib (program:Program, index:Int):ActiveInfo {
		
		return nme_gl_get_active_attrib (program.id, index);
		
	}
	
	
	public static function getActiveUniform (program:Program, index:Int):ActiveInfo {
		
		return nme_gl_get_active_uniform (program.id, index);
		
	}
	
	
	public static function getAttachedShaders (program:Program):Array<Shader> {
		
		return program.getShaders ();
		
	}
	
	
	public static function getAttribLocation (program:Program, name:String):Int {
		
		return nme_gl_get_attrib_location (program.id, name);
		
	}
	
	
	public static function getBufferParameter (target:Int, pname:Int):Dynamic {
		
		return nme_gl_get_buffer_paramerter (target, pname);
		
	}
	
	
	public static function getContextAttributes ():ContextAttributes {
		
		var base = nme_gl_get_context_attributes ();
		base.premultipliedAlpha = false;
		base.preserveDrawingBuffer = false;
		return base;
		
	}
	
	
	public static function getError ():Int {
		
		return nme_gl_get_error ();
		
	}
	
	
	public static function getExtension (name:String):Dynamic {
		
		// Hmmm
		return null;
		
	}
	
	
	public static function getFramebufferAttachmentParameter (target:Int, attachment:Int, pname:Int):Dynamic {
		
		return nme_gl_get_framebuffer_attachment_parameter (target, attachment, pname);
		
	}
	
	
	public static function getParameter (pname:Int):Dynamic {
		
		return nme_gl_get_parameter (pname);
		
	}
	
	
	public static function getProgramInfoLog (program:Program):String {
		
		return nme_gl_get_program_info_log (program.id);
		
	}
	
	
	public static function getProgramParameter (program:Program, pname:Int):Int {
		
		return nme_gl_get_program_parameter (program.id, pname);
		
	}
	
	
	public static function getRenderbufferParameter (target:Int, pname:Int):Dynamic {
		
		return nme_gl_get_render_buffer_parameter (target, pname);
		
	}
	
	
	public static function getShaderInfoLog (shader:Shader):String {
		
		return nme_gl_get_shader_info_log (shader.id);
		
	}
	
	
	public static function getShaderParameter (shader:Shader, pname:Int):Int {
		
		return nme_gl_get_shader_parameter (shader.id, pname);
		
	}
	
	
	public static function getShaderPrecisionFormat (shadertype:Int, precisiontype:Int):ShaderPrecisionFormat {
		
		return nme_gl_get_shader_precision_format (shadertype, precisiontype);
		
	}
	
	
	public static function getShaderSource (shader:Shader):String {
		
		return nme_gl_get_shader_source (shader.id);
		
	}
	
	
	public static function getSupportedExtensions ():Array<String> {
		
		var result = new Array<String> ();
		nme_gl_get_supported_extensions (result);
		return result;
		
	}
	
	
	public static function getTexParameter (target:Int, pname:Int):Dynamic {
		
		return nme_gl_get_tex_parameter (target, pname);
		
	}
	
	
	public static function getUniform (program:Program, location:UniformLocation):Dynamic { 
		
		return nme_gl_get_uniform (program.id, location);
		
	}
	
	
	public static function getUniformLocation (program:Program, name:String):Dynamic {
		
		return nme_gl_get_uniform_location(program.id, name);
		
	}
	
	
	public static function getVertexAttrib (index:Int, pname:Int):Dynamic {
		
		return nme_gl_get_vertex_attrib (index, pname);
		
	}
	
	
	public static function getVertexAttribOffset (index:Int, pname:Int):Int {
		
		return nme_gl_get_vertex_attrib_offset (index, pname);
		
	}
	
	
	public static function hint (target:Int, mode:Int):Void {
		
		nme_gl_hint (target, mode);
		
	}
	
	
	public static function isBuffer (buffer:Buffer):Bool {
		
		return buffer != null && buffer.id > 0 && nme_gl_is_buffer (buffer.id);
		
	}
	
	
	// This is non-static
	// public function isContextLost ():Bool { return false; }
	
	
	public static function isEnabled (cap:Int):Bool {
		
		return nme_gl_is_enabled (cap);
		
	}
	
	
	public static function isFramebuffer (framebuffer:Framebuffer):Bool {
		
		return framebuffer != null && framebuffer.id > 0 && nme_gl_is_framebuffer (framebuffer.id);
		
	}
	
	
	public static function isProgram (program:Program):Bool {
		
		return program != null && program.id > 0 && nme_gl_is_program (program.id);
		
	}
	
	
	public static function isRenderbuffer (renderbuffer:Renderbuffer):Bool {
		
		return renderbuffer != null && renderbuffer.id > 0 && nme_gl_is_renderbuffer (renderbuffer.id);
		
	}
	
	
	public static function isShader (shader:Shader):Bool {
		
		return shader != null && shader.id > 0 && nme_gl_is_shader (shader.id);
		
	}
	
	
	public static function isTexture (texture:Texture):Bool {
		
		return texture != null && texture.id > 0 && nme_gl_is_texture (texture.id);
		
	}
	
	
	public static function lineWidth (width:Float):Void {
		
		nme_gl_line_width (width);
		
	}
	
	
	public static function linkProgram (program:Program):Void {
		
		nme_gl_link_program (program.id);
		
	}
	
	
	private static function load (inName:String, inArgCount:Int):Dynamic {
		
		try {
			
			return Loader.load (inName, inArgCount);
			
		} catch (e:Dynamic) {
			
			trace(e);
			return null;
			
		}
		
	}
	
	
	public static function pixelStorei (pname:Int, param:Int):Void {
		
		nme_gl_pixel_storei (pname, param);
		
	}
	
	
	public static function polygonOffset (factor:Float, units:Float):Void {
		
		nme_gl_polygon_offset (factor, units);
		
	}
	
	
	public static function readPixels (x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:ByteArray):Void {
		
		
		
	}
	
	
	public static function renderbufferStorage (target:Int, internalformat:Int, width:Int, height:Int):Void {
		
		nme_gl_renderbuffer_storage (target, internalformat, width, height);
		
	}
	
	
	public static function sampleCoverage (value:Float, invert:Bool):Void {
		
		nme_gl_sample_coverage (value, invert);
		
	}
	
	
	public static function scissor (x:Int, y:Int, width:Int, height:Int):Void {
		
		nme_gl_scissor (x, y, width, height);
		
	}
	
	
	public static function shaderSource (shader:Shader, source:String):Void {
		
		nme_gl_shader_source (shader.id, source);
		
	}
	
	
	public static function stencilFunc (func:Int, ref:Int, mask:Int):Void {
		
		nme_gl_stencil_func (func, ref, mask);
		
	}
	
	
	public static function stencilFuncSeparate (face:Int, func:Int, ref:Int, mask:Int):Void {
		
		nme_gl_stencil_func_separate (face, func, ref, mask);
		
	}
	
	
	public static function stencilMask (mask:Int):Void {
		
		nme_gl_stencil_mask (mask);
		
	}
	
	
	public static function stencilMaskSeparate (face:Int, mask:Int):Void {
		
		nme_gl_stencil_mask_separate (face, mask);
		
	}
	
	
	public static function stencilOp (fail:Int, zfail:Int, zpass:Int):Void {
		
		nme_gl_stencil_op (fail, zfail, zpass);
		
	}
	
	
	public static function stencilOpSeparate (face:Int, fail:Int, zfail:Int, zpass:Int):Void {
		
		nme_gl_stencil_op_separate (face, fail, zfail, zpass);
		
	}
	
	
	public static function texImage2D (target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int, pixels:ArrayBufferView):Void {
		
		nme_gl_tex_image_2d (target, level, internalformat, width, height, border, format, type, pixels == null ? null : pixels.getByteBuffer (), pixels == null ? null : pixels.getStart ());
		
	}
	
	
	public static function texParameterf (target:Int, pname:Int, param:Float):Void {
		
		nme_gl_tex_parameterf (target, pname, param);
		
	}
	
	
	public static function texParameteri (target:Int, pname:Int, param:Int):Void {
		
		nme_gl_tex_parameteri (target, pname, param);
		
	}
	
	
	public static function texSubImage2D (target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, pixels:ByteArray):Void {
		
		nme_gl_tex_sub_image_2d(target, level, xoffset, yoffset, width, height, format, type, pixels == null ? null : pixels.getByteBuffer (), pixels == null ? null : pixels.getStart ());
		
	}
	
	
	public static function uniform1f (location:UniformLocation, x:Float):Void {
		
		nme_gl_uniform1f (location, x);
		
	}
	
	
	public static function uniform1fv (location:UniformLocation, x:Array<Float>):Void {
		
		nme_gl_uniform1fv (location, x);
		
	}
	
	
	public static function uniform1i (location:UniformLocation, x:Int):Void {
		
		nme_gl_uniform1i (location, x);
		
	}
	
	
	public static function uniform1iv (location:UniformLocation, v:Array<Int>):Void {
		
		nme_gl_uniform1iv (location, v);
		
	}
	
	
	public static function uniform2f (location:UniformLocation, x:Float, y:Float):Void {
		
		nme_gl_uniform2f (location, x, y);
		
	}
	
	
	public static function uniform2fv (location:UniformLocation, v:Array<Float>):Void {
		
		nme_gl_uniform2fv (location, v);
		
	}
	
	
	public static function uniform2i (location:UniformLocation, x:Int, y:Int):Void {
		
		nme_gl_uniform2i (location, x, y);
		
	}
	
	
	public static function uniform2iv (location:UniformLocation, v:Array<Int>):Void {
		
		nme_gl_uniform2iv (location, v);
		
	}
	
	
	public static function uniform3f (location:UniformLocation, x:Float, y:Float, z:Float):Void {
		
		nme_gl_uniform3f (location, x, y, z);
		
	}
	
	
	public static function uniform3fv (location:UniformLocation, v:Array<Float>):Void {
		
		nme_gl_uniform3fv (location, v);
		
	}
	
	
	public static function uniform3i (location:UniformLocation, x:Int, y:Int, z:Int):Void {
		
		nme_gl_uniform3i (location, x, y, z);
		
	}
	
	
	public static function uniform3iv (location:UniformLocation, v:Array<Int>):Void {
		
		nme_gl_uniform3iv (location, v);
		
	}
	
	
	public static function uniform4f (location:UniformLocation, x:Float, y:Float, z:Float, w:Float):Void {
		
		nme_gl_uniform4f (location, x, y, z, w);
		
	}
	
	
	public static function uniform4fv (location:UniformLocation, v:Array<Float>):Void {
		
		nme_gl_uniform4fv (location, v);
		
	}
	
	
	public static function uniform4i (location:UniformLocation, x:Int, y:Int, z:Int, w:Int):Void {
		
		nme_gl_uniform4i (location, x, y, z, w);
		
	}
	
	
	public static function uniform4iv (location:UniformLocation, v:Array<Int>):Void {
		
		nme_gl_uniform4iv (location, v);
		
	}
	
	
	public static function uniformMatrix2fv (location:UniformLocation, transpose:Bool, v:Float32Array):Void {
		
		nme_gl_uniform_matrix (location, transpose, v.getByteBuffer (), 2);
		
	}
	
	
	public static function uniformMatrix3fv (location:UniformLocation, transpose:Bool, v:Float32Array):Void {
		
		nme_gl_uniform_matrix (location, transpose, v.getByteBuffer (), 3);
		
	}
	
	
	public static function uniformMatrix4fv (location:UniformLocation, transpose:Bool, v:Float32Array):Void {
		
		nme_gl_uniform_matrix (location, transpose, v.getByteBuffer (), 4);
		
	}
	
	
	public static function uniformMatrix3D (location:UniformLocation, transpose:Bool, matrix:Matrix3D):Void {
		
		nme_gl_uniform_matrix (location, transpose, Float32Array.fromMatrix (matrix).getByteBuffer () , 4);
		
	}
	
	
	public static function useProgram (program:Program):Void {
		
		nme_gl_use_program (program == null ? 0 : program.id);
		
	}
	
	
	public static function validateProgram (program:Program):Void {
		
		nme_gl_validate_program (program.id);
		
	}
	
	
	public static function vertexAttrib1f (indx:Int, x:Float):Void {
		
		nme_gl_vertex_attrib1f (indx, x);
		
	}
	
	
	public static function vertexAttrib1fv (indx:Int, values:Array<Float>):Void {
		
		nme_gl_vertex_attrib1fv (indx, values);
		
	}
	
	
	public static function vertexAttrib2f (indx:Int, x:Float, y:Float):Void {
		
		nme_gl_vertex_attrib2f (indx, x, y);
		
	}
	
	
	public static function vertexAttrib2fv (indx:Int, values:Array<Float>):Void {
		
		nme_gl_vertex_attrib2fv (indx, values);
		
	}
	
	
	public static function vertexAttrib3f (indx:Int, x:Float, y:Float, z:Float):Void {
		
		nme_gl_vertex_attrib3f (indx, x, y, z);
		
	}
	
	
	public static function vertexAttrib3fv (indx:Int, values:Array<Float>):Void {
		
		nme_gl_vertex_attrib3fv (indx, values);
		
	}
	
	
	public static function vertexAttrib4f (indx:Int, x:Float, y:Float, z:Float, w:Float):Void {
		
		nme_gl_vertex_attrib4f (indx, x, y, z, w);
		
	}
	
	
	public static function vertexAttrib4fv (indx:Int, values:Array<Float>):Void {
		
		nme_gl_vertex_attrib4fv (indx, values);
		
	}
	
	
	public static function vertexAttribPointer (indx:Int, size:Int, type:Int, normalized:Bool, stride:Int, offset:Int):Void {
		
		nme_gl_vertex_attrib_pointer (indx, size, type, normalized, stride, offset);
		
	}
	
	
	public static function viewport (x:Int, y:Int, width:Int, height:Int):Void {
		
		nme_gl_viewport (x, y, width, height);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_drawingBufferHeight () { return Lib.current.stage.stageHeight; }
	private static function get_drawingBufferWidth () { return Lib.current.stage.stageWidth; }
	private static function get_version ():Int { return nme_gl_version (); }
	
	
	
	
	// Native Methods
	
	
	
	
	private static var nme_gl_active_texture = load ("nme_gl_active_texture", 1);
	private static var nme_gl_attach_shader = load ("nme_gl_attach_shader", 2);
	private static var nme_gl_bind_attrib_location = load ("nme_gl_bind_attrib_location", 3);
	private static var nme_gl_bind_bitmap_data_texture = load ("nme_gl_bind_bitmap_data_texture", 1);
	private static var nme_gl_bind_buffer = load ("nme_gl_bind_buffer", 2);
	private static var nme_gl_bind_framebuffer = load ("nme_gl_bind_framebuffer", 2);
	private static var nme_gl_bind_renderbuffer = load ("nme_gl_bind_renderbuffer", 2);
	private static var nme_gl_bind_texture = load ("nme_gl_bind_texture", 2);
	private static var nme_gl_blend_color = load ("nme_gl_blend_color", 4);
	private static var nme_gl_blend_equation = load ("nme_gl_blend_equation", 1);
	private static var nme_gl_blend_equation_separate = load ("nme_gl_blend_equation_separate", 2);
	private static var nme_gl_blend_func = load ("nme_gl_blend_func", 2);
	private static var nme_gl_blend_func_separate = load ("nme_gl_blend_func_separate", 4);
	private static var nme_gl_buffer_data = load ("nme_gl_buffer_data", 5);
	private static var nme_gl_buffer_sub_data = load ("nme_gl_buffer_sub_data", 5);
	private static var nme_gl_check_framebuffer_status = load ("nme_gl_check_framebuffer_status", 1);
	private static var nme_gl_clear = load ("nme_gl_clear", 1);
	private static var nme_gl_clear_color = load ("nme_gl_clear_color", 4);
	private static var nme_gl_clear_depth = load ("nme_gl_clear_depth", 1);
	private static var nme_gl_clear_stencil = load ("nme_gl_clear_stencil", 1);
	private static var nme_gl_color_mask = load ("nme_gl_color_mask", 4);
	private static var nme_gl_compile_shader = load ("nme_gl_compile_shader", 1);
	private static var nme_gl_compressed_tex_image_2d = load ("nme_gl_compressed_tex_image_2d", -1);
	private static var nme_gl_compressed_tex_sub_image_2d = load ("nme_gl_compressed_tex_sub_image_2d", -1);
	private static var nme_gl_copy_tex_image_2d = load ("nme_gl_copy_tex_image_2d", -1);
	private static var nme_gl_copy_tex_sub_image_2d = load ("nme_gl_copy_tex_sub_image_2d", -1);
	private static var nme_gl_create_buffer = load ("nme_gl_create_buffer", 0);
	private static var nme_gl_create_framebuffer = load ("nme_gl_create_framebuffer", 0);
	private static var nme_gl_create_program = load ("nme_gl_create_program", 0);
	private static var nme_gl_create_render_buffer = load ("nme_gl_create_render_buffer", 0);
	private static var nme_gl_create_shader = load ("nme_gl_create_shader", 1);
	private static var nme_gl_create_texture = load ("nme_gl_create_texture", 0);
	private static var nme_gl_delete_buffer = load ("nme_gl_delete_buffer", 1);
	private static var nme_gl_delete_program = load ("nme_gl_delete_program", 1);
	private static var nme_gl_delete_shader = load ("nme_gl_delete_shader", 1);
	private static var nme_gl_delete_texture = load ("nme_gl_delete_texture", 1);
	private static var nme_gl_depth_func = load ("nme_gl_depth_func", 1);
	private static var nme_gl_depth_mask = load ("nme_gl_depth_func", 1);
	private static var nme_gl_depth_range = load ("nme_gl_depth_range", 2);
	private static var nme_gl_detach_shader = load ("nme_gl_detach_shader", 2);
	private static var nme_gl_disable = load ("nme_gl_disable", 1);
	private static var nme_gl_disable_vertex_attrib_array = load ("nme_gl_disable_vertex_attrib_array", 1);
	private static var nme_gl_draw_arrays = load ("nme_gl_draw_arrays", 3);
	private static var nme_gl_draw_elements = load ("nme_gl_draw_elements", 4);
	private static var nme_gl_enable = load ("nme_gl_enable", 1);
	private static var nme_gl_enable_vertex_attrib_array = load ("nme_gl_enable_vertex_attrib_array", 1);
	private static var nme_gl_finish = load ("nme_gl_finish", 0);
	private static var nme_gl_flush = load ("nme_gl_flush", 0);
	private static var nme_gl_framebuffer_renderbuffer = load ("nme_gl_framebuffer_renderbuffer", 4);
	private static var nme_gl_framebuffer_texture2D = load ("nme_gl_framebuffer_texture2D", 5);
	private static var nme_gl_front_face = load ("nme_gl_front_face", 1);
	private static var nme_gl_generate_mipmap = load ("nme_gl_generate_mipmap", 1);
	private static var nme_gl_get_active_attrib = load ("nme_gl_get_active_attrib", 2);
	private static var nme_gl_get_active_uniform = load ("nme_gl_get_active_uniform", 2);
	private static var nme_gl_get_attrib_location = load ("nme_gl_get_attrib_location", 2);
	private static var nme_gl_get_buffer_paramerter = load ("nme_gl_get_buffer_paramerter", 2);
	private static var nme_gl_get_context_attributes = load ("nme_gl_get_context_attributes", 0);
	private static var nme_gl_get_error = load ("nme_gl_get_error", 0);
	private static var nme_gl_get_framebuffer_attachment_parameter = load ("nme_gl_get_framebuffer_attachment_parameter", 3);
	private static var nme_gl_get_parameter = load ("nme_gl_get_parameter", 1);
	private static var nme_gl_get_program_info_log = load ("nme_gl_get_program_info_log", 1);
	private static var nme_gl_get_program_parameter = load ("nme_gl_get_program_parameter", 2);
	private static var nme_gl_get_render_buffer_parameter = load ("nme_gl_get_render_buffer_parameter", 2);
	private static var nme_gl_get_shader_info_log = load ("nme_gl_get_shader_info_log", 1);
	private static var nme_gl_get_shader_parameter = load ("nme_gl_get_shader_parameter", 2);
	private static var nme_gl_get_shader_precision_format = load ("nme_gl_get_shader_precision_format", 2);
	private static var nme_gl_get_shader_source = load ("nme_gl_get_shader_source", 1);
	private static var nme_gl_get_supported_extensions = load ("nme_gl_get_supported_extensions", 1);
	private static var nme_gl_get_tex_parameter = load ("nme_gl_get_tex_parameter", 2);
	private static var nme_gl_get_uniform = load ("nme_gl_get_uniform", 2);
	private static var nme_gl_get_uniform_location = load ("nme_gl_get_uniform_location", 2);
	private static var nme_gl_get_vertex_attrib = load ("nme_gl_get_vertex_attrib", 2);
	private static var nme_gl_get_vertex_attrib_offset = load ("nme_gl_get_vertex_attrib_offset", 2);
	private static var nme_gl_hint = load ("nme_gl_hint", 2);
	private static var nme_gl_is_buffer = load ("nme_gl_is_buffer", 1);
	private static var nme_gl_is_enabled = load ("nme_gl_is_enabled", 1);
	private static var nme_gl_is_framebuffer = load ("nme_gl_is_framebuffer", 1);
	private static var nme_gl_is_program = load ("nme_gl_is_program", 1);
	private static var nme_gl_is_renderbuffer = load ("nme_gl_is_renderbuffer", 1);
	private static var nme_gl_is_shader = load ("nme_gl_is_shader", 1);
	private static var nme_gl_is_texture = load ("nme_gl_is_texture", 1);
	private static var nme_gl_line_width = load ("nme_gl_line_width", 1);
	private static var nme_gl_link_program = load ("nme_gl_link_program", 1);
	private static var nme_gl_pixel_storei = load ("nme_gl_pixel_storei", 2);
	private static var nme_gl_polygon_offset = load ("nme_gl_polygon_offset", 2);
	private static var nme_gl_renderbuffer_storage = load ("nme_gl_renderbuffer_storage", 4);
	private static var nme_gl_sample_coverage = load ("nme_gl_sample_coverage", 2);
	private static var nme_gl_scissor = load ("nme_gl_scissor", 4);
	private static var nme_gl_shader_source = load ("nme_gl_shader_source", 2);
	private static var nme_gl_stencil_func = load ("nme_gl_stencil_func", 3);
	private static var nme_gl_stencil_func_separate = load ("nme_gl_stencil_func_separate", 4);
	private static var nme_gl_stencil_mask = load ("nme_gl_stencil_mask", 1);
	private static var nme_gl_stencil_mask_separate = load ("nme_gl_stencil_mask_separate", 2);
	private static var nme_gl_stencil_op = load ("nme_gl_stencil_op", 3);
	private static var nme_gl_stencil_op_separate = load ("nme_gl_stencil_op_separate", 4);
	private static var nme_gl_tex_image_2d = load ("nme_gl_tex_image_2d", -1);
	private static var nme_gl_tex_parameterf = load ("nme_gl_tex_parameterf", 3);
	private static var nme_gl_tex_parameteri = load ("nme_gl_tex_parameteri", 3);
	private static var nme_gl_tex_sub_image_2d = load ("nme_gl_tex_sub_image_2d", -1);
	private static var nme_gl_uniform1f = load ("nme_gl_uniform1f", 2);
	private static var nme_gl_uniform1fv = load ("nme_gl_uniform1fv", 2);
	private static var nme_gl_uniform1i = load ("nme_gl_uniform1i", 2);
	private static var nme_gl_uniform1iv = load ("nme_gl_uniform1iv", 2);
	private static var nme_gl_uniform2f = load ("nme_gl_uniform2f", 3);
	private static var nme_gl_uniform2fv = load ("nme_gl_uniform2fv", 2);
	private static var nme_gl_uniform2i = load ("nme_gl_uniform2i", 3);
	private static var nme_gl_uniform2iv = load ("nme_gl_uniform2iv", 2);
	private static var nme_gl_uniform3f = load ("nme_gl_uniform3f", 4);
	private static var nme_gl_uniform3fv = load ("nme_gl_uniform3fv", 2);
	private static var nme_gl_uniform3i = load ("nme_gl_uniform3i", 4);
	private static var nme_gl_uniform3iv = load ("nme_gl_uniform3iv", 2);
	private static var nme_gl_uniform4f = load ("nme_gl_uniform4f", 5);
	private static var nme_gl_uniform4fv = load ("nme_gl_uniform4fv", 2);
	private static var nme_gl_uniform4i = load ("nme_gl_uniform4i", 5);
	private static var nme_gl_uniform4iv = load ("nme_gl_uniform4iv", 2);
	private static var nme_gl_uniform_matrix = load ("nme_gl_uniform_matrix", 4);
	private static var nme_gl_use_program = load ("nme_gl_use_program", 1);
	private static var nme_gl_validate_program = load ("nme_gl_validate_program", 1);
	private static var nme_gl_version = load ("nme_gl_version", 0);
	private static var nme_gl_vertex_attrib1f = load ("nme_gl_vertex_attrib1f", 2);
	private static var nme_gl_vertex_attrib1fv = load ("nme_gl_vertex_attrib1fv", 2);
	private static var nme_gl_vertex_attrib2f = load ("nme_gl_vertex_attrib2f", 3);
	private static var nme_gl_vertex_attrib2fv = load ("nme_gl_vertex_attrib2fv", 2);
	private static var nme_gl_vertex_attrib3f = load ("nme_gl_vertex_attrib3f", 4);
	private static var nme_gl_vertex_attrib3fv = load ("nme_gl_vertex_attrib3fv", 2);
	private static var nme_gl_vertex_attrib4f = load ("nme_gl_vertex_attrib4f", 5);
	private static var nme_gl_vertex_attrib4fv = load ("nme_gl_vertex_attrib4fv", 2);
	private static var nme_gl_vertex_attrib_pointer = load ("nme_gl_vertex_attrib_pointer", -1);
	private static var nme_gl_viewport = load ("nme_gl_viewport", 4);
	
   
}


class Object {
	
	
	public var id (default, null):Dynamic;
	public var invalidated (get_invalidated, null):Bool;
	public var valid (get_valid, null):Bool;
	
	var version:Int;
	
	
	function new (inVersion:Int, inId:Dynamic) { version = inVersion; id = inId; }
	function getType ():String { return "GLObject"; }
	public function invalidate ():Void { id = null; }
	public function toString ():String { return getType () + "(" + id + ")"; }
	public function isValid ():Bool { return id != null && version == GL.version; }
	public function isInvalid ():Bool { return !isValid (); }
	
	
	private function get_invalidated ():Bool { return isInvalid (); }
	private function get_valid ():Bool { return isValid (); }
	
	
}


class Buffer extends Object {
	
	public function new (inVersion:Int, inId:Dynamic) { super (inVersion, inId); }
	override function getType ():String { return "Buffer"; }
	
}


class Framebuffer extends Object {
	
	public function new (inVersion:Int, inId:Dynamic) { super (inVersion, inId); }
	override function getType ():String { return "Framebuffer"; }
	
}


class Program extends Object {
	
	
	public var shaders:Array<Shader>;
	
	
	public function new (inVersion:Int, inId:Dynamic) {
		
		super (inVersion, inId);
		shaders = new Array<Shader> ();
		
	}
	
	
	public function attach (s:Shader):Void { shaders.push (s); }
	override function getType ():String { return "Program"; }
	public function getShaders ():Array<Shader> { return shaders.copy (); }
	
	
}


class Renderbuffer extends Object {
	
	public function new (inVersion:Int, inId:Dynamic) { super (inVersion, inId); }
	override function getType ():String { return "Renderbuffer"; }
	
}


class Shader extends Object {
	
	public function new (inVersion:Int, inId:Dynamic) { super (inVersion, inId); }
	override function getType ():String { return "Shader"; }
	
}


class Texture extends Object {
	
	public function new (inVersion:Int, inId:Dynamic) { super (inVersion, inId); }
	override function getType ():String { return "Texture"; }
	
}


typedef ActiveInfo = {
	
    size : Int,
    type : Int,
    name : String,
	
};


typedef ContextAttributes = {
	
    alpha:Bool, 
    depth:Bool,
    stencil:Bool,
    antialias:Bool,
    premultipliedAlpha:Bool,
    preserveDrawingBuffer:Bool,
	
};


typedef ShaderPrecisionFormat = {
	
   rangeMin : Int,
   rangeMax : Int,
   precision : Int,
   
};


typedef UniformLocation = Dynamic;