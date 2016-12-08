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


###################################################
#################Visualization#####################
###################################################

setwd('C:/Users/mannfred/Dropbox/UBC Botany/Lotus/Excel Books/Greenhouse Exp')

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
              #geom_abline(intercept= -0.0198, slope= 0.11949, colour= 'blue')
              #geom_abline(intercept= -0.04036, slope= 0.24654, colour='red')
              
