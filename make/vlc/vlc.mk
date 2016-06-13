$(call PKG_INIT_BIN, 3.0.0-git)
$(PKG)_SNAPSHOT:=3.0.0-20160526-0148
$(PKG)_SOURCE:=vlc-$($(PKG)_SNAPSHOT).tar.xz
$(PKG)_SOURCE_MD5:=9a938a3e45f42c6af913a0e74a909a35
$(PKG)_SITE:=http://nightlies.videolan.org/build/source/
$(PKG)_BINARY:=$($(PKG)_DIR)/bin/.libs/vlc
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/vlc
$(PKG)_LIBVLC_VERSION:=10.0.5
$(PKG)_LIBVLCCORE_VERSION:=8.0.0


#$(PKG)_LIBNAME:=libvlc*.so*
#$(PKG)_LIBRARY_BUILD_DIR:=$($(PKG)_DIR)/lib/.libs/
$(PKG)_LIBRARY_STAGING_DIR:=$(TARGET_TOOLCHAIN_STAGING_DIR)/usr/lib/
$(PKG)_LIBRARY_TARGET_DIR:=$($(PKG)_TARGET_LIBDIR)/


$(PKG)_CATEGORY:=Unstable
$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)

$(PKG)_CONFIGURE_PRE_CMDS = $(call PKG_PREVENT_RPATH_HARDCODING,./configure)

$(PKG)_CONFIGURE_OPTIONS += --host=mips-linux-uclibc
$(PKG)_CONFIGURE_OPTIONS += --disable-qt
$(PKG)_CONFIGURE_OPTIONS += --disable-mad
$(PKG)_CONFIGURE_OPTIONS += --disable-a52
$(PKG)_CONFIGURE_OPTIONS += --disable-xcb
$(PKG)_CONFIGURE_OPTIONS += --disable-taglib
$(PKG)_CONFIGURE_OPTIONS += --disable-alsa
$(PKG)_CONFIGURE_OPTIONS += --disable-libgcrypt
$(PKG)_CONFIGURE_OPTIONS += --disable-lua
$(PKG)_CONFIGURE_OPTIONS += --disable-jpeg
$(PKG)_CONFIGURE_OPTIONS += --disable-vcd
$(PKG)_CONFIGURE_OPTIONS += --disable-screen
$(PKG)_CONFIGURE_OPTIONS += --disable-dbus
$(PKG)_CONFIGURE_OPTIONS += --disable-dbus-control
$(PKG)_CONFIGURE_OPTIONS += --disable-httpd
$(PKG)_CONFIGURE_OPTIONS += --disable-linsys
$(PKG)_CONFIGURE_OPTIONS += --disable-libcddb
$(PKG)_CONFIGURE_OPTIONS += --disable-postproc
$(PKG)_CONFIGURE_OPTIONS += --disable-png
$(PKG)_CONFIGURE_OPTIONS += --disable-x264
$(PKG)_CONFIGURE_OPTIONS += --disable-zvbi
$(PKG)_CONFIGURE_OPTIONS += --disable-telx
$(PKG)_CONFIGURE_OPTIONS += --disable-libass
$(PKG)_CONFIGURE_OPTIONS += --disable-xvideo
$(PKG)_CONFIGURE_OPTIONS += --disable-glx
$(PKG)_CONFIGURE_OPTIONS += --disable-sdl
$(PKG)_CONFIGURE_OPTIONS += --disable-sdl-image
$(PKG)_CONFIGURE_OPTIONS += --disable-oss
$(PKG)_CONFIGURE_OPTIONS += --disable-visual
$(PKG)_CONFIGURE_OPTIONS += --disable-projectm
$(PKG)_CONFIGURE_OPTIONS += --disable-atmo

$(PKG)_CONFIGURE_OPTIONS += --enable-libdvbpsi
$(PKG)_CONFIGURE_OPTIONS += --enable-run-as-root

$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(VLC_DIR) \
		CXX="$(TARGET_CXX)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	mkdir -p $(VLC_DEST_DIR)$(FREETZ_LIBRARY_DIR)
	cp -a $(VLC_DIR)/lib/.libs/libvlc.so* $(VLC_DIR)/src/.libs/libvlccore.so*  $(VLC_DEST_DIR)$(FREETZ_LIBRARY_DIR)	
	$(TARGET_STRIP) $(VLC_DEST_DIR)$(FREETZ_LIBRARY_DIR)/*.so*
	$(INSTALL_BINARY_STRIP)

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(VLC_DIR) clean

$(pkg)-uninstall:
	$(RM) $(VLC_TARGET_BINARY)

$(PKG_FINISH)
