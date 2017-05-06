#pragma once
#include "voPDPort.h"
//#include "utility.h"

#define EXTERN_C    //extern "C"
#define DECLSPEC_SELECTANY
/*
typedef struct _GUID {
	unsigned long  Data1;
	unsigned short Data2;
	unsigned short Data3;
	unsigned char  Data4[ 8 ];
} GUID;*/
#define EXTERN_GUID(itf,l1,s1,s2,c1,c2,c3,c4,c5,c6,c7,c8)  \
	EXTERN_C const GUID DECLSPEC_SELECTANY itf = {l1,s1,s2,{c1,c2,c3,c4,c5,c6,c7,c8}}
//////////////////////////////////////////////////////////////////////////
//Top-level ASF Object
//////////////////////////////////////////////////////////////////////////
// {75b22630-668e-11cf-a6d9-00aa0062ce6c}
EXTERN_GUID(ASF_Header_Object, 0x75b22630, 0x668e, 0x11cf, 0xa6, 0xd9, 0x00, 0xaa, 0x00, 0x62, 0xce, 0x6c);

// {75b22636-668e-11cf-a6d9-00aa0062ce6c}
EXTERN_GUID(ASF_Data_Object, 0x75b22636, 0x668e, 0x11cf, 0xa6, 0xd9, 0x00, 0xaa, 0x00, 0x62, 0xce, 0x6c);

// {33000890-e5b1-11cf-89f4-00a0c90349cb}
EXTERN_GUID(ASF_Simple_Index_Object, 
			0x33000890, 0xe5b1, 0x11cf, 0x89, 0xf4, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xcb);

// {d6e229d3-35da-11d1-9034-00a0c90349be}
EXTERN_GUID(ASF_Index_Object, 
			0xd6e229d3, 0x35da, 0x11d1, 0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe);

// {feb103f8-12ad-4c64-840f-2a1d2f7ad48c}
EXTERN_GUID(ASF_Media_Object_Index_Object, 
			0xfeb103f8, 0x12ad, 0x4c64, 0x84, 0x0f, 0x2a, 0x1d, 0x2f, 0x7a, 0xd4, 0x8c);

// {3cb73fd0-0c4a-4803-953d-edf7b6228f0c}
EXTERN_GUID(ASF_Timecode_Index_Object, 
			0x3cb73fd0, 0x0c4a, 0x4803, 0x95, 0x3d, 0xed, 0xf7, 0xb6, 0x22, 0x8f, 0x0c);

//////////////////////////////////////////////////////////////////////////
//Header Object
//////////////////////////////////////////////////////////////////////////
// {8cabdca1-a947-11cf-8ee4-00c00c205365}
EXTERN_GUID(ASF_File_Properties_Object, 0x8cabdca1, 0xa947, 0x11cf, 0x8e, 0xe4, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65);

// {b7dc0791-a9b7-11cf-8ee6-00c00c205365}
EXTERN_GUID(ASF_Stream_Properties_Object, 0xb7dc0791, 0xa9b7, 0x11cf, 0x8e, 0xe6, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65);

// {5fbf03b5-a92e-11cf-8ee3-00c00c205365}
EXTERN_GUID(ASF_Header_Extension_Object, 
			0x5fbf03b5, 0xa92e, 0x11cf, 0x8e, 0xe3, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65);

// {86d15240-311d-11d0-a3a4-00a0c90348f6}
EXTERN_GUID(ASF_Codec_List_Object, 
			0x86d15240, 0x311d, 0x11d0, 0xa3, 0xa4, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6);

// {1efb1a30-0b62-11d0-a39b-00a0c90348f6}
EXTERN_GUID(ASF_Script_Command_Object, 
			0x1efb1a30, 0x0b62, 0x11d0, 0xa3, 0x9b, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6);

// {f487cd01-a951-11cf-8ee6-00c00c205365}
EXTERN_GUID(ASF_Marker_Object, 
			0xf487cd01, 0xa951, 0x11cf, 0x8e, 0xe6, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65);

// {d6e229dc-35da-11d1-9034-00a0c90349be}
EXTERN_GUID(ASF_Bitrate_Mutual_Exclusion_Object, 
			0xd6e229dc, 0x35da, 0x11d1, 0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe);

// {75b22635-668e-11cf-a6d9-00aa0062ce6c}
EXTERN_GUID(ASF_Error_Correction_Object, 
			0x75b22635, 0x668e, 0x11cf, 0xa6, 0xd9, 0x00, 0xaa, 0x00, 0x62, 0xce, 0x6c);

// {75b22633-668e-11cf-a6d9-00aa0062ce6c}
EXTERN_GUID(ASF_Content_Description_Object, 
			0x75b22633, 0x668e, 0x11cf, 0xa6, 0xd9, 0x00, 0xaa, 0x00, 0x62, 0xce, 0x6c);

// {d2d0a440-e307-11d2-97f0-00a0c95ea850}
EXTERN_GUID(ASF_Extended_Content_Description_Object, 
			0xd2d0a440, 0xe307, 0x11d2, 0x97, 0xf0, 0x00, 0xa0, 0xc9, 0x5e, 0xa8, 0x50);

// {2211b3fa-bd23-11d2-b4b7-00a0c955fc6e}
EXTERN_GUID(ASF_Content_Branding_Object, 
			0x2211b3fa, 0xbd23, 0x11d2, 0xb4, 0xb7, 0x00, 0xa0, 0xc9, 0x55, 0xfc, 0x6e);

