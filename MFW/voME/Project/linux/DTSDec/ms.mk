
# please list all objects needed by your target here
OBJS:=	voCOMXBaseConfig.o \
		voCOMXBaseObject.o \
		voCOMXTaskQueue.o \
		voCOMXThreadMutex.o \
		voCOMXThreadSemaphore.o \
		voOMXBase.o \
		voOMXFile.o \
		voOMXMemroy.o \
		voOMXOSFun.o \
		voOMXPortAudioConnect.o \
		voOMXPortVideoConnect.o \
		voOMXThread.o \
		voCOMXCoreDTSDec.o \
		voOMXCoreDTS.o \
		voComponentEntry.o \
		voCOMXBaseComponent.o \
		voCOMXBasePort.o \
		voCOMXCompFilter.o \
		CBaseConfig.o \
		cmnFile.o \
		cmnVOMemory.o \
		CvoBaseObject.o \
		voCMutex.o \
		voOSFunc.o \
		voCOMXAudioDTSDec.o \
		voLog.o \
		voHalInfo.o \
        dts_tables_misc.o \
        dts_tables_huffman.o \
        dts_endian_conversion.o \
        dts_player_neo6_control.o \
        dts_player_config.o \
        dts_decoder_synthesis_filter_float.o \
        dtshd_file_player_seek.o \
        dts_wav_file_access.o \
        dts_decoder_adpcm_history.o \
        dts_decoder_core_lfe.o \
        dts_tables_quantization_step_size.o \
        dts_player_spdif_output_control.o \
        dts_pcm_output_file_access.o \
        dtshd_frame_player_others.o \
        dts_frame_segmenter.o \
        dts_decoder_downmix_control.o \
        dts_tables_square_root.o \
        dts_tables_down_mix.o \
        dts_decoder_core_dither.o \
        dts_tables_lookup.o \
        dts_bitstream.o \
        dts_decoder_synthesis_filter_int.o \
        dts_dial_norm_config.o \
        dts_dial_norm_funcs.o \
        dts_decoder_core_primary_audio_side_information.o \
        dts_debug.o \
        dtshd_file_writer.o \
        dts_table_lfe_coeff.o \
        dts_fade_in.o \
        dts_downmixer_matrices.o \
        dts_decoder_core_primary_audio_processor.o \
        dts_table_filter_coeff.o \
        dts_decoder_misc.o \
        dtshd_frame_parser.o \
        dtshd_file_reader_seek.o \
        dts_drc_config.o \
        dts_substream_header.o \
        dts_wav_output_file_access.o \
        dts_hd_file_access.o \
        dts_decoder_core_frame_header.o \
        dts_tables_range.o \
        dts_drc_funcs.o \
        dts_decoder_synthesis.o \
        dts_dial_norm.o \
        dts_downmixer.o \
        dtshd_frame_player.o \
        dtshd_frame_parser_substreams.o \
        dts_decoder_synthesis_filter_24bit.o \
        dtshd_frame_player_config.o \
        dts_decoder_core_channel_map.o \
        dts_player.o \
        dts_decoder_vq_high_freq_subband.o \
        dts_tables_joint_scales_scale_factor.o \
        dts_drc.o \
        dtshd_file_player.o \
        dts_decoder_subband_output.o \
        dts_peak_limit.o \
        dts_decoder.o \
        dts_speaker_remap_funcs.o \
        dts_decoder_core_optional_information.o \
        dts_decoder_primary_audio.o \
        dts_decoder_config.o \
        dts_player_api.o \
        dts_timecode.o \
        dts_decoder_synthesis_lfe_interpolation.o \
        dts_decoder_core.o \
        dts_decoder_core_primary_audio_header.o \
        dts_decoder_crc.o \
        dts_tables_linear_predictive_coding.o \
        dtshd_file_player_timestamp.o \
        dtshd_frame_player_getinfo.o \
        dts_downmixer_analog_compensation.o \
        dts_tables_high_freq_vq.o \
        dts_player_downmix_control.o \
        dts_downmixer_config.o \
        dtshd_file_reader.o \
        dts_file_access.o \
        dts_coeff_smoothing.o
		 

# please list all directories that your all of your source files(.h .c .cpp) locate 
VOSRCDIR:=../../../../../../Include \
					../../../../../../Include/vome \
		  ../../../../../../Common \
		  ../../../../../Common \
          ../../../../Include \
	      ../../../../Common \
		  ../../../../Component/Base \
          ../../../../Component/AudioDTSDec \
          ../../../../Component/AudioDTSDec/Core \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1 \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/common/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/player/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/file_player/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/fileio/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/core/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/DRC/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/downmixer/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/frame_parser/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/frame_player/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/decoder_api/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/dial_norm/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/file_reader/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/file_writer/private/src \
				  ../../../../../../Codec/Audio/DTS/dtshd_cdecoder1/pubheader


# please modify here to be sure to see the doit.mk
include ../../../../../../build/doit.mk

