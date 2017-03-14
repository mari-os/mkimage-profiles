# Simply Linux images

ifeq (distro,$(IMAGE_CLASS))

distro/slinux-live: distro/.livecd-install use/slinux/base
	@$(call add,THE_LISTS,slinux/live-install)

distro/slinux: distro/.installer use/slinux/full use/rescue/base
	@$(call set,INSTALLER,simply-linux)
	@$(call add,MAIN_GROUPS,slinux/dropbox slinux/emulators-full slinux/games-base slinux/games slinux/games-full slinux/games-full-steam slinux/graphics-base slinux/graphics-full-blender slinux/graphics slinux/graphics-full-inkscape slinux/graphics-full-shotwell slinux/graphics-full-synfigstudio slinux/multimedia-full-audacity slinux/multimedia-base slinux/multimedia-full-cheese slinux/multimedia slinux/multimedia-full-pitivi slinux/multimedia-full-sound-juicer slinux/network-base)

endif