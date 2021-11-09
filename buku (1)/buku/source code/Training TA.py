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
config = tf.compat.v1.ConfigProto(gpu_options=tf.compat.v1.GPUOptions(
    per_process_gpu_memory_fraction=0.8)
    # device_count = {'GPU': 1}
)
config.gpu_options.allow_growth = True
session = tf.compat.v1.Session(config=config)
tf.compat.v1.keras.backend.set_session(session)

normal = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-32/Training/Normal/*.png', recursive=True)
rbbb = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-32/Training/RBBB/*.png', recursive=True)
lbbb = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-32/Training/LBBB/*.png', recursive=True)
fvn = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-32/Training/FVN/*.png', recursive=True)
pvc = glob.glob(
    'E:/Tugas Akhir/Dataset Baru/7129/64-32/Training/PVC/*.png', recursive=True)

train_x = []
train_y = []

print("Inserting N to Train Set")
for x in normal:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    train_x.append(gambar)
    train_y.append(0)

print("Inserting R to Train Set")
for x in rbbb:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    train_x.append(gambar)
    train_y.append(1)

print("Inserting L to Train Set")
for x in lbbb:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    train_x.append(gambar)
    train_y.append(2)

print("Inserting F to Train Set")
for x in fvn:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    train_x.append(gambar)
    train_y.append(3)

print("Inserting V to Train Set")
for x in pvc:
    gambar = imread(x)
    gambar = cv2.cvtColor(gambar, cv2.COLOR_RGBA2RGB)
    train_x.append(gambar)
    train_y.append(4)

train_y = np.array(train_y)
train_y = to_categorical(train_y)
train_x = np.array(train_x)

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
fc_layer = Dense(512, activation='relu')(flatten)
fc_layer = Dense(256, activation='relu')(fc_layer)
fc_layer = Dense(128, activation='relu')(fc_layer)
fc_layer = Dense(64, activation='relu')(fc_layer)
fc_layer = Dense(32, activation='relu')(fc_layer)
fc_layer = Dense(16, activation='relu')(fc_layer)
fc_layer = Dense(8, activation='relu')(fc_layer)
outputs = Dense(5, activation='softmax')(fc_layer)

model = Model(inputs=inputs, outputs=outputs)

# Adam Optimizer and Cross Entropy Loss
adam = Adam(lr=0.0001)
model.compile(optimizer=adam, loss='categorical_crossentropy',
              metrics=['accuracy'])

# Print Model Summary
print(model.summary())

# Use TensorBoard
callbacks = TensorBoard(log_dir='D:\Graph7129-64-32Baru')

# Train for 100 Epochs and use TensorBoard Callback
model.fit(train_x, train_y, batch_size=80,
          epochs=100, verbose=1, validation_split=0.10, callbacks=[callbacks])

# Save Weights
model.save_weights('weight7129-64-32Baru.h5')
