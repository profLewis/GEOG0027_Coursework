####################################
# load up
####################################

library(readr)

model_data <- read_csv("model-2019.csv")

fit <- lm(du_dy ~ x1 + x2 + x3 + x4 + x5, data=model_data)

print(summary(fit))

####################################
# example with fewer parameters
####################################


# original model
fit <- lm(du_dy ~ x1 + x2 + x3 + x4 + x5, data=model_data)
model_du_dy <- predict(fit, model_data)
print(fit$call)
print(summary(fit)$adj.r.squared)

# lets try another model
fit1 <- lm(du_dy ~ x2 + x3 +  0 , data=model_data)
model_du_dy1 <- predict(fit1, model_data)
print(fit1$call)
print(summary(fit1)$adj.r.squared)

####################################
# subset validation
####################################
#########################
#
# We can take a subset of data 
# from model_data
#
#########################

# a utility function: last + first elements
last <- function(x) { tail(x, n = 1) }
first <- function(x) { head(x, n = 1) }

subber <- function(N,model_data){
    
    ystart = first(model_data$year)
    yend = last(model_data$year)
    M = yend - ystart - N
    # sub-dataset for year from ystart for count years
    train = model_data[model_data$year %in% seq(ystart,ystart+N-1),]
    test  = model_data[model_data$year %in% seq(ystart+N+1,yend),]
    #########################
    #
    # train
    #
    #########################
    fits <- lm(du_dy ~ x1 + x2 + x3 + x4 + x5,train)
    
    # or another model?
    # fits <- lm(du_dy ~  x2  ,train)

    my_list <- list('train'=train,'test'=test,'fits'=fits)
    return(my_list)
}



#####################################
# plotting
#####################################

# N needs to be *at least* the number
# of parameters + 1 and more like 2 x
# the number of parameters or more
N = 9
# get subset
sub <- subber(N,model_data)

# training
train_du_dy <- predict(sub$fits, sub$train)

# validation
test_du_dy <- predict(sub$fits, sub$test)

# max value for plotting
m = max(c(train_du_dy,test_du_dy,sub$train$du_dy,sub$test$du_dy))

# plotting in R
plot(sub$train$du_dy,train_du_dy
     ,xlim=c(0,m),ylim=c(0,m)
     ,xlab='observed du_dy / pixels',
     ,ylab='modelled du_dy / pixels') + abline(0,1,col="red")
title('Calibration and validation')
points(sub$test$du_dy,test_du_dy,col='green',pch=2)
legend(0, m*4/6, legend=c("calibration","validation"),
       col=c( "black", 'green'),pch=c(1,2))


