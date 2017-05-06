LOCAL_PATH := $(call my-dir)
VOTOP?=../../../../../../../..

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm

LOCAL_MODULE := voDRMCommonAES128

CMNSRC_PATH:=../../../../../../../../Common
CSRCMN_PATH:=../../../../../../../Common
CSRC_PATH:=../../../../Source
CDRMMN_PATH:=../../../../../../Common
CAES128_PATH:=../../../../../../VisualOn/AES128_2/Source
CSRCIO_PATH:=../../../../../../../IO

LOCAL_SRC_FILES := \
	\
	$(CMNSRC_PATH)/CvoBaseObject.cpp \
	$(CMNSRC_PATH)/voCMutex.cpp \
	$(CMNSRC_PATH)/voOSFunc.cpp \
	$(CMNSRC_PATH)/voHalInfo.cpp \
	$(CMNSRC_PATH)/voLog.c \
	$(CMNSRC_PATH)/CDllLoad.cpp \
	$(CMNSRC_PATH)/NetWork/vo_socket.cpp \
	$(CAES128_PATH)/aes-internal-dec.c \
	$(CAES128_PATH)/aes-internal.c \
	$(CAES128_PATH)/AES_CBC.cpp \
	$(CDRMMN_PATH)/DRM.cpp \
	$(CSRCMN_PATH)/vo_thread.cpp \
	$(CSRCMN_PATH)/CSourceIOUtility.cpp \
	$(CSRC_PATH)/voDRMCommonAES128.cpp \
	$(CSRC_PATH)/AES128_CommonAPI.cpp \
	$(CSRC_PATH)/VOAES128_CBC.cpp \
	

LOCAL_C_INCLUDES := \
	../../../../../../../Include \
	../../../../../../../../Include \
	../../../../../../../../Include/OSMP_V3 \
	$(CSRCMN_PATH) \
	$(CMNSRC_PATH)/NetWork \
	$(CMNSRC_PATH)/NetWork/ares \
	$(CMNSRC_PATH) \
	$(CSRC_PATH) \
	$(CDRMMN_PATH) \
	$(CAES128_PATH) \
	$(CSRCIO_PATH)
	

VOMM:= -D__arm -D__VO_NDK__ -DLINUX -D_LINUX -D_LINUX_ANDROID -DCARES_STATICLIB -DENABLE_ASYNCDNS -D_VOLOG_ERROR -D_VOLOG_INFO -D_VOLOG_WARNING
# -D_VOLOG_RUN

# about info option, do not need to care it
LOCAL_CFLAGS := -D_VOMODULEID=0x0a310000  -DNDEBUG -DARM -DARM_ASM -march=armv6j -mtune=arm1136jf-s -mfpu=vfp  -mfloat-abi=softfp -msoft-float -fsigned-char 
LOCAL_LDLIBS := -llog -L../../../../../../../../Lib/ndk -lvodl ../../../../../../../../Lib/ndk/libcares.a
include $(VOTOP)/build/vondk.mk
include $(BUILD_SHARED_LIBRARY)

