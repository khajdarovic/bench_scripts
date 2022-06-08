library(tidyverse)
library(Biostrings)


date<-"20220608"
crispick_file<-"crispick_results.csv"


picks<-read_csv(crispick_file)


picks<-select(picks, Input,`sgRNA Sequence` )
picks$version <- rep(c("1","2","3"),length(picks$Input)/3)

picks$guide_name<-paste0("sg", picks$Input)
picks$guide_name<-paste(picks$guide_name, picks$version, sep = "_")
picks$guide_name




picks$forward<-paste0("CACCg", picks$`sgRNA Sequence`)
  

dna<-picks$`sgRNA Sequence`
dna
dna <- DNAStringSet(dna)
dna_revcom<-reverseComplement(dna)
dna_revcom<-as.character(dna_revcom)
picks$reverse<-dna_revcom

picks$reverse<-paste0("AAAC",picks$reverse, "c")
picks$reverse

primer_order<-select(picks,guide_name,forward,reverse )
primer_order<-primer_order %>% pivot_longer(-guide_name, names_to = "direction", values_to = "seq")

primer_order$dir_label<- rep(c("F", "R"),length(primer_order$direction)/2)

primer_order$guide_name<-paste(primer_order$guide_name, primer_order$dir_label, sep = "_")

primer_order<-dplyr::select(primer_order, guide_name, seq)



write_csv(primer_order, paste0("primer_order", date, ".csv"))

