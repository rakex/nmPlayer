// voMP3Dec.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include "voChHdle.h"

BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
    g_hMP3DecInst = hModule;
	return TRUE;
}

