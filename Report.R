## Import Packages
library(readr)
library(car)
library(leaps)
library(caret)
library(e1071)
library(rpart)
library(neuralnet)
library(nnet)
library(randomForest)
library(C50)

## Import Datasets
wine <- read_csv("~/Documents/College Courses/Senior Year/CSE 5243/Homework 4/wine.csv")
wine.df <- data.frame(wine)
wine.df <- wine.df[-c(1296,1297),]

## Preliminary Data Analysis

## Data Summary
summary(wine.df)

## Pairwise Plots
plot(wine.df[,-14])

## Boxplots amongst Potential Predictors
par(mfrow=c(2,2))
boxplot(wine.df$quality)
boxplot(wine.df$alcohol)
boxplot(wine.df$sulph)
boxplot(wine.df$pH)
par(mfrow=c(2,2))
boxplot(wine.df$density)
boxplot(wine.df$tot_sulf_d)
boxplot(wine.df$free_sulf_d)
boxplot(wine.df$chlorides)
par(mfrow=c(2,2))
boxplot(wine.df$resid_sugar)
boxplot(wine.df$citric_acid)
boxplot(wine.df$vol_acidity)
boxplot(wine.df$fx_acidity)

## Histograms
par(mfrow=c(2,2))
hist(wine.df$quality) # Figure 1
hist(wine.df$alcohol) # Figure 2
hist(wine.df$sulph) # Figure 4
hist(wine.df$pH)
par(mfrow=c(2,2))
hist(wine.df$density)
hist(wine.df$tot_sulf_d) # Figure 5
hist(wine.df$free_sulf_d) # Figure 6
hist(wine.df$chlorides)
par(mfrow=c(2,2))
hist(wine.df$resid_sugar)
hist(wine.df$citric_acid)
hist(wine.df$vol_acidity)
hist(wine.df$fx_acidity)

## Scatterplots
par(mfrow=c(2,2))
plot(wine.df$alcohol, wine.df$quality)
plot(wine.df$sulph, wine.df$quality)
plot(wine.df$pH, wine.df$quality)
plot(wine.df$density, wine.df$quality)
par(mfrow=c(2,2))
plot(wine.df$tot_sulf_d, wine.df$quality)
plot(wine.df$free_sulf_d, wine.df$quality)
plot(wine.df$chlorides, wine.df$quality)
plot(wine.df$resid_sugar, wine.df$quality)
par(mfrow=c(1,2))
plot(wine.df$citric_acid, wine.df$quality)
plot(wine.df$vol_acidity, wine.df$quality)
plot(wine.df$fx_acidity, wine.df$quality)

## Summary of Highest Alcohol Content
high.alc <- subset(wine.df, wine.df$alcohol>13)
hist(high.alc$quality) # Figure 3
summary(high.alc)

## Data Transformation

## Change High and Low Values
wine.df[wine.df$class == "High", 14] <-  1
wine.df[wine.df$class == "Low", 14] <-  0
wine.df$class <- as.numeric(wine.df$class)

## Simple Linear Regression

## Linear Regression (Full)
full.lm <- lm(quality~fx_acidity+vol_acidity+citric_acid+resid_sugar+chlorides+
                free_sulf_d+tot_sulf_d+density+pH+sulph+alcohol, data=wine.df)

## Full Model Summary
summary(full.lm)
AIC(full.lm)

full.res <- rstandard(full.lm)
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
hist(full.res)
plot(full.res) # By Index
plot(predict(full.lm), full.res) # By Predicted

## Q-Q Plot
qqPlot(full.lm) # Figure 7

## Exhaustive Search 
red.lm <- regsubsets(quality~.,
                     data = wine.df,
                     nbest = 2,
                     nvmax = NULL,
                     force.in = NULL,
                     force.out = NULL,
                     really.big = FALSE,
                     method = "exhaustive")
full.lm.sum <- summary(red.lm)

## R-Squared Search and BIC
ixbest<- seq(1,ncol(wine.df)*2-1,by=2)
par(mfrow=c(1,2))
plot(ixbest,
     full.lm.sum$adjr2[ixbest],
     pch=20,
     xlab="Model",
     ylab="adjR2",
     cex.lab=1,
     cex.axis=1)
plot(ixbest,full.lm.sum$bic[ixbest],
     pch=20,
     xlab="Model",
     ylab="BIC",
     cex.lab=1,
     cex.axis=1)

## Adjusted R-Squared suggested Model
full.lm.sum$outmat[15,] # fx_acidity+vol_acidity+chlorides+pH+sulph+alcohol

## Linear Regression (Reduced: R-Squared)
red.lm <- lm(quality~fx_acidity+vol_acidity+chlorides+
               pH+sulph+alcohol, data=wine.df)

## Full Model Summary
summary(red.lm)
AIC(red.lm)

## BIC suggested Model
full.lm.sum$outmat[12,] # vol_acidity+chlorides+pH+sulph+alcohol

## Linear Regression (Reduced: BIC)
red.lm <- lm(quality~fx_acidity+vol_acidity+citric_acid+resid_sugar+chlorides+
               free_sulf_d+tot_sulf_d+density+pH+sulph+alcohol, data=wine.df)

## Full Model Summary
summary(red.lm)
AIC(red.lm)

## Logistic Regression Model

## Logistic Regression (Full)
full.glm <- glm(class~fx_acidity+vol_acidity+citric_acid+resid_sugar+chlorides+
                  free_sulf_d+tot_sulf_d+density+pH+sulph+alcohol, data=wine.df, family = binomial)

## Full Model Summary
summary(full.glm)

