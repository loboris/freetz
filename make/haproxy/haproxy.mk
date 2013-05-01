$(call PKG_INIT_BIN, 1.4.23)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=6535d5e58037ada4b58b439cebe03c79
$(PKG)_SITE:=http://haproxy.1wt.eu/download/1.4/src

$(PKG)_BINARY:=$($(PKG)_DIR)/haproxy
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/haproxy

$(PKG)_REBUILD_SUBOPTS += FREETZ_KERNEL_VERSION_2_6_28_MIN

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(HAPROXY_DIR) \
		TARGET=$(if $(FREETZ_KERNEL_VERSION_2_6_28_MIN),linux2628,linux26) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(HAPROXY_DIR) clean

$(pkg)-uninstall:
	$(RM) $(HAPROXY_TARGET_BINARY)

$(PKG_FINISH)
