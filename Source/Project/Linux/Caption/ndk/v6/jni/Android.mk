LOCAL_PATH := $(call my-dir)
VOTOP?=../../../../../../..

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm

LOCAL_MODULE := libvoCaptionParser

CMNSRC_PATH:=../../../../../../../Common
CSRC_PATH:=../../../../../../MTV/ClosedCaption
CSRCMN_PATH:=../../../../../../File/Common
CMNMTV_PATH:=../../../../../../MTV/Common

LOCAL_SRC_FILES := \
	\
	$(CMNSRC_PATH)/cmnFile.cpp \
	$(CMNSRC_PATH)/cmnMemory.c \
	$(CMNSRC_PATH)/voOSFunc.cpp \
	$(CMNSRC_PATH)/voLog.c \
	$(CMNSRC_PATH)/CvoBaseObject.cpp \
	$(CMNSRC_PATH)/voHalInfo.cpp \
	$(CSRCMN_PATH)/CvoBaseMemOpr.cpp \
	$(CSRC_PATH)/CCaptionParser.cpp \
	$(CSRC_PATH)/CCCH264PacketParser.cpp \
	$(CSRC_PATH)/CCCharParser.cpp \
	$(CSRC_PATH)/CCCPacketParser.cpp \
	$(CSRC_PATH)/CHTMLPacker.cpp \
	$(CSRC_PATH)/ParseSEI.cpp \
	$(CSRC_PATH)/voCaptionParser.cpp \
	$(CSRC_PATH)/CC708CharParser.cpp \
	$(CSRC_PATH)/CCCharData.cpp \
	$(CSRC_PATH)/CSubtilePacker.cpp \
	$(CMNMTV_PATH)/CDumper.cpp

#	$(CMNSRC_PATH)/CDllLoad.cpp 

LOCAL_C_INCLUDES := \
	../../../../../../../Include \
	$(CMNSRC_PATH) \
	$(CSRC_PATH) \
	$(CSRCMN_PATH) \
	$(CMNMTV_PATH) \



VOMM:= -DLINUX -D_LINUX_ANDROID -D_LINUX -D_VOLOG_ERROR -D__arm -D__VO_NDK__

# about info option, do not need to care it
LOCAL_CFLAGS := -D_VOMODULEID=0x00500000  -DNDEBUG -DARM -DARM_ASM -march=armv6j -mtune=arm1136jf-s -mfpu=vfp -mfloat-abi=softfp
LOCAL_LDLIBS := ../../../../../../../Lib/ndk/libvoCheck.a ../../../../../../../Lib/ndk/libvoVideoParser.a -llog 

include $(VOTOP)/build/vondk.mk
include $(BUILD_SHARED_LIBRARY)

