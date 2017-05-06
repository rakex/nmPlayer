
#ifndef __VO_SMALLFILE_BUFFER_MANAGER_H__

#define __VO_SMALLFILE_BUFFER_MANAGER_H__

#include "vo_buffer.h"
#include "vo_stream.h"
#include "voCMutex.h"

#ifdef _VONAMESPACE
namespace _VONAMESPACE{
#endif

struct BUFFER_SEGMENT
{
	VO_S64 physical_pos;
	VO_S64 size;

	BUFFER_SEGMENT * ptr_next;
	BUFFER_SEGMENT * ptr_pre;
};

class vo_smallfile_buffer_manager: public vo_buffer
{
public:
	vo_smallfile_buffer_manager();
	virtual ~vo_smallfile_buffer_manager();

	//vo_buffer
	virtual VO_BOOL init( VOPDInitParam * ptr_param );
	virtual VO_VOID uninit();
	virtual VO_S64 read( VO_S64 physical_pos , VO_PBYTE buffer , VO_S64 toread , VO_BOOL issync = VO_TRUE );
	virtual VO_S64 write( VO_S64 physical_pos , VO_PBYTE buffer , VO_S64 towrite );
	virtual VO_S64 seek( VO_S64 physical_pos );
	virtual VO_VOID reset();
	virtual VO_VOID close(){}

	virtual VO_VOID get_buffer_info( BUFFER_INFO * ptr_info );
	virtual VO_VOID get_buffering_start_info( BUFFER_INFO * ptr_info );

	virtual VO_VOID set_filesize( VO_S64 filesize );
	//

private:
	BUFFER_SEGMENT * get_segment( VO_S64 physical_pos );
	VO_VOID combine_segment( BUFFER_SEGMENT * ptr_segment , VO_BOOL new_segment = VO_FALSE );
	VO_VOID add_segment( BUFFER_SEGMENT * ptr_segment );

	//judge if all data has been download to local buffer
	VO_BOOL	is_alldata_downloaded();


protected:
	BUFFER_SEGMENT * m_ptr_segment_begin;
	BUFFER_SEGMENT * m_ptr_segment_end;
	VO_S64 m_curpos;

	vo_stream * m_ptr_stream;

	VO_CHAR m_tempfile[1024];

	voCMutex m_lock;

	VO_BOOL m_is_exit;

	VO_BOOL m_is_alldata_downloaded;
	VO_S64	m_download_pos;
	VO_U32	m_notify_freq;
	VO_U32	m_last_time;
};

#ifdef _VONAMESPACE
}
#endif

#endif