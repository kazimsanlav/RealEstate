
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

fileName = '/home/kazim/Desktop/projects/IE490/input/tubitak_data2_processesed2_outlier.csv'
df = pd.read_csv(fileName,  sep = ',')

#preview data
# df.head()

# Model Training and Evaulation
# 
# 1. Random Forest

from sklearn.ensemble import RandomForestRegressor

X = df.drop('adil_piyasa_degeri_yasal_durum',axis=1)
y = df['adil_piyasa_degeri_yasal_durum']

RANDOM_STATE = 42

regr = RandomForestRegressor(bootstrap=True,
                             oob_score=True,
                             max_depth= 10,
                             max_features= 5,
                             min_samples_leaf= 1,
                             min_samples_split= 4,
                             n_estimators= 400,
                             random_state = RANDOM_STATE)
rf = regr.fit(X, y)
preds = rf.oob_prediction_
    
df['prediction'] = preds
df['error'] = np.abs(df['adil_piyasa_degeri_yasal_durum']-df['prediction'])/df['adil_piyasa_degeri_yasal_durum']

oob_error = 1 - rf.oob_score_

print("oob error: %0.2f" % oob_error)
print("R^2: %0.2f" % rf.score(X, y, sample_weight=None))# print(":",regr.oob_score_)# print(":",regr.oob_score_)
print("20% error quantile: {0:.3f}".format(((df[df.error<=0.2].shape[0])/df.shape[0]))) 

print(rf.predict(X.head(1)),y.head(1))

