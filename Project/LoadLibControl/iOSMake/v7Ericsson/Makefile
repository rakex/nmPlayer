						#################################################################
						#  									Visualon Makefile Template  							 	#
						#																																#
						#						(Please Keep Below Options Order Unchanged)					#
						#################################################################

# target type
# available: pc(i386/simulator), v6(armv6), v7(cortex-a8 neon)
VOTT:=v7
 

#top root path
VOTOP:=../../../..

VODBG=yes

# module type
# please specify the type of your module: lib or exe
VOMT:=lib


# module macros
# please append the additional macro definitions here for your module if necessary.
# e.g. -D_IOS, macro _IOS defined for your module(We define _IOS for iOS system, and define _MAC_OS for mac system)
VOMM:=-D_IOS \
-D_ENABLE_SOURCE_MP4=1 \
-D_ENABLE_SOURCE_ASF=0 \
-D_ENABLE_SOURCE_AVI=0 \
-D_ENABLE_SOURCE_MOV=0 \
-D_ENABLE_SOURCE_REAL=0 \
-D_ENABLE_SOURCE_MPG=0 \
-D_ENABLE_SOURCE_TS=1 \
-D_ENABLE_SOURCE_DV=0 \
-D_ENABLE_SOURCE_FLV=0 \
-D_ENABLE_SOURCE_CMMB=0 \
-D_ENABLE_SOURCE_MKV=0 \
-D_ENABLE_SOURCE_AUDIO=1 \
-D_ENABLE_SOURCE_OGG=0 \
-D_ENABLE_SOURCE_RTSP=0 \
-D_ENABLE_SOURCE_HLS=1 \
-D_ENABLE_SOURCE_SSS=1 \
-D_ENABLE_SOURCE_DASH=0 \
-D_ENABLE_SOURCE_HTTPPD=0 \
-D_ENABLE_SOURCE_DRM=1 \
-D_ENABLE_VIDEO_MPEG4=0 \
-D_ENABLE_VIDEO_H264=1 \
-D_ENABLE_VIDEO_WMV=0 \
-D_ENABLE_VIDEO_VC1=0 \
-D_ENABLE_VIDEO_RV=0 \
-D_ENABLE_VIDEO_MPEG2=0 \
-D_ENABLE_VIDEO_MJPEG=0 \
-D_ENABLE_VIDEO_DIVX=0 \
-D_ENABLE_VIDEO_VP6=0 \
-D_ENABLE_VIDEO_VP8=0 \
-D_ENABLE_AUDIO_MP3=0 \
-D_ENABLE_AUDIO_AAC=1 \
-D_ENABLE_AUDIO_AMRNB=0 \
-D_ENABLE_AUDIO_AMRWB=0 \
-D_ENABLE_AUDIO_AMRWBP=0 \
-D_ENABLE_AUDIO_WMA=0 \
-D_ENABLE_AUDIO_ADPCM=0 \
-D_ENABLE_AUDIO_QCELP13=0 \
-D_ENABLE_AUDIO_EVRC=0 \
-D_ENABLE_AUDIO_AC3=1 \
-D_ENABLE_AUDIO_EAC3=1 \
-D_ENABLE_AUDIO_FLAC=0 \
-D_ENABLE_AUDIO_OGG=0 \
-D_ENABLE_AUDIO_RA=0 \
-D_ENABLE_AUDIO_DOLBY=0 \
-D_ENABLE_VIDEO_SUBTITLE=1

# please specify the name of your module
VOTARGET:=libvoLoadLibControl


# please modify here to be sure to see the eclair.mk
include $(VOTOP)/build/ios.mk


#dependent static libraries
#Do not link shared libraries into your library, it should be link by the top application link
#Format: -L+ThePath; -l++DependentLibrary(Remove the prefix "lib" and suffix "a")
#e.g. VOSTCLIBS:=-L../dir -lvoXXXBase  #means your module depends on $(VOPREBUILTPATH)/libvoXXXBase.a


# module source
# please modify here to be sure to see the ms.mk which specifies all source info of your module
include ../source.mk


# please specify where is the$(VOTOP)/../voRelease on your PC, relative path is suggested
#$(VOTOP)/../voRelease folder is local on the same level directory with the trunk folder
# pc(simulator),v6,v7 corresponding path:i386,v6,v7
VORELDIR:=$(VOTOP)/../voRelease/iOS/static/v7/Ericsson


# please modify here to be sure to see the doit.mk
include $(VOTOP)/build/idoit.mk

