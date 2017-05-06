/*********************************************************** BEGIN LICENSE BLOCK ***************************************** 
* Version: RCSL 1.0 and Exhibits. 
* REALNETWORKS CONFIDENTIAL--NOT FOR DISTRIBUTION IN SOURCE CODE FORM 
* Portions Copyright (c) 1995-2002 RealNetworks, Inc. 
* All Rights Reserved. 
* 
* The contents of this file, and the files included with this file, are 
* subject to the current version of the RealNetworks Community Source 
* License Version 1.0 (the "RCSL"), including Attachments A though H, 
* all available at http://www.helixcommunity.org/content/rcsl. 
* You may also obtain the license terms directly from RealNetworks. 
* You may not use this file except in compliance with the RCSL and 
* its Attachments. There are no redistribution rights for the source 
* code of this file. Please see the applicable RCSL for the rights, 
* obligations and limitations governing use of the contents of the file. 
* 
* This file is part of the Helix DNA Technology. RealNetworks is the 
* developer of the Original Code and owns the copyrights in the portions 
* it created. 
* 
* This file, and the files included with this file, is distributed and made 
* available on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER 
* EXPRESS OR IMPLIED, AND REALNETWORKS HEREBY DISCLAIMS ALL SUCH WARRANTIES, 
* INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY, FITNESS 
* FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT. 
* 
* Technology Compatibility Kit Test Suite(s) Location: 
* https://rarvcode-tck.helixcommunity.org 
* 
* Contributor(s): 
* 
********************************************************* END LICENSE BLOCK ************************************************************* 
*********************************************************************************************
*    RealNetworks, Inc. Confidential and Proprietary Information. 
*    Copyright (c) 2001 RealNetworks, Inc. 
*    All Rights Reserved. 
*    Do not redistribute. 
*    Inloop Deblocking Filter interface. 
********************************************************************************************
********************************************************************************************
*    INTEL Corporation Proprietary Information 
*    This listing is supplied under the terms of a license 
*    agreement with INTEL Corporation and may not be copied 
*    nor disclosed except in accordance with the terms of 
*    that agreement. 
*    Copyright (c) 1999 - 2000 Intel Corporation. 
*    All Rights Reserved. 
*    DESCRIPTION: 
*	  Header file corresponding to RV89Combo inloop 4x4 deblocking filter  
*		class implementation. 
***********************************************************************************************
************************************************************************
*																		*
*	VisualOn, Inc. Confidential and Proprietary, 2008		            *
*								 										*
************************************************************************/
/* $Header: /cvsroot/rarvcode-video/codec/rv89combo/platform/emuzed/cdeclib/deblock.h,v 1.2 2006/10/26 06:29:30 pncbose Exp $ */

#ifndef DCDBLOCK_H__
#define DCDBLOCK_H__

#include "rvtypes.h"

#ifdef __cplusplus
extern "C" {
#endif

#define QP_LEVELS 32

extern const I8 s_deblock_rv89combo[][QP_LEVELS];

RV_Status InLoopFilterRV9(struct Decoder *t, U32 row);
RV_Status InLoopFilterRV8(struct Decoder *t, U32 row);


#ifdef __cplusplus
}
#endif

#endif	/* DCDBLOCK_H__ */
