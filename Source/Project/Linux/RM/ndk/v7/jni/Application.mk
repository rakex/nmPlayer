# Build both ARMv5TE and ARMv7-A machine code.
APP_CFLAGS := -O3
APP_ABI := armeabi-v7a

# release/debug
APP_OPTIM?= release

# VisualOn Info
VOMODVER ?= 3.01.15
VOBRANCH ?= trunk 
VOSRCNO ?= 23691  

VOBUILDTOOL ?= NDKr6b
VOBUILDNUM ?= 0000
VOGPVER ?= 3.3.18
