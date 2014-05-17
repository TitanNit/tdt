KERNEL_DIR=../linux-sh4
BASE_DIR=..
TFINSTALLER_DIR=.
all:	
	cp $(KERNEL_DIR)/arch/sh/boot/uImage.gz $(TFINSTALLER_DIR)/uImage.gz.org
	cp $(TFINSTALLER_DIR)/initramfs_list $(KERNEL_DIR)/initramfs_list
	cp $(KERNEL_DIR)/.config $(TFINSTALLER_DIR)/.config.org
	sed -i 's/CONFIG_INITRAMFS_SOURCE=""/CONFIG_INITRAMFS_SOURCE="initramfs_list"/g' $(KERNEL_DIR)/.config && \
		echo "CONFIG_INITRAMFS_ROOT_UID=0" >> $(KERNEL_DIR)/.config && \
		echo "CONFIG_INITRAMFS_ROOT_GID=0" >> $(KERNEL_DIR)/.config && \
		echo "# CONFIG_INITRAMFS_COMPRESSION_NONE is not set" >> $(KERNEL_DIR)/.config && \
		echo "CONFIG_INITRAMFS_COMPRESSION_GZIP=y" >> $(KERNEL_DIR)/.config
	@export PATH=$(hostprefix)/bin:$(PATH) && \
	$(MAKE) -C $(BASE_DIR) tfkernel.do_compile
	rm $(KERNEL_DIR)/initramfs_list
	rm $(KERNEL_DIR)/.config
	mv $(TFINSTALLER_DIR)/.config.org $(KERNEL_DIR)/.config
	mv $(KERNEL_DIR)/arch/sh/boot/uImage.gz $(TFINSTALLER_DIR)/uImage
	mv $(TFINSTALLER_DIR)/uImage.gz.org $(KERNEL_DIR)/arch/sh/boot/uImage.gz


TFP_OBJS = io.o encode.o decode.o maketree.o maketbl.o huf.o

tfpacker: $(TFP_OBJS)
	gcc -o $@ $(TFP_OBJS)

clean:
	rm -f $(TFP_OBJS)
	rm -f uImage

.c.o:
	gcc -c $< -Wall

$(TFP_OBJS): ar.h

