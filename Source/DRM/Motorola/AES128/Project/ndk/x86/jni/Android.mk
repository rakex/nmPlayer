LOCAL_PATH := $(call my-dir)
VOTOP?=../../../../../../../..

include $(CLEAR_VARS)

LOCAL_MODULE := voDRM_Moto_AES128

CMNSRC_PATH:=../../../../../../../../Common
CSRCMN_PATH:=../../../../../../../Common
CSRCLOCALMN_PATH:=../../../../../../../File/Common
CSRC_PATH:=../../../../Source
CDRMMN_PATH:=../../../../../../Common

LOCAL_SRC_FILES := \
	\
	$(CMNSRC_PATH)/CvoBaseObject.cpp \
	$(CMNSRC_PATH)/voLog.c \
	$(CMNSRC_PATH)/voOSFunc.cpp \
	$(CSRCMN_PATH)/CSourceIOUtility.cpp \
	$(CDRMMN_PATH)/DRM.cpp \
	$(CDRMMN_PATH)/DRMStreaming.cpp \
	$(CDRMMN_PATH)/voDRM.cpp\
	$(CSRC_PATH)/DRM_Motorola_AES128.cpp \
	$(CSRCLOCALMN_PATH)/base64.cpp \
	$(CSRCLOCALMN_PATH)/strutil.cpp \
	

LOCAL_C_INCLUDES := \
	../../../../../../../Include \
	../../../../../../../../Include \
	$(CMNSRC_PATH) \
	$(CSRCMN_PATH) \
	$(CSRC_PATH) \
	$(CDRMMN_PATH) \
	$(CSRCLOCALMN_PATH)



VOMM:= -D_DRM_MOTO_AES128 -D__VO_NDK__ -DLINUX -D_LINUX -D_LINUX_ANDROID -D_VOLOG_ERROR -D_VOLOG_INFO -D_VOLOG_WARNING
# -D_VOLOG_RUN

# about info option, do not need to care it
LOCAL_CFLAGS := -D_VOMODULEID=0x0a080000  -DNDEBUG -march=i686 -mtune=atom -mstackrealign -msse3 -mfpmath=sse -m32
LOCAL_LDLIBS := -llog
include $(VOTOP)/build/vondk.mk
include $(BUILD_SHARED_LIBRARY)

