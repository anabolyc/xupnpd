LUA     = lua-5.1.4
STATIC  = false
CC      = gcc
CXX     = g++

CFLAGS  = -fno-exceptions -fno-rtti -O2 -I$(LUA) -L$(LUA)
SRC     = main.cpp soap.cpp mem.cpp mcast.cpp luaxlib.cpp luaxcore.cpp luajson.cpp luajson_parser.cpp
LUAMYCFLAGS = -DLUA_USE_LINUX

SDK_ONION = /media/storage-unprotected/opt/onion
TOOLCHAIN_ONION=$(SDK_ONION)/staging_dir/toolchain-mipsel_24kc_gcc-5.4.0_musl-1.1.16

ifeq ($(STATIC),true)
CFLAGS+=-static
LUAMYCFLAGS+=-static
endif

x86-dbg:
	$(MAKE) -C $(LUA) CC=$(CC) a
	$(CC) -O2 -c -o md5/md5.o md5/md5c.c
	$(CC) $(CFLAGS) -g -DWITH_LIBUUID -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -o staging/xupnpd $(SRC) md5/md5.o -llua -ldl -lm -luuid

x86:
	$(MAKE) -C $(LUA) CC=$(CC) a
	$(CC) -O2 -c -o md5/md5.o md5/md5c.c
	$(CC) $(CFLAGS) -DWITH_LIBUUID -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -o staging/xupnpd $(SRC) md5/md5.o -llua -ldl -lm -luuid
	strip staging/xupnpd

onion:
	$(MAKE) embedded \
		STAGING_DIR=$(SDK_ONION)/staging_dir \
		CC=$(TOOLCHAIN_ONION)/bin/mipsel-openwrt-linux-gcc \
		CXX=$(TOOLCHAIN_ONION)/bin/mipsel-openwrt-linux-g++ \
		STRIP=$(TOOLCHAIN_ONION)/mipsel-openwrt-linux/bin/strip

embedded:
	STAGING_DIR=$(STAGING_DIR) $(MAKE) -C $(LUA) CC=$(CC) a MYCFLAGS='$(LUAMYCFLAGS)'
	$(CC) -O2 -c -o md5/md5.o md5/md5c.c
	$(CC) $(CFLAGS) -DWITH_URANDOM -o staging/xupnpd $(SRC) md5/md5.o -llua -lm -ldl
	$(STRIP) staging/xupnpd

clean:
	$(MAKE) -C $(LUA) clean
	rm -f $(LUA)/liblua.a
	rm -f md5/md5.o
	rm -f staging/xupnpd
