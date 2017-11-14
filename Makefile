LUA     = lib/lua-5.1.4
STATIC  = false
CC      = gcc
CXX     = g++

CFLAGS  = -fno-exceptions -fno-rtti -O2 -I$(LUA) -L$(LUA)
SRC     = main.cpp tools/soap.cpp tools/mem.cpp tools/mcast.cpp lua/luaxlib.cpp lua/luaxcore.cpp lua/luajson.cpp lua/luajson_parser.cpp
LUAMYCFLAGS = -DLUA_USE_LINUX

SDK_ONION = /media/storage-unprotected/opt/onion
TOOLCHAIN_ONION=$(SDK_ONION)/staging_dir/toolchain-mipsel_24kc_gcc-5.4.0_musl-1.1.16

STAGING=staging
TARGET=xupnpd

ifeq ($(STATIC),true)
CFLAGS+=-static
LUAMYCFLAGS+=-static
endif

x86-dbg:
	$(MAKE) DEBUG=true x86

x86:
	#$(MAKE) -C $(LUA) CC=$(CC) a
	$(CC) -O2 -c -o lib/md5/md5.o lib/md5/md5c.c
	$(CC) $(CFLAGS) -DWITH_LIBUUID -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -o $(STAGING)/$(TARGET) $(SRC) lib/md5/md5.o -llua -ldl -lm -luuid
	@if [ "$(DEBUG)" != "true" ] ; then echo strip $(STAGING)/$(TARGET) && strip $(STAGING)/$(TARGET); fi

onion-static:
	$(MAKE) STATIC=true onion

onion:
	$(MAKE) embedded \
		STAGING_DIR=$(SDK_ONION)/staging_dir \
		CC=$(TOOLCHAIN_ONION)/bin/mipsel-openwrt-linux-gcc \
		CXX=$(TOOLCHAIN_ONION)/bin/mipsel-openwrt-linux-g++ \
		STRIP=$(TOOLCHAIN_ONION)/mipsel-openwrt-linux/bin/strip

embedded:
	STAGING_DIR=$(STAGING_DIR) $(MAKE) -C $(LUA) CC=$(CC) a MYCFLAGS='$(LUAMYCFLAGS)'
	$(CC) -O2 -c -o lib/md5/md5.o lib/md5/md5c.c
	$(CC) $(CFLAGS) -DWITH_URANDOM -o $(STAGING)/$(TARGET) $(SRC) lib/md5/md5.o -llua -lm -ldl
	@if [ "$(DEBUG)" != "true" ]; then strip $(STAGING)/$(TARGET); fi

clean:
	#$(MAKE) -C $(LUA) clean
	rm -f lib/md5/md5.o
	rm -f $(STAGING)/$(TARGET)
