######################################################
###############General Linear  Model##################
######################################################

mydata<-read.csv('Standards_PACC.csv')
head(mydata)

daysPACC<- mydata$Days       #fixed effect
treatment<-mydata$Treatment  #fixed effect
colour<-   mydata$Condition2 #response

library(lme4)


#general linear model
PACCmodel      <- glm(colour ~ daysPACC + treatment + daysPACC*treatment, data= mydata)

summary(PACCmodel) 

Call:
glm(formula = colour ~ daysPACC + treatment + daysPACC * treatment, 
    data = mydata)

Deviance Residuals: 
     Min        1Q    Median        3Q       Max  
-1.44996  -0.35824   0.05937   0.30622   0.90852  

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)         -0.05937    0.22982  -0.258 0.797625    
daysPACC             0.35848    0.04482   7.998 1.69e-09 ***
treatmentP          -0.06167    0.32520  -0.190 0.850662    
daysPACC:treatmentP  0.38116    0.09974   3.822 0.000506 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for gaussian family taken to be 0.2960798)

    Null deviance: 50.000  on 39  degrees of freedom
Residual deviance: 10.659  on 36  degrees of freedom
AIC: 70.616

Number of Fisher Scoring iterations: 2

####################################################
##Calculating R-squared values for both treatments##
####################################################

    #control model
Call:
lm(formula = colourCTL ~ daysPACCCTL, data = mydataCTL)

Residuals:
     Min       1Q   Median       3Q      Max 
-1.44996 -0.37453  0.05937  0.55004  0.90852 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -0.05937    0.24508  -0.242    0.811    
daysPACCCTL  0.35848    0.04780   7.500 6.07e-07 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.5803 on 18 degrees of freedom
Multiple R-squared:  0.7576,	Adjusted R-squared:  0.7441 
F-statistic: 56.25 on 1 and 18 DF,  p-value: 6.067e-07
    
    #treatment model

Call:
lm(formula = colourTRT ~ daysPACCTRT, data = mydataTRT)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.0979 -0.1630  0.1210  0.1898  0.9021 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) -0.12104    0.21372  -0.566    0.578    
daysPACCTRT  0.73964    0.08277   8.937 4.89e-08 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.5054 on 18 degrees of freedom
Multiple R-squared:  0.8161,	Adjusted R-squared:  0.8058 
F-statistic: 79.86 on 1 and 18 DF,  p-value: 4.893e-08
    
    
###################################################
#################Visualization#####################
###################################################

setwd('C:/path/')

mydata<-read.csv('Standards_PACC.csv')
head(mydata)

daysPACC<-mydata$Days
colour<-mydata$Condition3
treatment<-factor(mydata$Treatment, levels=c('P','N'))
instances<-mydata$Instances

plot<- ggplot(data= mydata, aes(x= daysPACC, y= colour, colour= treatment))+
              geom_point(aes(size= instances))+
              scale_size_area(max_size= 7)+
              theme(legend.position="bottom")+
              guides(colour= guide_legend(override.aes= list(size= 2.7)))+
              theme(
                axis.text=element_text(size=20),
                axis.title=element_text(size=20))+
              scale_y_continuous(breaks=c(0,0.3333,0.6667,1), labels=c('Yellow','Blush','Orange','Red'))+
              xlab('Days From Anthesis')+
              ylab('Colour Stage')+
              coord_cartesian(ylim= c(-0.16667, 1))+
              theme_classic()+
              geom_smooth(method='glm',lwd=0.8, fullrange=TRUE)+
          
              