// {7bf875ce-468d-11d1-8d82-006097c9a2b2}
EXTERN_GUID(ASF_Stream_Bitrate_Properties_Object, 
			0x7bf875ce, 0x468d, 0x11d1, 0x8d, 0x82, 0x00, 0x60, 0x97, 0xc9, 0xa2, 0xb2);

// {2211b3fb-bd23-11d2-b4b7-00a0c955fc6e}
EXTERN_GUID(ASF_Content_Encryption_Object, 
			0x2211b3fb, 0xbd23, 0x11d2, 0xb4, 0xb7, 0x00, 0xa0, 0xc9, 0x55, 0xfc, 0x6e);

// {298ae614-2622-4c17-b935-dae07ee9289c}
EXTERN_GUID(ASF_Extended_Content_Encryption_Object, 
			0x298ae614, 0x2622, 0x4c17, 0xb9, 0x35, 0xda, 0xe0, 0x7e, 0xe9, 0x28, 0x9c);

// {2211b3fc-bd23-11d2-b4b7-00a0c955fc6e}
EXTERN_GUID(ASF_Digital_Signature_Object, 
			0x2211b3fc, 0xbd23, 0x11d2, 0xb4, 0xb7, 0x00, 0xa0, 0xc9, 0x55, 0xfc, 0x6e);

// {1806d474-cadf-4509-a4ba-9aabcb96aae8}
EXTERN_GUID(ASF_Padding_Object, 
			0x1806d474, 0xcadf, 0x4509, 0xa4, 0xba, 0x9a, 0xab, 0xcb, 0x96, 0xaa, 0xe8);

//////////////////////////////////////////////////////////////////////////
//Header Extension Object
//////////////////////////////////////////////////////////////////////////
// {14e6a5cb-c672-4332-8399-a96952065b5a}
EXTERN_GUID(ASF_Extended_Stream_Properties_Object, 
			0x14e6a5cb, 0xc672, 0x4332, 0x83, 0x99, 0xa9, 0x69, 0x52, 0x06, 0x5b, 0x5a);

// {a08649cf-4775-4670-8a16-6e35357566cd}
EXTERN_GUID(ASF_Advanced_Mutual_Exclusion_Object, 
			0xa08649cf, 0x4775, 0x4670, 0x8a, 0x16, 0x6e, 0x35, 0x35, 0x75, 0x66, 0xcd);

// {d1465a40-5a79-4338-b71b-e36b8fd6c249}
EXTERN_GUID(ASF_Group_Mutual_Exclusion_Object, 
			0xd1465a40, 0x5a79, 0x4338, 0xb7, 0x1b, 0xe3, 0x6b, 0x8f, 0xd6, 0xc2, 0x49);

// {d4fed15b-88d3-454f-81f0-ed5c45999e24}
EXTERN_GUID(ASF_Stream_Prioritization_Object, 
			0xd4fed15b, 0x88d3, 0x454f, 0x81, 0xf0, 0xed, 0x5c, 0x45, 0x99, 0x9e, 0x24);

// {a69609e6-517b-11d2-b6af-00c04fd908e9}
EXTERN_GUID(ASF_Bandwidth_Sharing_Object, 
			0xa69609e6, 0x517b, 0x11d2, 0xb6, 0xaf, 0x00, 0xc0, 0x4f, 0xd9, 0x08, 0xe9);

// {7c4346a9-efe0-4bfc-b229-393ede415c85}
EXTERN_GUID(ASF_Language_List_Object, 
			0x7c4346a9, 0xefe0, 0x4bfc, 0xb2, 0x29, 0x39, 0x3e, 0xde, 0x41, 0x5c, 0x85);

// {c5f8cbea-5baf-4877-8467-aa8c44fa4cca}
EXTERN_GUID(ASF_Metadata_Object, 
			0xc5f8cbea, 0x5baf, 0x4877, 0x84, 0x67, 0xaa, 0x8c, 0x44, 0xfa, 0x4c, 0xca);

// {44231c94-9498-49d1-a141-1d134e457054}
EXTERN_GUID(ASF_Metadata_Library_Object, 
			0x44231c94, 0x9498, 0x49d1, 0xa1, 0x41, 0x1d, 0x13, 0x4e, 0x45, 0x70, 0x54);

// {d6e229df-35da-11d1-9034-00a0c90349be}
EXTERN_GUID(ASF_Index_Parameters_Object, 
			0xd6e229df, 0x35da, 0x11d1, 0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe);

// {6b203bad-3f11-48e4-aca8-d7613de2cfa7}
EXTERN_GUID(ASF_Media_Object_Index_Parameters_Object, 
			0x6b203bad, 0x3f11, 0x48e4, 0xac, 0xa8, 0xd7, 0x61, 0x3d, 0xe2, 0xcf, 0xa7);

// {f55e496d-9797-4b5d-8c8b-604dfe9bfb24}
EXTERN_GUID(ASF_Timecode_Index_Parameters_Object, 
			0xf55e496d, 0x9797, 0x4b5d, 0x8c, 0x8b, 0x60, 0x4d, 0xfe, 0x9b, 0xfb, 0x24);

