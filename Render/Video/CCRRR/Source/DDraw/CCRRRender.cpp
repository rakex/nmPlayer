// CCRRRender.cpp : Defines the entry point for the DLL application.
//

#include <windows.h>


#include "voCCRRR.h"

#include "CBaseRender.h"

VO_PTR		g_hvoccrrInst = NULL;

#define CHECK_CCRRR_POINT if (hCCRRR == NULL)\
	return VO_ERR_INVALID_ARG | VO_INDEX_SNK_VIDEO;\
	CBaseRender * pCCRRR = (CBaseRender *)hCCRRR;

#ifdef _WIN32
BOOL APIENTRY DllMain( HANDLE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
	g_hvoccrrInst = hModule;

	return TRUE;
}
#endif // _WIN32

VO_U32 voccrrInit (VO_HANDLE * phCCRRR, VO_PTR hView, VO_MEM_OPERATOR * pMemOP, VO_U32 nFlag)
{
	CBaseRender * pCCRRR = NULL;


	pCCRRR = new CBaseRender (g_hvoccrrInst, hView, pMemOP);


	if (pCCRRR == NULL)
		return VO_ERR_OUTOF_MEMORY | VO_INDEX_SNK_CCRRR;

	*phCCRRR = pCCRRR;

	return VO_ERR_NONE;
}

VO_U32 voccrrUninit (VO_HANDLE hCCRRR)
{
	CHECK_CCRRR_POINT

	delete pCCRRR;

	return VO_ERR_NONE;
}

VO_U32 voccrrGetProperty (VO_HANDLE hCCRRR, VO_CCRRR_PROPERTY * pProperty)
{
	CHECK_CCRRR_POINT

		return pCCRRR->GetProperty (pProperty);
}

VO_U32 voccrrGetInputType (VO_HANDLE hCCRRR, VO_IV_COLORTYPE * pColorType, VO_U32 nIndex)
{
	CHECK_CCRRR_POINT

		return pCCRRR->GetInputType (pColorType, nIndex);
}

VO_U32 voccrrGetOutputType (VO_HANDLE hCCRRR, VO_IV_COLORTYPE * pColorType, VO_U32 nIndex)
{
	CHECK_CCRRR_POINT

		return pCCRRR->GetOutputType (pColorType, nIndex);
}

VO_U32 voccrrSetColorType (VO_HANDLE hCCRRR, VO_IV_COLORTYPE nInputColor, VO_IV_COLORTYPE nOutputColor)
{
	CHECK_CCRRR_POINT

		return pCCRRR->SetColorType (nInputColor, nOutputColor);
}

VO_U32 voccrrSetCCRRSize (VO_HANDLE hCCRRR, VO_U32 * pInWidth, VO_U32 * pInHeight, VO_U32 * pOutWidth, VO_U32 * pOutHeight, VO_IV_RTTYPE nRotate)
{
	CHECK_CCRRR_POINT

		return pCCRRR->SetCCRRSize (pInWidth, pInHeight, pOutWidth, pOutHeight, nRotate);
}

VO_U32 voccrrProcess (VO_HANDLE hCCRRR, VO_VIDEO_BUFFER * pVideoBuffer, VO_VIDEO_BUFFER * pOutputBuffer, VO_S64 nStart, VO_BOOL bWait)
{
	CHECK_CCRRR_POINT

		return pCCRRR->Process (pVideoBuffer, pOutputBuffer, nStart, bWait);
}

VO_U32 voccrrWaitDone (VO_HANDLE hCCRRR)
{
	CHECK_CCRRR_POINT

		return pCCRRR->WaitDone ();
}

VO_U32 voccrrSetCallBack (VO_HANDLE hCCRRR, VOVIDEOCALLBACKPROC pCallBack, VO_PTR pUserData)
{
	CHECK_CCRRR_POINT

		return pCCRRR->SetCallBack (pCallBack, pUserData);
}

VO_U32 voccrrGetVideoMemOP (VO_HANDLE hCCRRR, VO_MEM_VIDEO_OPERATOR ** ppVideoMemOP)
{
	CHECK_CCRRR_POINT

		return pCCRRR->GetVideoMemOP (ppVideoMemOP);
}

VO_U32 voccrrSetParam (VO_HANDLE hCCRRR, VO_U32 nID, VO_PTR pValue)
{
	CHECK_CCRRR_POINT

		return pCCRRR->SetParam (nID, pValue);
}

VO_U32 voccrrGetParam (VO_HANDLE hCCRRR, VO_U32 nID, VO_PTR pValue)
{
	CHECK_CCRRR_POINT

		return pCCRRR->GetParam (nID, pValue);
}


VO_S32 voGetVideoCCRRRAPI (VO_VIDEO_CCRRRAPI * pCCRRR, VO_U32 uFlag)
{
	if (pCCRRR == NULL)
		return VO_ERR_INVALID_ARG | VO_INDEX_SNK_CCRRR;

	pCCRRR->Init = voccrrInit;
	pCCRRR->Uninit = voccrrUninit;
	pCCRRR->GetProperty = voccrrGetProperty;
	pCCRRR->GetInputType = voccrrGetInputType;
	pCCRRR->GetOutputType = voccrrGetOutputType;
	pCCRRR->SetColorType = voccrrSetColorType;
	pCCRRR->SetCCRRSize = voccrrSetCCRRSize;
	pCCRRR->Process = voccrrProcess;
	pCCRRR->WaitDone = voccrrWaitDone;
	pCCRRR->SetCallBack = voccrrSetCallBack;
	pCCRRR->GetVideoMemOP = voccrrGetVideoMemOP;
	pCCRRR->SetParam = voccrrSetParam;
	pCCRRR->GetParam = voccrrGetParam;

	return VO_ERR_NONE;
}

