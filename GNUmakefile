PREFIX = /usr/local
LIBDIR = lib/imunes
IMUNESDIR = $(PREFIX)/$(LIBDIR)
CONFIGDIR = $(IMUNESDIR)/config
GUIDIR = $(IMUNESDIR)/gui
GUIDIRMSGS = $(GUIDIR)/msgs
GUIDIRAYU = $(GUIDIR)/ayuda
ICONSDIR = $(IMUNESDIR)/icons
NODESDIR = $(IMUNESDIR)/nodes
RUNTIMEDIR = $(IMUNESDIR)/runtime
SCRIPTSDIR = $(IMUNESDIR)/scripts
PATCHESDIR = $(IMUNESDIR)/src/patches
NORMAL_ICONSDIR = $(ICONSDIR)/normal
SMALL_ICONSDIR = $(ICONSDIR)/small
TINY_ICONSDIR = $(ICONSDIR)/tiny
BINDIR = $(PREFIX)/bin
IMUNESDATE = `date +"%Y%m%d"`
IMUNESVER = 1.0
TARBALL_DIR = imunes_$(IMUNESDATE)
RELEASE_DIR = imunes-$(IMUNESVER)
UNAME_S = $(shell uname -s)
VROOT_EXISTS = $(shell [ -d /var/imunes/vroot ] && echo 1 || echo 0 )
SERVICEDIR=/usr/local/etc/rc.d
STARTUPDIR=/var/imunes-service