//the guid is different from document, pls note when use!
// {26f18b5d-4584-47ec-9f5f-0e651f0452c9}
EXTERN_GUID(ASF_Compatibility_Object, 
			0x26f18b5d, 0x4584, 0x47ec, 0x9f, 0x5f, 0x0e, 0x65, 0x1f, 0x04, 0x52, 0xc9);

// {43058533-6981-49e6-9b74-ad12cb86d58c}
EXTERN_GUID(ASF_Advanced_Content_Encryption_Object, 
			0x43058533, 0x6981, 0x49e6, 0x9b, 0x74, 0xad, 0x12, 0xcb, 0x86, 0xd5, 0x8c);

//////////////////////////////////////////////////////////////////////////
//Stream Properties Object Stream Type
//////////////////////////////////////////////////////////////////////////
// {f8699e40-5b4d-11cf-a8fd-00805f5c442b}
EXTERN_GUID(ASF_Audio_Media, 
			0xf8699e40, 0x5b4d, 0x11cf, 0xa8, 0xfd, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b);

// {bc19efc0-5b4d-11cf-a8fd-00805f5c442b}
EXTERN_GUID(ASF_Video_Media, 
			0xbc19efc0, 0x5b4d, 0x11cf, 0xa8, 0xfd, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b);

// {59dacfc0-59e6-11d0-a3ac-00a0c90348f6}
EXTERN_GUID(ASF_Command_Media, 
			0x59dacfc0, 0x59e6, 0x11d0, 0xa3, 0xac, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6);

// {b61be100-5b4e-11cf-a8fd-00805f5c442b}
EXTERN_GUID(ASF_JFIF_Media, 
			0xb61be100, 0x5b4e, 0x11cf, 0xa8, 0xfd, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b);

// {35907de0-e415-11cf-a917-00805f5c442b}
EXTERN_GUID(ASF_Degradable_JPEG_Media, 
			0x35907de0, 0xe415, 0x11cf, 0xa9, 0x17, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b);

// {91bd222c-f21c-497a-8b6d-5aa86bfc0185}
EXTERN_GUID(ASF_File_Transfer_Media, 
			0x91bd222c, 0xf21c, 0x497a, 0x8b, 0x6d, 0x5a, 0xa8, 0x6b, 0xfc, 0x01, 0x85);

// {3afb65e2-47ef-40f2-ac2c-70a90d71d343}
EXTERN_GUID(ASF_Binary_Media, 
			0x3afb65e2, 0x47ef, 0x40f2, 0xac, 0x2c, 0x70, 0xa9, 0x0d, 0x71, 0xd3, 0x43);

//////////////////////////////////////////////////////////////////////////
//Web Stream Type-Specific Data
//////////////////////////////////////////////////////////////////////////
// {776257d4-c627-41cb-8f81-7ac7ff1c40cc}
EXTERN_GUID(ASF_Web_Stream_Media_Subtype, 
			0x776257d4, 0xc627, 0x41cb, 0x8f, 0x81, 0x7a, 0xc7, 0xff, 0x1c, 0x40, 0xcc);

// {da1e6b13-8359-4050-b398-388e965bf00c}
EXTERN_GUID(ASF_Web_Stream_Format, 
			0xda1e6b13, 0x8359, 0x4050, 0xb3, 0x98, 0x38, 0x8e, 0x96, 0x5b, 0xf0, 0x0c);

//////////////////////////////////////////////////////////////////////////
//Stream Properties Object Error Correction Type
//////////////////////////////////////////////////////////////////////////
// {20fb5700-5b55-11cf-a8fd-00805f5c442b}
EXTERN_GUID(ASF_No_Error_Correction, 
			0x20fb5700, 0x5b55, 0x11cf, 0xa8, 0xfd, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b);

// {bfc3cd50-618f-11cf-8bb2-00aa00b4e220}
EXTERN_GUID(ASF_Audio_Spread, 
			0xbfc3cd50, 0x618f, 0x11cf, 0x8b, 0xb2, 0x00, 0xaa, 0x00, 0xb4, 0xe2, 0x20);

//////////////////////////////////////////////////////////////////////////
//Reserved 1 Field Of The Header Extension Object
//////////////////////////////////////////////////////////////////////////
// {abd3d211-a9ba-11cf-8ee6-00c00c205365}
EXTERN_GUID(ASF_Reserved_1, 
			0xabd3d211, 0xa9ba, 0x11cf, 0x8e, 0xe6, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65);

//////////////////////////////////////////////////////////////////////////
//System ID Filed Of The Advanced Content Encryption Object
//////////////////////////////////////////////////////////////////////////
// {7a079bb6-daa4-4e12-a5ca-91d38dc11a8d}
EXTERN_GUID(ASF_Content_Encryption_System_Windows_Media_DRM_Network_Devices, 
			0x7a079bb6, 0xdaa4, 0x4e12, 0xa5, 0xca, 0x91, 0xd3, 0x8d, 0xc1, 0x1a, 0x8d);

//////////////////////////////////////////////////////////////////////////
//Reserved 2 Field Of The Codec List Object
//////////////////////////////////////////////////////////////////////////
// {86d15241-311d-11d0-a3a4-00a0c90348f6}
EXTERN_GUID(ASF_Reserved_2, 
			0x86d15241, 0x311d, 0x11d0, 0xa3, 0xa4, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6);

