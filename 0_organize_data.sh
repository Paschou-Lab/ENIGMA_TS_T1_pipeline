#!/bin/bash

module load r

for biomarker in {AACT AAT APOA1 APOB APOD APOE B2M BDNF CD40L CLU EGFR ESELECTN IGFBP2 IL6R IL13 IL16 IL18 IL8 LCN2 MCP1 MCP2 MDC MYOGLOBN MIPRT1B MPO P PlGF PLMNRARC PPP PRL SCF RESISTIN T TBG TFF TIMP} ; do

   mkdir $biomarker_PRS

   Rscript PRSice.R     --prsice PRSice_linux     --base  $biomarker --target mergeallQ   --binary-target F     --pheno  $biomarker.txt  --cov mergeallQ.eigenvec  --stat Beta  --beta --out  ./$biomarker_PRS/$biomarker
   
   cd $biomarker_PRS
   
   cat $biomarker.best|awk '{print $4}'| sed 's/PRS/$biomarker/g' >../PRS/$biomarker
   
   cd ../;
   
   done


