import pandas as pd
from pathlib import Path
import cv2

n = 0
r = 0
l = 0
fvn = 0
v = 0
for z in range(400):
    pathAnno = ('C:/Users/firda/OneDrive - Institut Teknologi Sepuluh Nopember/Tugas Akhir/Data ECG/MIT-BIH annotations/annotations%d.csv' % z)
    pathECG = ('C:/Users/firda/OneDrive - Institut Teknologi Sepuluh Nopember/Tugas Akhir/Data ECG/MIT-BIH csv to end/ecg%d.csv' % z)

    file = Path(pathAnno)
    if file.is_file():
        y = 0
        print("Reading ECG-%d" % z)
        anotasi = pd.read_csv(pathAnno, sep=';')
        npanotasi = anotasi.values
        sample = npanotasi[:, 1]
        tipe = npanotasi[:, 2]
        data = pd.read_csv(pathECG, sep=';')
        npdata = data.values
        ecg = npdata[:, 1]

        for x in tipe:
            if x == "N":
                tengah = sample[y]
                awal = tengah-180
                if (awal >= 0) and (int(sample[y]+180) < len(ecg)):
                    f = open(
                        "E:/Tugas Akhir/Dataset Fix/Normal/%d.txt" % n, "w")
                    for i in ecg:
                        if awal == tengah+180:
                            break
                        f.write("%s\n" % str(ecg[awal]))
                        awal += 1
                    f.close()
                    n += 1
            if x == "R":
                tengah = sample[y]
                awal = tengah-180
                if (awal >= 0) and (int(sample[y]+180) < len(ecg)):
                    f = open(
                        "E:/Tugas Akhir/Dataset Fix/RBBB/%d.txt" % r, "w")
                    for i in ecg:
                        if awal == tengah+180:
                            break
                        f.write("%s\n" % str(ecg[awal]))
                        awal += 1
                    f.close()
                    r += 1
            if x == "L":
                tengah = sample[y]
                awal = tengah-180
                if (awal >= 0) and (int(sample[y]+180) < len(ecg)):
                    f = open(
                        "E:/Tugas Akhir/Dataset Fix/LBBB/%d.txt" % l, "w")
                    for i in ecg:
                        if awal == tengah+180:
                            break
                        f.write("%s\n" % str(ecg[awal]))
                        awal += 1
                    f.close()
                    l += 1
            if x == "V":
                tengah = sample[y]
                awal = tengah-180
                if (awal >= 0) and (int(sample[y]+180) < len(ecg)):
                    f = open(
                        "E:/Tugas Akhir/Dataset Fix/PVC/%d.txt" % v, "w")
                    for i in ecg:
                        if awal == tengah+180:
                            break
                        f.write("%s\n" % str(ecg[awal]))
                        awal += 1
                    f.close()
                    v += 1
            if x == "F":
                tengah = sample[y]
                awal = tengah-180
                if (awal >= 0) and (int(sample[y]+180) < len(ecg)):
                    f = open(
                        "E:/Tugas Akhir/Dataset Fix/FVN/%d.txt" % fvn, "w")
                    for i in ecg:
                        if awal == tengah+180:
                            break
                        f.write("%s\n" % str(ecg[awal]))
                        awal += 1
                    f.close()
                    fvn += 1
            y += 1
print("DONE")
