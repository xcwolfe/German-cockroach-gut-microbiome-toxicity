---
title: "Lefse analysis in R"
output: html_document
---

## Plotting lefse data

```{r}
library("ggplot2")
```

# Read in data:
```{r}
LFKA <- read.table("analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.AvsKexcel35.txt", header = TRUE, sep="\t" )
LFDJ <- read.table("analysis.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.opti_mcc.0.03.DvsJexcel35.txt", header = TRUE, sep="\t" )
    ### Added dashes in 4th and 5th columns of .txt files
  #### in excel, I got rid of all rows with dashes (non-significant) OTUs
head(LFKA)
head(LFDJ)
```


# Set order to be by order of OTUs in original file:
```{r}
LFKA$OTU <- factor(LFKA$OTU, levels = LFKA$OTU)
LFDJ$OTU <- factor(LFDJ$OTU, levels = LFDJ$OTU)
```

# In fact, i want reverse of this since it makes the plot easier to interpret:
```{r}
LFKA$OTU <- factor(LFKA$OTU, levels = rev(LFKA$OTU))
LFDJ$OTU <- factor(LFDJ$OTU, levels = rev(LFDJ$OTU))

ka <- ggplot(LFKA, aes(x=OTU, y=LDA, fill=Class), show_guide=FALSE) + 
  geom_bar(position="dodge",stat="identity") + 
  coord_flip() # flip it 90
dj <- ggplot(LFDJ, aes(x=OTU, y=LDA, fill=Class), show_guide=FALSE) + 
  geom_bar(position="dodge",stat="identity") + 
  coord_flip() # flip it 90

```


# Replace OTU### with tax info:
```{r}
# Make a vector with the names of the taxa matching each significant OTU:

head(tax.clean)
myLabscd <- tax.clean
```

# Then add these labels to the to plot:
```{r}
KAL <- ka + scale_x_discrete(labels=myLabscd$Family, position = "top")
DJL <- dj + scale_x_discrete(labels=myLabscd$Family, position = "top")
```


# Change font, color, size, etc.
```{r}
k = KAL + theme_gray() +
  theme(axis.text.x=element_text(hjust=10, size=8, vjust=0.1, colour="black")) +
  theme(axis.text.y=element_text(hjust=10, size=15, vjust=0.1, colour="black")) +
  theme(axis.title.x=element_text(size=8, colour="black")) +
  theme(axis.title.y=element_text(size=8, colour="black")) + 
  labs(fill="Treatment Type\n") +
  theme(legend.title =element_text(size=12, colour="black")) +
  theme(legend.text = element_text(size=14, colour="black")) +
  guides(fill = guide_legend(override.aes = list(size=3)))

d = DJL + theme_gray() +
  theme(axis.text.x=element_text(hjust=10, size=8, vjust=0.1, colour="black")) +
  theme(axis.text.y=element_text(hjust=10, size=14, vjust=0.1, colour="black")) +
  theme(axis.title.x=element_text(size=8, colour="black")) +
  theme(axis.title.y=element_text(size=8, colour="black")) + 
  labs(fill="Strain\n") +
  theme(legend.title =element_text(size=12, colour="black")) +
  theme(legend.text = element_text(size=14, colour="black")) +
  guides(fill = guide_legend(override.aes = list(size=3)))

plot(k + 
       labs(title = "Family Differences between Ace (control) and Kan (antibiotic) Treatments (LDA > 3.5)", size=4))
plot(d +
       labs(title = "Family Differences between Danville (R) and Jwax (S) Strains (LDA > 3.5)", size=4)) 
```

