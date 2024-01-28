PKG_1_VERSION = 1.0.0
PKG_1_SITE = $(BR2_EXTERNAL_MYDISTRO_PATH)/package/pkg-1/src
PKG_1_SITE_METHOD = local
PKG_1_LICENSE = GPL-3.0+

$(eval $(autotools-package))
