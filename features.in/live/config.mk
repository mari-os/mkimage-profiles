+live: use/live/desktop; @:

# service defaults
_ON = alteratord cpufreq-simple \
      livecd-evms livecd-fstab livecd-hostname \
      livecd-setauth livecd-setlocale livecd-net-eth livecd-install-wmaker \
      random rpcbind plymouth avahi-daemon \

_OFF = anacron blk-availability bridge clamd crond dhcpd dmeventd dnsmasq \
       lvm2-lvmetad lvm2-monitor mdadm netfs o2cb ocfs2 openvpn postfix \
       rawdevices slapd smartd sshd sysstat update_wms xinetd

# copy stage2 as live
# NB: starts to preconfigure but doesn't use/cleanup yet
use/live: use/stage2 sub/rootfs@live sub/stage2@live \
	use/services use/deflogin/live
	@$(call add_feature)
	@$(call add,CLEANUP_PACKAGES,'installer*')
	@$(call add,DEFAULT_SERVICES_ENABLE,$(_ON))
	@$(call add,DEFAULT_SERVICES_DISABLE,$(_OFF))
	@$(call add,CONTROL,rpcbind:local)

use/live/base: use/live use/net use/syslinux/ui/menu
	@$(call add,LIVE_LISTS,$(call tags,base && (live || network)))

# rw slice, see http://www.altlinux.org/make-initrd-propagator and #28289
ifeq (,$(EFI_BOOTLOADER))
use/live/rw: use/live use/syslinux
	@$(call add,SYSLINUX_CFG,live_rw)
else
use/live/rw: use/live; @:
endif

# graphical target (not enforcing xorg drivers or blobs)
use/live/x11: use/live/base use/syslinux/localboot.cfg \
	use/deflogin/desktop use/x11-autologin use/sound +power +efi
	@$(call add,LIVE_LISTS,$(call tags,desktop && (live || network)))
	@$(call add,LIVE_LISTS,$(call tags,base l10n))
	@$(call add,LIVE_PACKAGES,fonts-ttf-dejavu fonts-ttf-droid)
	@$(call add,LIVE_PACKAGES,pciutils)

# this target specifically pulls free xorg drivers in (and a few more bits);
# a browser is requested too, the recommended one can be overridden downstream
use/live/desktop: use/live/x11 use/x11/xorg use/x11/wacom \
	use/browser/firefox/live use/xdg-user-dirs/deep +vmguest; @:

# preconfigure apt for both live and installed-from-live systems
use/live/repo: use/live
	@$(call add,LIVE_PACKAGES,installer-feature-online-repo)
	@$(call try,LIVE_REPO,http/alt)
	@$(call xport,LIVE_REPO)

# preconfigure apt in runtime (less reliable)
use/live/repo/online:
	@$(call add,LIVE_PACKAGES,livecd-online-repo)

# alterator-based permanent installation
use/live/install: use/metadata use/xdg-user-dirs use/syslinux/localboot.cfg
	@$(call add,LIVE_PACKAGES,livecd-install)
	@$(call add,LIVE_PACKAGES,livecd-installer-features)

# text-based installation script
use/live/textinstall: use/syslinux/lateboot.cfg
	@$(call add,LIVE_PACKAGES,live-install)

# a very simplistic one
use/live/.x11: use/live use/x11 use/x11-autologin
	@$(call add,LIVE_PACKAGES,xinit)

# NB: some implementation has to be added if it's not a display manager
use/live/autologin: use/live/.x11
	@$(call add,LIVE_PACKAGES,autologin)

use/live/nodm: use/live/.x11
	@$(call add,LIVE_PACKAGES,nodm)

# see also http://www.altlinux.org/Netbook-live/hooks
use/live/hooks: use/live
	@$(call add,LIVE_PACKAGES,livecd-run-hooks)

# a crude hack to make sure Russian is supported in a particular image
use/live/ru: use/live
	@$(call add,LIVE_PACKAGES,livecd-ru)
