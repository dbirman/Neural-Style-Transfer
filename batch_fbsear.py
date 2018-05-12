import os
import subprocess

ipath = "images/fbsear/objects"
opath  = "images/fbsear/objects/out"

d = ipath
dirs = [o for o in os.listdir(d) if ("out" not in o) and os.path.isdir(os.path.join(d,o))]

front_call = "sbatch -p hns --gres gpu:1 --mem=5000 --time=00:30:00 --wrap=\"module load py-tensorflow; module load py-scipystack; cd $HOME/Neural-Style-Transfer; "

dirs = dirs[0:2]
print(dirs)

for content in dirs:
	for style in dirs:
		if style != content: 
			for ci in [1]:
				for si in [1]:
			# for ci in range(1,5):
				# for si in range(1,5):
					content_image = os.path.join(ipath,content,str(ci)+".jpg")
					style_image = os.path.join(ipath,style,str(si)+".jpg")

					# check folder
					ofolder = os.path.join(opath,style+content)
					if not os.path.exists(ofolder):
						os.makedirs(ofolder)

					opfx = os.path.join(ofolder,str(si)+str(ci))

					# create call
					call = "python ~/proj/Neural-Style-Transfer/inetwork.py " \
						"\'./" + content_image + "\' " \
						"\'./" + style_image + "\' " \
						"\'./" + opfx + "\' " \
						"\""

					totalcall = front_call+call

					print('*********************************')
					print('* creating call for: ************')
					print('*********************************')
					print(totalcall)
					print('*********************************')
					# subprocess.call(call,shell=True)
					os.system(call)
					print('*********************************')
