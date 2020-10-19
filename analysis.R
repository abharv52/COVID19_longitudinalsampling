###############################
# Positive samples and COVID-19 cases
# Oct 19, 2020


# read in data
samples <- readRDS("sample_quantities.rds") #sample results
covidcases_city <- readRDS("covid_cases_wholecity.rds") #covid-19 case numbers
covidcases_zip <- readRDS("covid_cases_Zip.rds") #cases only in zip of sampling

# load in required packages
library(dplyr)
library(zoo)
library(ggplot2)

# Summarizing sample data by week
Weekly_pos <- samples %>%
  group_by(Collection.date) %>%
  summarise(n=n(), #calculating number of samples by week
            n_pos=sum(nreps.pos.N1>0|nreps.pos.E>0,na.rm=T), # counting number of positive samples by week
            Percent=n_pos/n*100,# calculating percentage of positive samples
            # calculating 95% CI
            prop=n_pos/n,
            se=sqrt((prop*(1-prop))/n),
            t95=qt(.95,n-1),
            error=se*t95*100)

# Calculating 7-day moving average for case numbers
covidcases_zip$movingavg7 <- rollmean(covidcases_zip$Total.cases,7,align="center",fill=NA)
covidcases_city$movingavg7 <- rollmean(covidcases_city$Total.cases,7,align="center",fill=NA)

####################### Creating plots ####################################
# Plot of cases in entire city
xmax1=60
coeff1=25/xmax1 # Coefficient for plotting with 2 axes

city_plot <- ggplot(Weekly_pos,aes(x=Collection.date,y=Percent))+geom_point(data=covidcases_city,aes(x=Date,y=movingavg7/coeff1),color="red",size=3)+
  geom_point(size=4) +
  geom_errorbar(aes(ymin=Percent-error, ymax=Percent+error), width=.8,
                position=position_dodge(.9)) +
  # Adding mask order info
  geom_vline(xintercept=as.Date("2020-05-06"),linetype = "dashed")+
  # Adding shutdown info
  geom_vline(xintercept=as.Date("2020-03-24"),linetype = "dashed")+
  # Phase 1 reopening
  geom_vline(xintercept=as.Date("2020-05-18"),linetype = "dashed")+
  # Phase 2 reopening
  geom_vline(xintercept=as.Date("2020-06-08"),linetype = "dashed")+
  theme_minimal(base_size=25) +
  xlab("Date") +
  geom_hline(yintercept=0)+
  scale_y_continuous(name="Percent Positive",
                     limits=c(-20,xmax1),
                     breaks=c(0,10,20,30,40,50,60),
                     sec.axis=sec_axis(~.*coeff1,name="New Cases",
                                       breaks=c(0,5,10,15,20,25)))+
  theme(text = element_text(face="bold",family="sans"),
        axis.title.y=element_text(size=15),
        axis.title.x=element_blank(),
        axis.text.y=element_text(size=15),
        axis.text.y.right = element_text(color="red",size=15),
        axis.title.y.right=element_text(color="red",size=15),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        plot.margin=unit(c(1.5,.1,.1,.1),units="in"))+
  xlim(as.Date("2020-03-04"),as.Date("2020-06-30"))


# Plot of cases in specific zip code
xmax=60
coeff=4/xmax

zip_plot <- ggplot(Weekly_pos,aes(x=Collection.date,y=Percent))+geom_point(data=covidcases_zip,aes(x=Date,y=movingavg7/coeff),color="red",size=3)+
  geom_point(size=4) +
  geom_errorbar(aes(ymin=Percent-error, ymax=Percent+error), width=.8,
                position=position_dodge(.9)) +
  # Adding mask order info
  geom_vline(xintercept=as.Date("2020-05-06"),linetype = "dashed")+
  # Adding shutdown info
  geom_vline(xintercept=as.Date("2020-03-24"),linetype = "dashed")+
  # Phase 1 reopening
  geom_vline(xintercept=as.Date("2020-05-18"),linetype = "dashed")+
  # Phase 2 reopening
  geom_vline(xintercept=as.Date("2020-06-08"),linetype = "dashed")+
  theme_minimal(base_size=25) +
  xlab("Date") +
  geom_hline(yintercept=0)+
  scale_y_continuous(name="Percent Positive",
                     limits=c(-10,xmax),
                     breaks=c(0,10,20,30,40,50,60),
                     sec.axis=sec_axis(~.*coeff,name="New Cases",
                                       breaks=c(0,1,2,3,4)))+
  theme(text = element_text(face="bold",family="sans"),
        axis.title.y=element_text(size=15),
        axis.title.x=element_text(size=15),
        axis.text.x=element_text(size=15),
        axis.text.y=element_text(size=15),
        axis.text.y.right = element_text(color="red",size=15),
        axis.title.y.right=element_text(color="red",size=15),
        panel.border = element_rect(colour = "black", fill=NA, size=1),
        plot.margin=unit(c(1.5,.1,.1,.1),units="in"))+
  xlim(as.Date("2020-03-04"),as.Date("2020-06-30"))