//////////////////////////////////////////////////////////////////////////
//Reserved 3 Field Of The Script Command Object
//////////////////////////////////////////////////////////////////////////
// {4b1acbe3-100b-11d0-a39b-00a0c90348f6}
EXTERN_GUID(ASF_Reserved_3, 
			0x4b1acbe3, 0x100b, 0x11d0, 0xa3, 0x9b, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6);

//////////////////////////////////////////////////////////////////////////
//Reserved 4 Field Of The Marker Object
//////////////////////////////////////////////////////////////////////////
// {4cfedb20-75f6-11cf-9c0f-00a0c90349cb}
EXTERN_GUID(ASF_Reserved_4, 
			0x4cfedb20, 0x75f6, 0x11cf, 0x9c, 0x0f, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xcb);

//////////////////////////////////////////////////////////////////////////
//Mutual Exclusion Object Exclusion Type
//////////////////////////////////////////////////////////////////////////
// {d6e22a00-35da-11d1-9034-00a0c90349be}
EXTERN_GUID(ASF_Mutex_Language, 
			0xd6e22a00, 0x35da, 0x11d1, 0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe);

// {d6e22a01-35da-11d1-9034-00a0c90349be}
EXTERN_GUID(ASF_Mutex_Bitrate, 
			0xd6e22a01, 0x35da, 0x11d1, 0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe);

// {d6e22a02-35da-11d1-9034-00a0c90349be}
EXTERN_GUID(ASF_Mutex_Unknown, 
			0xd6e22a02, 0x35da, 0x11d1, 0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe);

//////////////////////////////////////////////////////////////////////////
//Bandwidth Sharing Object
//////////////////////////////////////////////////////////////////////////
// {af6060aa-5197-11d2-b6af-00c04fd908e9}
EXTERN_GUID(ASF_Bandwidth_Sharing_Exclusive, 
			0xaf6060aa, 0x5197, 0x11d2, 0xb6, 0xaf, 0x00, 0xc0, 0x4f, 0xd9, 0x08, 0xe9);

// {af6060ab-5197-11d2-b6af-00c04fd908e9}
EXTERN_GUID(ASF_Bandwidth_Sharing_Partial, 
			0xaf6060ab, 0x5197, 0x11d2, 0xb6, 0xaf, 0x00, 0xc0, 0x4f, 0xd9, 0x08, 0xe9);

//////////////////////////////////////////////////////////////////////////
//Standard Payload Extension System
//////////////////////////////////////////////////////////////////////////
// {399595ec-8667-4e2d-8fdb-98814ce76c1e}
EXTERN_GUID(ASF_Payload_Extension_System_Timecode, 
			0x399595ec, 0x8667, 0x4e2d, 0x8f, 0xdb, 0x98, 0x81, 0x4c, 0xe7, 0x6c, 0x1e);

// {e165ec0e-19ed-45d7-b4a7-25cbd1e28e9b}
EXTERN_GUID(ASF_Payload_Extension_System_File_Name, 
			0xe165ec0e, 0x19ed, 0x45d7, 0xb4, 0xa7, 0x25, 0xcb, 0xd1, 0xe2, 0x8e, 0x9b);

// {d590dc20-07bc-436c-9cf7-f3bbfbf1a4dc}
EXTERN_GUID(ASF_Payload_Extension_System_Content_Type, 
			0xd590dc20, 0x07bc, 0x436c, 0x9c, 0xf7, 0xf3, 0xbb, 0xfb, 0xf1, 0xa4, 0xdc);

// {1b1ee554-f9ea-4bc8-821a-376b74e4c4b8}
EXTERN_GUID(ASF_Payload_Extension_System_Pixel_Aspect_Ratio, 
			0x1b1ee554, 0xf9ea, 0x4bc8, 0x82, 0x1a, 0x37, 0x6b, 0x74, 0xe4, 0xc4, 0xb8);

// {c6bd9450-867f-4907-83a3-c77921b733ad}
EXTERN_GUID(ASF_Payload_Extension_System_Sample_Duration, 
			0xc6bd9450, 0x867f, 0x4907, 0x83, 0xa3, 0xc7, 0x79, 0x21, 0xb7, 0x33, 0xad);

// {6698b84e-0afa-4330-aeb2-1c0a98d7a44d}
EXTERN_GUID(ASF_Payload_Extension_System_Encryption_Sample_ID, 
			0x6698b84e, 0x0afa, 0x4330, 0xae, 0xb2, 0x1c, 0x0a, 0x98, 0xd7, 0xa4, 0x4d);

#define AudioFlag_MP3			85
// {00000055-0000-0010-8000-00AA00389B71}
EXTERN_GUID(WMMEDIASUBTYPE_MP3, 
			0x00000055, 0x0000, 0x0010, 0x80, 0x00, 0x00, 0xAA, 0x00, 0x38, 0x9B, 0x71);

#define AudioFlag_WMV8			353
// 00000161-0000-0010-8000-00AA00389B71            WMMEDIASUBTYPE_WMAudioV8 
EXTERN_GUID(WMMEDIASUBTYPE_WMAudioV8, 
			0x00000161, 0x0000, 0x0010, 0x80, 0x00, 0x00, 0xAA, 0x00, 0x38, 0x9B, 0x71);

