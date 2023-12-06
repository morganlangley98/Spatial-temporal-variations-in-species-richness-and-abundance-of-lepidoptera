library(tidyverse)
library(blmeco)
library(lme4)
library(ggplot2)

setwd("directory")

### read data
dat<-data.table::fread('Bumble_Butter.csv') 

unique(dat$locality)

### Get unique event id, based on locality and event date
dat$evendID <- paste0(dat$locality, ' ', dat$eventDate)

### Subset all of those from leptidoptera

dat2 <- dat[dat$order=='Lepidoptera',]

### get days since study start to use as numeric predictor for time

class(dat2$eventDate) ### check class format

### Already set as date, substract from first date

days.str <- difftime(dat2$eventDate, min(dat2$eventDate), units = 'days')

dat2$days.str <- as.numeric(days.str) ### append as numeric

### obtain total abundance per sampling event

AB <- dat2 %>%
  group_by(evendID, stateProvince, days.str, locality) %>%
  summarise(abundance=sum(individualCount))

### Exploratory data analysis

hist(AB$abundance) ###

boxplot(AB$abundance~AB$stateProvince)

plot(AB$abundance~AB$days.str)

### data looks poisson distributed, and its count data, thus need to analyse with poisson glm
### however, non independence of observations arising from data collection at some locality, use mixed effects poisson glm

mod_ab1 <- glmer(abundance~days.str+stateProvince+days.str:stateProvince
                 + (1|locality), data=AB, family='poisson')

deviance(mod_ab1)
AIC(mod_ab1)

drop1(mod_ab1, test='Chisq')

### remove interaction

mod_ab2 <- glmer(abundance~days.str+stateProvince
                 + (1|locality), data=AB, family='poisson')

deviance(mod_ab2)
AIC(mod_ab2)

drop1(mod_ab2, test='Chisq')

### remove days

mod_ab3 <- glmer(abundance~stateProvince + (1|locality),
                 data=AB, family='poisson')

deviance(mod_ab3)
AIC(mod_ab3)

drop1(mod_ab3, test='Chisq')

### remove region

mod_ab4 <- glmer(abundance~days.str + (1|locality),
                 data=AB, family='poisson')

deviance(mod_ab4)
AIC(mod_ab4)

mod2 <- glmer(abundance~days.str+stateProvince+days.str:stateProvince
              + (1|locality) , data=AB, family='poisson')

drop1(mod2, test='Chisq')

### interaction highly significant, minimal adequate model reached

### plot model output

### 1. get line of best fit for the interaction

glm.lfb<-function(data, predictor, intercept, slope){
  range<-seq(min(data[c(predictor)]), max(data[c(predictor)]), by=0.01)
  probs<-exp(intercept+slope*range)
  out.df<-data.frame(range, probs)
  return(out.df)
}

sum_mod <- summary(mod2)

sum_mod$coefficients[[1]]

inter <- sum_mod$coefficients[[1]]
slop <- sum_mod$coefficients[[2]]

### Agder

ag_int <- inter
ag_slp <- slop

ag_line <- glm.lfb(data=AB[AB$stateProvince=="Agder",],
                 predictor='days.str', intercept=ag_int, slope=ag_slp)

### Trondelag

sum_mod$coefficients[[4]]

tron_int <- inter + sum_mod$coefficients[[4]]
tron_slp <- slop + sum_mod$coefficients[[8]]

tron_line <- glm.lfb(data=AB[AB$stateProvince=="Trøndelag",],
                   predictor='days.str', intercept=tron_int, slope=tron_slp)

### Rogaland

rog_int <- inter + sum_mod$coefficients[[3]]
rog_slp <- slop + sum_mod$coefficients[[7]]

rog_line <- glm.lfb(data=AB[AB$stateProvince=="Rogaland",],
                  predictor='days.str', intercept=rog_int, slope=rog_slp)

### Viken

vik_int <- inter + sum_mod$coefficients[[6]]
vik_slp <- slop + sum_mod$coefficients[[10]]

vik_line <- glm.lfb(data=AB[AB$stateProvince=="Viken",],
                    predictor='days.str', intercept=vik_int, slope=vik_slp)

### Vestfold

ves_int <- inter + sum_mod$coefficients[[5]]
ves_slp <- slop + sum_mod$coefficients[[9]]

ves_line <- glm.lfb(data=AB[AB$stateProvince=="Vestfold og Telemark",],
                  predictor='days.str', intercept=ves_int, slope=ves_slp)

### Plot with ggplot2
### custom x labels

#specify labels for plot

colours <- c('blue','red','darkblue','green','orange')

AB$Region <- AB$stateProvince

AB_plot <- ggplot()+
  geom_point(mapping=aes(x=days.str, y=abundance, color=stateProvince), data=AB, size=1) +
  scale_color_manual(values=colours) +
  geom_line(aes(x=range, y=probs), data=ag_line, color='blue',size=1) +
  geom_line(aes(x=range, y=probs), data=rog_line, color='red',size=1) +
  geom_line(aes(x=range, y=probs), data=tron_line, color='darkblue',size=1) + 
  geom_line(aes(x=range, y=probs), data=ves_line, color='green',size=1) +
  geom_line(aes(x=range, y=probs), data=vik_line, color='orange',size=1) +
  theme(panel.background = element_rect(fill = NA),
        panel.grid.major = element_blank(),
        panel.ontop = FALSE,
        plot.title = element_text(hjust = 0.5), 
        axis.title.y = element_text(size=13, colour='black', vjust= 0), 
        axis.title.x = element_text(size=13, colour='black', vjust= 0),
        axis.text.y = element_text(size=12, colour='black'), 
        axis.text.x = element_text(size=12, colour='black'),
        panel.border = element_rect(fill = "transparent",  
                                    color = 'black',          
                                    size = 0.5)) +
  xlab('Days since study start') + ylab('Abundance') + 
  guides(color=guide_legend(title="Region"))

