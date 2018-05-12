import os
import subprocess

ipath = "images/fbsear/"
opath  = "images/fbsear/out"

cats = ["banana","cat","doge","leek"]

for content in cats:
	for style in cats:
		if style != content: 
			for ci in range(1,5):
				for si in range(1,5):
					content_image = os.path.join(ipath,content,str(ci)+".jpg")
					style_image = os.path.join(ipath,style,str(si)+".jpg")

					# check folder
					ofolder = os.path.join(opath,content+"_"+style)
					if not os.path.exists(ofolder):
						os.makedirs(ofolder)

					opfx = os.path.join(ofolder,str(ci)+"_"+str(si))

					# create call
					call = "python ~/proj/Neural-Style-Transfer/inetwork.py " \
						"\"./" + content_image + "\" " \
						"\"./" + style_image + "\" " \
						"\"./" + opfx + "\" " \
						""

					print(call)
					subprocess.call(call,shell=True)
					# os.system(call)
