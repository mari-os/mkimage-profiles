use/slinux: use/x11/xfce use/x11/gdm2.20
	@$(call add_feature)
	@$(call add,THE_LISTS,gnome-p2p)
	@$(call add,THE_LISTS,slinux/$(ARCH))
	@$(call add,THE_LISTS,slinux/games)
	@$(call add,THE_LISTS,slinux/graphics)
	@$(call add,THE_LISTS,slinux/live)
	@$(call add,THE_LISTS,slinux/misc)
	@$(call add,THE_LISTS,slinux/misc-dvd)
	@$(call add,THE_LISTS,slinux/multimedia)
	@$(call add,THE_LISTS,slinux/network)
	@$(call add,THE_LISTS,slinux/xfce)
	@$(call add,THE_LISTS,$(call tags,base l10n))
	@$(call add,THE_PACKAGES,apt-conf-sisyphus)

use/slinux-live: use/slinux
	@$(call add,THE_LISTS,slinux/live-install)
