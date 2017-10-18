import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
import scipy.io as sio

n_clusters = 4

f_bar = sio.loadmat("f_bar.mat")
f_max = sio.loadmat("f_max.mat")

f_bar = f_bar['f_bar']
f_max = f_max['tmp_max']

data = np.concatenate((f_max, f_bar), axis=1)

plt.figure(1)
plt.clf()
plt.scatter(data[:,0], data[:,1], marker="+")

kmeans = KMeans(init='k-means++', n_clusters=n_clusters, n_init=10)
labels = kmeans.fit_predict(data)

f = plt.figure(2)
plt.clf()
color = np.array(["g", "r", "b", "c", "m"])
plt.scatter(data[:, 0], data[:, 1], marker="+", c=color[labels])

centroids = kmeans.cluster_centers_
plt.scatter(centroids[:, 0], centroids[:, 1], marker='x', c="black")
plt.title('K-means clustering')
#plt.xlim(x_min, x_max)
#plt.ylim(y_min, y_max)
plt.xticks(())
plt.yticks(())
plt.savefig("fig.png")

































