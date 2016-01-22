$(call PKG_INIT_BIN, 3100200)
$(PKG)_LIB_VERSION:=0.8.6
$(PKG)_SOURCE:=$(pkg)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_SHA1:=ea4156fc3f6a4a4a2752a5a3ac5c5b3fe7e1a24b
$(PKG)_SITE:=http://www.sqlite.org/2016

$(PKG)_DIR:=$($(PKG)_SOURCE_DIR)/$(pkg)-autoconf-$($(PKG)_VERSION)

ifeq ($(strip $(FREETZ_PACKAGE_SQLITE_WITH_READLINE)),y)
$(PKG)_DEPENDS_ON += readline
endif

$(PKG)_BINARY:=$($(PKG)_DIR)/.libs/sqlite3
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/sqlite3

$(PKG)_LIB_BINARY:=$($(PKG)_DIR)/.libs/libsqlite3.so.$($(PKG)_LIB_VERSION)
$(PKG)_LIB_STAGING_BINARY:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libsqlite3.so.$($(PKG)_LIB_VERSION)
$(PKG)_LIB_TARGET_BINARY:=$($(PKG)_TARGET_LIBDIR)/libsqlite3.so.$($(PKG)_LIB_VERSION)

$(PKG)_CONFIGURE_OPTIONS += --enable-shared
$(PKG)_CONFIGURE_OPTIONS += --enable-static
$(PKG)_CONFIGURE_OPTIONS += --disable-editline
$(PKG)_CONFIGURE_OPTIONS += --disable-static-shell
$(PKG)_CONFIGURE_OPTIONS += $(if $(FREETZ_PACKAGE_SQLITE_WITH_READLINE),--enable-readline,--disable-readline)

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_LIB_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE1) -C $(SQLITE_DIR)

$($(PKG)_BINARY): $($(PKG)_LIB_BINARY)
	@touch -c $@

$($(PKG)_LIB_STAGING_BINARY): $($(PKG)_LIB_BINARY)
	$(SUBMAKE) -C $(SQLITE_DIR) \
		DESTDIR="$(TARGET_TOOLCHAIN_STAGING_DIR)" \
		all install
	$(PKG_FIX_LIBTOOL_LA) \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/pkgconfig/sqlite3.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libsqlite3.la

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$($(PKG)_LIB_TARGET_BINARY): $($(PKG)_LIB_STAGING_BINARY)
	$(INSTALL_LIBRARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $($(PKG)_LIB_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(SQLITE_DIR) clean
	$(RM) -r $(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/libsqlite3* \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/lib/pkgconfig/sqlite3.pc \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/include/sqlite \
		$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/bin/sqlite3*

$(pkg)-uninstall:
	$(RM) $(SQLITE_TARGET_BINARY) $(SQLITE_TARGET_LIBDIR)/libsqlite3*.so*

$(call PKG_ADD_LIB,libsqlite3)
$(PKG_FINISH)
