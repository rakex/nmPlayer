// voJPEGDecDll.cpp : Defines the entry point for the DLL application.
//
#include <windows.h>
#include "stdafx.h"
#include "jdll.h"

BOOL APIENTRY DllMain( HANDLE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
	g_hJPEGDecInst = hModule;
    return TRUE;
}

