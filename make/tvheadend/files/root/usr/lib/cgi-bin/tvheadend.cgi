#!/bin/sh

. /usr/lib/libmodcgi.sh


#

sec_begin '$(lang de:"Starttyp" en:"Start type")'

cgi_print_radiogroup_service_starttype "enabled" "$TVHEADEND_ENABLED" "" "" 0

sec_end


#sec_begin '$(lang de:"Konfiguration" en:"Configuration")'

#cgi_print_textline_p "configdir" "$TVHEADEND_CONFIGDIR" 55/255 "$(lang de:"tvheadend Verzeichnis" en:"tvheadend directory"): "

#sec_end

#



