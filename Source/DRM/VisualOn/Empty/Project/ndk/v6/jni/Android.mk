LOCAL_PATH := $(call my-dir)
VOTOP?=../../../../../../../..

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm

LOCAL_MODULE := voDRM_VisualOn_Empty

CMNSRC_PATH:=../../../../../../../../Common
CSRC_PATH:=../../../../Source
CDRMMN_PATH:=../../../../../../Common

LOCAL_SRC_FILES := \
	\
	$(CMNSRC_PATH)/CvoBaseObject.cpp \
	$(CMNSRC_PATH)/voLog.cpp \
	$(CDRMMN_PATH)/DRM.cpp \
	$(CDRMMN_PATH)/voDRM.cpp\
	$(CSRC_PATH)/DRM_VisualOn_Empty.cpp

LOCAL_C_INCLUDES := \
	../../../../../../../../Include \
	$(CMNSRC_PATH) \
	$(CSRC_PATH) \
	$(CDRMMN_PATH)



VOMM:= -D_DRM_VISUALON_EMPTY -D__arm -D__VO_NDK__ -DLINUX -D_LINUX -D_LINUX_ANDROID -D_VOLOG_ERROR -D_VOLOG_INFO -D_VOLOG_WARNING

# about info option, do not need to care it
LOCAL_CFLAGS := -DNDEBUG -DARM -DARM_ASM -march=armv6j -mtune=arm1136jf-s -mfpu=vfp -mfloat-abi=soft -fsigned-char
LOCAL_LDLIBS := -llog

include $(VOTOP)/build/vondk.mk
include $(BUILD_SHARED_LIBRARY)
