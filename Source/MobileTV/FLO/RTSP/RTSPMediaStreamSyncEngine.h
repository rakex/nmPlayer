#ifndef __RTSPMEDIASTREAMSYNCENGINE_H__
#define __RTSPMEDIASTREAMSYNCENGINE_H__

#include "network.h"
#include "utility.h"
#include "RTPParser.h"

enum
{
	ASF_SEQ_RESET = -1,
	ASF_SEQ_USE_INDIVIDUAL=-2,
};

class CMediaStream;
class CRDTMediaStream;
class CRDTParser;
class CMediaStreamSocket;

/**
\brief the engine of streams synchronizer

It synchronizes the timestamp of media streams according to RTCP or RTPInfo.
*/
class CRTSPMediaStreamSyncEngine
{
public:
	static CRTSPMediaStreamSyncEngine * CreateRTSPMediaStreamSyncEngine();
	static void DestroyRTSPMediaStreamSyncEngine();

protected:
	static CRTSPMediaStreamSyncEngine * m_pRTSPMediaStreamSyncEngine;

protected:
	CRTSPMediaStreamSyncEngine();
	virtual ~CRTSPMediaStreamSyncEngine();

public:
	void AddMediaStream(CMediaStream * mediaStream);
	bool AllMediaStreamsHaveBeenSynchronized();
	
public:
	typedef struct  
	{
		unsigned long startTime;
		unsigned long syncAudioTime;
		long		  seq;
		int			  flag;
		bool		  valid;
	}TFirstIFrame;
	
	bool	IsFirstIFrameRecieved() { return m_firstIframeInfo.valid; }
	void	SetFirstIFrameInfo(bool isIntra, unsigned long startTime, long seq, int flag);
	void	SetSyncAudioTime(unsigned long syncAudioTime);
	unsigned long	GetSyncAuidoTime() { return m_firstIframeInfo.syncAudioTime; }
	
protected:
	TFirstIFrame m_firstIframeInfo;
	
public:
	void  EnableRejectAfterScan(bool isRejectAll);
	bool  RejectFrameBeforeIFrame(CMediaStream * mediaStream, unsigned long startTime, bool isIntra, bool isVideo);
	
	virtual void RestartMediaStream(CMediaStream * mediaStream);
	virtual void SyncMediaStream(CMediaStream * mediaStream, unsigned int ntpTimestampMSW, unsigned int ntpTimestampLSW, unsigned int rtpTimestamp);
	virtual int CalculateMediaFramePresentationTime(CMediaStream * mediaStream, unsigned int rtpTimestamp, long * frameStartTime, int seqNum);

protected:
	virtual void SetBaseSyncTimeIfAllStreamsHaveBeenSynchronized();
	
#if CP_SOCKET
	struct timeval m_baseSyncWallClockTime;
#else
	struct timeval m_baseSyncWallClockTime;
#endif
	
private:
	bool m_isWatingIFrame;
	bool m_theAudioBeforeIFrameIsCleared;
	long m_firstIFrameTime;
	long m_avsyncAfterWait;
	bool m_isRejectAll;
	int	 m_tryWaitCount;
	int  m_waitIFrameTime;
	bool m_dataSyncbyRTCP;
	
public:
	bool IsSyncEngineSyncbyRTCP(){return m_mediaStreamCount>1? m_dataSyncbyRTCP:false;}
	void EnableWaitIFrame(bool isEnable);
	bool IsWaitingIframe(){return m_isWatingIFrame;};
	bool IsWaitIFrameTimeNotComplete(){return (m_firstIFrameTime!=-2)&&(!m_avsyncAfterWait); }//waiting mechanisam is working but av is not synced
	void RecvMediaFrame(int streamNum,FrameData* frame);

public:
	CMediaStream * m_mediaStreams[32];
	int            m_mediaStreamCount;
	
private:
#if CP_SOCKET
	struct timeval	m_playBegin;
#else
	struct timeval	m_playBegin;
#endif
	
	int		m_maxWaitFrames;
	bool	m_dataSyncbyRTPInfo;
	
public:
	void SetMaxWaitFrames(int max){m_maxWaitFrames=max;};
	void SetSyncByRTPInfo(bool sync);
	bool IsSyncByRTPInfo(){return m_mediaStreamCount>1? m_dataSyncbyRTPInfo:false;}
	
public:
	void SetPlayRangeBegin(float begin){m_playBegin.tv_sec = (int)begin;m_playBegin.tv_usec= (begin-(int)begin)*million;};
#if CP_SOCKET
	struct timeval GetPlayRangeBegin(){return m_playBegin;};	
#else
	struct timeval GetPlayRangeBegin(){return m_playBegin;};	
#endif
private:
	int m_rdtClientPort;
	CMediaStreamSocket * m_rdtStreamSock;
	CRDTParser*	m_rdtParser;
	bool		m_playResponseDone;
	int			m_commonASFSeqNum;
	int			m_commonASFTimeStamp;
public:
	int		GetCommonSeqNum(){return m_commonASFSeqNum;}
	int		GetCommonASFTimeStamp(){return m_commonASFTimeStamp;}
	int	CreateRDTParser(CRDTMediaStream* mediaStream);
	CMediaStreamSocket * GetRDTStreamSock(){return m_rdtStreamSock;};
	int					 GetRDTClientPort(){return m_rdtClientPort;};
	CRDTParser*			 GetRDTParser(){return m_rdtParser;};
	void		SetPlayResponse(bool done){m_playResponseDone=done;}
	bool		GetPlayResponse(){return m_mediaStreamCount>1&&m_dataSyncbyRTPInfo?m_playResponseDone:true;}
	void		AssignRTPInfo(CMediaStream* stream);
	void		ResetASFCOMSEQ(){m_commonASFSeqNum = ASF_SEQ_RESET;}
};




#endif //__RTSPMEDIASTREAMSYNCENGINE_H__
