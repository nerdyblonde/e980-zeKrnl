#  update_script_gen.py
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
import datetime
import os

# get current path, because reasons.
scriptPath = str(os.path.dirname(os.path.abspath(__file__)))
# Set template filename
templateFileName =  scriptPath+"/updater-script.template"
print("Using template from ", templateFileName)

# 'tags' to hunt
tagDate='%%BUILD_DATE%%'
tagTime='%%BUILD_TIME%%'
tagVersion='%%VERSION%%'
tagBranch='%%BRANCH%%'
tagNumber='%%BUILD_NO%%'


# get values from build_me.sh
informations=sys.argv
total_ins = len(informations)
if total_ins < 7:
	# Not enough data. I don't want to fail & I don't want to do builder's dirty work THAT much.
	print("Missing data...")
	print("Please input in following order: build_date build_time build_no version branch path_to_save_updater-script")
	print("Given data:")
	for i in informations:
		print(" - ", i)
		
	exit(1)
else:
	# All fine, put input into responding fields
	buildDate = informations[1]
	buildTime = informations[2]
	buildNo = informations[3]
	version = informations[4].replace("-","",1)
	branch = informations[5]
	path = informations[6]
	
	# Load updater-script.template
	tmpFile = open(templateFileName,"r")
	lines = tmpFile.readlines()
	# Create new file
	newFile = open(path,"w")
	
	try:
		for line in lines:
			newline = str(line)

			# Replace needed strings...
			newline = newline.replace(tagDate,buildDate)
			newline = newline.replace(tagTime, buildTime)
			newline = newline.replace(tagVersion, version)
			newline = newline.replace(tagBranch, branch)
			newline = newline.replace(tagNumber, buildNo)

			# Write to new config...
			newFile.write(newline)
		
		# Make sure newFile has empty row
		#newFile.write(" ");
		
		# Close files
		newFile.close()
		tmpFile.close()
	except e:
		z = e
		print(z)
	
	exit(0)
		
