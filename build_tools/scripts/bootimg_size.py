import sys
import math

sizes=sys.argv
total = len(sizes)
#print("got %d sizes" % total)

if total != 5:
	print("Invalid number of arguments passed! I need four arguments, not more, not less in this order: kernel_size ramdisk_size second_size page_size")
else:
	kernel_size = float(sizes[1])
	ramdisk_size = float(sizes[2])
	second_size = float(sizes[3])
	page_size = float(sizes[4])
	
	#print("Sizes loaded:")
	#print("Kernel size: {} bytes; ramdisk size: {} bytes; second size: {} bytes; page size: {} bytes".format(kernel_size, ramdisk_size, second_size, page_size))
	
	#print("++ calculating boot.img size")
	
	n=(kernel_size+page_size-1)/page_size
	n1=math.floor(n)
	#print(n1)
	m=(ramdisk_size+page_size-1)/page_size
	m1=math.floor(m)
	#print(m1)
	o=0
	if second_size > 0:
		o = (second_size+page_size-1)/page_size
	
	o1=math.floor(o)
	#print(o1)
	total_size = int((1+m1+n1+o1)*page_size)
	
	print(total_size)
