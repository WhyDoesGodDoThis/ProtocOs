# $@ = target file
# $< = first dependency
# $^ = all dependencies

# First rule is the one executed when no parameters are fed to the Makefile
all: run

kernelEntry.obj: src\main\kernelEntry.asm
	nasm $< -f elf -o $@

kernel.obj: src\main\kernel.c
	gcc -o3 -ffreestanding -c $< -o $@

boot.bin: src\main\boot.asm
	nasm $< -f bin -o $@
	
kernel.bin: kernelEntry.obj kernel.obj
	link $^ > $@

os-image.os: boot.bin kernel.bin
	type $^ > $@

run: os-image.os
	qemu/qemu-system-x86_64 $<

clean:
	$(RM) *.bin *.obj