import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from pathlib import Path
from PIL import Image
import glob

t = np.arange(0.0, 360)
print("Inserting FVN to Dataset\n")

for x in range(0, 7129):
    path = ('E:/Tugas Akhir/Dataset Fix/FVN+/%d.txt' % x)
    f = open(path, 'r')
    x1 = []
    for i in f:
        x1.append(i)
    x1 = list(map(lambda x: x.strip(), x1))
    x1 = list(map(float, x1))
    plt.axis('off')
    plt.plot(t, x1)

    if x < 713:
        plt.savefig('E:/Tugas Akhir/Dataset Baru/7129/Image/Testing/FVN/%d.png' %
                    x, dpi=70, bbox_inches='tight', pad_inches=0)
    else:
        # plt.savefig('E:/Tugas Akhir/Dataset Baru/7129/Image/Training/Normal/%d.png' %
        #             x, dpi=70, bbox_inches='tight', pad_inches=0)
        break
    plt.close()
    f.close()
print("DONE")
