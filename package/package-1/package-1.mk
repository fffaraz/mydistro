PKG_1_VERSION = 1.0.0
PKG_1_SITE = $(BR2_EXTERNAL_MYDISTRO_PATH)/package/test/src
PKG_1_SITE_METHOD = local
PKG_1_LICENSE = GPL-3.0+
PKG_1_LICENSE_FILES = COPYING
PKG_1_DEPENDENCIES = liba libb

define PKG_1_BUILD_CMDS
    $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define PKG_1_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/test $(TARGET_DIR)/usr/sbin/
endef

$(eval $(generic-package))
