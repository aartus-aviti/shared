# Define some compilation flags for Linux

# Centralize the choice of C compiler here (gcc, clang...)
CC ?= cc

# C preprocessor flags
CPPFLAGS ?= -D_GNU_SOURCE -D_FORTIFY_SOURCE=2

# C compiler flags
# list of warnings from https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
CFLAGS ?= -O2 -ansi -pedantic -pipe \
	-Wall -W -Wextra \
	-Wfloat-equal \
	-Wformat=2 \
	-Winit-self \
	-Wmissing-declarations \
	-Wmissing-prototypes \
	-Wpointer-arith \
	-Wshadow \
	-Wstrict-prototypes \
	-Wwrite-strings \
	-Wno-unused-function \
	-fPIE  \
	-fno-exceptions \
	-fstack-protector --param=ssp-buffer-size=4 \
	-fvisibility=hidden

# Add GCC-specific options unknown to clang
ifeq ($(shell $(CC) -Wtrampolines -Werror -E - < /dev/null > /dev/null 2>&1 && echo y), y)
CFLAGS += -Wtrampolines
endif

# Linker flags
LDFLAGS ?= -Wl,-as-needed,-no-undefined,-z,relro,-z,now \
	-fPIE -pie -fstack-protector

LIBS ?=