#define Compression_WMV1		827739479
// 31564D57-0000-0010-8000-00AA00389B71            WMMEDIASUBTYPE_WMV1 
EXTERN_GUID(WMMEDIASUBTYPE_WMV1, 
			0x31564D57, 0x0000, 0x0010, 0x80, 0x00, 0x00, 0xAA, 0x00, 0x38, 0x9B, 0x71); 

#define Compression_WMV2		844516695
// 32564D57-0000-0010-8000-00AA00389B71            WMMEDIASUBTYPE_WMV2 
EXTERN_GUID(WMMEDIASUBTYPE_WMV2, 
			0x32564D57, 0x0000, 0x0010, 0x80, 0x00, 0x00, 0xAA, 0x00, 0x38, 0x9B, 0x71);

#define Compression_WMV3		861293911
// 33564D57-0000-0010-8000-00AA00389B71            WMMEDIASUBTYPE_WMV3 
EXTERN_GUID(WMMEDIASUBTYPE_WMV3, 
			0x33564D57, 0x0000, 0x0010, 0x80, 0x00, 0x00, 0xAA, 0x00, 0x38, 0x9B, 0x71);

#define Compression_MP43		859066445
// 3334504D-0000-0010-8000-00AA00389B71            WMMEDIASUBTYPE_MP43 
EXTERN_GUID(WMMEDIASUBTYPE_MP43, 
			0x3334504D, 0x0000, 0x0010, 0x80, 0x00, 0x00, 0xAA, 0x00, 0x38, 0x9B, 0x71);

//Add Two New Data Type
#ifdef LINUX
typedef unsigned long long QWORD;
#else
typedef unsigned __int64 QWORD;
#endif
typedef QWORD* PQWORD;
/*
typedef unsigned long	 DWORD;
typedef unsigned char    BYTE; 
typedef BYTE            *PBYTE;
typedef unsigned short   WORD;
typedef wchar_t WCHAR;
typedef WCHAR *PWCHAR;
typedef WORD* PWORD;
typedef QWORD* PQWORD;
typedef DWORD *PDWORD;
#define VOID void
typedef char CHAR;
typedef short SHORT;
typedef long LONG;
typedef bool BOOL;
typedef signed char         INT8, *PINT8;
typedef signed short        INT16, *PINT16;
typedef signed int          INT32, *PINT32;
typedef signed __int64      INT64, *PINT64;
typedef unsigned char       UINT8, *PUINT8;
typedef unsigned short      UINT16, *PUINT16;
typedef unsigned int        UINT32, *PUINT32;
typedef unsigned __int64    UINT64, *PUINT64;
//typedef QWORD near* PQWORD;
//end of Add Two New Data Type
*/
//Base Data Struct
#define Len_Object						24
typedef struct tagAsfObject {
	GUID id;
	QWORD size;
} AsfObject, *PAsfObject;
//end of Base Data Struct

//ASF Header Object
#define Len_Header_Object				6
typedef struct tagAsfHeaderObject {
	DWORD header_objects_number;
	BYTE reserved1;	//must be set to 0x01
	BYTE reserved2;	//must be set to 0x02
} AsfHeaderObject, *PAsfHeaderObject;

#define Len_File_Prop_Object			80
typedef struct tagAsfFilePropObject {
	GUID file_id;
	QWORD file_size;
	QWORD creation_date;
	QWORD data_packets_count;
	QWORD play_duration;
	QWORD send_duration;
	QWORD preroll;
	DWORD flags;
	DWORD min_data_packet_size;
	DWORD max_data_packet_size;
	DWORD max_bitrate;
} AsfFilePropObject, *PAsfFilePropObject;

#define Len_Stream_Prop_Object			54
typedef struct tagAsfStreamPropObject {
	GUID stream_type;
	GUID error_correction_type;
	QWORD time_offset;
	DWORD type_specific_data_len;
	DWORD error_correction_data_len;
	WORD flags;
	DWORD reserved;
	PBYTE type_specific_data;
	PBYTE error_correction_data;
} AsfStreamPropObject, *PAsfStreamPropObject;

#define Len_Header_Ext_Object			22
typedef struct tagAsfHeaderExtObject {
	GUID reserved_filed_1;
	WORD reserved_filed_2;
	DWORD data_size;
	PBYTE data;
} AsfHeaderExtObject, *PAsfHeaderExtObject;

typedef struct tagAsfCodecEntries {
	WORD type;
	WORD name_len;
	PWCHAR name;
	WORD descr_len;
	PWCHAR descr;
	WORD info_len;
	PBYTE info;
} AsfCodecEntries, PAsfCodecEntries;

#define Len_Codec_List_Object			20
typedef struct tagAsfCodecListObject {
	GUID reserved;
	DWORD entries_count;
	PAsfCodecEntries entries;
} AsfCodecListObject, *PAsfCodecListObject;

typedef struct tagAsfCommandType {
	WORD name_len;
	PWCHAR name;
} AsfCommandType, *PAsfCommandType;

typedef struct tagAsfCommand {
	DWORD presentation_time;
	WORD type_index;
	WORD name_len;
	PWCHAR name;
} AsfCommand, *PAsfCommand;

typedef struct tagAsfScriptCmdObject {
	GUID reserved;
	WORD commands_count;
	WORD command_types_count;
	PAsfCommandType command_types;
	PAsfCommand commands;
} AsfScriptCmdObject, *PAsfScriptCmdObject;

