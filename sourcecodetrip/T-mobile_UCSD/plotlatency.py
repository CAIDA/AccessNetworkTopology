import matplotlib.pyplot as plt
plt.style.use('seaborn-whitegrid')
import matplotlib.dates as md
import dateutil
import numpy as np
import datetime

X = []
Y = []
index = 0
colorset = ['black','red','bisque','maroon','blue','yellow','orange','green','plum','crimson','lime','skyblue','hotpink','darkmagenta','olive','peru','palegreen','y','darkblue','navy','darkcyan','seagreen','teal','maroon','firebrick','c','violet','m','fuchsia','thistle','steelblue','springgreen']
gap = 0.0
filename = "Latency_T-mobile_ucsd_back.txt"
with open(filename) as f:
	latency = f.readlines()
# Xrange = []
# timeY = []
num = 0
# color = 7900
for line in latency:
	# if num<2:
	# 	x,y,z,n = line.split(' ')
	# 	# numy = float(y)
	# 	time = datetime.datetime.strptime(z, "%H:%M:%S").time()
	# 	# print(time)
	# 	# Y.append(numy)
	# 	Xrange.append(z)
	# 	numy = float(y)
	# 	timeY.append(numy)
	# 	# print(z)
	# 	num = num+1
	# else:
		# if num == 2:
		# 	timexrange = [datetime.datetime.strptime(d, "%H:%M:%S") for d in Xrange]
	if line[0] == '\n':
		# color = color+100
		# strcolor = '#00'+str(color)
		# trycolor = '#008000'
		xs = [datetime.datetime.strptime(d, "%H:%M:%S") for d in X]
		# xsnew = np.linspace(min(xs),max(xs),300)
		# Y_smooth = spline(xs,Y,xsnew)
		print(x)
		plt.plot(xs,Y,".",color=colorset[index],label=x)
		# plt.plot(timexrange,timeY,"o",color = "white")
		plt.xlabel('record_time')
		plt.ylabel('latency')
		# gap = (max(Y) + 1 - min(Y))/10
		# plt.xticks(min(timexrange),max(timexrange),6)
		plt.yticks(np.arange(0, max(Y)+10, 10.0))
		# plt.ylim(0,150)
		plt.legend()
		plt.show()
		# plt.yticks(np.arange(, 1.0))
		# print(X)
		# print(Y)
		# print(min(Y))
		# print(max(Y))
		X = []
		Y = []
		print(colorset[index])

		index = index+1
		continue
	else:
		x,y,z,n = line.split(' ')
		# print(x)
		# print(y)
		# print(z)
		numy = float(y)
		time = datetime.datetime.strptime(z, "%H:%M:%S").time()
		# print(time)
		Y.append(numy)
		X.append(z)


	# values = [float(s) for s in line.split()]