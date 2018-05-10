library(reticulate)
# os <- import("os")
# os$listdir(".")

# source_python('Python2.py')

# (ilces <- ilce %>% unique() %>% as.character())
# (mahalles <- mahalle%>% unique()) %>% as.character()

#working on ilcekods
ilcekods <- rep(0,18)
x=names(df)[7:(7+17)]
sub('.*-([0-9]+).*','\\1',x)
m <- gregexpr('[0-9]+',x)
names(ilcekods) <- regmatches(x,m)

#working on mahallekods
mahallekods <- rep(0,302)
x=names(df)[25:(25+301)]
sub('.*-([0-9]+).*','\\1',x)
m <- gregexpr('[0-9]+',x)
names(mahallekods) <- regmatches(x,m)

ilcekods[as.character(73)] <- 1
mahallekods[as.character(4036)] <- 1


arr <- np_array(c(1,1,1,1,1,
                  ilcekods,
                  mahallekods), order = "C")

test.data <- array_reshape(arr, c(1,length(arr)))

prediction <- rf$predict(test.data)

prediction
# test_data <- r_to_py(X[1,])
# rf$predict(test_data)

# arr <- np_array(c(1,875,125,4,60,4,1,0), dtype = NULL, order = "C")
# test.data <- array_reshape(arr, c(1,8))
# 
# rf$predict(test.data)
# 
# head(X)
# head(df)
library(magrittr)

list(`districts`=df_prev %>% group_by(ilce_kod) %>% 
       filter(ilce_kod==88) %>% select(mahalle_kod) %>% 
       as.data.frame() %>% extract2('mahalle_kod') %>% 
       unique() %>% as.character())

