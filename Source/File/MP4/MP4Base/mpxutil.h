/**
 * ISO Media
 * Utility, Helper functions
 * @created 12/17/2004
 */

#ifndef _MPX_UTIL_H
#define _MPX_UTIL_H

#include "mpxtype.h"

#if defined(LINUX) || defined(__arm) || defined(_IOS) || defined(_MAC_OS)
#   define __stdcall 
#include <string.h>
#endif	//LINUX or arm

#ifdef _VONAMESPACE
namespace _VONAMESPACE{
#endif
//namespace MPx {

class Util
{
public:
	static void Swap(uint8* p1, uint8* p2)
	{
		uint8 t = *p1;
		*p1 = *p2;
		*p2 = t;
	}

	static void Swap(uint8* p1, uint8* p2, uint8* p3, uint8* p4)
	{
		Swap(p1, p4);
		Swap(p2, p3);
	}

	static void Swap(uint8* p1, uint8* p2, uint8* p3, uint8* p4, 
		uint8* p5, uint8* p6, uint8* p7, uint8* p8)
	{
		Swap(p1, p8);
		Swap(p2, p7);
		Swap(p3, p6);
		Swap(p4, p5);
	}

	static void Swap16(void* val)
	{
		Swap((uint8*)val, ((uint8*)val) + 1);
	}

	static void Swap32(void* val)
	{
		Swap((uint8*)val, ((uint8*)val) + 1, ((uint8*)val) + 2, ((uint8*)val) + 3);
	}

	static void Swap64(void* val)
	{
		Swap((uint8*)val, ((uint8*)val) + 1, ((uint8*)val) + 2, ((uint8*)val) + 3,
			((uint8*)val) + 4, ((uint8*)val) + 5, ((uint8*)val) + 6, ((uint8*)val) + 7);
	}

	static void Int32Text(uint32 type, char* text)
	{
		*(uint32*) text = type;
		Swap32(text);
		text[4] = 0;
		if (text[0] < 0 || text[0] == '-')
			text[0] = '_';
	}

	static char* __stdcall Int32Text(uint32 type)
	{
		static char buf[5];
		Int32Text(type, buf);
		return buf;
	}

	static char* __stdcall TimeText(uint64 t);
	static char* __stdcall LanguageText(uint16 lang);

	static uint64 __stdcall CurrentTime();
	static uint16 __stdcall LanguageCode(uint32 lang);

	static uint32 Fixed32(double d)
	{
		uint32 u = (uint32)d;
		return (u << 16) + (uint32)((d - u) * 65536.);
	}

	static uint16 Fixed16(double d)
	{
		uint16 u = (uint16)d;
		return (u << 8) + (uint16)((d - u) * 256.);
	}
	
	static uint8* MemFind(void* whole, int wholesize, void* part, int partsize)
	{
		uint8* p = (uint8*)whole;
		int c = wholesize - partsize;
		while (c >= 0)
		{
			if (memcmp(p, part, partsize) == 0)
				return p;
			++p;
			--c;
		}
		return 0;
	}
};

//} //namespace MPx
#ifdef _VONAMESPACE
}
#endif
#endif // _MPX_UTIL_H
