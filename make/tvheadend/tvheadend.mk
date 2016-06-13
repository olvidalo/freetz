$(call PKG_INIT_BIN, 4.0.9)
#$(PKG)_SOURCE:=master.zip
$(PKG)_SOURCE:=v$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_MD5:=afe45a345151e7ce31db673e0c738e6e
$(PKG)_SITE:=https://github.com/$(pkg)/$(pkg)/archive/
$(PKG)_BINARY:=$($(PKG)_DIR)/build.linux/tvheadend
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/tvheadend

$(PKG)_WEBUI_DIR:=$($(PKG)_DIR)/src/webui/
$(PKG)_TARGET_WEBUI_DIR:=$($(PKG)_DEST_DIR)/usr/share/tvheadend/src/webui
$(PKG)_DATA_DIR:=$($(PKG)_DIR)/data/
$(PKG)_TARGET_DATA_DIR:=$($(PKG)_DEST_DIR)/usr/share/tvheadend/data

$(PKG)_CATEGORY:=Unstable
$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)




$(PKG)_CONFIGURE_OPTIONS += --arch=$(KERNEL_ARCH)
$(PKG)_CONFIGURE_OPTIONS += --platform=linux
$(PKG)_CONFIGURE_OPTIONS += --disable-hdhomerun_static
$(PKG)_CONFIGURE_OPTIONS += --disable-libffmpeg_static



$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(TVHEADEND_DIR) \
		CXX="$(TARGET_CXX)"

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(PKG)-install-webui: $(TVHEADEND_DIR)/.unpacked
	mkdir -p $(TVHEADEND_TARGET_WEBUI_DIR)
	$(call COPY_USING_TAR,$(TVHEADEND_WEBUI_DIR),$(TVHEADEND_TARGET_WEBUI_DIR), -h --exclude='*.c' .)
	#chmod -R 644 $(TVHEADEND_TARGET_WEBUI_DIR)
	find $(TVHEADEND_TARGET_WEBUI_DIR) -exec touch {} \;

$(PKG)-install-data: $(TVHEADEND_DIR)/.unpacked
	mkdir -p $(TVHEADEND_TARGET_DATA_DIR)
	$(call COPY_USING_TAR,$(TVHEADEND_DATA_DIR),$(TVHEADEND_TARGET_DATA_DIR), -h --exclude=LICENSE --exclude='Makefile*' .)
	#chmod -R 644 $(TVHEADEND_TARGET_DATA_DIR)
	find $(TVHEADEND_TARGET_DATA_DIR) -exec touch {} \;



$(pkg)-precompiled: $($(PKG)_TARGET_BINARY) $(PKG)-install-webui $(PKG)-install-data

$(pkg)-clean:
	-$(SUBMAKE) -C $(TVHEADEND_DIR) clean

$(pkg)-uninstall:
	$(RM) $(TVHEADEND_TARGET_BINARY)

$(PKG_FINISH)
