# release/debug
APP_OPTIM?= release
# highest optimized level
APP_CFLAGS := -O3
# Build both ARMv5TE and ARMv7-A machine code.
APP_ABI := armeabi
# VisualOn Info
VOMODVER ?= 3.0.0
VOBRANCH ?= trunk 
VOSRCNO ?= 11803 



VOBUILDTOOL ?= NDKr6b
VOBUILDNUM ?= 0000
VOGPVER ?= 3.3.18
