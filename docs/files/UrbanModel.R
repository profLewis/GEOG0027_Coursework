############################
# First, change directory to where
# your (csv) files are 
############################

# change working directory to
# where our files are
#
# Be careful with the setwd command
# and check where you are first
print('I am in:')
print(getwd())

# test for this file
test = "Guangdong-Yearbook-2019.csv"

# somewhere else it might be
# if its not here 
# (put something appropriate!!)
sub = 'files'

if (test %in% list.files('.','*.csv')){
    print(paste('found',test))
}else if (test %in% list.files(sub,'*.csv')){
    print(paste('found',test,'in',sub))
    
    setwd(sub)
    
    print('I have moved to:')
    print(getwd())
}


#########################################################



# The name of the file with year, urban_land and possibly agr_land
result_file <- 'results-2019.csv'
# the name of the supplied data file with Guandong stats
stats_file  <- "Guangdong-Yearbook-2019.csv"


# load library
library(readr)

# read the datasets
Guangdong_Yearbook_2019 <- read_csv(stats_file)
input                   <- read_csv(result_file)

# fix the input dataset in case arg_land doesnt exist
if('agr_land' %in% names(input)){
    print(paste('using agricultural land data from',results))
}else{
    # If no ag land variable, insert one
    print('inserting synthetic agricultural land data')
    input$agr_land = 2 * max(input$urban_land) - input$urban_land
}

# The years in Guangdong_Yearbook_2019$year and 
# input$year need to match
# so we force this with the match function in R
overlap <- match(Guangdong_Yearbook_2019$year,input$year,nomatch=0)
input <- input[overlap,]
Guangdong_Yearbook_2019 <- Guangdong_Yearbook_2019[overlap,]

# print the datasets to visualise and check it looks ok
print(input)
print(Guangdong_Yearbook_2019)

################################################################


X = data.frame(year=Guangdong_Yearbook_2019$year,
               x1=Guangdong_Yearbook_2019$investment/Guangdong_Yearbook_2019$population,
               x2=Guangdong_Yearbook_2019$agr_output/Guangdong_Yearbook_2019$agr_pop,
               x3=log(Guangdong_Yearbook_2019$private_wage),
               x4=log(Guangdong_Yearbook_2019$avg_wage),
               x5=(Guangdong_Yearbook_2019$agr_output/input$agr_land)/
                  (Guangdong_Yearbook_2019$indust_output/input$urban_land))


################################################################

############################
#
# 4th, our model needs the change in urban area
# with resect to year, which we might call du_dy
#
# to get this, we need to calculate du and dy
# i.e. the change ('delta') in urban area and year
# 
# We will pack all of these datasets into a dataframe
# called model_data
#
############################

# Calculate the delta in year for observation data
# This will mostly be 1, but could be more
# if you have missing years
dy <- diff(input$year,differences = 1) 

# Calculate the delta in urban land for observation data
du <-  diff(input$urban_land,differences = 1)

# The rate of change of urban land per year
du_dy =  du / dy

# reconstruct the observation year
# from the cumulative sum of dyear
# This should give a 'year' dataset
# with one fewer entry
obs_year <- data.frame(year=input$year[c(1)] + cumsum(dy))

# Now select all columns of X that match obs_year
# and call it model_data
overlap <- match(input$year,obs_year$year,nomatch=0)
model_data <- X[overlap,]

# and add in du_dy and dy to dataset
model_data$du_dy <- du_dy
model_data$dyear <- dy
model_data$urban_land <- input$urban_land[overlap]

# save this file
write.csv(model_data, file = "model-2019.csv")

###########################################################

############################
#
# 5th, we do the linear modelling:
# multi linear fit of du_dy as function of X
# using the function lm and the x and y data
# stored in model_data
#
############################


# next time, you could skip all of the 
# above and just load the model_data ...

library(readr)
model_data <- read_csv("model-2019.csv")

fit <- lm(du_dy ~ x1 + x2 + x3 + x4 + x5, data=model_data)

print(summary(fit))

###########################################################

############################
#
# 6th, lets predict the du_dy from
# the model, and plot the measured and modelled
# values
#
############################

# predict from model
model_du_dy <- predict(fit, data=model_data)

plot(model_data$du_dy,model_du_dy
     ,xlab='observed du_dy / pixels',
     ,ylab='modelled du_dy / pixels') + abline(0,1,col="red")

###########################################################

############################
#
# 6th, lets predict the du_dy from
# the model, and plot the measured and modelled
# values
#
############################

# Now reconstruct urban area from du_dy
modelled <- data.frame(year=model_data$year+dy[c(1)],
                       y=model_data$urban_land[c(1)] - model_du_dy[c(1)] + cumsum(model_du_dy))
measured <- data.frame(year=model_data$year,
                       y=model_data$urban_land)

# and plot the urban area measured and modelled
plot(modelled$year,modelled$y,pch=0
     ,xlab='year',
     ,ylab='urban land / pixels') 
lines(modelled$year,modelled$y,col="red")
points(measured$year,measured$y,pch=1) 
lines(measured$year,measured$y,,col="black")
legend(1988, 1800000, legend=c("modelled","measured"),
       col=c("red", "black"), lty=1:2)

###########################################################

#########################
#
# We can take a subset of data 
# from model_data
#
#########################

# a utility function: last + first elements
last <- function(x) { tail(x, n = 1) }
first <- function(x) { head(x, n = 1) }


count = 10
ystart = first(model_data$year)
yend = last(model_data$year)
print(yend)
# sub-dataset for year from ystart for count years
sub = model_data[model_data$year %in% seq(ystart,ystart+count-1),]

print(sub)
#########################
#
# What if we used fewer data points?
#
#########################
fits <- lm(du_dy ~ x1 + x2 + x3 + x4 + x5, data=sub)

print(fits$coefficients)
model_data$year[5:7]


###########################################################
#########################
#
# What if we used fewer data points?
#
#########################
count <- 10

# loop over count years 
for (y0 in seq(first(model_data$year),last(model_data$year)-count,1)){
    years <- seq(y0,y0+count-1)
    sub = model_data[model_data$year %in% years,]
    fits <- lm(du_dy ~ x2 + x5  , data=sub)


    print(sub)
    print(fits$coefficients)
    print(summary(fits))
}

#fit <- lm(du_dy ~ x1 + x2 + x3 + x4 + x5, data=model_data)


#c(array(fit$coefficients))

###########################################################


fit <- lm(du_dy ~ x1 + x2 + x3 + x4 + x5, data=model_data)

#print(summary(fit))
# lets try another model
fit1 <- lm(du_dy ~ x2 + x5 +  0 , data=model_data)

model_du_dy <- predict(fit, data=model_data)
model_du_dy1 <- predict(fit1, data=model_data)


plot(model_data$du_dy,model_du_dy
     ,xlab='observed du_dy / pixels',
     ,ylab='modelled du_dy / pixels') 
points(model_data$du_dy,model_du_dy1,pch=2,col='green') 
abline(0,1,col="red")

print(summary(fit1)) # $adj.r.squared
print(summary(fit)) # $adj.r.squared

###########################################################
###########################################################

