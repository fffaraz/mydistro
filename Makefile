TARGETS = mydistro

MK_DIR = $(realpath $(dir $(firstword $(MAKEFILE_LIST)))))
BR_DIR = $(realpath $(MK_DIR)/../buildroot)

include $(BR_DIR)/board/mydistro/build-rules.mk