typedef struct tagAsfMarket {
	QWORD offset;
	QWORD presentation_time;
	WORD entry_len;
	DWORD send_time;
	DWORD flags;
	DWORD descr_len;
	PWCHAR descr;
} AsfMarket, *PAsfMarket;

typedef struct tagAsfMarketObject {
	GUID reserved;
	DWORD market_count;
	WORD reserved1;
	WORD name_len;
	PWCHAR name;
	PAsfMarket markets;
} AsfMarketObject, *PAsfMarketObject;

#define Len_Bitrate_Mutex_Object		18
typedef struct tagAsfBitrateMutexObject {
	GUID mutex_type;
	WORD stream_numbers_count;
	WORD* stream_numbers;
} AsfBitrateMutexObject, *PAsfBitrateMutexObject;

typedef struct tagAsfErrCorrectObject {
	GUID type;
	DWORD data_len;
	PBYTE data;
} AsfErrCorrectObject, *PAsfErrCorrectObject;

#define Len_Content_Desc_Object			10
typedef struct tagAsfContentDescObject {
	WORD title_len;
	WORD author_len;
	WORD copyright_len;
	WORD descr_len;
	WORD rating_len;
	PWCHAR title;
	PWCHAR author;
	PWCHAR copyright;
	PWCHAR descr;
	PWCHAR rating;
} AsfContentDescObject, *PAsfContentDescObject;

typedef struct tagAsfContentDesc {
	WORD name_len;
	PWCHAR name;
	WORD value_data_type;
	WORD value_len;
	void* value;
} AsfContentDesc, *PAsfContentDesc;

#define Len_Ext_Content_Desc_Object		2
typedef struct tagAsfExtContentDescObject {
	WORD content_descs_count;
	PAsfContentDesc content_descs;
} AsfExtContentDescObject, *PAsfExtContentDescObject;

#define Len_Bitrate_Record				6
typedef struct tagAsfBitrateRecord {
	WORD flags;
	DWORD average_bitrate;
} AsfBitrateRecord, *PAsfBitrateRecord;

#define Len_Stream_Bitrate_Prop_Object	2
typedef struct tagAsfStreamBitratePropObject {
	WORD records_count;
	PAsfBitrateRecord records;
} AsfStreamBitratePropObject, *PAsfStreamBitratePropObject;

typedef struct tagAsfContentBrandObject {
	DWORD banner_image_type;
	DWORD banner_image_data_size;
	PBYTE banner_image_data;
	DWORD banner_image_url_len;
	char* banner_image_url;
} AsfContentBrandObject, *PAsfContentBrandObject;

typedef struct tagAsfContentEncryptObject {
	DWORD secret_data_len;
	PBYTE secret_data;
	DWORD protection_type_len;
	char* protection_type;
	DWORD key_id_len;
	char* key_id;
	DWORD license_url_len;
	char* license_url;
} AsfContentEncryptObject, *PAsfContentEncryptObject;

typedef struct tagAsfExtContentEncryptObject {
	DWORD data_size;
	PBYTE data;
} AsfExtContentEncryptObject, *PAsfExtContentEncryptObject;

typedef struct tagAsfDigiSignObject {
	DWORD sign_type;
	DWORD sign_data_len;
	PBYTE sign_data;
} AsfDigiSignObject, *PAsfDigiSignObject;

typedef struct tagAsfPaddingObject {
	PBYTE data;
} AsfPaddingObject, *PAsfPaddingObject;
//end of ASF Header Object

//ASF Header Extension Object
#define Len_Stream_Name				4
typedef struct tagAsfStreamName {
	WORD lang_id_index;
	WORD name_len;
	PWCHAR name;
} AsfStreamName, *PAsfStreamName;

#define Len_Payload_Ext_Sys			22
typedef struct tagAsfPayloadExtSys {
	GUID id;
	WORD size;
	DWORD info_len;
	PBYTE info;
} AsfPayloadExtSys, *PAsfPayloadExtSys;

#define Len_Ext_Stream_Prop_Object		64
typedef struct tagAsfExtStreamPropObject {
	QWORD start_time;
	QWORD end_time;
	DWORD data_bitrate;
	DWORD buffer_size;
	DWORD init_buffer_fullness;
	DWORD alternate_data_bitrate;
	DWORD alternate_buffer_size;
	DWORD alternate_init_buffer_fullness;
	DWORD max_object_size;
	DWORD flags;
	WORD stream_number;
	WORD stream_lang_id_index;
	QWORD average_time_per_frame;
	WORD stream_name_count;
	WORD payload_ext_sys_count;
	PAsfStreamName stream_names;
	PAsfPayloadExtSys payload_ext_syss;
	PAsfStreamPropObject stream_prop_objects;
} AsfExtStreamPropObject, *PAsfExtStreamPropObject;

typedef struct tagAsfAdvanceMutexObject {
	GUID mutex_type;
	WORD stream_numbers_count;
	PWORD stream_numbers;
} AsfAdvancedMutexObject, *PAsfAdvancedMutexObject;

typedef struct tagAsfRecord {
	WORD stream_numbers_count;
	PWORD stream_numbers;
} AsfRecord, *PAsfRecord;

typedef struct tagAsfGroupMutexObject {
	GUID mutex_type;
	WORD records_count;
	PAsfRecord records;
} AsfGroupMutexObject, *PAsfGroupMutexObject;

