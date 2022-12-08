# $@ = target file
# $< = first dependency
# $^ = all dependencies

# First rule is the one executed when no parameters are fed to the Makefile
all: run

kernelEntry.obj: kernelEntry.asm
	nasm $< -f elf -o $@

kernel.obj: kernel.c
	gcc -o3 -ffreestanding -c $< -o $@

boot.bin: boot.asm
	nasm $< -f bin -o $@
	
kernel.bin: kernelEntry.obj kernel.obj
	link $^ > $@

os_image.bin: boot.bin kernel.bin
	type $^ > $@

run: os_image.bin
	qemu\qemu-system-x86_64 $<

clean:
	$(RM) *.bin *.obj