AB_plot

ggsave(filename='AB_plot.png', dpi=300)

#### ---------------------------------------------------------------------------

### Species Richness

## get species richness with loop to account for those transects where no species
## of lepidoptera were seen

events <- unique(dat2$evendID)

all.d <- data.frame()

for(i in 1:length(events)){
  temp<-dat2[dat2$evendID==events[i],]
  locality<-unique(temp$locality)
  ID<-i
  temp.date<-unique(temp$days.str)
  region<-unique(temp$stateProvince)
  total.c<-sum(temp$individualCount)
  
  if(total.c>0) {
    richness<-length(unique(temp$species[!temp$individualCount==0]))
  }
  
  if(total.c==0){
    richness<-0  
  }
  
  temp.out<-data.frame(ID, temp.date, region, richness, locality)
  colnames(temp.out)<-c('eventID','days.strt','region', 'richness', 'locality')
  all.d<-rbind(all.d, temp.out)
  print(paste0(round(i/length(events)*100, 2), '%'))
}

DIV <- all.d
rm(all.d)

### exploratory data analysis

plot(DIV$richness~DIV$days.strt)

boxplot(DIV$richness~DIV$region)

hist(DIV$richness)

### Highly-skewed to the left
### fit poisson GLM

DIV$days.strt2 <- scale(DIV$days.strt)

### null model for checking deviance explained

mod_div_null <- glmer(richness~1+(1|locality), data=DIV, family='poisson')

mod_div1 <- glmer(richness~days.strt+region+days.strt:region
                + (1|locality), data=DIV, family='poisson')
sum1 <- summary(mod_div1)

### get deviance explained
deviance(mod_div1)
AIC(mod_div1)

### find significance

drop1(mod_div1, test='Chisq')

### remove interaction
mod_div2 <- glmer(richness~days.strt+region + (1|locality), data=DIV, family='poisson')

deviance(mod_div2)
AIC(mod_div2)

drop1(mod_div2, test='Chisq')

### remove days
mod_div3 <- glmer(richness~region + (1|locality), data=DIV, family='poisson')
summary(mod_div3)

deviance(mod_div3)
AIC(mod_div3)


### remove region
mod_div4 <- glmer(richness~days.strt + (1|locality), data=DIV, family='poisson')

deviance(mod_div4)
AIC(mod_div4)

### plot it
sum_div <- summary(mod_div1)

inter <- sum_div$coefficients[[1]]
slop <- sum_div$coefficients[[2]]

### Agder

ag_int <- inter
ag_slp <- slop

ag_line <- glm.lfb(data=DIV[DIV$region=="Agder",], predictor='days.strt',
                   intercept=ag_int, slope=ag_slp)

### Trondelag

tron_int <- inter + sum_div$coefficients[[4]]
tron_slp <- slop + sum_div$coefficients[[8]]

tron_line <- glm.lfb(data=DIV[DIV$region=="Trøndelag",], predictor='days.strt',
                     intercept=tron_int, slope=tron_slp)

### Rogaland

rog_int <- inter + sum_div$coefficients[[3]]
rog_slp <- slop + sum_div$coefficients[[7]]

rog_line <- glm.lfb(data=DIV[DIV$region=="Rogaland",], predictor='days.strt',
                    intercept=rog_int, slope=rog_slp)

### Viken

vik_int <- inter + sum_div$coefficients[[6]]
vik_slp <- slop + sum_div$coefficients[[10]]

vik_line <- glm.lfb(data=DIV[DIV$region=="Viken",], predictor='days.strt',
                    intercept=vik_int, slope=vik_slp)

### Vestfold

ves_int <- inter + sum_div$coefficients[[5]]
ves_slp <- slop + sum_div$coefficients[[9]]

ves_line <- glm.lfb(data=DIV[DIV$region=="Vestfold og Telemark",], predictor='days.strt',
                    intercept=ves_int, slope=ves_slp)

### plot it with ggplot

### levels have been somehow modified, change to alphabetical order to match Abundance plot
DIV$region <- factor(DIV$region, levels=c("Agder","Rogaland","Trøndelag", 'Vestfold og Telemark', 'Viken'))

colours <- c('blue','red','darkblue','green','orange')

DIV_plot <- ggplot()+
  geom_point(mapping=aes(x=days.strt, y=richness, color=region), data=DIV, size=1) +
  scale_color_manual(values=colours) +
  geom_line(aes(x=range, y=probs), data=ag_line, color='blue', size=1) +
  geom_line(aes(x=range, y=probs), data=rog_line, color='red', size=1) +
  geom_line(aes(x=range, y=probs), data=tron_line, color='darkblue', size=1) + 
  geom_line(aes(x=range, y=probs), data=ves_line, color='green', size=1) +
  geom_line(aes(x=range, y=probs), data=vik_line, color='orange', size=1) +
  theme(panel.background = element_rect(fill = NA),
        panel.grid.major = element_blank(),
        panel.ontop = FALSE,
        plot.title = element_text(hjust = 0.5), 
        axis.title.y = element_text(size=13, colour='black', vjust= 0), 
        axis.title.x = element_text(size=13, colour='black', vjust= 0),
        axis.text.y = element_text(size=12, colour='black'), 
        axis.text.x = element_text(size=12, colour='black'),
        panel.border = element_rect(fill = "transparent",  
                                    color = 'black',          
                                    size = 0.5)) +
  xlab('Days since study start') + ylab('Species Richness')+ 
  guides(color=guide_legend(title="Region"))

DIV_plot

ggsave(filename='DIV_plot.png', dpi=300)
