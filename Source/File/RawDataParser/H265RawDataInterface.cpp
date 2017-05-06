	/************************************************************************
	*																		*
	*		VisualOn, Inc. Confidential and Proprietary, 2003-2012			*
	*																		*
	************************************************************************/
/*******************************************************************************
	File:		H265RawDataInterface.h

	Contains:	H265 raw data interface file.

	Written by:	Rodney Zhang

	Change History (most recent first):
	2012-02-02		Rodney		Create file

*******************************************************************************/


#include "H265RawData.h"
#include "H265RawDataInterface.h"

#define LOG_TAG "H264RawDataInterface"
#include "voLog.h"

#if defined __cplusplus
extern "C" {
#endif

    VO_U32 VO_API voFRH265Open(VO_PTR* ppHandle, VO_SOURCE_OPENPARAM* pParam)
    {
	    if(VO_SOURCE_OPENPARAM_FLAG_OPENLOCALFILE != (pParam->nFlag & 0xFF) && 
		  (VO_SOURCE_OPENPARAM_FLAG_OPENPD != (pParam->nFlag & 0xFF)) &&
		  (VO_SOURCE_OPENPARAM_FLAG_OPENFORTHUMBNAIL != (pParam->nFlag & VO_SOURCE_OPENPARAM_FLAG_OPENFORTHUMBNAIL)))
	    {
		    VOLOGE("invalid file open flags!!");
		    return VO_ERR_INVALID_ARG;
	    }

	    if(VO_SOURCE_OPENPARAM_FLAG_FILEOPERATOR != (pParam->nFlag & 0xFF00))
	    {
		    VOLOGE("invalid file operator flags!!");
		    return VO_ERR_INVALID_ARG;
	    }

	    CH265RawData* pReader = new CH265RawData((VO_FILE_OPERATOR*)pParam->pSourceOP, pParam->pMemOP, pParam->pLibOP, pParam->pDrmCB);
	    if(!pReader)
	    {
		    VOLOGE("failed to create h264 raw data file reader!!");
		    return VO_ERR_OUTOF_MEMORY;
	    }

	    VO_U32 rc = pReader->Load(pParam->nFlag, (VO_FILE_SOURCE*)pParam->pSource);
	    //only OK/DRM can be playback
	    if(VO_ERR_SOURCE_OK != rc && VO_ERR_SOURCE_CONTENTENCRYPT != rc)
	    {
		    VOLOGE("failed to load file parser: 0x%08X!!", rc);
		    delete pReader;
		    return rc;
	    }
	    *ppHandle = pReader;

	    return rc;
    }

    VO_U32 VO_API voFRH265GetTrackInfo(VO_PTR pHandle, VO_U32 nTrack, VO_SOURCE_TRACKINFO* pTrackInfo)
    {
	    if(!pHandle)
		    return VO_ERR_INVALID_ARG;

	    CH265RawData* pReader = (CH265RawData*)pHandle;

	    return pReader->GetTrackInfo(pTrackInfo);
    }

    VO_U32 VO_API voFRH265GetSample(VO_PTR pHandle, VO_U32 nTrack, VO_SOURCE_SAMPLE* pSample)
    {
	    if(!pHandle)
		    return VO_ERR_INVALID_ARG;

		CH265RawData *pRawDataParser = (CH265RawData*)pHandle;

		return pRawDataParser->GetSample(pSample);
    }

    VO_U32 VO_API voFRH265SetPos(VO_PTR pHandle, VO_U32 nTrack, VO_S64* pPos)
    {
	    if(!pHandle)
		    return VO_ERR_INVALID_ARG;

	    CH265RawData* pReader = (CH265RawData*)pHandle;

	    return pReader->SetPos(pPos);
    }

    VO_U32 VO_API voFRH265SetFileParam(VO_PTR pHandle, VO_U32 uID, VO_PTR pParam)
    {
	    if(!pHandle)
		    return VO_ERR_INVALID_ARG;

	    CH265RawData* pReader = (CH265RawData*)pHandle;

	    return pReader->SetParameter(uID, pParam);
    }

    VO_U32 VO_API voFRH265SetTrackParam(VO_PTR pHandle, VO_U32 nTrack, VO_U32 uID, VO_PTR pParam)
    {
	    if(!pHandle)
		    return VO_ERR_INVALID_ARG;

	    CH265RawData* pReader = (CH265RawData*)pHandle;

		return pReader->SetTrackParameter(uID, pParam);
    }

    VO_U32 VO_API voFRH265GetTrackParam(VO_PTR pHandle, VO_U32 nTrack, VO_U32 uID, VO_PTR pParam)
    {
	    if(!pHandle)
		    return VO_ERR_INVALID_ARG;

	    CH265RawData* pReader = (CH265RawData*)pHandle;

	    return pReader->GetTrackParameter(uID, pParam);
    }


#if defined __cplusplus
}
#endif
