
#ifndef _BaseUrl_H
#define _BaseUrl_H

#include "voType.h"
#include "voSource2.h"
#include "tinyxml.h"
#include  "Common_Tag.h"


#ifdef _VONAMESPACE
namespace _VONAMESPACE{
#endif


#define BASE_LOCATION			"serviceLocation"
#define BYTE_RANGE		        "byteRange"
#define TAG_DASH_BASEURL_2       "BaseURL"






class BaseUrl:public Common_Tag
	{
	public:
		BaseUrl(void);
		~BaseUrl(void);
	public:
		virtual VO_U32 Init(TiXmlNode* pNode);
	public:
	    VO_CHAR *GetRange(){ return m_byte_range;}
		VO_CHAR *GetServiceLocation(){ return m_serviceLocation;}
	private:
		VO_CHAR m_byte_range[256];
		VO_CHAR m_serviceLocation[256];
		Common_Tag * m_comtag;
};
#ifdef _VONAMESPACE
}
#endif
#endif