{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "c8dab7c3",
   "metadata": {},
   "outputs": [],
   "source": [
    "import pandas as pd\n",
    "import tensorflow as tf\n",
    "import numpy as np"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 64,
   "id": "49b0ccff",
   "metadata": {},
   "outputs": [],
   "source": [
    "# #predicting_files = tf.io.gfile.glob(\"../../mnt/c/Users/i_maa/Desktop/Thesis/Data_g/atrribute_vec?.csv\")\n",
    "# predicting_files = ['../../mnt/c/Users/i_maa/Desktop/Thesis/Data_g/atrribute_vec1.csv']\n",
    "# #print(predicting_files)\n",
    "\n",
    "# frame1= pd.read_csv(predicting_files[0],names=[\"Label\",\"Cell\",\"X\",\"Y\",\"Velocity\",\"Theta\",\"I1\",\"I2\",\"I3\"])\n",
    "# input1 = frame1[[\"X\",\"Y\",\"Velocity\",\"Theta\",\"I1\",\"I2\",\"I3\"]]\n",
    "# input_l = input1[0:1]\n",
    "    \n",
    "\n",
    "# predict = model.predict(input_l)\n",
    "# #predict = model.predict(generate_batches_g(predicting_files,batch_size))\n",
    "# predict = np.argmax(predict, axis=1)\n",
    "# print(predict)\n",
    "# #print(input_l)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 117,
   "id": "f7386e50",
   "metadata": {},
   "outputs": [],
   "source": [
    "#Lookup tables\n",
    "\n",
    "lookup_table = [0]*64\n",
    "lookup_table[6-1] = [6,15,14,13,5,None,7]\n",
    "lookup_table[13-1] = [13,14,21,12,4,5,6]\n",
    "lookup_table[15-1] = [15,16,23,14,6,7,8]\n",
    "lookup_table[23-1] = [23,24,31,22,14,15,16]\n",
    "lookup_table[24-1] = [24,None,32,31,23,16,None]\n",
    "lookup_table[32-1] = [32,None,40,39,31,24,None]"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 98,
   "id": "c7190938",
   "metadata": {
    "scrolled": false
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "1/1 [==============================] - 0s 44ms/step\n",
      "[6]\n",
      "1/1 [==============================] - 0s 16ms/step\n",
      "[0]\n",
      "1/1 [==============================] - 0s 17ms/step\n",
      "[1]\n",
      "1/1 [==============================] - 0s 17ms/step\n",
      "[0]\n",
      "1/1 [==============================] - 0s 17ms/step\n",
      "[0]\n",
      "1/1 [==============================] - 0s 17ms/step\n",
      "[2]\n",
      "1/1 [==============================] - 0s 17ms/step\n",
      "[0]\n",
      "1/1 [==============================] - 0s 17ms/step\n",
      "[1]\n",
      "1/1 [==============================] - 0s 17ms/step\n",
      "[0]\n",
      "1/1 [==============================] - 0s 17ms/step\n",
      "[2]\n",
      "1/1 [==============================] - 0s 18ms/step\n",
      "[0]\n"
     ]
    }
   ],
   "source": [
    "prob_matrix = [0]*64\n",
    "model = tf.keras.models.load_model('G')\n",
    "frame= pd.read_csv(predicting_files[0],names=[\"Label\",\"Cell\",\"X\",\"Y\",\"Velocity\",\"Theta\",\"I1\",\"I2\",\"I3\"])\n",
    "input = frame[[\"X\",\"Y\",\"Velocity\",\"Theta\",\"I1\",\"I2\",\"I3\"]]\n",
    "cells = frame[\"Cell\"]\n",
    "prob_matrix[cells[0]] = 1\n",
    "\n",
    "for cell in np.nonzero(prob_matrix):\n",
    "    transition_matrix = [0]*7\n",
    "    prob_matrix1 = [0]*64\n",
    "    for row in range(0,input.shape[0]):\n",
    "        predict = model.predict(input.iloc[row:row+1])\n",
    "        #predict = np.argmax(predict, axis=1)\n",
    "        #print(predict)\n",
    "        for p in range (0,predict.shape[1]):\n",
    "            cell_to_alter = lookup_table[cell][p]\n",
    "            prob_matrix1[cell_to_alter-1] = prob_matrix1[cell_to_alter-1] + prob_matrix[cell_to_alter-1]*predict[p]\n",
    "        "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 119,
   "id": "6c62d1ec",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[12]\n"
     ]
    }
   ],
   "source": [
    "prob_matrix = [0]*64\n",
    "prob_matrix[cells[0]-1]=1\n",
    "\n",
    "for cell in np.nonzero(prob_matrix):\n",
    "    print (cell)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 116,
   "id": "bdf99e46",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[15, 14, 13, 5, None, 7]\n"
     ]
    }
   ],
   "source": [
    "\n",
    "print(lookup_table[5])"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "8e2e7319",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.8.10"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
