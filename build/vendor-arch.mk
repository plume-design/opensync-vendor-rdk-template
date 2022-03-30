ifeq ($(TARGET),RDKB)

# To customize: put actual vendor name here
VENDOR = turris

VERSION_NO_BUILDNUM = 1
VERSION_NO_SHA1 = 1
VERSION_NO_PROFILE = 1

# To customize: This vendor layer supports Turris Omnia as a residential / business gateway
# and Turris Omnia as Extender/GW. Put your machine name here.
ifeq ($(RDK_MACHINE),$(filter $(RDK_MACHINE),turris turris-extender turris-bci turris_5.10))

# To customize: put OEM and MODEL names here
RDK_OEM = turris
RDK_MODEL = omnia

SERVICE_PROVIDERS = ALL

# To customize: put image deployment profile name here
export IMAGE_DEPLOYMENT_PROFILE = dev-academy

# To customize: extender targets (e.g. turris-extender) use a different configuration
ifeq ($(RDK_MACHINE), turris-extender)
KCONFIG_TARGET ?= vendor/$(VENDOR)/kconfig/RDK_EXTENDER
RDK_CFLAGS  += -DTURRIS_POD
else
KCONFIG_TARGET ?= vendor/$(VENDOR)/kconfig/RDK
endif

# To customize: put any vendor-specific C flags here
RDK_CFLAGS += -D_PLATFORM_TURRIS_

# The following flag is NOT obligatory for non-ARMv7 based platforms.
# It is added specifically for the Turris toolchain, to avoid wrong symbol
# relocation in case of empty extern C arrays (e.g. target_managers_config)
# which apparently are not handled correctly by ARMv7 based Turris' toolchain.
# Add it only if you know what you are doing (e.g. expecting OpenSync library
# to be dynamically loaded, which is not a default case).
RDK_CFLAGS += -fPIC

else
$(error Unsupported RDK_MACHINE ($(RDK_MACHINE)).)
endif

endif