BASEFILES =	COPYRIGHT README VERSION
CONFIGFILES =	$(wildcard config/*.tcl)
GUIFILES =	$(wildcard gui/*.tcl)
GUIFILESMSGS =  $(wildcard gui/msgs/*.msg)
NODESFILES =	$(wildcard nodes/*.tcl)
RUNTIMEFILES =	$(wildcard runtime/*.tcl)
PATCHESFILES =	$(wildcard src/patches/*)

VROOT =	$(wildcard scripts/*.sh scripts/*.bash)
TOOLS =	$(filter-out $(VROOT), $(wildcard scripts/*))

NODE_ICONS = frswitch.svg hub.svg lanswitch.svg rj45.svg cloud.svg host.svg ipfirewall.svg \
	pc.svg router.svg click_l2.svg click_l3.svg stpswitch.svg filter.svg packgen.svg \
	nat64.svg ext.svg extnat.svg

NORMAL_ICONS = $(NODE_ICONS)

SMALL_ICONS = $(NODE_ICONS)

TINY_ICONS = $(NODE_ICONS) link.svg minizoomin.svg minizoomout.svg play_start.svg play_stop.svg \
		select.svg extnat.svg l2.svg l2.gif l3.svg l3.gif freeform.svg oval.svg rectangle.svg text.svg

ICONS = $(wildcard icons/imunes_*)

info:
	@echo 	"To install the IMUNES GUI use: make install"
	@echo	"To install the files needed to execute experiments use: make vroot"
	@echo	"To install everything: make all"
	@echo	"To make tarball: make tarball"

all: install vroot

install: uninstall netgraph
	mkdir -p $(IMUNESDIR)
	cp $(BASEFILES) $(IMUNESDIR)
	ROOTDIR=$(PREFIX) sh scripts/update_version.sh
	mkdir -p $(BINDIR)

	sed -e "s,set LIBDIR \"\",set LIBDIR $(LIBDIR)," \
	    -e "s,set ROOTDIR \".\",set ROOTDIR $(PREFIX)," \
	    imunes.tcl > $(IMUNESDIR)/imunes.tcl

	cp helpers.tcl $(IMUNESDIR)

	sed -e "s,LIBDIR=\"\",LIBDIR=$(LIBDIR)," \
	    -e "s,ROOTDIR=\".\",ROOTDIR=$(PREFIX)," \
	    -e "s,BINDIR=\".\",BINDIR=$(BINDIR)," \
	    imunes > $(BINDIR)/imunes
	chmod 755 $(BINDIR)/imunes

	cp $(TOOLS) $(BINDIR)
	for file in $(notdir $(TOOLS)); do \
		chmod 755 $(BINDIR)/$${file}; \
	done ;
ifeq ($(UNAME_S), Linux)
	mv $(BINDIR)/hcp.linux $(BINDIR)/hcp
	mv $(BINDIR)/himage.linux $(BINDIR)/himage
	mv $(BINDIR)/cleanupAll.linux $(BINDIR)/cleanupAll
	mv $(BINDIR)/startxcmd.linux $(BINDIR)/startxcmd
	rm -f $(BINDIR)/pkg_add_imunes $(BINDIR)/pkg_imunes
else
	rm -f $(BINDIR)/himage.linux $(BINDIR)/cleanupAll.linux $(BINDIR)/startxcmd.linux $(BINDIR)/hcp.linux $(BINDIR)/apt-get_imunes
endif

	mv $(BINDIR)/vlink.tcl $(BINDIR)/vlink

	mkdir -p $(SCRIPTSDIR)

	for file in $(VROOT); do \
	    sed -e "s,LIBDIR=\"\",LIBDIR=$(LIBDIR)," \
		-e "s,ROOTDIR=\".\",ROOTDIR=$(PREFIX)," \
		$${file} > $(IMUNESDIR)/$${file}; \
	    chmod 755 $(IMUNESDIR)/$${file}; \
	done ;

	mkdir -p $(CONFIGDIR)
	cp $(CONFIGFILES) $(CONFIGDIR)

	mkdir -p $(GUIDIR)
	cp $(GUIFILES) $(GUIDIR)

	mkdir -p $(GUIDIRMSGS)
	cp $(GUIFILESMSGS) $(GUIDIRMSGS)

	mkdir -p $(GUIDIRAYU)

	mkdir -p $(NODESDIR)
	cp $(NODESFILES) $(NODESDIR)

	mkdir -p $(RUNTIMEDIR)
	cp $(RUNTIMEFILES) $(RUNTIMEDIR)

	mkdir -p $(PATCHESDIR)
	cp $(PATCHESFILES) $(PATCHESDIR)

	mkdir -p $(ICONSDIR)
	for file in $(ICONS); do \
		cp $${file} $(ICONSDIR); \
	done ;

	mkdir -p $(NORMAL_ICONSDIR)
	for file in $(NORMAL_ICONS); do \
		cp icons/normal/$${file} $(NORMAL_ICONSDIR); \
	done ;

	mkdir -p $(SMALL_ICONSDIR)
	for file in $(SMALL_ICONS); do \
		cp icons/small/$${file} $(SMALL_ICONSDIR); \
	done ;

	mkdir -p $(TINY_ICONSDIR)
	for file in $(TINY_ICONS); do \
		cp icons/tiny/$${file} $(TINY_ICONSDIR); \
	done ;

uninstall:
	rm -rf $(IMUNESDIR)
	for file in imunes $(notdir $(TOOLS)); do \
		rm -f $(BINDIR)/$${file}; \
	done ;
	rm -rf $(SERVICEDIR)/imunes-service.sh
	@echo 	"To remove startup topologies, remove $(STARTUPDIR)"

netgraph:
ifeq ($(UNAME_S), FreeBSD)
	sh scripts/install_ng_modules.sh
endif

vroot:
	sh scripts/prepare_vroot.sh

vroot_zfs:
	sh scripts/prepare_vroot.sh zfs

vroot_m:
	sh scripts/prepare_vroot.sh mini

vroot_m_zfs:
	sh scripts/prepare_vroot.sh zfs mini

vroot_usr:
ifeq ($(VROOT_EXISTS), 1)
	sh scripts/install_usr_tools.sh
else
	@echo   "/var/imunes/vroot does not exist, exiting..."
endif

remove_vroot:
ifeq ($(VROOT_EXISTS), 1)
	chflags -R noschg /var/imunes/vroot
	rm -fr /var/imunes/vroot
else
	@echo   "/var/imunes/vroot does not exist, exiting..."
endif

service:
ifeq ($(UNAME_S), FreeBSD)
	cp scripts/imunes-service.sh $(SERVICEDIR)
	chmod 755 $(SERVICEDIR)/imunes-service.sh
	mkdir -p $(STARTUPDIR)
	@echo	""
	@echo   "Created directory $(STARTUPDIR)"
	@echo   "To start the experiment on boot, copy a topology to this folder."
endif

noservice:
ifeq ($(UNAME_S), FreeBSD)
	rm -rf $(SERVICEDIR)/imunes-service.sh
	@echo	""
	@echo   "Removed $(SERVICEDIR)/imunes-service.sh"
	@echo 	"To remove startup topologies, remove $(STARTUPDIR)"
endif


tarball:
	rm -f ../$(TARBALL_DIR).tar.gz

	mkdir -p ../$(TARBALL_DIR)
	cp $(FILES) $(BINARIES) $(VROOT) Makefile imunes imunes.tcl ../$(TARBALL_DIR)

	mkdir -p ../$(TARBALL_DIR)/icons
	for file in $(ICONS); do \
		cp icons/$${file} ../$(TARBALL_DIR)/icons; \
	done ;

	mkdir -p ../$(TARBALL_DIR)/icons/normal
	for file in $(NORMAL_ICONS); do \
		cp icons/normal/$${file} ../$(TARBALL_DIR)/icons/normal; \
	done ;

	mkdir -p ../$(TARBALL_DIR)/icons/small
	for file in $(SMALL_ICONS); do \
		cp icons/small/$${file} ../$(TARBALL_DIR)/icons/small; \
	done ;

	mkdir -p ../$(TARBALL_DIR)/icons/tiny
	for file in $(TINY_ICONS); do \
		cp icons/tiny/$${file} ../$(TARBALL_DIR)/icons/tiny; \
	done ;

	cd .. && tar czfv $(TARBALL_DIR).tar.gz $(TARBALL_DIR)
	rm -r ../$(TARBALL_DIR)

release:
	rm -f ../$(RELEASE_DIR).tar.gz

	mkdir -p ../$(RELEASE_DIR)
	cp $(FILES) $(BINARIES) $(VROOT) Makefile imunes imunes.tcl ../$(RELEASE_DIR)

	mkdir -p ../$(RELEASE_DIR)/icons
	for file in $(ICONS); do \
		cp icons/$${file} ../$(RELEASE_DIR)/icons; \
	done ;

	mkdir -p ../$(RELEASE_DIR)/icons/normal
	for file in $(NORMAL_ICONS); do \
		cp icons/normal/$${file} ../$(RELEASE_DIR)/icons/normal; \
	done ;

	mkdir -p ../$(RELEASE_DIR)/icons/small
	for file in $(SMALL_ICONS); do \
		cp icons/small/$${file} ../$(RELEASE_DIR)/icons/small; \
	done ;

	mkdir -p ../$(RELEASE_DIR)/icons/tiny
	for file in $(TINY_ICONS); do \
		cp icons/tiny/$${file} ../$(RELEASE_DIR)/icons/tiny; \
	done ;

	cd .. && tar czfv $(RELEASE_DIR).tar.gz $(RELEASE_DIR)
	rm -r ../$(RELEASE_DIR)
