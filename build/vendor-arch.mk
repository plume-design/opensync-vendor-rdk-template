# To customize: add actual devices/targets
RDK_TARGETS = turris turris-extender

ifneq ($(filter $(TARGET),$(RDK_TARGETS)),)

OS_TARGETS += $(RDK_TARGETS)

# To customize: put actual vendor name here
VENDOR = turris

VERSION_NO_BUILDNUM = 1
VERSION_NO_SHA1 = 1
VERSION_NO_PROFILE = 1

# To customize: put OEM and MODEL names here
RDK_OEM = turris
RDK_MODEL = omnia

SERVICE_PROVIDERS = ALL

# To customize: put image deployment profile name here
export IMAGE_DEPLOYMENT_PROFILE = $(OPENSYNC_SERVICE_PROVIDER_SUFFIX)

# To customize: extender targets (e.g. turris-extender) use a different configuration
ifeq ($(TARGET), turris-extender)
KCONFIG_TARGET ?= vendor/$(VENDOR)/kconfig/RDK_EXTENDER
RDK_CFLAGS  += -DTURRIS_POD
else
KCONFIG_TARGET ?= vendor/$(VENDOR)/kconfig/RDK
endif

# To customize: put any vendor-specific C flags here
RDK_CFLAGS += -D_PLATFORM_TURRIS_

endif
