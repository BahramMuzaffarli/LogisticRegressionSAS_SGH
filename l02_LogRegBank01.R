#K. Kopczewska, T. Kopczewski, P. Wójcik (2009) Metody ilościowe w R. Aplikacje ekonomiczne i finansowe (Warszawa:CeDeWu.pl), section 15.3.
#install.packages("lmtest") #testing the model significance
#install.packages("gmodels") #cross tables with tests
#install.packages("ROCit") #ROC curve https://cran.r-project.org/web/packages/ROCit/vignettes/my-vignette.html
library(lmtest)
library(gmodels)
library(ROCit) 

#Read the data
bank<-read.table("/Users/adam/Documents/U/zajecia/LogisticRegression/summer_2023/data/bank.csv",header=TRUE,sep=",")

#Check the data
head(bank)

#Check the response distribution
table(bank$y)
table(bank$y,bank$poutcome)

#Estimate the logistic regression model. Note that the reference is selected for eduction
ModEst <- glm(NewDeposit ~ age + relevel(factor(poutcome),ref='failure'), data=bank, family=binomial(link="logit"))

#Model estimates
summary(ModEst)

#Likelihood ratio test - elements of model assessment
lrtest(ModEst)

#Odds ratios with CI
exp(ModEst$coefficients)
exp(confint(ModEst))






