#  bootimg_size.py
#  
#  Copyright 2015 gromikakao@github a.k.a. ShadySquirrel@XDA
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  
import sys
import math

sizes=sys.argv
total = len(sizes)

if total != 5:
	print("Invalid number of arguments passed! I need four arguments, not more, not less in this order: kernel_size ramdisk_size second_size page_size")
else:
	kernel_size = float(sizes[1])
	ramdisk_size = float(sizes[2])
	second_size = float(sizes[3])
	page_size = float(sizes[4])
		
	n=(kernel_size+page_size-1)/page_size
	n1=math.floor(n)
	
	m=(ramdisk_size+page_size-1)/page_size
	m1=math.floor(m)
	
	o=0
	if second_size > 0:
		o = (second_size+page_size-1)/page_size
	
	o1=math.floor(o)
	
	total_size = int((1+m1+n1+o1)*page_size)
	
	print(total_size)