#define Len_Prior_Record				4
typedef struct tagAsfPriorRecord {
	WORD stream_number;
	WORD flags;
} AsfPriorRecord, *PAsfPriorRecord;

#define Len_Stream_Prior_Object			2
typedef struct tagAsfStreamPriorObject {
	WORD records_count;
	PAsfPriorRecord records;
} AsfStreamPriorObject, *PAsfStreamPriorObject;

typedef struct tagAsfBandwidthShareObject {
	GUID share_type;
	DWORD data_bitrate;
	DWORD buffer_size;
	WORD stream_numbers_count;
	PWORD stream_numbers;
} AsfBandwidthShareObject, *PAsfBandwidthShareObject;

typedef struct tagAsfLangIDRecord {
	BYTE lang_id_len;
	PWCHAR lang_id;
} AsfLangIDRecord, *PAsfLangIDRecord;

#define Len_Lang_List_Object			2
typedef struct tagAsfLangListObject {
	WORD lang_id_records_count;
	PAsfLangIDRecord lang_id_records;
} AsfLangListObject, *PAsfLangListObject;

#define Len_Desc_Record					12
typedef struct tagAsfDescRecord {
	WORD reserved;	//if in tagAsfMetaDataLibObject, it is lang_list_index
	WORD stream_number;
	WORD name_len;
	WORD data_type;
	DWORD date_len;
	PWCHAR name;
	void* data;
} AsfDescRecord, *PAsfDescRecord;

#define Len_Meta_Data_Object			2
typedef struct tagAsfMetaDataObject {
	WORD descr_records_count;
	PAsfDescRecord descr_records;
} AsfMetaDataObject, *PAsfMetaDataObject;

typedef AsfMetaDataObject AsfMetaDataLibObject;
typedef PAsfMetaDataObject PAsfMetaDataLibObject;

#define Len_Index						4
typedef struct tagAsfIndex {
	WORD stream_number;
	WORD index_type;
} AsfIndex, *PAsfIndex;

typedef struct tagAsfIndexParamObject {
	DWORD index_entry_time_interval;
	WORD indexs_count;
	PAsfIndex indexs;
} AsfIndexParamObject, *PAsfIndexParamObject;

typedef AsfIndexParamObject AsfMediaObjIndexParamObject;
typedef PAsfIndexParamObject PAsfMediaObjIndexParamObject;
typedef AsfIndexParamObject AsfTimecodeIndexParamObject;
typedef PAsfIndexParamObject PAsfTimecodeIndexParamObject;

#define Len_Compatible_Object			2
typedef struct tagAsfCompatibleObject {
	BYTE profile;
	BYTE mode;
} AsfCompatibleObject, *PAsfCompatibleObject;

typedef struct tagAsfEncryptObjectRecord {
	WORD id_type;
	WORD id_len;
	void* id;
} AsfEncryptObjectRecord, *PAsfEncryptObjectRecord;

typedef struct tagAsfContentEncryptRecord {
	GUID sys_id;
	DWORD sys_ver;
	WORD encrypt_obj_records_count;
	PAsfEncryptObjectRecord encrypt_obj_records;
	DWORD data_size;
	PBYTE data;
} AsfContentEncryptRecord, *PAsfContentEncryptRecord;

typedef struct tagAsfAdvanceContentEncryptObject {
	WORD content_encrypt_records_count;
	PAsfContentEncryptRecord content_encrypt_records;
} AsfAdvanceContentEncryptObject, *PAsfAdvanceContentEncryptObject;
//end of ASF Header Extension Object

//ASF Data Object
#define Len_Data_Object					26
typedef struct tagAsfDataObject {
	GUID file_id;
	QWORD total_data_packets;
	WORD reserved;
	//need to be filled.
} AsfDataObject, *PAsfDataObject;
//end of ASF Data Object

//ASF Index Object
#define Len_Index_Entry					6
typedef struct tagAsfIndexEntry {
	DWORD packet_number;
	WORD packet_count;
} AsfIndexEntry, *PAsfIndexEntry;

typedef struct tagAsfSimpleIndexObject {
	GUID file_id;
	QWORD index_entry_time_interval;
	DWORD max_packet_count;
	DWORD index_entries_count;
	PAsfIndexEntry index_entries;
} AsfSimpleIndexObject, *PAsfSimpleIndexObject;

typedef struct tagAsfIndexBlock {
	DWORD index_entries_count;
	PQWORD block_positions;
	PDWORD index_entries;		//offset
} AsfIndexBlock, *PAsfIndexBlock;

typedef struct tagAsfIndexObject {
	DWORD index_entry_time_interval;	//in tagAsfTimecodeIndexObject, it is  reserved
	WORD indexs_count;
	DWORD index_blocks_count;
	PAsfIndex indexs;
	PAsfIndexBlock index_blocks;
} AsfIndexObject, *PAsfIndexObject;

typedef AsfIndexObject AsfMediaObjIndexObject;
typedef PAsfIndexObject PAsfMediaObjIndexObject;
typedef AsfIndexObject AsfTimecodeIndexObject;
typedef PAsfIndexObject PAsfTimecodeIndexObject;

