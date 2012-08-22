$(call PKG_INIT_BIN, 0.2.2.38)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=91a9dd2c9d7fbd946bda5a13edbe5667
$(PKG)_SITE:=http://www.torproject.org/dist

$(PKG)_BINARY:=$($(PKG)_DIR)/src/or/tor
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/sbin/tor

$(PKG)_DEPENDS_ON := zlib openssl libevent

$(PKG)_CONFIGURE_ENV += tor_cv_malloc_zero_works=no
$(PKG)_CONFIGURE_ENV += tor_cv_null_is_zero=yes
$(PKG)_CONFIGURE_ENV += tor_cv_sign_extend=yes
$(PKG)_CONFIGURE_ENV += tor_cv_size_t_signed=no
$(PKG)_CONFIGURE_ENV += tor_cv_time_t_signed=yes
$(PKG)_CONFIGURE_ENV += tor_cv_twos_complement=yes

$(PKG)_CONFIGURE_OPTIONS += --sysconfdir=/mod/etc
$(PKG)_CONFIGURE_OPTIONS += --enable-shared
$(PKG)_CONFIGURE_OPTIONS += --enable-static
$(PKG)_CONFIGURE_OPTIONS += --with-openssl-dir="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib"
$(PKG)_CONFIGURE_OPTIONS += --with-libevent-dir="$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib"

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_TOR_STATIC

ifeq ($(strip $(FREETZ_PACKAGE_TOR_STATIC)),y)
$(PKG)_LDFLAGS := -static
endif

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(TOR_DIR) \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TOR_LDFLAGS)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(TOR_DIR) clean

$(pkg)-uninstall:
	$(RM) $(TOR_TARGET_BINARY)

$(PKG_FINISH)
