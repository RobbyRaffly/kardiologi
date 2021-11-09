import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from pathlib import Path
from PIL import Image
import glob

NFFT = 64  # the length of the windowing segments
Fs = 360  # the sampling frequency
noverlap = 32
t = np.arange(0.0, 360)

print("Inserting PVC to Dataset\n")

for x in range(7129):
    path = ('E:/Tugas Akhir/Dataset Fix/PVC/%d.txt' % x)
    file = Path(path)
    if file.is_file():

        print(x)
        f = open(path, 'r')
        x1 = []
        for i in f:
            x1.append(i)
        x1 = list(map(lambda x: x.strip(), x1))
        x1 = list(map(float, x1))
        plt.axis('tight')
        plt.axis('off')
        Pxx, freqs, bins, im = plt.specgram(
            x1, NFFT=NFFT, Fs=Fs, noverlap=noverlap)
        if x < 722:
            plt.savefig('E:/Tugas Akhir/Dataset Baru/7129/64-32/Testing/PVC/%d.png' %
                        x, dpi=70, bbox_inches='tight', pad_inches=0)
        else:
            plt.savefig('E:/Tugas Akhir/Dataset Baru/7129/64-32/Training/PVC/%d.png' %
                        x, dpi=70, bbox_inches='tight', pad_inches=0)
        plt.close()
        f.close()
print("DONE")
