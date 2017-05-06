/************************************************************************
VisualOn Proprietary
Copyright (c) 2003, VisualOn Incorporated. All Rights Reserved

VisualOn, Inc., 4675 Stevens Creek Blvd, Santa Clara, CA 95051, USA

All data and information contained in or disclosed by this document are
confidential and proprietary information of VisualOn, and all rights
therein are expressly reserved. By accepting this material, the
recipient agrees that this material and the information contained
therein are held in confidence and in trust. The material may only be
used and/or disclosed as authorized in a license agreement controlling
such use and disclosure.
************************************************************************/
/************************************************************************
* @file CSrtParser.h
*
* @author  Mingbo Li
* @author  Ferry Zhang
* 
* Change History
* 2012-11-28    Create File
************************************************************************/

#ifndef __CSrtParser_H__
#define __CSrtParser_H__

#include "CBaseSubtitleParser.h"


class	CSrtParser : CBaseSubtitleParser
{
public:
	CSrtParser(void);
	virtual ~CSrtParser(void);

public:
	virtual	bool	Parse (void);


};

#endif // __CSrtParser_H__
