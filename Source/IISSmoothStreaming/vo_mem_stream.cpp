#include "vo_mem_stream.h"
#include "voLog.h"
#ifdef _VONAMESPACE
using namespace _VONAMESPACE;
#endif

mem_block::mem_block()
{
	m_start = 0;
	m_end = 0;
	is_end = VO_FALSE;
	is_full = VO_FALSE;
	m_ptr_next =0;
}
VO_S64 mem_block::read( VO_PBYTE ptr_buffer , VO_U64 buffer_size )
{
	VO_U64 size = (VO_U64)(m_end - m_start);

	if( size > buffer_size )
	{
		memcpy( ptr_buffer , m_buffer + m_start , size_t(buffer_size) );
		m_start =VO_U32( VO_U64(m_start) + buffer_size);

		return buffer_size;
	}
	else if( size == buffer_size )
	{
		memcpy( ptr_buffer , m_buffer + m_start , size_t(buffer_size) );
		m_start = m_end = 0;

		is_end = VO_TRUE;

		return buffer_size;
	}
	else
	{
		memcpy( ptr_buffer , m_buffer + m_start , size_t( size) );
		m_start = m_end = 0;

		is_end = VO_TRUE;

		return size;
	}
}

VO_S64 mem_block::write( VO_PBYTE ptr_buffer , VO_U64 buffer_size )
{
	VO_U64 size = VO_U64(BLOCKSIZE - m_end);

	if( size == 0 )
		return 0;
	else
	{
		if( size > buffer_size )
		{
			memcpy( m_buffer + m_end , ptr_buffer , size_t(buffer_size) );
			m_end = VO_U32( VO_U64(m_end) + buffer_size);
			return buffer_size;
		}
		else if( size == buffer_size )
		{
			memcpy( m_buffer + m_end , ptr_buffer , size_t(buffer_size) );
			m_end = VO_U32( VO_U64(m_end) + buffer_size);
			is_full = VO_TRUE;
			return buffer_size;
		}
		else
		{
			memcpy( m_buffer + m_end , ptr_buffer , size_t(size) );
			m_end = BLOCKSIZE;
			is_full = VO_TRUE;
			return size;
		}
	}
}

vo_mem_stream::vo_mem_stream(void):
m_ptr_block_head(0)
,m_ptr_block_tail(0)
,m_ptr_recycle_block(0)
{
}

vo_mem_stream::~vo_mem_stream(void)
{
	destroy_memblock();
}

VO_BOOL vo_mem_stream::open()
{
	close();
	create_memblock();

	return VO_TRUE;
}

VO_VOID vo_mem_stream::close()
{
	destroy_memblock();
}

VO_S64 vo_mem_stream::read( VO_PBYTE ptr_buffer , VO_U64 buffer_size )
{
	voCAutoLock lock( &m_lock );

	VO_S64 readsize = 0;

	mem_block * ptr_entry = m_ptr_block_head;

	//Modified by HDS 2010.10.19
	while( readsize != VO_S64(buffer_size) && ptr_entry )
	{
		VO_S64 readed = ptr_entry->read( ptr_buffer , buffer_size - readsize );

		readsize += readed;
		ptr_buffer = ptr_buffer + readed;

		if( VO_S64(buffer_size)  == readsize )
		{
			if( ptr_entry->is_end )
			{

			}
			break;
		}

		if( ptr_entry->is_end )
		{
			ptr_entry = ptr_entry->m_ptr_next;
		}
	}
	
	return readsize;
}

VO_S64 vo_mem_stream::write( VO_PBYTE ptr_buffer , VO_U64 buffer_size )
{
	return -1;
}

VO_BOOL vo_mem_stream::seek( VO_S64 pos , vo_stream_pos stream_pos  )
{
	return VO_FALSE;
}

VO_S64 vo_mem_stream::append( VO_PBYTE ptr_buffer , VO_U64 buffer_size )
{
	voCAutoLock lock( &m_lock );
	VO_U64 writesize = 0;

	if( m_ptr_block_tail == NULL )
		create_memblock();

	while( writesize != buffer_size )
	{
		VO_S64 writen = m_ptr_block_tail->write( ptr_buffer , buffer_size - writesize );

		writesize += writen;
		ptr_buffer = ptr_buffer + writen;

		if( writesize == buffer_size )
			break;

		if( m_ptr_block_tail->is_full )
			create_memblock();
	}

	//VOLOGR( "dowload ");
	return writesize;
}

VO_VOID vo_mem_stream::destroy_memblock()
{
	mem_block * ptr = m_ptr_block_head;

	while( ptr )
	{
		mem_block * ptr_temp = ptr;
		ptr = ptr->m_ptr_next;

		delete ptr_temp;
	}

	m_ptr_block_head = m_ptr_block_tail = NULL;
}

VO_VOID vo_mem_stream::create_memblock()
{
	if( m_ptr_block_head == NULL && m_ptr_block_tail == NULL )
	{
		m_ptr_block_head = m_ptr_block_tail = new mem_block;
	}
	else
	{
		m_ptr_block_tail->m_ptr_next = new mem_block;
		m_ptr_block_tail = m_ptr_block_tail->m_ptr_next;
	}
}
