#ifndef __VOSOURCEVIDEODATABUFFER_H__
#define __VOSOURCEVIDEODATABUFFER_H__

#pragma once
#include "voSourceDataBuffer.h"

#ifdef _VONAMESPACE
namespace _VONAMESPACE{
#endif

class voSourceVideoDataBuffer :
	public voSourceDataBuffer
{
public:
	voSourceVideoDataBuffer( vo_allocator< VO_BYTE >& allocator , VO_S32 nMaxBufferTime = 10000 );
	virtual ~voSourceVideoDataBuffer(void);

	virtual VO_S32		GetBuffer (_SAMPLE * pBuffer);

	virtual VO_U64		GetBuffTime (void);
protected:
	vo_singlelink_list< _SAMPLE * >::iterator GetNextKeyFrame( VO_U64 timestamp );
	VO_S32	m_frameinterval;
	VO_U32  m_uflag;
};

#ifdef _VONAMESPACE
}
#endif

#endif