## Residual Plots
full.res <- rstandard(full.glm)
layout(matrix(c(1,1,2,3), 2, 2, byrow = TRUE))
hist(full.res)
plot(full.res) # By Index
plot(predict(full.glm), full.res) # By Predicted

## Logistic Regression (Reduced)
red.glm <- glm(class~vol_acidity+citric_acid+chlorides+
                 free_sulf_d+tot_sulf_d+sulph+alcohol, data=wine.df, family = binomial)

# Reduced Model Summary
summary(red.glm)

## Model Development

### Decision Tree
## Transform Dataset
wine.df.temp <- wine.df[,-c(1, 13)]

## Create Model
model.dt <- rpart(as.factor(class) ~ ., data = wine.df.temp,
                  method = "class")

## Confusion Matrix
pred.dt <- predict(model.dt, wine.df.temp, type = "class")
table(pred.dt, wine.df.temp$class)

## Calculate Accuracy
mean(pred.dt==wine.df.temp$class)

## Perform 10-fold Cross Validation
model <- train(as.factor(class) ~ ., wine.df.temp,
               method = "rpart",
               trControl = trainControl(
                 method = "cv", number = 10,
                 verboseIter = TRUE))

## Print Summary and Confusion Matrix of Cross Validated Model
model
confusionMatrix(predict(model, wine.df.temp), wine.df.temp$class)

### Rules-Based
## Transform Dataset
wine.df.temp <- wine.df[,-c(1, 13)]

## Create Model
model.rb <- C5.0(as.factor(class) ~ ., data = wine.df.temp)

## Confusion Matrix
pred.rb <- predict(model.rb, wine.df.temp)
table(pred.rb, wine.df.temp$class)

## Calculate Accuracy
mean(pred.rb==wine.df.temp$class)

## Perform 10-fold Cross Validation
model <- train(as.factor(class) ~ ., wine.df.temp,
               method = "C5.0",
               trControl = trainControl(
                 method = "cv", number = 10,
                 verboseIter = TRUE))

## Print Summary and Confusion Matrix of Cross Validated Model
model

### Naive Bayes
## Transform Dataset
wine.df.temp <- wine.df[,-c(1, 13)]

## Create Model
model.nb <- naiveBayes(as.factor(class) ~ ., data = wine.df.temp)

## Confusion Matrix
pred.nb <- predict(model.nb, wine.df.temp)
table(pred = pred.nb, true=wine.df.temp$class)

## Calculate Accuracy
mean(pred.nb==wine.df.temp$class)

## Perform 10-fold Cross Validation
model <- train(as.factor(class) ~ ., wine.df.temp,
               method = "nb",
               trControl = trainControl(
                 method = "cv", number = 10,
                 verboseIter = TRUE))

## Print Summary of Cross Validated Model
model

### Artificial Neural Network
## Transform Dataset
wine.df.temp <- wine.df[,-c(1, 13)]

## Normalize Data
maxs <- apply(wine.df.temp, 2, max) 
mins <- apply(wine.df.temp, 2, min)
scaled <- as.data.frame(scale(wine.df.temp, center = mins, scale = maxs - mins))
train_ <- scaled[1:1118,]
test_ <- scaled[1119:1597,]

## Create Model
n <- names(train_)
f <- as.formula(paste("class ~", paste(n[!n %in% "class"], collapse = " + ")))
model.nn <- neuralnet(f, data=train_, linear.output=TRUE)

# Scale the Model Back
pr.nn <- compute(model.nn,test_[,-12])
pr.nn_ <- pr.nn$net.result*(max(wine.df.temp$class)-min(wine.df.temp$class))+min(wine.df.temp$class)
test.r <- (test_$class)*(max(wine.df.temp$class)-min(wine.df.temp$class))+min(wine.df.temp$class)

## Calculate MSE Error
MSE.nn <- sum((test.r - pr.nn_)^2)/nrow(test_)
MSE.nn

## Calculate Confusion Matrix
pr.nn <- round(compute(model.nn,test_[,-12])$net.result)
table(pr.nn, test_$class)

## Perform 10-fold Cross Validation
model <- train(as.factor(class) ~ ., wine.df.temp,
               method = "nnet",
               trControl = trainControl(
                 method = "cv", number = 10,
                 verboseIter = TRUE))

## Print Summary of Cross Validated Model
model

### Support Vector Machine
## Transform Dataset
wine.df.temp <- wine.df[,-c(1, 13)]

## Create Model
model.vm <- svm(as.factor(class) ~ ., data = wine.df.temp)

## Confusion Matrix
pred.vm <- predict(model.vm, wine.df.temp)
table(pred = pred.vm, true=wine.df.temp$class)

## Calculate Accuracy
mean(pred.vm==wine.df.temp$class)

## Perform 10-fold Cross Validation
model <- train(as.factor(class) ~ ., wine.df.temp,
               method = "svmLinearWeights2",
               trControl = trainControl(
                 method = "cv", number = 10,
                 verboseIter = TRUE))

## Print Summary of Cross Validated Model
model

### Ensemble Learner [Random Forest]
## Transform Dataset
wine.df.temp <- wine.df[,-c(1, 13)]

## Create Model
model.rf <- randomForest(as.factor(class) ~ ., data = wine.df.temp)

## Confusion Matrix
pred.rf <- predict(model.rf, wine.df.temp)
table(pred = pred.rf, true=wine.df.temp$class)

## Calculate Accuracy
mean(pred.vm==wine.df.temp$class)

## Perform 10-fold Cross Validation
model <- train(as.factor(class) ~ ., wine.df.temp,
               method = "rf",
               trControl = trainControl(
                 method = "cv", number = 10,
                 verboseIter = TRUE))

## Print Summary of Cross Validated Model
model

