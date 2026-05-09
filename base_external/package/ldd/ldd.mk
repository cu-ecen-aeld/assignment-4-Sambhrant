##############################################################
#
# LDD
#
##############################################################

LDD_VERSION = 0d4519da730df17a6f0dd49b531f547d63e6eec6
LDD_SITE = git@github.com:cu-ecen-aeld/assignment-7-Sambhrant.git
LDD_SITE_METHOD = git
LDD_GIT_SUBMODULES = YES
LDD_LICENSE = GPL-2.0
LDD_LICENSE_FILES = COPYING

LDD_SUBDIRS = misc-modules scull
LDD_MODULE_MAKE_OPTS = KVERSION=$(LINUX_VERSION_PROBED)

define LDD_BUILD_CMDS
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D)/misc-modules \
		ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KERNELDIR=$(LINUX_DIR) \
		M=$(@D)/misc-modules modules
		
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(@D)/scull \
		ARCH=$(KERNEL_ARCH) \
		CROSS_COMPILE="$(TARGET_CROSS)" \
		KERNELDIR=$(LINUX_DIR) \
		M=$(@D)/scull modules
endef

define LDD_INSTALL_TARGET_CMDS
    # 1. Create the target directory
    $(INSTALL) -d -m 0755 $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/init.d/
    
    # 2. Copy the compiled kernel modules
    $(INSTALL) -m 0755 $(@D)/misc-modules/hello.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/
    $(INSTALL) -m 0755 $(@D)/misc-modules/faulty.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/
    $(INSTALL) -m 0755 $(@D)/scull/scull.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/

	# 3. Copy the load/unload utility scripts to /usr/bin
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_load $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 $(@D)/misc-modules/module_unload $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 $(@D)/scull/scull_load $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 $(@D)/scull/scull_unload $(TARGET_DIR)/usr/bin/

	# 4. Copy the startup init script to /etc/init.d/ and make it executable
	$(INSTALL) -m 0755 $(@D)/S98lddmodules $(TARGET_DIR)/etc/init.d/S98lddmodules
endef

LDD_POST_BUILD_HOOKS += LDD_INSTALL_TARGET_CMDS

$(eval $(kernel-module))
$(eval $(generic-package))