//////////////////////////////////////////////////////////////////////////
//MediaType
//////////////////////////////////////////////////////////////////////////
#define Len_Audio_Media_Type			18
typedef struct tagAsfAudioMediaType {
	WORD codec_id;
	WORD channels;
	DWORD samples_per_second;
	DWORD average_bytes_per_second;
	WORD block_alignment;
	WORD bits_per_sample;
	WORD codec_data_len;
	PBYTE codec_data;
} AsfAudioMediaType, *PAsfAudioMediaType;

#define Len_Video_Format				40
typedef struct tagAsfVideoFormat {
	DWORD size;
	LONG image_width;
	LONG image_height;
	WORD reserved;
	WORD bits_per_pixel;
	DWORD compression_id;
	DWORD image_size;
	LONG horizontal_pixels_per_meter;
	LONG vertical_pixels_per_meter;
	DWORD colors_used;
	DWORD important_colors;
	PBYTE codec_data;
} AsfVideoFormat, *PAsfVideoFormat;

#define Len_Video_Media_Type			51
typedef struct tagAsfVideoMediaType {
	DWORD image_width;
	DWORD image_height;
	BYTE reserved;
	WORD format_data_len;
	AsfVideoFormat format_data;
} AsfVideoMediaType, *PAsfVideoMediaType;

#define BITL_2(a) (((a[1]<<8 )&0x0000ff00)|a[0])
#define BITL_3(a) (((a[2]<<16)&0x00ff0000)|((a[1]<<8 )&0x0000ff00)|a[0])
#define BITL_4(a) (((a[3]<<24)&0xff000000)|((a[2]<<16)&0x00ff0000)|((a[1]<<8)&0x0000ff00)|a[0])
#define VO_DEFAULT_IMAGE_AREA		320 * 240
#define read_byte(b) {\
	b=m_head[0];\
	m_head+=1;\
	}

#define read_word(w) {\
	w=BITL_2(m_head);\
	m_head+=sizeof(WORD);\
	}

#define read_dword(dw) {\
	dw=BITL_4(m_head);\
	m_head+=sizeof(DWORD);\
	}

#define read_qword(qw) {\
	memcpy(&(qw),m_head,sizeof(QWORD));\
	m_head+=sizeof(QWORD);\
	}

#define read_guid(g) {\
	memcpy(&(g),m_head,sizeof(GUID));\
	m_head+=sizeof(GUID);\
	}

#define read_pointer(p, l) {\
	memcpy(p,m_head,l);\
	m_head+=l;\
	}

#define read_by_type(dw, type) {\
	switch(type)\
{\
	case 1:\
{\
	BYTE b;\
	read_byte(b);\
	dw = b;\
}\
	break;\
	case 2:\
{\
	WORD w;\
	read_word(w);\
	dw = w;\
}\
	break;\
	case 3:\
{\
	read_dword(dw);\
}\
	break;\
	default:\
	break;\
}\
}

#define skip(l) {\
	m_head+=l;\
}

#define skip_asf_object() {\
	skip(ao.size - Len_Object);\
}

#define skip_by_type(type) {\
	switch(type)\
{\
	case 1:\
	skip(sizeof(BYTE));\
	break;\
	case 2:\
	skip(sizeof(WORD));\
	break;\
	case 3:\
	skip(sizeof(DWORD));\
	break;\
	default:\
	break;\
}\
}
typedef struct{
	UINT16 wFormatTag;
	UINT16 nChannels;
	UINT32 nSamplesPerSec;
	UINT32 nAvgBytesPerSec;
	UINT16 nBlockAlign;
	UINT16 nValidBitsPerSample;
	UINT32 nChannelMask;				/* if wFormatTag < WAVE_FORMAT_MSAUDIO3, it can be not set */
	UINT16 wEncodeOpt;
	UINT16 wAdvancedEncodeOpt;			/* if wFormatTag < WAVE_FORMAT_MSAUDIO3, it can be not set */
	UINT32 dwAdvancedEncodeOpt2;		/* if wFormatTag < WAVE_FORMAT_MSAUDIO3, it can be not set */
	int	   iExtSize;
	unsigned char *pHdrExt;
} WMAHeaderInfo;
/**
* Header data for WMV9 Decoder. 
*/
typedef struct
{
	int  iCodecVer;
	int  iPicHorizSize;
	int  iPicVertSize;
	int  iExtSize;
	unsigned char *pHdrExt;
}
VOWMV9DECHEADER;
typedef struct  
{
	int streamNum;
	VOWMV9DECHEADER head;
}ASF_VIDEO_INFO;
typedef struct  
{
	int streamNum;
	WMAHeaderInfo head;
}ASF_AUDIO_INFO;
class CASFHeadParser:MEM_MANAGER
{
public:
	CASFHeadParser(void);
	virtual ~CASFHeadParser(void);
	bool Parse(unsigned char* head,int size);
	int	 GetPacketSize(){return m_packetSize;}
	VOWMV9DECHEADER* GetAsfVideoMediaType();
	WMAHeaderInfo*	GetAsfAudioMediaType();
private:
	ASF_VIDEO_INFO	 m_videoInfo;
	ASF_AUDIO_INFO	 m_audioInfo;
	bool		ReadFileHeader();
	bool		ReadHeaderInfo();
	DWORD		ReadExtHeaderInfo();
	bool		ReadStreamPropObject();
	unsigned char* m_head;
	int			   m_headSize;
	int			  m_packetSize;
};
