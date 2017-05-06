/************************************************************************
*									     *
*		VisualOn, Inc. Confidential and Proprietary, 2003 -2009	     *
*									     *
************************************************************************/
/*******************************************************************************
File:		voG729A_D_SAMPLE.c

Contains:	G729A Codec sample code

Written by:	Huaping Liu

Change History (most recent first):
2009-11-02		LHP			Create file

*******************************************************************************/
#ifdef _WIN32_WCE
#include <windows.h>
#include <objbase.h>
#include <Winbase.h>
#else
#ifdef LINUX
#include <dlfcn.h>
#endif
#endif // _WIN32_WCE

#include     <stdio.h>
#include     <stdlib.h>
#include     <string.h>
#include     <time.h>
#include     "voG729.h"
#include     "cmnMemory.h"

#define    INPUT_LEN   10            /*Raw Data Length, testing for G729A constant bitrates*/
                                     /*if add sysnc word, INPUT_LEN 14 */
#define    BUFFER_LEN  160
unsigned char InputBuf[BUFFER_LEN];
unsigned char OutputBuf[BUFFER_LEN];

int  GetNextBuf(FILE* inFile,unsigned char* dst,int size)
{
	int size2 = fread(dst, sizeof(signed char), size,inFile);
	return size2;
}

typedef int (VO_API * VOGETAUDIODECAPI) (VO_AUDIO_CODECAPI * pDecHandle);

#ifdef _WIN32_WCE
int _tmain(int argc, TCHAR **argv) 
#else
int main(int argc, char *argv[])
#endif
{
	int  ret = 0;
	FILE *input_file = NULL;                      //input file
	FILE *output_file = NULL;                     //output file
	VO_AUDIO_CODECAPI AudioAPI;
	VO_MEM_OPERATOR moper;
	VO_CODEC_INIT_USERDATA useData;
	VO_HANDLE hCodec;
	VO_CODECBUFFER inData;
	VO_CODECBUFFER outData;
	VO_AUDIO_OUTPUTINFO outFormat;
	unsigned char *inBuf = InputBuf;
	unsigned char *OutBuf = OutputBuf;
	int  returnCode;
	int  frameCount = 0;
	int  Relens = 0;
	int  endFile = 0;  
	int  package = 0;        /* 0 ---- Raw Data, decoder input 80bits(10Bytes) for one frame, default the setting*/
	                         /* 1 ---- Pack with sysnc word. decoder input 14Bytes for one frame */

#ifdef LINUX
	void  *handle;
	void  *pfunc;
	VOGETAUDIODECAPI pGetAPI;
#endif

#ifdef _WIN32_WCE
	DWORD total = 0;
	int t1, t2 = 0;	
#else
	clock_t   start, finish;
	double    duration = 0.0;
#endif

#ifdef _WIN32_WCE
	TCHAR msg[256];
	/*open input file*/
	if(!(input_file = fopen("/Storage Card/G729/EXPT1OBJ22.out", "rb"))){
		printf("open source file error!");
		return 0;
	}

	/*open out put file*/
	if(!(output_file = fopen("/Storage Card/G729/EXPT1OBJ22.pcm", "w+b"))){
		printf("Open output file error!");
		return 0;
	}	
#else
	if(argc <= 1)
		printf("please input decoder name\n");
	/*open input file*/
	if(!(input_file = fopen(argv[1], "rb"))){
		printf("open source file error!");
	}

	/*open out put file*/
	if(!(output_file = fopen(argv[2], "w+b"))){
		printf("Open output file error!");
	}
#endif 
	moper.Alloc = cmnMemAlloc;
	moper.Copy = cmnMemCopy;
	moper.Free = cmnMemFree;
	moper.Set = cmnMemSet;
	moper.Check = cmnMemCheck;

	useData.memflag = VO_IMF_USERMEMOPERATOR;
	useData.memData = (VO_PTR)(&moper);

#ifdef LINUX
	handle = dlopen("/data/local/tmp/voG729Dec.so", RTLD_NOW);
	if(handle == 0)
	{
		printf("open dll error......");
		return -1;
	}

	pfunc = dlsym(handle, "voGetG729DecAPI");	
	if(pfunc == 0)
	{
		printf("open function error......");
		return -1;
	}

	pGetAPI = (VOGETAUDIODECAPI)pfunc;

	returnCode  = pGetAPI(&AudioAPI);
	if(returnCode)
		return -1;
#else
	returnCode = voGetG729DecAPI(&AudioAPI);
	if(returnCode)
	{
		ret = -1;
		goto safe_exit;
	}
#endif
	//#######################################   Init Decoding Section   #########################################
	returnCode = AudioAPI.Init(&hCodec, VO_AUDIO_CodingG729, &useData);
	if(returnCode)
	{
		ret = 3;
		goto safe_exit;
	}
    //####################################### G729 fraem type Setting ############################################
    returnCode = AudioAPI.SetParam(hCodec, VO_PID_G729_FRAMETYPE, &package);
	if(returnCode)
	{
		ret = 3;
		goto safe_exit;
	}

	Relens = GetNextBuf(input_file,InputBuf,INPUT_LEN);

	if(Relens != INPUT_LEN)
	{
		goto safe_exit;
	}

	//#######################################   Decoding Section   #############################################
	do{
		inData.Buffer = (unsigned char *)inBuf;
		inData.Length = INPUT_LEN;
		outData.Buffer = OutBuf;

#ifdef _WIN32_WCE
		t1 = GetTickCount();
#else
		start = clock();
#endif
		/* decode one G729 frame block = 80samples */
		returnCode = AudioAPI.SetInputData(hCodec,&inData); 
		returnCode = AudioAPI.GetOutputData(hCodec,&outData, &outFormat);

#ifdef _WIN32_WCE
		t2 = GetTickCount();
		total += t2 - t1;
#else
		finish = clock();
		duration += finish - start;
#endif

		if(returnCode==0)
		{	
			fwrite(outData.Buffer, 1, outData.Length, output_file);
			frameCount++;
		}

		Relens = GetNextBuf(input_file,InputBuf,INPUT_LEN);
		if(Relens != INPUT_LEN)
		{
			endFile = 1;
		}
	}while(!endFile);


safe_exit:
	returnCode = AudioAPI.Uninit(hCodec);

#ifdef _WIN32_WCE
	wsprintf(msg, TEXT("Decode Time: %d clocks, Decode frames: %d, Decode frames per s: %f"), total, frameCount, (float)frameCount*1000/total);
	MessageBox(NULL, msg, TEXT("G729AB Decode Finished"), MB_OK);
#else
	printf( "\n%2.5f seconds\n", (double)duration);
#endif

	if(input_file)
		fclose(input_file);
	if(output_file)
		fclose(output_file);

#ifdef LINUX
	dlclose(handle);
#endif
	return ret;
}


