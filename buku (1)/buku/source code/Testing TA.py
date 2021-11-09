import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import tensorflow as tf
import cv2
from tensorflow.keras.models import Model
from tensorflow.keras.layers import Input, Activation, Dense, Conv2D, MaxPooling2D, ZeroPadding2D, Flatten
from keras.utils.np_utils import to_categorical
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import TensorBoard
import PIL.Image
import glob
from skimage.io import imread
import skimage
import scipy
import time
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report
from sklearn.utils.multiclass import unique_labels
start_time = time.time()
config = tf.compat.v1.ConfigProto(gpu_options=tf.compat.v1.GPUOptions(
    per_process_gpu_memory_fraction=0.8)
    # device_count = {'GPU': 1}
)
config.gpu_options.allow_growth = True
session = tf.compat.v1.Session(config=config)
tf.compat.v1.keras.backend.set_session(session)


def plot_confusion_matrix(y_true, y_pred, classes,
                          normalize=False,
                          title=None,
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    if not title:
        if normalize:
            title = 'Normalized confusion matrix'
        else:
            title = 'Confusion matrix, without normalization'

    # Compute confusion matrix
    cm = confusion_matrix(y_true, y_pred)
    # Only use the labels that appear in the data
    classes = classes[unique_labels(y_true, y_pred)]
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    fig, ax = plt.subplots()
    im = ax.imshow(cm, interpolation='nearest', cmap=cmap)
    ax.figure.colorbar(im, ax=ax)
    # We want to show all ticks...
    ax.set(xticks=np.arange(cm.shape[1]),
           yticks=np.arange(cm.shape[0]),
           # ... and label them with the respective list entries
           xticklabels=classes, yticklabels=classes,
           title=title,
           ylabel='True label',
           xlabel='Predicted label')

    # Rotate the tick labels and set their alignment.
    plt.setp(ax.get_xticklabels(), rotation=45, ha="right",
             rotation_mode="anchor")

    # Loop over data dimensions and create text annotations.
    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i in range(cm.shape[0]):
        for j in range(cm.shape[1]):
            ax.text(j, i, format(cm[i, j], fmt),
                    ha="center", va="center",
                    color="white" if cm[i, j] > thresh else "black")
    fig.tight_layout()
    return ax


normal = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-60/Testing/Normal/*.png', recursive=True)
rbbb = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-60/Testing/RBBB/*.png', recursive=True)
lbbb = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-60/Testing/LBBB/*.png', recursive=True)
fvn = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-60/Testing/FVN/*.png', recursive=True)
pvc = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-60/Testing/PVC/*.png', recursive=True)

test_x = []
test_y = []
print("Inserting N to test")
for x in normal:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    test_x.append(gambar)
    test_y.append(0)


print("Inserting R to test")
for x in rbbb:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    test_x.append(gambar)
    test_y.append(1)


print("Inserting L to test")
for x in lbbb:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    test_x.append(gambar)
    test_y.append(2)


print("Inserting F to test")
for x in fvn:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    test_x.append(gambar)
    test_y.append(3)

print("Inserting V to test")
for x in pvc:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    test_x.append(gambar)
    test_y.append(4)

test_y = np.array(test_y)
test_x = np.array(test_x)

print("DONE")

inputs = Input(shape=(258, 347, 3))
conv_layer = ZeroPadding2D(padding=(2, 2))(inputs)

conv_layer = Conv2D(16, (5, 5), strides=(1, 1), activation='relu')(conv_layer)
conv_layer = MaxPooling2D((2, 2))(conv_layer)

conv_layer = Conv2D(32, (3, 3), strides=(1, 1), activation='relu')(conv_layer)
conv_layer = MaxPooling2D((2, 2))(conv_layer)

conv_layer = Conv2D(32, (3, 3), strides=(1, 1), activation='relu')(conv_layer)
conv_layer = Conv2D(32, (3, 3), strides=(1, 1), activation='relu')(conv_layer)
conv_layer = MaxPooling2D((2, 2))(conv_layer)

conv_layer = Conv2D(32, (3, 3), strides=(1, 1), activation='relu')(conv_layer)
conv_layer = Conv2D(32, (3, 3), strides=(1, 1), activation='relu')(conv_layer)
conv_layer = MaxPooling2D((2, 2))(conv_layer)

conv_layer = Conv2D(64, (3, 3), strides=(1, 1), activation='relu')(conv_layer)
conv_layer = Conv2D(64, (3, 3), strides=(1, 1), activation='relu')(conv_layer)
conv_layer = MaxPooling2D((2, 2))(conv_layer)

# Flatten feature map to Vector with 576 element.
flatten = Flatten()(conv_layer)

# Fully Connected Layer
fc_layer = Dense(1024, activation='relu')(flatten)
fc_layer = Dense(2048, activation='relu')(fc_layer)
outputs = Dense(5, activation='softmax')(fc_layer)

model = Model(inputs=inputs, outputs=outputs)

# Adam Optimizer and Cross Entropy Loss
adam = Adam(lr=0.00025)
model.compile(optimizer=adam, loss='categorical_crossentropy',
              metrics=['accuracy'])

# Print Model Summary
print(model.summary())

model.load_weights(
    'C:/Users/firda/OneDrive - Institut Teknologi Sepuluh Nopember/Tugas Akhir/weight rev 7129 64-60.h5')
predict = model.predict(test_x)
indexes = tf.argmax(predict, axis=1)
indexes = np.array(indexes)
print(indexes)
print(test_y)
class_name = ['NOR', 'RBBB', 'LBBB', 'FVN', 'PVC']
class_name = np.array(class_name)
print("--- %s seconds ---" % (time.time() - start_time))
plot_confusion_matrix(test_y, indexes, classes=class_name, normalize=False)
plt.show()
print(classification_report(test_y, indexes,
                            labels=[0, 1, 2, 3, 4]))
