**Spatial-temporal variations in species richness and abundance of lepidoptera**

**Data**: https://doi.org/10.15468/dl.9ncqv7

In recent years, Anthropogenic activities have had a substantial negative effect on biodiversity, with countless species becoming endangered and/or going extinct yearly; along with endangering the critical ecosystem services they underpin. The Lepidoptera family are vital to ecosystem functionality, playing a key role in the pollination of numerous plant species (Johnson, 1994). It is widely known that species within Lepidoptera have been unequivocally affected by human activities, with negative trends in populations seen globally (Warren et al., 2021). Therefore, it is of great importance to examine spatial and temporal trends in species richness and abundance of this important taxonomic group, in order to determine where conservation efforts should be focused. Here, I aim to examine the changes in Lepidoptera across time and space with respect to species richness and abundance. As the main hypothesis, it seems evident that species richness and abundance will vary across time, with negative trends likely. However, given that different localities are subject to varying levels of disturbance, it could also be that temporal trends in species richness and abundance of Lepidoptera will vary across regions.

**Methods**
1. **Data collection**
In this assessment, the Global Biodiversity Information Facility (GBIF) ‘Bumblebees and butterflies in Norway’ public data set was utilised. This data set was created by the Norwegian institute of nature research through representative surveys across 52 localities in 5 different regions of Norway. Surveys started in 2009 and are conducted three times throughout the summer, with a standardised method. This includes visual identification and sweep netting along fixed transects (Åström S and Åström J (2022).

2. **Data preparation**
To prepare the data for analysis, firstly it was necessary to derive the abundance and species richness of Lepidoptera observed in each sampling event (disregarding bumblebee data). With respect to abundance, a sequential loop was built to count the total number of Lepidoptera individuals seen at every given sampling event. For species richness, a similar loop was applied, where the total number of species observed at each given sampling event was counted. Additionally, a condition was added to the loop that when no Lepidoptera species were seen in a sampling event, a 0 was added as the measure of species richness. Finally, to utilise date as a numerical predictor, the date format was transformed to the variable ‘days since study start’, by calculating the number of days passed since the beginning of the study for each sampling event.

3. **Exploratory data analysis**
Exploratory data analysis was carried out prior to analysis to observe the distribution of the data against the predictor variables, using point plots for time, and boxplots for region. Likewise, histograms were plotted for both dependent variables.

4. **Data Analysis**
The data analysed here is count data, and for both dependant variables, the preliminary exploratory data analysis histograms show that the data is highly skewed to the left and compromised by various meaningful 0s; hence analysis with a generalised linear model with a poisson error distribution is most appropriate. However, given that many sampling events took place in the same area of each region, the observations are not independent from each other, violating a central assumption of (generalised) linear modelling. To account for this pseudoreplication, generalised linear mixed-effects models with a poisson error distribution were built with the ‘lme4’ package (Bates et al., 2015) for species richness and abundance, with days since study start, region, and interaction between these two as fixed predictors, and locality as a random predictor. According to Bates et al., a random effect should have at least 7 levels, meaning that locality provides an adequate random effect (52 localities). Model validation was carried out through residual plots. In both cases, the residuals follow an adequate distribution, with variance being largely homogenous around the mean and with no observations having too much leverage. In addition, the dispersion parameter was calculated with the ‘blmeco’ package (Korner-Nievergelt et al. 2015) to determine the degree of over/under dispersion. In both cases, no signs of over/under dispersion were detected (Species richness full model: 1.09, Abundance full model: 1.11). To determine the relative contribution of predictor variables, a deconstruction technique was utilised whereby predictors were removed sequentially and tested against the previous model with a Likelihood Ratio Test to determine if the removal of a given term results in a significantly worse model. Indicators of model quality, obtained for all models were AIC and Deviance. Data visualisation was carried out with ggplot2, using the model outputs to calculate lines of best fit.

**Results**
a. **Relative abundance**
Sequential deconstruction of the contribution effect of fixed predictors on relative abundance of Lepidoptera abundance suggests that all predictors have a significant effect (interaction: Chi=679.87, p <0.0001| Days: Chi=68.51, p<0.0001 | Region: Chi=22.046, p=0.0001) (see Table 1). However, the lowest AIC and deviance was observed for the full model (AIC – 25622.5, Deviance – 19552.96) (Table 1.), suggesting that including all terms and the interaction gives place to the model which best represents the observed data.

Table 1: Outputs from backwards stepwise model selection with AIC, Deviance, Chi-squared and P value for each term



Thus, it seems that the effect of time on abundance is reliant on region (and vice versa), with different regions experiencing different trends over time. For instance, for Adger, Rogaland, and Trondelag, a positive trend can be observed in abundance over time (Agder: slope =0.0003, intercept =1.384, | Rogaland: slope = 0.0004, intercept =1.268 | Trondelag: slope =0.0002, intercept = 1.497), with the effect being strongest in Rogaland (0.0004), and weakest for Trondelag (0.0002) (Figure 1.) In contrast, abundance of Lepidoptera in both Vestfold og Telemark and Viken appears to decrease over time (Vestfold og Telemark: slope = -6.089, intercept =2.809, | Viken: slope =-4.087, intercept =3.109) with both sites showing a similar negative trend (-6.089 / - 4.087) (Figure 1.).


Figure 1: Abundance of Lepidoptera over study duration (2009-2021) across 5 regions of Norway
 
b. **Species richness**
With regards to species richness, removal of fixed predictors indicates that they are all important terms with significant explanatory power (interaction: Chi=91.9, p <0.0001| Days: Chi=11.6, p= 0.0006 | Region: Chi=41.8, p<0.0001) (Table 2.). However, parameters indicative of the model quality suggest that the full model including an interaction between time and region is the most adequate, displaying the lowest AIC and Deviance of all the models (AIC=7290.6, Deviance=2729.0) (Table 2.), thus similar to abundance, the model suggests that the effect of time on species richness varies across regions.


Table 2: Outputs from backwards stepwise model selection with AIC, Deviance, Chi-squared and P value for each term





Following on, the individual regional trends follow a similar pattern to that of relative abundance, with species richness of Agder, Rogaland, and Trondelag increasing across the studies duration (Agder: slope =0.00018, intercept =0.663, | Rogaland: slope = 0.00022, intercept = 0.555| Trondelag: slope = 0.00018, intercept =0.174) (Figure 2.), while that of Vestfold og Telemark and Viken decrease over time (Vestfold og Telemark: slope =-3.43, intercept =1.515, | Viken: slope =-3.837, intercept =1.683) (Figure 2.).
Figure 2: Lepidoptera species richness over study duration (2009-2021) across 5 regions of Norway
In conclusion, Viken and Vestfold og Telemark show negative trends in species richness and abundance over time, while positive trends are seen in Agder, Rogaland and Trondelag. The first hypothesis ‘species richness and abundance will vary across time, with negative trends likely’, is proved partially correct (Figure 1 + 2) with all regions varying in species richness and abundance over time. Although all regions do vary in species richness and abundance, there is no negative trend exhibited by all the regions. Regarding the second hypothesis ‘temporal trends in species richness and abundance of Lepidoptera will vary across regions’, this is confidently proved, with a significant change in species richness and abundance seen in all regions.
 
As can be seen in Figure 3, the regions the surveys are undertaken from are broadly spread out across Norway. This most likely explains why there are both positive and negative trends seen in the change of species richness and abundance over the 5 regions. It is probable that the regions increasing in species richness and abundance have been negatively influenced in the past by Anthropogenic impacts and are now recovering and or are part of a restoration programme. The regions decreasing in species richness and abundance over time are more uniform with current global biodiversity trends, with a plausible explanation most likely involving further encroachment by humans. Encroachment is generally coupled with associated land use change, reducing habitats for Lepidoptera species, hence the reduction in their numbers.
Figure 3. Survey sites in Norway, sourced from (Åström S and Åström J, 2022)
It is clear that temporal trends in species richness and abundance of Lepidoptera do in fact vary across regions. Hence, this suggests that these areas may be the most affected by the loss of Lepidoptera, and as such is where concentration efforts should be focused. However, it should be noted that a dilemma exists here, in the form of should sites which are recovering be a focus of conservation efforts. Currently, this is the most widespread approach utilised for improving biodiversity but should this focus instead be shifted towards areas currently declining in biodiversity over time, and the recovering areas which are improving be left to fare for themselves.
Further study could be carried out on species-specific trends, giving more specific effects of where this habitat degradation is occurring (e.g., butterflies have specific food plants, if they are decreasing in numbers then could infer the host plant is also). Additionally, further research could be focused on the regions declining in biodiversity, with the hope that the reasons why are found, allowing attempted mitigation of these effects.

**References**
Åström S, Åström J (2022). Bumblebees and butterflies in Norway. Version 1.4. Norwegian Institute for Nature Research. Sampling event dataset https://doi.org/10.15468/mpsa4g accessed via GBIF.org on 2022-12-09.
Bates, D. et al. (2015) ‘Fitting Linear Mixed-Effects Models Using lme4’, Journal of Statistical Software, 67, pp. 1–48. Available at: https://doi.org/10.18637/jss.v067.i01.
Bates, D. et al. (2018) ‘Parsimonious Mixed Models’. arXiv. Available at: http://arxiv.org/abs/1506.04967 (Accessed: 15 December 2022).
Bates, D. et al. (2022) ‘lme4: Linear Mixed-Effects Models using “Eigen” and S4’. Available at: https://CRAN.R-project.org/package=lme4 (Accessed: 15
December 2022).
Johnson, S.D. (1994) ‘Evidence for Batesian mimicry in a butterfly-pollinated orchid’, Biological Journal of the Linnean Society, 53(1), pp. 91–104. Available
at: https://doi.org/10.1006/bijl.1994.1062.
Korner-Nievergelt F, Roth T, von Felten S, Guelat J, Almasi B, Korner-Nievergelt P (2015). Bayesian Data Analysis in Ecology using Linear Models with
R, BUGS and Stan. Elsevier.
Warren, M.S. et al. (2021) ‘The decline of butterflies in Europe: Problems, significance, and possible solutions’, Proceedings of the National Academy of Sciences of the United States of America, 118(2), p. e2002551117. Available at: https://doi.org/10.1073/pnas.2002551117.
