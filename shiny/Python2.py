import pandas as pd
# import matplotlib.pyplot as plt
# import seaborn as sns
import numpy as np
# import copy
# from scipy.stats import norm
# from sklearn import preprocessing


fileName = '/home/kazim/Desktop/projects/IE490/input/tubitak_data2_processesed2.csv'
df = pd.read_csv(fileName,  sep = ',')

#preview data
df_prev = df

### Ilce 79

# df.drop(df.index[df.ilce_kod != 79], inplace=True)
# # df
# df.drop('ilce_kod', axis=1, inplace=True)
# 
# df.info()

mahalle = df["mahalle_kod"]
ilce = df["ilce_kod"]

# df['mahalle_kod'].describe()

#we can drop yasal burut alani as it has almost 1 correlation with mevcut alan
df = df.drop('yasal_burut_alani', axis=1)

# df_pre = copy.deepcopy(df)
### One Hot Encoding for Categorical Variables

df = pd.get_dummies(df, columns=["ilce_kod"])
df = pd.get_dummies(df, columns=["mahalle_kod"])

# df.head()

# df.shape

# Model Training and Evaulation
#
# 1. Random Forest

from sklearn.ensemble import RandomForestRegressor

X = df.drop('adil_piyasa_degeri_yasal_durum', axis=1)
y = df['adil_piyasa_degeri_yasal_durum']

RANDOM_STATE = 42

# regr = RandomForestRegressor(bootstrap=True,
#                              oob_score=True,
#                             #  max_depth=10,
#                             #  max_features=5,
#                              min_samples_leaf = 5,
#                              min_samples_split = 5,
#                              n_estimators = 500,
#                              random_state=RANDOM_STATE)
# rf = regr.fit(X, y)

from sklearn.externals import joblib
# joblib.dump(rf, 'trainedRF.pkl') 

# Later you can load back the pickled model (possibly in another Python process) with:

rf = joblib.load('trainedRF.pkl') 

preds = rf.oob_prediction_

df['prediction'] = preds
df['error'] = np.abs(df['adil_piyasa_degeri_yasal_durum'] -
                     df['prediction'])/df['adil_piyasa_degeri_yasal_durum']

# oob_error = 1 - rf.oob_score_

# print("oob error: %0.2f" % oob_error)
# # print(":",regr.oob_score_)# print(":",regr.oob_score_)
# print("R^2: %0.2f" % rf.score(X, y, sample_weight=None))
# print("20% error quantile: {0:.3f}".format(
#     ((df[df.error <= 0.2].shape[0])/df.shape[0])))

# print(rf.predict(X.head(1)), y.head(1))
