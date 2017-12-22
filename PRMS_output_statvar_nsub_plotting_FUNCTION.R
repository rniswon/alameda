statvar_nsub_plotting <- function(plots_OnOff, subbasin_OnOff, runFolder){
  
  
  # prep subbasin indices for variable data frames
  numDateCol <- 7
  subbasinIdxTmp <- numDateCol + which(subbasin_OnOff == 1)
  subbasinIdx <- c(1:numDateCol, subbasinIdxTmp)
  
  
  ### function assumptions ######################
  
  # This function assumes that the statvar file has these columns:
  # row
  # year
  # month
  # day
  # hour 
  # minute
  # second
  # sub_cfs	1: IndianCreek
  # sub_cfs	2: SanAntonioCreekAtIndianCreekRd
  # sub_cfs	3: ArroyoHondo
  # sub_cfs	4 SanAntonioCreek
  # sub_cfs	5: CalaverasCreek
  # sub_cfs	6: AlamedaCreekAboveACDD
  # sub_cfs	7: AlamedaCreekBelowACDD
  # sub_cfs	8: AlamedaCreekBelowCalaverasCreek
  # sub_cfs	9: AlamedaCreekBelowWelchCreek
  # sub_cfs	10: AlamedaCreekNearNiles
  # sub_cfs	11: AlamedaCreekAboveSanAntonioCreek
  # sub_cfs	12: AlamedaCreekAboveArroyoDeLaLaguna
  # basin_cfs	1: WatershedExit
  # runoff	1: IndianCreek
  # runoff	2: SanAntonioCreekAtIndianCreekRd
  # runoff	3: ArroyoHondo
  # runoff	4: SanAntonioCreek
  # runoff	5: CalaverasCreek
  # runoff	6: AlamedaCreekAboveACDD
  # runoff	7: AlamedaCreekBelowACDD
  # runoff	8: AlamedaCreekBelowCalaverasCreek
  # runoff	9: AlamedaCreekBelowWelchCreek
  # runoff	10: AlamedaCreekNearNiles
  # runoff	11: AlamedaCreekAboveSanAntonioCreek
  # runoff	12: AlamedaCreekAboveArroyoDeLaLaguna
  # runoff	13: ArroyoDeLaLagunaAtVerona
  # subinc_precip	1: IndianCreek
  # subinc_precip	2: SanAntonioCreekAtIndianCreekRd
  # subinc_precip	3: ArroyoHondo
  # subinc_precip	4: SanAntonioCreek
  # subinc_precip	5: CalaverasCreek
  # subinc_precip	6: AlamedaCreekAboveACDD
  # subinc_precip	7: AlamedaCreekBelowACDD
  # subinc_precip	8: AlamedaCreekBelowCalaverasCreek
  # subinc_precip	9: AlamedaCreekBelowWelchCreek
  # subinc_precip	10: AlamedaCreekNearNiles
  # subinc_precip	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_precip	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_wb	1: IndianCreek
  # subinc_wb	2: SanAntonioCreekAtIndianCreekRd
  # subinc_wb	3: ArroyoHondo
  # subinc_wb	4: SanAntonioCreek
  # subinc_wb	5: CalaverasCreek
  # subinc_wb	6: AlamedaCreekAboveACDD
  # subinc_wb	7: AlamedaCreekBelowACDD
  # subinc_wb	8: AlamedaCreekBelowCalaverasCreek
  # subinc_wb	9: AlamedaCreekBelowWelchCreek
  # subinc_wb	10: AlamedaCreekNearNiles
  # subinc_wb	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_wb	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_deltastor	1: IndianCreek
  # subinc_deltastor	2: SanAntonioCreekAtIndianCreekRd
  # subinc_deltastor	3: ArroyoHondo
  # subinc_deltastor	4: SanAntonioCreek
  # subinc_deltastor	5: CalaverasCreek
  # subinc_deltastor	6: AlamedaCreekAboveACDD
  # subinc_deltastor	7: AlamedaCreekBelowACDD
  # subinc_deltastor	8: AlamedaCreekBelowCalaverasCreek
  # subinc_deltastor	9: AlamedaCreekBelowWelchCreek
  # subinc_deltastor	10: AlamedaCreekNearNiles
  # subinc_deltastor	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_deltastor	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_actet	1: IndianCreek
  # subinc_actet	2: SanAntonioCreekAtIndianCreekRd
  # subinc_actet	3: ArroyoHondo
  # subinc_actet	4: SanAntonioCreek
  # subinc_actet	5: CalaverasCreek
  # subinc_actet	6: AlamedaCreekAboveACDD
  # subinc_actet	7: AlamedaCreekBelowACDD
  # subinc_actet	8: AlamedaCreekBelowCalaverasCreek
  # subinc_actet	9: AlamedaCreekBelowWelchCreek
  # subinc_actet	10: AlamedaCreekNearNiles
  # subinc_actet	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_actet	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_potet	1: IndianCreek
  # subinc_potet	2: SanAntonioCreekAtIndianCreekRd
  # subinc_potet	3: ArroyoHondo
  # subinc_potet	4: SanAntonioCreek
  # subinc_potet	5: CalaverasCreek
  # subinc_potet	6: AlamedaCreekAboveACDD
  # subinc_potet	7: AlamedaCreekBelowACDD
  # subinc_potet	8: AlamedaCreekBelowCalaverasCreek
  # subinc_potet	9: AlamedaCreekBelowWelchCreek
  # subinc_potet	10: AlamedaCreekNearNiles
  # subinc_potet	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_potet	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_swrad	1: IndianCreek
  # subinc_swrad	2: SanAntonioCreekAtIndianCreekRd
  # subinc_swrad	3: ArroyoHondo
  # subinc_swrad	4: SanAntonioCreek
  # subinc_swrad	5: CalaverasCreek
  # subinc_swrad	6: AlamedaCreekAboveACDD
  # subinc_swrad	7: AlamedaCreekBelowACDD
  # subinc_swrad	8: AlamedaCreekBelowCalaverasCreek
  # subinc_swrad	9: AlamedaCreekBelowWelchCreek
  # subinc_swrad	10: AlamedaCreekNearNiles
  # subinc_swrad	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_swrad	12: AlamedaCreekAboveArroyoDeLaLaguna
  # sub_inq	1: IndianCreek
  # sub_inq	2: SanAntonioCreekAtIndianCreekRd
  # sub_inq	3: ArroyoHondo
  # sub_inq	4: SanAntonioCreek
  # sub_inq	5: CalaverasCreek
  # sub_inq	6: AlamedaCreekAboveACDD
  # sub_inq	7: AlamedaCreekBelowACDD
  # sub_inq	8: AlamedaCreekBelowCalaverasCreek
  # sub_inq	9: AlamedaCreekBelowWelchCreek
  # sub_inq	10: AlamedaCreekNearNiles
  # sub_inq	11: AlamedaCreekAboveSanAntonioCreek
  # sub_inq	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_interflow	1: IndianCreek
  # subinc_interflow	2: SanAntonioCreekAtIndianCreekRd
  # subinc_interflow	3: ArroyoHondo
  # subinc_interflow	4: SanAntonioCreek
  # subinc_interflow	5: CalaverasCreek
  # subinc_interflow	6: AlamedaCreekAboveACDD
  # subinc_interflow	7: AlamedaCreekBelowACDD
  # subinc_interflow	8: AlamedaCreekBelowCalaverasCreek
  # subinc_interflow	9: AlamedaCreekBelowWelchCreek
  # subinc_interflow	10: AlamedaCreekNearNiles
  # subinc_interflow	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_interflow	12: AlamedaCreekAboveArroyoDeLaLaguna
  # sub_interflow	1: IndianCreek
  # sub_interflow	2: SanAntonioCreekAtIndianCreekRd
  # sub_interflow	3: ArroyoHondo
  # sub_interflow	4: SanAntonioCreek
  # sub_interflow	5: CalaverasCreek
  # sub_interflow	6: AlamedaCreekAboveACDD
  # sub_interflow	7: AlamedaCreekBelowACDD
  # sub_interflow	8: AlamedaCreekBelowCalaverasCreek
  # sub_interflow	9: AlamedaCreekBelowWelchCreek
  # sub_interflow	10: AlamedaCreekNearNiles
  # sub_interflow	11: AlamedaCreekAboveSanAntonioCreek
  # sub_interflow	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_sroff	1: IndianCreek
  # subinc_sroff	2: SanAntonioCreekAtIndianCreekRd
  # subinc_sroff	3: ArroyoHondo
  # subinc_sroff	4: SanAntonioCreek
  # subinc_sroff	5: CalaverasCreek
  # subinc_sroff	6: AlamedaCreekAboveACDD
  # subinc_sroff	7: AlamedaCreekBelowACDD
  # subinc_sroff	8: AlamedaCreekBelowCalaverasCreek
  # subinc_sroff	9: AlamedaCreekBelowWelchCreek
  # subinc_sroff	10: AlamedaCreekNearNiles
  # subinc_sroff	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_sroff	12: AlamedaCreekAboveArroyoDeLaLaguna
  # sub_sroff	1: IndianCreek
  # sub_sroff	2: SanAntonioCreekAtIndianCreekRd
  # sub_sroff	3: ArroyoHondo
  # sub_sroff	4: SanAntonioCreek
  # sub_sroff	5: CalaverasCreek
  # sub_sroff	6: AlamedaCreekAboveACDD
  # sub_sroff	7: AlamedaCreekBelowACDD
  # sub_sroff	8: AlamedaCreekBelowCalaverasCreek
  # sub_sroff	9: AlamedaCreekBelowWelchCreek
  # sub_sroff	10: AlamedaCreekNearNiles
  # sub_sroff	11: AlamedaCreekAboveSanAntonioCreek
  # sub_sroff	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_gwflow	1: IndianCreek
  # subinc_gwflow	2: SanAntonioCreekAtIndianCreekRd
  # subinc_gwflow	3: ArroyoHondo
  # subinc_gwflow	4: SanAntonioCreek
  # subinc_gwflow	5: CalaverasCreek
  # subinc_gwflow	6: AlamedaCreekAboveACDD
  # subinc_gwflow	7: AlamedaCreekBelowACDD
  # subinc_gwflow	8: AlamedaCreekBelowCalaverasCreek
  # subinc_gwflow	9: AlamedaCreekBelowWelchCreek
  # subinc_gwflow	10: AlamedaCreekNearNiles
  # subinc_gwflow	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_gwflow	12: AlamedaCreekAboveArroyoDeLaLaguna
  # sub_gwflow	1: IndianCreek
  # sub_gwflow	2: SanAntonioCreekAtIndianCreekRd
  # sub_gwflow	3: ArroyoHondo
  # sub_gwflow	4: SanAntonioCreek
  # sub_gwflow	5: CalaverasCreek
  # sub_gwflow	6: AlamedaCreekAboveACDD
  # sub_gwflow	7: AlamedaCreekBelowACDD
  # sub_gwflow	8: AlamedaCreekBelowCalaverasCreek
  # sub_gwflow	9: AlamedaCreekBelowWelchCreek
  # sub_gwflow	10: AlamedaCreekNearNiles
  # sub_gwflow	11: AlamedaCreekAboveSanAntonioCreek
  # sub_gwflow	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_tavgc	1: IndianCreek
  # subinc_tavgc	2: SanAntonioCreekAtIndianCreekRd
  # subinc_tavgc	3: ArroyoHondo
  # subinc_tavgc	4: SanAntonioCreek
  # subinc_tavgc	5: CalaverasCreek
  # subinc_tavgc	6: AlamedaCreekAboveACDD
  # subinc_tavgc	7: AlamedaCreekBelowACDD
  # subinc_tavgc	8: AlamedaCreekBelowCalaverasCreek
  # subinc_tavgc	9: AlamedaCreekBelowWelchCreek
  # subinc_tavgc	10: AlamedaCreekNearNiles
  # subinc_tavgc	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_tavgc	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_tmaxc	1: IndianCreek
  # subinc_tmaxc	2: SanAntonioCreekAtIndianCreekRd
  # subinc_tmaxc	3: ArroyoHondo
  # subinc_tmaxc	4: SanAntonioCreek
  # subinc_tmaxc	5: CalaverasCreek
  # subinc_tmaxc	6: AlamedaCreekAboveACDD
  # subinc_tmaxc	7: AlamedaCreekBelowACDD
  # subinc_tmaxc	8: AlamedaCreekBelowCalaverasCreek
  # subinc_tmaxc	9: AlamedaCreekBelowWelchCreek
  # subinc_tmaxc	10: AlamedaCreekNearNiles
  # subinc_tmaxc	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_tmaxc	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_tminc	1: IndianCreek
  # subinc_tminc	2: SanAntonioCreekAtIndianCreekRd
  # subinc_tminc	3: ArroyoHondo
  # subinc_tminc	4: SanAntonioCreek
  # subinc_tminc	5: CalaverasCreek
  # subinc_tminc	6: AlamedaCreekAboveACDD
  # subinc_tminc	7: AlamedaCreekBelowACDD
  # subinc_tminc	8: AlamedaCreekBelowCalaverasCreek
  # subinc_tminc	9: AlamedaCreekBelowWelchCreek
  # subinc_tminc	10: AlamedaCreekNearNiles
  # subinc_tminc	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_tminc	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_pkweqv	1: IndianCreek
  # subinc_pkweqv	2: SanAntonioCreekAtIndianCreekRd
  # subinc_pkweqv	3: ArroyoHondo
  # subinc_pkweqv	4: SanAntonioCreek
  # subinc_pkweqv	5: CalaverasCreek
  # subinc_pkweqv	6: AlamedaCreekAboveACDD
  # subinc_pkweqv	7: AlamedaCreekBelowACDD
  # subinc_pkweqv	8: AlamedaCreekBelowCalaverasCreek
  # subinc_pkweqv	9: AlamedaCreekBelowWelchCreek
  # subinc_pkweqv	10: AlamedaCreekNearNiles
  # subinc_pkweqv	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_pkweqv	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_snowcov	1: IndianCreek
  # subinc_snowcov	2: SanAntonioCreekAtIndianCreekRd
  # subinc_snowcov	3: ArroyoHondo
  # subinc_snowcov	4: SanAntonioCreek
  # subinc_snowcov	5: CalaverasCreek
  # subinc_snowcov	6: AlamedaCreekAboveACDD
  # subinc_snowcov	7: AlamedaCreekBelowACDD
  # subinc_snowcov	8: AlamedaCreekBelowCalaverasCreek
  # subinc_snowcov	9: AlamedaCreekBelowWelchCreek
  # subinc_snowcov	10: AlamedaCreekNearNiles
  # subinc_snowcov	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_snowcov	12: AlamedaCreekAboveArroyoDeLaLaguna
  # subinc_snowmelt	1: IndianCreek
  # subinc_snowmelt	2: SanAntonioCreekAtIndianCreekRd
  # subinc_snowmelt	3: ArroyoHondo
  # subinc_snowmelt	4: SanAntonioCreek
  # subinc_snowmelt	5: CalaverasCreek
  # subinc_snowmelt	6: AlamedaCreekAboveACDD
  # subinc_snowmelt	7: AlamedaCreekBelowACDD
  # subinc_snowmelt	8: AlamedaCreekBelowCalaverasCreek
  # subinc_snowmelt	9: AlamedaCreekBelowWelchCreek
  # subinc_snowmelt	10: AlamedaCreekNearNiles
  # subinc_snowmelt	11: AlamedaCreekAboveSanAntonioCreek
  # subinc_snowmelt	12: AlamedaCreekAboveArroyoDeLaLaguna
  
  # In the future, the simplest way to add on additional outputs to the 
  # statvar file (and therefore to the plotting performed by this script)
  # is to add on the new output variables to the end of the list above, 
  # without changing the order of the variables above.  This way, none 
  # of the indices in the existing script will need to be changed.
  
  
  ### read in data #########################################################
  
  # read in statvar file
  filePath <- paste0("./gsflow/output/prms/", runFolder, "/statvar.csv")
  statvarReadIn <- read.csv(filePath, header=FALSE, 
                            na.strings="-999", stringsAsFactors=FALSE)
  
  
  # read in gauged precipitation 
  gaugedPrecipReadIn<- read.csv("./calibration_data/alameda_data_20170216_precip.csv", header=TRUE, 
                                na.strings="-999", stringsAsFactors=FALSE)
  
  
  # read in outputs from new subbasin module
  folderPath <- paste0("./gsflow/output/prms/", runFolder, "/nsubOutVar")
  filenames <- list.files(path = folderPath, pattern="*.csv")
  filenamesPath <- paste("./gsflow/output/prms/", runFolder, "/nsubOutVar/", filenames, sep="")
  subbasinVar = lapply(filenamesPath, read.csv, header=TRUE)
  
  # extract variable names from filenames
  variableNamesTmp <- sapply(filenames, strsplit, split="\\.")
  subbasinVarNames <- as.character(sapply(variableNamesTmp, "[[",2))
  
  # assign subbasin names
  subbasinNames <- c("IndianCreek", 
                     "SanAntonioCreekAtIndianCreekRd",
                     "ArroyoHondo",	
                     "SanAntonioCreek",	
                     "CalaverasCreek",
                     "AlamedaCreekAboveACDD",	
                     "AlamedaCreekBelowACDD",
                     "AlamedaCreekBelowCalaverasCreek",
                     "AlamedaCreekBelowWelchCreek",
                     "AlamedaCreekNearNiles",
                     "AlamedaCreekAboveSanAntonioCreek",
                     "AlamedaCreekAboveArroyoDeLaLaguna")
  
  subbasinNamesPretty <- c("Indian Creek", 
                           "San Antonio Creek At Indian Creek Rd",
                           "Arroyo Hondo",	
                           "San Antonio Creek",	
                           "Calaveras Creek",
                           "Alameda Creek Above ACDD",	
                           "Alameda Creek Below ACDD",
                           "Alameda Creek Below Calaveras Creek",
                           "Alameda Creek Below Welch Creek",
                           "Alameda Creek Near Niles",
                           "Alameda Creek Above San Antonio Creek",
                           "Alameda Creek Above Arroyo De La Laguna")
  
  
  ### reorganize data ###########################################
  
  # set statvar headers aside
  numVar <- as.numeric(statvarReadIn[1,1])
  numHeaderLines <- numVar + 1
  headerLines <- statvarReadIn[ (1:numHeaderLines), (1:2) ]
  statvar <- statvarReadIn[ (numHeaderLines+1): nrow(statvarReadIn), ]
  
  # asssign column names
  names(statvar) <- c("row",
                      "year",
                      "month",
                      "day",
                      "hour",
                      "minute",
                      "second",
                      "IndianCreek", 
                      "SanAntonioCreekAtIndianCreekRd",
                      "ArroyoHondo",	
                      "SanAntonioCreek",	
                      "CalaverasCreek",
                      "AlamedaCreekAboveACDD",	
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles",
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",	
                      "WatershedExit",
                      "IndianCreek", 
                      "SanAntonioCreekAtIndianCreekRd",
                      "ArroyoHondo",	
                      "SanAntonioCreek",	
                      "CalaverasCreek",
                      "AlamedaCreekAboveACDD",	
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles",
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "ArroyoDeLaLagunaAtVerona", 
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna",
                      "IndianCreek",
                      "SanAntonioCreekAtIndianCreekRd",	
                      "ArroyoHondo",
                      "SanAntonioCreek", 
                      "CalaverasCreek", 
                      "AlamedaCreekAboveACDD", 
                      "AlamedaCreekBelowACDD",
                      "AlamedaCreekBelowCalaverasCreek",
                      "AlamedaCreekBelowWelchCreek",
                      "AlamedaCreekNearNiles", 
                      "AlamedaCreekAboveSanAntonioCreek",
                      "AlamedaCreekAboveArroyoDeLaLaguna")
  
  
  # create datetime column
  # need to change date column to pacific time zone
  date <- as.Date(ISOdatetime(statvar$year, statvar$month, statvar$day, 
                              statvar$hour, statvar$minute, statvar$second, 
                              tz="UTC"))
  
  # create YMDHMS data frame
  ymdhms <- statvar[,2:7]
  
  # pull out individual statvar variables, add date in
  sub_cfs <- cbind(date, statvar[,2:19])  # units: cfs
  basin_cfs <- cbind(date, statvar[,20])  # units: cfs
  runoff <- cbind(date, statvar[,c(2:7,21:33)])   # units: cfs
  subinc_precip <- cbind(date, statvar[, c(2:7,34:45)])   # units: inches
  subinc_wb <- cbind(date, statvar[, c(2:7,46:57)])     # units: cfs
  subinc_deltastor <- cbind(date, statvar[, c(2:7,58:69)])   # units: cfs
  subinc_actet <- cbind(date, statvar[, c(2:7,70:81)])    # units: inches
  subinc_potet <- cbind(date, statvar[, c(2:7,82:93)])    # units: inches
  subinc_swrad <- cbind(date, statvar[, c(2:7,94:105)])   # units: Langleys = J / m^2
  sub_inq <- cbind(date, statvar[, c(2:7,106:117)])      # units: cfs
  subinc_interflow <- cbind(date, statvar[, c(2:7,118:129)])      # units: cfs
  sub_interflow <- cbind(date, statvar[, c(2:7,130:141)])      # units: cfs
  subinc_sroff <- cbind(date, statvar[, c(2:7,142:153)])      # units: cfs
  sub_sroff <- cbind(date, statvar[, c(2:7,154:165)])      # units: cfs
  subinc_gwflow <- cbind(date, statvar[, c(2:7,166:177)])      # units: cfs
  sub_gwflow <- cbind(date, statvar[, c(2:7,178:189)])      # units: cfs
  subinc_tavgc <- cbind(date, statvar[, c(2:7,190:201)])      # units: degrees Celsius
  subinc_tmaxc <- cbind(date, statvar[, c(2:7,202:213)])      # units: degrees Celsius
  subinc_tminc <- cbind(date, statvar[, c(2:7,214:225)])      # units: degrees Celsius
  subinc_pkweqv <- cbind(date, statvar[, c(2:7,226:237)])      # units: inches
  subinc_snowcov <- cbind(date, statvar[, c(2:7,238:249)])      # units: decimal fraction
  subinc_snowmelt <- cbind(date, statvar[, c(2:7,250:261)])      # units: inches
  
  
  
  ### add date column into subbasinVar and gaugedPrecipReadIn ###################################
  
  # subbasinVar
  for (i in 1: length(subbasinVar)){
    
    subbasinVar[[i]] <- cbind(subbasinVar[[i]][,1], ymdhms, subbasinVar[[i]][,2:13])
    names(subbasinVar[[i]]) <- c("date", "year", "month", "day", "hour", "minute", "second", 
                                 subbasinNames)
    
  }
  
  #gaugedPrecip
  gaugedPrecip <- cbind(date, gaugedPrecipReadIn)
  
  
  
  
  ### put all variables in a list ##############################################################
  
  allVarSubbasin <- c( list( sub_cfs, 
                     runoff[,1:19],
                     subinc_precip,
                     subinc_wb,
                     subinc_deltastor,
                     subinc_actet,
                     subinc_potet,
                     subinc_swrad,
                     sub_inq,
                     subinc_interflow,
                     sub_interflow,
                     subinc_sroff,
                     sub_sroff,
                     subinc_gwflow,
                     sub_gwflow,
                     subinc_tavgc,
                     subinc_tmaxc,
                     subinc_tminc,
                     subinc_pkweqv,
                     subinc_snowcov,
                     subinc_snowmelt), 
               subbasinVar)
  
  allVarNames <- c("sub_cfs", "runoff", "subinc_precip", "subinc_wb",
                   "subinc_deltastor", "subinc_actet", "subinc_potet", "subinc_swrad",
                   "sub_inq", "subinc_interflow", "sub_interflow", "subinc_sroff", 
                   "sub_sroff", "subinc_gwflow", "sub_gwflow", "subinc_tavgc", "subinc_tmaxc", "subinc_tminc",
                   "subinc_pkweqv", "subinc_snowcov", "subinc_snowmelt", subbasinVarNames)
  
  names(allVarSubbasin) <- allVarNames
  
  
  
  
  ### create allVarSubbasin_hyd from allVarSubbasin ##############################################################
  
  
  # create hydYear and hydMonth
  year <- allVarSubbasin[[1]][,2]
  hydYear <- year
  month <- allVarSubbasin[[1]][,3]
  hydMonth <- month
  for (i in 1:length(hydYear)){
    
    if ( (month[i] == 10) | (month[i] == 11) | (month[i] == 12)) {
      hydYear[i] <- year[i] + 1
    }
    
    if (month[i] == 10){
      hydMonth[i] <- 1
    }
    
    if (month[i] == 11){
      hydMonth[i] <- 2
    }
    
    if (month[i] == 12){
      hydMonth[i] <- 3
    }
    
    if (month[i] == 1){
      hydMonth[i] <- 4
    }
    
    if (month[i] == 2){
      hydMonth[i] <- 5
    }
    
    if (month[i] == 3){
      hydMonth[i] <- 6
    }
    
    if (month[i] == 4){
      hydMonth[i] <- 7
    }
    
    if (month[i] == 5){
      hydMonth[i] <- 8
    }
    
    if (month[i] == 6){
      hydMonth[i] <- 9
    }
    
    if (month[i] == 7){
      hydMonth[i] <- 10
    }
    
    if (month[i] == 8){
      hydMonth[i] <- 11
    }
    
    if (month[i] == 9){
      hydMonth[i] <- 12
    }
    
  }
  
  
  
  # create allVarSubbasin_hydYear and allVarSubbasin_hydYearMonth
  allVarSubbasin_hydYear <- allVarSubbasin
  allVarSubbasin_hydYearMonth <- allVarSubbasin
  for (i in 1:length(allVarSubbasin)){
    
    # hydYear
    allVarSubbasin_hydYear[[i]][,2] <- hydYear
    
    # hydYearMonth
    allVarSubbasin_hydYearMonth[[i]][,2] <- hydYear
    allVarSubbasin_hydYearMonth[[i]][,3] <- hydMonth
    
  }
  
  
  
  
  
  ### create gaugedPrecip_hyd from gaugedPrecip ###############################################
  
  
  # create gaugedPrecip_hydYear and gaugedPrecip_hydYearMonth 
  gaugedPrecip_hydYear <- gaugedPrecip
  gaugedPrecip_hydYearMonth <- gaugedPrecip
  
  # hydYear
  gaugedPrecip_hydYear[,2] <- hydYear
  
  # hydYearMonth
  gaugedPrecip_hydYearMonth[,2] <- hydYear
  gaugedPrecip_hydYearMonth[,3] <- hydMonth
  
  
  
  
  
  ### write data reformatting function ############################
  
  reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                      variableValue, typeValue, idVarsInput, castFormula, 
                                      idVarsOutput){
    
    # inputData = data frame of dates and variables
    # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
    #                        want to convert to volumes, if not, just set it to 1)
    # numDateCol = number of date columns
    # typeValue = either "simulated" or "measured" to place in a type column that is used 
    # for plotting subsets of the data later on
    # variableValue = either "precipitation" or "streamflow" to place in variable column that
    # is used for plotting subsets of the data later on
    # idVarsInput = name of variables to use as id.vars in first melt function
    # castFormula = formula to use for "formula" in dcast function
    # idVarsOutput = name of variables to use as id.vars in second melt function
    
    # first data column index
    firstDataColIdx <- numDateCol + 1
    
    # convert mean daily simulated cfs to daily volumes
    inputData[, firstDataColIdx:ncol(inputData)] <- 
      inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
    
    # calculate simulated [time frame] volumes
    meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                       variable.name = "site")
    castData <- dcast(meltedData, castFormula, fun.aggregate = sum, 
                      na.rm=TRUE)
    
    # reformat simulated [time frame] volumes
    variable = rep(variableValue, nrow(castData))
    type = rep(typeValue, nrow(castData))
    castData <- data.frame(year = castData[,1], variable=variable, type=type,
                           castData[,2:ncol(castData)])
    castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
    
    return(castDataMelt)
    
  }
  
  
  
  
  
  ## create watershed versions of allVarSubbasin, allVarSubbasin_hydYear, and allVarSubbasin_hydYearMonth ###############################
  
  
  # Each of the following watersheds consists of the listed subbasins (if watershed not listed, then 
  # watershed = subbasin):
  
  # San Antonio Creek (4): San Antonio Creek (4), 
  #                        San Antonio Creek at Indian Creek Rd (2), 
  #                        Indian Creek (1)
  # Calaveras Creek (5): Calaveras Creek (5), 
  #                      Arroyo Hondo (3)
  # Alameda Creek below ACDD (7): Alameda Creek below ACDD (7), 
  #                               Alameda Creek above ACDD (6)
  # Alameda Creek below Calaveras Creek (8): Alameda Creek below Calaveras Creek (8), 
  #                                          Calaveras Creek (5), 
  #                                          Arroyo Hondo (3),
  #                                          Alameda Creek below ACDD (7), 
  #                                          Alameda Creek above ACDD (6)
  # Alameda Creek below Welch Creek (9): Alameda Creek below Welch Creek (9),
  #                                      Alameda Creek below Calaveras Creek (8), 
  #                                      Calaveras Creek (5), 
  #                                      Arroyo Hondo (3),
  #                                      Alameda Creek below ACDD (7), 
  #                                      Alameda Creek above ACDD (6)
  # Alameda Creek upstream of San Antonio Creek (11): Alameda Creek upstream of San Antonio Creek (11),
  #                                                   Alameda Creek below Welch Creek (9),
  #                                                   Alameda Creek below Calaveras Creek (8), 
  #                                                   Calaveras Creek (5), 
  #                                                   Arroyo Hondo (3),
  #                                                   Alameda Creek below ACDD (7), 
  #                                                   Alameda Creek above ACDD (6)
  # Alameda Creek upstream of Arroyo de la Laguna (12): Alameda Creek upstream of Arroyo de la Laguna (12),
  #                                                     Alameda Creek upstream of San Antonio Creek (11),
  #                                                     Alameda Creek below Welch Creek (9),
  #                                                     Alameda Creek below Calaveras Creek (8), 
  #                                                     Calaveras Creek (5), 
  #                                                     Arroyo Hondo (3),
  #                                                     Alameda Creek below ACDD (7), 
  #                                                     Alameda Creek above ACDD (6),
  #                                                     San Antonio Creek (4), 
  #                                                     San Antonio Creek at Indian Creek Rd (2), 
  #                                                     Indian Creek (1)
  # Alameda Creek near Niles Creek (10): Alameda Creek near Niles Creek (10),
  #                                      Alameda Creek upstream of Arroyo de la Laguna (12),
  #                                      Alameda Creek upstream of San Antonio Creek (11),
  #                                      Alameda Creek below Welch Creek (9),
  #                                      Alameda Creek below Calaveras Creek (8), 
  #                                      Calaveras Creek (5), 
  #                                      Arroyo Hondo (3),
  #                                      Alameda Creek below ACDD (7), 
  #                                      Alameda Creek above ACDD (6),
  #                                      San Antonio Creek (4), 
  #                                      San Antonio Creek at Indian Creek Rd (2), 
  #                                      Indian Creek (1)

  
  
  
  
  
  # List of allVar variables and instructions for how to adjust them from subbasin values to watershed values
  # (if any calculations are necessary):
  # NOTE: when units are cfs, assuming no adjustment necessary
  
  # 1) sub_cfs: - 
  # 2) runoff: - 
  # 3) subinc_precip (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 4) subinc_wb: - 
  # 5) subinc_deltastor (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 6) subinc_actet (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 7) subinc_potet (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 8) subinc_swrad (langleys): convert langleys to J/m^2 (1 Langley = 41840 J/m^2), convert m^2 to ft^2, multiply by subbasin area, add up Joules for all contributing subbasins
  # 9) sub_inq: -
  # 10) subinc_interflow: - 
  # 11) sub_interflow: -
  # 12) subinc_sroff: - 
  # 13) sub_sroff: -
  # 14) subinc_gwflow: -
  # 15) sub_gwflow: -
  # 16) subinc_tavgc (celsius): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  # 17) subinc_tmaxc (celsius): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  # 18) subinc_tminc (celsius): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  # 19) subinc_pkweqv (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 20) subinc_snowcov (decimal fraction): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  # 21) subinc_snowmelt (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 22) dunnian_flow (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 23) gwres_flow (inches):  multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 24) gwres_sink (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 25) gwres_stor (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 26) hortonian_flow (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 27) hru_actet (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 28) hru_intcpstor (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 29) hru_ppt (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 30) hru_rain (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 31) hru_storage (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 32) potet (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 33) pref_flow (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 34) recharge (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 35) slow_flow (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 36) slow_stor (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 37) soil_moist (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 38) soil_moist_tot (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 39) soil_rech (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 40) soil_to_gw (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 41) soil_to_ssr (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 42) ssr_to_gw (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 43) ssres_flow (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 44) ssres_stor (inches): multiply by subbasin area to get volume, add up volumes for all contributing subbasins
  # 45) swrad (langley): convert langleys to J/m^2 (1 Langley = 41840 J/m^2), convert m^2 to ft^2, multiply by subbasin area, add up Joules for all contributing subbasins
  # 46) tavgc (celsius): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  # 47) tavgf (fahrenheit): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  # 48) tmaxc (celsius): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  # 49) tmaxf (fahrenheit): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  # 50) tminc (celsius): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  # 51) tminf (fahrenheit): (calculate area-weighted mean over contributing subbasins) for each contributing subbasin, multiply by subbasin area, add up contributing subbasins, divide by (total area * number of contributing subbasins)
  
  
  
  
  
  ## create allVarWatershed ############################################
  
  
  # create vector of subbasin areas in square feet (in same order as siteNames)
  subbasinAreas <- c(183639662.433,
                     519000171.356,
                     2135840088.53,
                     390839981.924,
                     626560246.394,
                     932039752.807,
                     8800030.411188,
                     178279884,
                     269520211.269,
                     799520305.87,
                     132039704.767,
                     221680169.704)
  
  # set date and data columns
  dateCols <- c(1:7)
  numDateCol <- length(dateCols)
  firstDataCol <- numDateCol + 1
  lastDataCol <- numDateCol + 12
  
  # starting value for allVarWatershed
  allVarWatershed <- allVarSubbasin
  
  # loop through variables
  for (i in 1:length(allVarSubbasin)){
    
    # select df
    df <- allVarSubbasin[[i]]
    
    # if units in inches
    if (i %in% c(3,5,6,7,19,21:44)){
      
      # convert to feet and then multiply by subbasin area to get volume in ft^3
      df[,firstDataCol:lastDataCol] <- ( t(t(df[,firstDataCol:lastDataCol]) * subbasinAreas) ) * (1/12) 
      
      # add up volumes for all contributing subbasins
      df[,(numDateCol + 4)] <- df[,(numDateCol + 4)] + df[,(numDateCol + 2)] + df[,(numDateCol + 1)]
      df[,(numDateCol + 5)] <- df[,(numDateCol + 5)] + df[,(numDateCol + 3)] 
      df[,(numDateCol + 7)] <- df[,(numDateCol + 7)] + df[,(numDateCol + 6)] 
      df[,(numDateCol + 8)] <- df[,(numDateCol + 8)] + df[,(numDateCol + 5)] + df[,(numDateCol + 3)] + 
                               df[,(numDateCol + 7)] + df[,(numDateCol + 6)]
      df[,(numDateCol + 9)] <- df[,(numDateCol + 9)] + df[,(numDateCol + 8)] + df[,(numDateCol + 5)] + 
                               df[,(numDateCol + 3)] + df[,(numDateCol + 7)] + df[,(numDateCol + 6)]
      df[,(numDateCol + 11)] <- df[,(numDateCol + 11)] + df[,(numDateCol + 9)] + df[,(numDateCol + 8)] + 
                                df[,(numDateCol + 5)] + df[,(numDateCol + 3)] + df[,(numDateCol + 7)] +
                                df[,(numDateCol + 6)]
      df[,(numDateCol + 12)] <- df[,(numDateCol + 12)] + df[,(numDateCol + 11)] + df[,(numDateCol + 9)] + 
                                df[,(numDateCol + 8)] + df[,(numDateCol + 5)] + df[,(numDateCol + 3)] +
                                df[,(numDateCol + 7)] + df[,(numDateCol + 6)] + df[,(numDateCol + 4)] +
                                df[,(numDateCol + 2)] + df[,(numDateCol + 1)]
      df[,(numDateCol + 10)] <- df[,(numDateCol + 10)] + df[,(numDateCol + 12)] + df[,(numDateCol + 11)] + 
                                df[,(numDateCol + 9)] + df[,(numDateCol + 8)] + df[,(numDateCol + 5)] +
                                df[,(numDateCol + 3)] + df[,(numDateCol + 7)] + df[,(numDateCol + 6)] +
                                df[,(numDateCol + 4)] + df[,(numDateCol + 2)] + df[,(numDateCol + 1)]
      
    }

    
    # if units in langley
    if (i %in% c(8,45)){
      
      # convert langleys to J/ft^2 (1 Langley = 41840 J/m^2 * ((1 m^2)/10.7639 ft^2))
      df[,firstDataCol:lastDataCol] <- df[,firstDataCol:lastDataCol] * 41840 * (1/10.7639)
      
      # multiply by subbasin area
      df[,firstDataCol:lastDataCol] <- ( t(t(df[,firstDataCol:lastDataCol]) * subbasinAreas) ) 
      
      # add up Joules for all contributing subbasins
      df[,(numDateCol + 4)] <- df[,(numDateCol + 4)] + df[,(numDateCol + 2)] + df[,(numDateCol + 1)]
      df[,(numDateCol + 5)] <- df[,(numDateCol + 5)] + df[,(numDateCol + 3)] 
      df[,(numDateCol + 7)] <- df[,(numDateCol + 7)] + df[,(numDateCol + 6)] 
      df[,(numDateCol + 8)] <- df[,(numDateCol + 8)] + df[,(numDateCol + 5)] + df[,(numDateCol + 3)] + 
        df[,(numDateCol + 7)] + df[,(numDateCol + 6)]
      df[,(numDateCol + 9)] <- df[,(numDateCol + 9)] + df[,(numDateCol + 8)] + df[,(numDateCol + 5)] + 
        df[,(numDateCol + 3)] + df[,(numDateCol + 7)] + df[,(numDateCol + 6)]
      df[,(numDateCol + 11)] <- df[,(numDateCol + 11)] + df[,(numDateCol + 9)] + df[,(numDateCol + 8)] + 
        df[,(numDateCol + 5)] + df[,(numDateCol + 3)] + df[,(numDateCol + 7)] +
        df[,(numDateCol + 6)]
      df[,(numDateCol + 12)] <- df[,(numDateCol + 12)] + df[,(numDateCol + 11)] + df[,(numDateCol + 9)] + 
        df[,(numDateCol + 8)] + df[,(numDateCol + 5)] + df[,(numDateCol + 3)] +
        df[,(numDateCol + 7)] + df[,(numDateCol + 6)] + df[,(numDateCol + 4)] +
        df[,(numDateCol + 2)] + df[,(numDateCol + 1)]
      df[,(numDateCol + 10)] <- df[,(numDateCol + 10)] + df[,(numDateCol + 12)] + df[,(numDateCol + 11)] + 
        df[,(numDateCol + 9)] + df[,(numDateCol + 8)] + df[,(numDateCol + 5)] +
        df[,(numDateCol + 3)] + df[,(numDateCol + 7)] + df[,(numDateCol + 6)] +
        df[,(numDateCol + 4)] + df[,(numDateCol + 2)] + df[,(numDateCol + 1)]
      
    }
        
    
    # if units in celsius, fahrenheit, or decimal fraction
    # calculate area-weighted mean over contributing subbasins
    if (i %in% c(16,17,18,20,46:51)){

      # for each contributing subbasin, multiply by subbasin area
      df[,firstDataCol:lastDataCol] <- ( t(t(df[,firstDataCol:lastDataCol]) * subbasinAreas) )
      
      # add up contributing subbasins and divide by total contributing area
      df[,(numDateCol + 4)] <- (df[,(numDateCol + 4)] + df[,(numDateCol + 2)] + df[,(numDateCol + 1)]) / 
        sum(subbasinAreas[c(4,2,1)]) 
     
       df[,(numDateCol + 5)] <- (df[,(numDateCol + 5)] + df[,(numDateCol + 3)]) / sum(subbasinAreas[c(5,3)]) 
      
      df[,(numDateCol + 7)] <- (df[,(numDateCol + 7)] + df[,(numDateCol + 6)]) / sum(subbasinAreas[c(7,6)]) 
      
      df[,(numDateCol + 8)] <- (df[,(numDateCol + 8)] + df[,(numDateCol + 5)] + df[,(numDateCol + 3)] + 
        df[,(numDateCol + 7)] + df[,(numDateCol + 6)]) / sum(subbasinAreas[c(8,5,3,7,6)]) 
      
      df[,(numDateCol + 9)] <- (df[,(numDateCol + 9)] + df[,(numDateCol + 8)] + df[,(numDateCol + 5)] + 
        df[,(numDateCol + 3)] + df[,(numDateCol + 7)] + df[,(numDateCol + 6)]) / 
        sum(subbasinAreas[c(9,8,5,3,7,6)]) 
      
      df[,(numDateCol + 11)] <- (df[,(numDateCol + 11)] + df[,(numDateCol + 9)] + df[,(numDateCol + 8)] + 
        df[,(numDateCol + 5)] + df[,(numDateCol + 3)] + df[,(numDateCol + 7)] + df[,(numDateCol + 6)]) / 
        sum(subbasinAreas[c(11,9,8,5,3,7,6)]) 
        
      df[,(numDateCol + 12)] <- (df[,(numDateCol + 12)] + df[,(numDateCol + 11)] + df[,(numDateCol + 9)] + 
        df[,(numDateCol + 8)] + df[,(numDateCol + 5)] + df[,(numDateCol + 3)] +
        df[,(numDateCol + 7)] + df[,(numDateCol + 6)] + df[,(numDateCol + 4)] +
        df[,(numDateCol + 2)] + df[,(numDateCol + 1)]) / sum(subbasinAreas[c(12,11,9,8,5,3,7,6,4,2,1)])
      
      df[,(numDateCol + 10)] <- (df[,(numDateCol + 10)] + df[,(numDateCol + 12)] + df[,(numDateCol + 11)] + 
        df[,(numDateCol + 9)] + df[,(numDateCol + 8)] + df[,(numDateCol + 5)] +
        df[,(numDateCol + 3)] + df[,(numDateCol + 7)] + df[,(numDateCol + 6)] +
        df[,(numDateCol + 4)] + df[,(numDateCol + 2)] + df[,(numDateCol + 1)]) / 
        sum(subbasinAreas[c(10,12,11,9,8,5,3,7,6,4,2,1)])
      

    }
      
    
    # set allVarWatershed[[i]]
    allVarWatershed[[i]] <- df
    
    
  }
  
  
  
  
  # create allVarWatershed_hydYear and allVarWatershed_hydYearMonth
  allVarWatershed_hydYear <- allVarWatershed
  allVarWatershed_hydYearMonth <- allVarWatershed
  for (i in 1:length(allVarWatershed)){
    
    # hydYear
    allVarWatershed_hydYear[[i]][,2] <- hydYear
    
    # hydYearMonth
    allVarWatershed_hydYearMonth[[i]][,2] <- hydYear
    allVarWatershed_hydYearMonth[[i]][,3] <- hydMonth
    
  }
  
  
  
  
  
  ##############################################################################################
  # 1) Plot for each subbasin: watershed average annual precipitation total, gauged average
  # annual precipitation total
  ##############################################################################################
  
  if (plots_OnOff[1] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    # reformat subinc_precip_hyd for plotting annual totals
    inputData <- allVar_hydYearMonth$subinc_precip
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "precipitation"
    typeValue="watershed"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    subinc_precip_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                             numDateCol, variableValue, typeValue, 
                                                             idVarsInput, castFormula, idVarsOutput)
    
    
    # reformat gaugedPrecip_hyd for plotting annual totals
    inputData <- gaugedPrecip_hydYearMonth
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue = "precipitation"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year", "variable", "type")
    gaugedPrecip_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                            numDateCol, variableValue, typeValue, 
                                                            idVarsInput, castFormula, idVarsOutput)
    
    
    # calculate average annual total for subinc_precip_hyd_annual_melt
    subinc_precip_hyd_annual_melt_mean <- dcast(subinc_precip_hyd_annual_melt, 
                                                variable + type + site ~ ., 
                                                fun.aggregate = mean)
    
    
    # calculate average annual total for gaugedPrecip_hyd_annual_melt
    gaugedPrecip_hyd_annual_melt_mean <- dcast(gaugedPrecip_hyd_annual_melt, 
                                               variable + type + site ~ ., 
                                               fun.aggregate = mean)
    
    # need to plot these together similar to the way the other two precip values are plotted together
    # below
    
    
    # export to csv
    write.csv(subinc_precip_hyd_annual_melt, file= paste0("./R_outputs/", runFolder, "/tables/subinc_precip_hyd_annual_melt.csv"), row.names=FALSE)
    write.csv(gaugedPrecip_hyd_annual_melt, file= paste0("./R_outputs/", runFolder, "/tables/gaugedPrecip_hyd_annual_melt.csv"), row.names=FALSE)
    write.csv(subinc_precip_hyd_annual_melt_mean, file= paste0("./R_outputs/", runFolder, "/tables/subinc_precip_hyd_annual_melt_mean.csv"), row.names=FALSE)
    write.csv(gaugedPrecip_hyd_annual_melt_mean, file= paste0("./R_outputs/", runFolder, "/tables/gaugedPrecip_hyd_annual_melt_mean.csv"), row.names=FALSE)
    
  }
  
  
  
  
  
  ##############################################################################################
  # 2) Plot for each subbasin: distributed monthly precipitation, gauged monthly precipitation
  ##############################################################################################
  
  # ideally would calculate what percentage of each subbasin comes from which gauges and then 
  # plot this hybrid "gauge" along with the subbasin precip
  
  # second best (Which is what I'm doing) would be to plot the two or three gauges that are 
  # in each subbasin along with that subbasin's precip - then the subbasin precip needs to be 
  # between the gauged precips.
  
  # here is a list of the gauges within each subbasin (with the gauges listed in the order of
  # the amount of area they cover in the subbasin - from most to least):
  
  # Arroyo Hondo: Mount Hamilton, Calaveras
  # Alameda Creek above ACDD: Calaveras, Mount Hamilton
  # Indian Creek: Calaveras, San Antonio, Alameda East, Calaveras
  # San Antonio Creek at Indian Creek Rd: Calaveras, San Antonio
  # San Antonio CreeK: San Antonio, Alameda East
  # Alameda Creek near Niles: Sunol, San Antonio
  # Alameda Creek upstream of Arroyo de la Laguna: Sunol, Alameda East, San Antonio
  # Alameda Creek upstream of San Antonio Creek: Alameda East
  # Alameda Creek below Welch Creek: Alameda East, Calaveras
  # Alameda Creek below Calaveras Creek: Calaveras
  # Alameda Creek below ACDD: Calaveras
  # Calaveras Creek: Calaveras
  
  
  
  if (plots_OnOff[2] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    # reformat gaugedPrecip_hyd for plotting monthly totals
    inputData <- gaugedPrecip_hydYearMonth
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue = "precipitation"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    gaugedPrecip_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                             numDateCol, variableValue, typeValue, 
                                                             idVarsInput, castFormula, idVarsOutput)
    gaugedPrecip_hyd_monthly_melt$month <- as.factor(gaugedPrecip_hyd_monthly_melt$month)
    
    
    # reformat subinc_precip_hyd for plotting monthly totals
    inputData <- allVar_hydYearMonth$subinc_precip
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue = "precipitation"
    typeValue="estimated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    subinc_precip_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                              numDateCol, variableValue, typeValue, 
                                                              idVarsInput, castFormula, idVarsOutput)
    subinc_precip_hyd_monthly_melt$month <- as.factor(subinc_precip_hyd_monthly_melt$month)
    
    
    # rbind subinc_precip_hyd_monthly_melt and gaugedPrecip_hyd_monthly_melt
    allPrecipHyd <- rbind(subinc_precip_hyd_monthly_melt, gaugedPrecip_hyd_monthly_melt)
    
    # convert site names to the site names that you want in the plot legend
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "IndianCreek"] <- "Indian Creek subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "SanAntonioCreekAtIndianCreekRd"] <- "San Antonio Creek at Indian Creek Rd subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "ArroyoHondo"] <- "Arroyo Hondo subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "SanAntonioCreek"] <- "San Antonio Creek subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "CalaverasCreek"] <- "Calaveras Creek subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "AlamedaCreekAboveACDD"] <- "Alameda Creek above ACDD subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "AlamedaCreekBelowACDD"] <- "Alameda Creek below ACDD subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "AlamedaCreekBelowCalaverasCreek"] <- "Alameda Creek below Calaveras Creek subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "AlamedaCreekBelowWelchCreek"] <- "Alameda Creek below Welch Creek subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "AlamedaCreekNearNiles"] <- "Alameda Creek near Niles subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "AlamedaCreekAboveSanAntonioCreek"] <- "Alameda Creek above San Antonio Creek subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "AlamedaCreekAboveArroyoDeLaLaguna"] <- "Alameda Creek above Arroyo de la Laguna subbasin"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "SanAntonio"] <- "San Antonio gauge"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "MountHamilton"] <- "Mount Hamilton gauge"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "AlamedaEast"] <- "Alameda East gauge"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "Calaveras"] <- "Calaveras gauge"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "RosePeak"] <- "Rose Peak gauge"
    levels(allPrecipHyd$site)[levels(allPrecipHyd$site) %in% "Sunol"] <- "Sunol gauge"
    
    
    
    ### plot allPrecipHyd monthly totals for each subbasin ###################################
    
    # Arroyo Hondo: Mount Hamilton, Calaveras
    # Alameda Creek above ACDD: Calaveras, Mount Hamilton
    # Indian Creek: Calaveras, San Antonio, Alameda East, Calaveras
    # San Antonio Creek at Indian Creek Rd: Calaveras, San Antonio
    # San Antonio CreeK: San Antonio, Alameda East
    # Alameda Creek near Niles: Sunol, San Antonio
    # Alameda Creek upstream of Arroyo de la Laguna: Sunol, Alameda East, San Antonio
    # Alameda Creek upstream of San Antonio Creek: Alameda East
    # Alameda Creek below Welch Creek: Alameda East, Calaveras
    # Alameda Creek below Calaveras Creek: Calaveras
    # Alameda Creek below ACDD: Calaveras
    # Calaveras Creek: Calaveras
    
    
    # create list of subsetted allPrecips (one per subbasin)
    
    allPrecipHydSubset <- list()
    allPrecipHydSubset[[1]] <- subset(allPrecipHyd, site %in% c('Arroyo Hondo subbasin', 'Mount Hamilton gauge',
                                                                'Calaveras gauge'))
    allPrecipHydSubset[[2]] <- subset(allPrecipHyd, site %in% c('Alameda Creek above ACDD subbasin', 'Calaveras gauge'))
    allPrecipHydSubset[[3]] <- subset(allPrecipHyd, site %in% c('Indian Creek subbasin', 
                                                                'San Antonio gauge', 'Alameda East gauge',
                                                                'Calaveras gauge'))
    allPrecipHydSubset[[4]] <- subset(allPrecipHyd, site %in% c('San Antonio Creek at Indian Creek Rd subbasin', 
                                                                'San Antonio gauge'))
    allPrecipHydSubset[[5]] <- subset(allPrecipHyd, site %in% c('San Antonio Creek subbasin', 
                                                                'San Antonio gauge', 'Alameda East gauge'))
    allPrecipHydSubset[[6]] <- subset(allPrecipHyd, site %in% c('Alameda Creek near Niles subbasin', 
                                                                'Sunol gauge', 'San Antonio gauge'))
    allPrecipHydSubset[[7]] <- subset(allPrecipHyd, site %in% c('Alameda Creek above Arroyo de la Laguna subbasin', 
                                                                'Sunol gauge', 'Alameda East gauge', 'San Antonio gauge'))
    allPrecipHydSubset[[8]]<- subset(allPrecipHyd, site %in% c('Alameda Creek above San Antonio Creek subbasin', 
                                                               'Alameda East gauge'))
    allPrecipHydSubset[[9]] <- subset(allPrecipHyd, site %in% c('Alameda Creek below Welch Creek subbasin', 
                                                                'Alameda East gauge', 'Calaveras gauge'))
    allPrecipHydSubset[[10]] <- subset(allPrecipHyd, site %in% c('Alameda Creek below Calaveras Creek subbasin', 
                                                                 'Calaveras gauge'))
    allPrecipHydSubset[[11]] <- subset(allPrecipHyd, site %in% c('Alameda Creek below ACDD subbasin', 
                                                                 'Calaveras gauge'))
    allPrecipHydSubset[[12]] <- subset(allPrecipHyd, site %in% c('Calaveras Creek subbasin', 
                                                                 'Calaveras gauge'))
    
    
    for (i in 1:length(allPrecipHydSubset)){
      
      filename <- paste0("./R_outputs/", runFolder, "/plots/precipDistributedHyd_precipGaugedHyd_0",i, ".jpg")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 10, 
           units = "in", quality = 75, res = 300)
      
      # plot
      allPrecipSubsetPlot <- ggplot(data=allPrecipHydSubset[[i]], aes(month, value)) + 
        geom_bar(aes(fill=site), position ="dodge", stat="identity") + 
        ylab("Precipitation (inches)") +
        xlab("Hydrologic month") +
        ggtitle("Subbasin vs. gauged monthly precipitation per hydrologic year\n") +
        guides(fill=guide_legend(title=NULL)) +
        facet_wrap(facets= ~ year, nrow = 5, ncol = 4, scales="free")
      
      # print plot
      print(allPrecipSubsetPlot)
      
      # close plotting device
      dev.off()
      
    }
    
    
    
  }
  
  
  
  
  ##############################################################################################
  # 3) Plot for each subbasin: distributed annual precipitation, annual measured streamflow 
  #    volume, annual simulated streamflow volume 
  ##############################################################################################
  
  
  
  if (plots_OnOff[3] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    # reformat subinc_precip_hyd for plotting annual totals
    inputData <- allVar_hydYearMonth$subinc_precip[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "precipitation"
    typeValue="watershed"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    subinc_precip_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                             numDateCol, variableValue, typeValue, 
                                                             idVarsInput, castFormula, idVarsOutput)
    
    
    #reformat sub_cfs_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_cfs_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue,typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    
    
    #reformat runoff_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    runoff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                      numDateCol, variableValue, typeValue, 
                                                      idVarsInput, castFormula, idVarsOutput)
    
    
    
    
    # place distributed precip, simulated streamflow, and measured streamflow in the same 
    # data frame
    annualTotalHyd <- rbind(subinc_precip_hyd_annual_melt, sub_cfs_hyd_annual_melt, runoff_hyd_annual_melt)
    
    
    # create vector of site names
    siteNames <- unique(annualTotalHyd$site)
    
    
    # create an empty list to subset into 
    annualTotalHydSubset <- list()
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # subset
      annualTotalHydSubset[[i]] <- subset(annualTotalHyd, site %in% siteNames[i])
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/annualTotal_precipDistributedHyd_simulatedStreamflowHyd_measuredStreamflowHyd_0",i, 
                         ".jpg")
      
      plotTitle <- paste0(siteNames[i], ": annual distributed precipitation, simulated vs. measured streamflow volume\n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 10, 
           units = "in", quality = 75, res = 300)  
      
      # plot
      annualTotalHydSubsetPlot <- ggplot(data=annualTotalHydSubset[[i]], aes(year, value)) + 
        geom_bar(aes(fill=type), position = "dodge", stat="identity") + 
        ylab("Precip (in.) or streamflow (ft^3)") +
        xlab("Hydrologic year") + 
        ggtitle(plotTitle) +
        facet_wrap(facets = ~ variable, nrow = 2, scales="free")
      
      # print plot
      print(annualTotalHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
    }
    
  }
  
  
  
  
  ##############################################################################################
  # 4) Plot for each subbasin: annual measured streamflow volume, annual simulated streamflow 
  #    volume in acre-ft
  ##############################################################################################
  
  if (plots_OnOff[4] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    #reformat sub_cfs_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_cfs_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue,typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_cfs_hyd_annual_melt$value <- sub_cfs_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat runoff_hyd for plotting annual volume
    inputData <-  allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    runoff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                      numDateCol, variableValue, typeValue, 
                                                      idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    runoff_hyd_annual_melt$value <- runoff_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    
    # place simulated streamflow and measured streamflow in the same data frame
    annualTotalHyd <- rbind(sub_cfs_hyd_annual_melt, runoff_hyd_annual_melt)
    
    
    # create vector of site names
    siteNames <- unique(annualTotalHyd$site)
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    # create an empty list to subset into 
    annualTotalHydSubset <- list()
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # subset
      annualTotalHydSubset[[i]] <- subset(annualTotalHyd, site %in% siteNames[i])
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/annualTotalAF_simulatedStreamflowHyd_measuredStreamflowHyd_0",i, 
                         ".jpg")
      
      plotTitle <- paste0(siteNamesForTitle[i], ": simulated vs. measured streamflow volume\n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # plot
      annualTotalHydSubsetPlot <- ggplot(data=annualTotalHydSubset[[i]], aes(year, value)) + 
        geom_bar(aes(fill=type), position = "dodge", stat="identity") + 
        ylab("Streamflow volume (acre-ft)\n") +
        xlab("\nHydrologic year") + 
        ggtitle(plotTitle) + 
        scale_x_continuous(breaks=seq(1996,2014,1)) + 
        guides(fill=guide_legend(title=NULL))
      
      
      # print plot
      print(annualTotalHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
    }
    
  }
  
  
  
  
  
  
  ##############################################################################################
  # 5) Plot for each subbasin: annual streamflow components as bar plots along with runoff
  #     (sub_gwflow, sub_interflow, sub_sroff, sub_cfs, runoff)
  ##############################################################################################
  
  
  if (plots_OnOff[5] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    #reformat sub_cfs_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "simulated streamflow"
    typeValue="unstack"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_cfs_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue,typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_cfs_hyd_annual_melt$value <- sub_cfs_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat runoff_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "observed streamflow"
    typeValue="unstack"
    idVarsInput <- c("date","year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    runoff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                      numDateCol, variableValue, typeValue, 
                                                      idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    runoff_hyd_annual_melt$value <- runoff_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat sub_gwflow_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_gwflow[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "groundwater flow"
    typeValue="stack"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_gwflow_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                          numDateCol, variableValue, typeValue, 
                                                          idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_gwflow_hyd_annual_melt$value <- sub_gwflow_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat sub_interflow_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_interflow[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "interflow"
    typeValue="stack"
    idVarsInput <- c("date","year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_interflow_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                             numDateCol, variableValue, typeValue, 
                                                             idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_interflow_hyd_annual_melt$value <- sub_interflow_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat sub_sroff_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_sroff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "surface runoff"
    typeValue="stack"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_sroff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                         numDateCol, variableValue, typeValue, 
                                                         idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_sroff_hyd_annual_melt$value <- sub_sroff_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    # place all streamflow components in the same data frame
    annualTotalHyd <- rbind(runoff_hyd_annual_melt, sub_cfs_hyd_annual_melt, sub_gwflow_hyd_annual_melt,
                            sub_interflow_hyd_annual_melt, sub_sroff_hyd_annual_melt)
    
    
    # create vector of site names
    siteNames <- unique(annualTotalHyd$site)
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    # create an empty list to subset into 
    annualTotalHydSubset <- list()
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # subset
      annualTotalHydSubset[[i]] <- subset(annualTotalHyd, site %in% siteNames[i])
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/annualTotalAF_streamflowComponents_0",i, 
                         ".jpg")
      
      plotTitle <- paste0(siteNamesForTitle[i], ": streamflow components \n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # plot
      annualTotalHydSubsetPlot <- ggplot() +
        geom_bar(data=annualTotalHydSubset[[i]], aes(year, value, fill=variable), position='dodge', stat='identity') + 
        ylab("Flow volume (acre-ft)\n") +
        xlab("\nHydrologic year") + 
        ggtitle(plotTitle) + 
        scale_x_continuous(breaks=seq(1996,2014,1)) + 
        guides(fill=guide_legend(title=NULL))  
      
      # print plot
      print(annualTotalHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
    }
    
  }
  
  
  
  
  
  ##############################################################################################
  # 6) Plot for each subbasin: daily streamflow components as line plots
  #     (sub_gwflow, sub_interflow, sub_sroff, sub_cfs, hortonian_flow, dunnian_flow)
  ##############################################################################################
  
  
  if (plots_OnOff[6] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    ## multiply hortonian_flow and dunnian_flow by subbasin area
    
    # create vector of subbasin areas in square feet (in same order as siteNames)
    subbasinAreas <- c(183639662.433,
                       519000171.356,
                       2135840088.53,
                       390839981.924,
                       626560246.394,
                       932039752.807,
                       8800030.411188,
                       178279884,
                       269520211.269,
                       799520305.87,
                       132039704.767,
                       221680169.704) 
    
    # create convertUnitsList
    convertUnitsList <- list(allVar$hortonian_flow, allVar$dunnian_flow)
    names(convertUnitsList) <- c("hortonian_flow", "dunnian_flow")
    
    # loop through variables
    for (j in 1:length(convertUnitsList)){
      
      df <- convertUnitsList[[j]]
      
      # loop through subbasin names
      for (i in 1:length(subbasinNames)){
        
        # find index
        idx <- which(names(df) %in% subbasinNames[i])
        
        # do conversion: multiply (in/day) * (subbasin area in ft^2) 
        df[,idx] <- df[,idx] * subbasinAreas[i]
        
      }
      
      convertUnitsList[[j]] <- df
      
    }
    
    
    
    #reformat subinc_precip for daily plotting
    inputData <- allVar$subinc_precip[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "precipitation"
    typeValue="watershed"
    idVarsInput <- c("date","year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    subinc_precip_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                            numDateCol, variableValue, typeValue,  
                                                            idVarsInput, castFormula, idVarsOutput)
    
    
    #reformat sub_cfs for daily plotting
    inputData <- allVar$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "simulated streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    sub_cfs_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                      numDateCol, variableValue, typeValue,  
                                                      idVarsInput, castFormula, idVarsOutput)
    
    #reformat runoff for daily plotting
    inputData <- allVar$runoff[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "observed streamflow"
    typeValue="observed"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    runoff_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                     numDateCol, variableValue, typeValue,  
                                                     idVarsInput, castFormula, idVarsOutput)
    
    #reformat sub_gwflow for daily plotting
    inputData <- allVar$sub_gwflow[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "groundwater flow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    sub_gwflow_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                         numDateCol, variableValue, typeValue,  
                                                         idVarsInput, castFormula, idVarsOutput)
    
    #reformat sub_interflow for daily plotting
    inputData <- allVar$sub_interflow[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "interflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    sub_interflow_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                            numDateCol, variableValue, typeValue,  
                                                            idVarsInput, castFormula, idVarsOutput)
    
    
    #reformat sub_sroff for daily plotting
    inputData <- allVar$sub_sroff[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "surface runoff"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    sub_sroff_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                        numDateCol, variableValue, typeValue,  
                                                        idVarsInput, castFormula, idVarsOutput)
    
    
    # reformat hortonian_flow for daily plotting in cfs
    inputData <- convertUnitsList$hortonian_flow[,subbasinIdx]
    multiplicationFactor <- (1/12) * (1/86400)  #convert from (inches/day)*(ft^2) to cfs
    numDateCol <- 7
    variableValue <- "hortonian runoff"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    hortonian_flow_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                             numDateCol, variableValue, typeValue,  
                                                             idVarsInput, castFormula, idVarsOutput)
    
    
    
    
    
    # reformat dunnian_flow for daily plotting in cfs
    inputData <- convertUnitsList$dunnian_flow[,subbasinIdx]
    multiplicationFactor <- (1/12) * (1/86400)  #convert from (inches/day)*(ft^2) to cfs
    numDateCol <- 7
    variableValue <- "dunnian runoff"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    dunnian_flow_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                           numDateCol, variableValue, typeValue,  
                                                           idVarsInput, castFormula, idVarsOutput)
    
    
    
    
    
    # make one data frame of all data
    dailyFlowHyd <- rbind(subinc_precip_hyd_daily_melt, sub_cfs_hyd_daily_melt, runoff_hyd_daily_melt, 
                          sub_gwflow_hyd_daily_melt, sub_interflow_hyd_daily_melt, 
                          sub_sroff_hyd_daily_melt, hortonian_flow_hyd_daily_melt, dunnian_flow_hyd_daily_melt)
    
    
    
    
    # create hydrologic date 
    monthPrep <- formatC(dailyFlowHyd$month, width = 2, format = "d", flag = "0")
    dayPrep <- formatC(dailyFlowHyd$day, width = 2, format = "d", flag = "0")
    dateHydPrep <- paste0(dailyFlowHyd$year, monthPrep, dayPrep)
    dateHyd <- as.Date(dateHydPrep, format = "%Y%m%d")
    
    
    # cbind hydrologic date to data frame of all data
    dailyFlowHyd <- cbind(dateHyd, dailyFlowHyd)
    
    # # create new variable column that has the categories: 
    # # precipitation, simulated flow, observed flow
    # newVariableVec <- vector(mode="character", length=length(dailyFlowHyd$variable))
    # for (i in 1:length(newVariableVec)){
    #   
    #   if (dailyFlowHyd$variable[i] %in% "precipitation"){
    #     newVariableVec[i] <- "precipitation"
    #   }
    #   
    #   if (dailyFlowHyd$variable[i] %in% "streamflow" & dailyFlowHyd$type[i] %in% "simulated"){
    #     newVariableVec[i] <- "simulated flow"
    #   }
    #   
    #   if (dailyFlowHyd$variable[i] %in% "streamflow" & dailyFlowHyd$type[i] %in% "measured"){
    #     newVariableVec[i] <- "observed flow"
    #   }
    #   
    # }
    # dailyFlowHyd$variable <- newVariableVec
    
    
    # create hydrologic year for dailyFlowHyd
    hydMonth <- dailyFlowHyd$month
    hydYear <- dailyFlowHyd$year
    for (i in 1:length(hydYear)){
      
      if ( (dailyFlowHyd$month[i] == 10) | (dailyFlowHyd$month[i] == 11) | (dailyFlowHyd$month[i] == 12)) {
        hydYear[i] <- dailyFlowHyd$year[i] + 1
      }
    }
    dailyFlowHyd <- data.frame(dailyFlowHyd, hydYear=hydYear)
    
    
    
    
    # create separate data frame for each subbasin 
    siteNames <- unique(dailyFlowHyd$site)
    dailyFlowHydList <- list()
    for (i in 1:length(siteNames)){
      
      dailyFlowHydList[[i]] <- subset(dailyFlowHyd, dailyFlowHyd$site %in% siteNames[i])
      
    }
    
    
    # create wide format data frame for each subbasin
    dailyFlowHydWideList <- list()
    for (i in 1:length(siteNames)){
      
      dailyFlowHydWideList[[i]] <- dcast(dailyFlowHydList[[i]][,-6], 
                                         dateHyd + hydYear + year + month + day + site ~ variable)
      
    }
    
    
    
    # make line plot for each year-site combo with streamflow on primary y-axis and precip on 
    # secondary y-axis 
    
    # create vector of site names
    siteNames <- unique(dailyFlowHyd$site)
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    # plot daily data for entire study period
    for (i in 1:length(siteNames)){
      
      # select data frame for plotting
      dfPlot <- dailyFlowHydWideList[[i]]
      
      # calculate min and max flows
      minFlow <- min(dfPlot$`simulated streamflow`, dfPlot$`observed streamflow`, 
                     dfPlot$`groundwater flow`, dfPlot$interflow, dfPlot$`surface runoff`,
                     dfPlot$`hortonian runoff`, dfPlot$`dunnian runoff`)
      maxFlow <- max(dfPlot$`simulated streamflow`, dfPlot$`observed streamflow`, 
                     dfPlot$`groundwater flow`, dfPlot$interflow, dfPlot$`surface runoff`,
                     dfPlot$`hortonian runoff`, dfPlot$`dunnian runoff`)
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/dailyStudyPeriod_streamflowComponents_0",i, 
                         ".jpg")
      
      # set plot title
      plotTitle <- paste0(siteNamesForTitle[i], ": streamflow components\n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      
      # plot 
      par(mar=c(5,4,4,5) + 0.1)
      plot(x=dfPlot$dateHyd, y=dfPlot$`observed streamflow`, type="l", col="cornflowerblue", main=plotTitle, 
           xlab = "Hydrologic Date", ylab="Flow (cfs)", ylim=c(minFlow,maxFlow))
      lines(dfPlot$dateHyd, dfPlot$`simulated streamflow`, type="l", col="indianred2")
      lines(dfPlot$dateHyd, dfPlot$`surface runoff`, type="l", col="forestgreen")
      lines(dfPlot$dateHyd, dfPlot$`groundwater flow`, type="l", col="gold1")
      lines(dfPlot$dateHyd, dfPlot$interflow, type="l", col="darkorchid3")
      lines(dfPlot$dateHyd, dfPlot$`hortonian runoff`, type="l", lty=3, lwd=2, col="darkolivegreen")
      lines(dfPlot$dateHyd, dfPlot$`dunnian runoff`, type="l", lty=3, lwd=2, col="darkolivegreen3")
      par(new=TRUE)
      plot(dfPlot$dateHyd, dfPlot$precipitation, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
           ylab="", ylim=rev(range(dfPlot$precipitation)))
      axis(4)
      mtext("Precipitation (inches)", side=4, line=3)
      legend("topright", legend=c("observed streamflow", "simulated streamflow", "groundwater flow", 
                                  "interflow", "surface runoff", "hortonian runoff", "dunnian runoff", 
                                  "precipitation"), 
             col=c("cornflowerblue", "indianred2", "gold1", "darkorchid3", "forestgreen", 
                   "darkolivegreen", "darkolivegreen3",  "palegoldenrod"), 
             lty=c(1,1,1,1,1,3,3,3), lwd=3, bty="n")
      grid()
      
      
      
      # print plot
      #print(dailyPrecipStreamflowHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
    }
    
    
    
    
    
    # for each site: plot daily data for one year at a time
    for (i in 1:length(siteNames)){
      
      # select data frame for plotting
      dfPlot <- dailyFlowHydWideList[[i]]
      
      years <- unique(dfPlot$hydYear)
      
      for (j in 1:length(years)){
        
        dfPlotYr <- subset(dfPlot, dfPlot$hydYear == years[j])
        
        # calculate min and max flows
        minFlow <- min(dfPlotYr$`simulated streamflow`, dfPlotYr$`observed streamflow`, 
                       dfPlotYr$`groundwater flow`, dfPlotYr$interflow, dfPlotYr$`surface runoff`,
                       dfPlotYr$`hortonian runoff`, dfPlotYr$`dunnian runoff`)
        maxFlow <- max(dfPlotYr$`simulated streamflow`, dfPlotYr$`observed streamflow`, 
                       dfPlotYr$`groundwater flow`, dfPlotYr$interflow, dfPlotYr$`surface runoff`,
                       dfPlotYr$`hortonian runoff`, dfPlotYr$`dunnian runoff`)
        
        # set file name
        filename <- paste0("./R_outputs/", runFolder, "/plots/dailyEachYear_streamflowComponents_",siteNames[i],"_0",j, 
                           ".jpg")
        
        # set plot title
        plotTitle <- paste0(siteNamesForTitle[i], ", HY ", years[j], ": streamflow components\n")
        
        # open plotting device
        jpeg(filename=filename, width = 12, height = 8, 
             units = "in", quality = 75, res = 300)  
        
        
        # plot 
        par(mar=c(5,4,4,5) + 0.1)
        plot(x=dfPlotYr$dateHyd, y=dfPlotYr$`observed streamflow`, type="l", lwd=2, col="cornflowerblue", main=plotTitle, 
             xlab = "Date", ylab="Flow (cfs)", ylim=c(minFlow,maxFlow))
        lines(dfPlotYr$dateHyd, dfPlotYr$`simulated streamflow`, type="l", lwd=2, col="indianred2")
        lines(dfPlotYr$dateHyd, dfPlotYr$`surface runoff`, type="l", lwd=2, col="forestgreen")
        lines(dfPlotYr$dateHyd, dfPlotYr$`groundwater flow`, type="l", lwd=2, col="gold1")
        lines(dfPlotYr$dateHyd, dfPlotYr$interflow, type="l", lwd=2, col="darkorchid3")
        lines(dfPlotYr$dateHyd, dfPlotYr$`hortonian runoff`, type="l", lty=3, lwd=2, col="darkolivegreen")
        lines(dfPlotYr$dateHyd, dfPlotYr$`dunnian runoff`, type="l", lty=3, lwd=2, col="darkolivegreen3")
        par(new=TRUE)
        plot(dfPlotYr$dateHyd, dfPlotYr$precipitation, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
             ylab="", ylim=rev(range(dfPlotYr$precipitation)))
        axis(4)
        mtext("Precipitation (inches)", side=4, line=3)
        legend("topright", legend=c("observed streamflow", "simulated streamflow", "groundwater flow", 
                                    "interflow", "surface runoff", "hortonian runoff", "dunnian runoff", 
                                    "precipitation"), 
               col=c("cornflowerblue", "indianred2", "gold1", "darkorchid3", "forestgreen", 
                     "darkolivegreen", "darkolivegreen3",  "palegoldenrod"), 
               lty=c(1,1,1,1,1,3,3,3), lwd=3, bty="n")
        grid()
        
        # close plotting device
        dev.off()
        
      }
      
    }
    
    
    
    # for each site: plot daily data for one year at a time in log scale
    for (i in 1:length(siteNames)){
      
      # select data frame for plotting
      dfPlot <- dailyFlowHydWideList[[i]]
      
      years <- unique(dfPlot$hydYear)
      
      for (j in 1:length(years)){
        
        dfPlotYr <- subset(dfPlot, dfPlot$hydYear == years[j])
        
        # calculate min and max flows
        minFlow <- min(dfPlotYr$`simulated streamflow`, dfPlotYr$`observed streamflow`, 
                       dfPlotYr$`groundwater flow`, dfPlotYr$interflow, dfPlotYr$`surface runoff`,
                       dfPlotYr$`hortonian runoff`, dfPlotYr$`dunnian runoff`)
        maxFlow <- max(dfPlotYr$`simulated streamflow`, dfPlotYr$`observed streamflow`, 
                       dfPlotYr$`groundwater flow`, dfPlotYr$interflow, dfPlotYr$`surface runoff`,
                       dfPlotYr$`hortonian runoff`, dfPlotYr$`dunnian runoff`)
        
        # set file name
        filename <- paste0("./R_outputs/", runFolder, "/plots/dailyEachYear_streamflowComponents_logScale",siteNames[i],"_0",j, 
                           ".jpg")
        
        # set plot title
        plotTitle <- paste0(siteNamesForTitle[i], ", HY ", years[j], ": streamflow components\n")
        
        # open plotting device
        jpeg(filename=filename, width = 12, height = 8, 
             units = "in", quality = 75, res = 300)  
        
        
        # plot 
        par(mar=c(5,4,4,5) + 0.1)
        plot(x=dfPlotYr$dateHyd, y=dfPlotYr$`observed streamflow`, type="l", lwd=2, col="cornflowerblue", main=plotTitle, 
             xlab = "Date", ylab="Flow (cfs)", ylim=c(minFlow+0.000001,maxFlow), log="y")
        lines(dfPlotYr$dateHyd, dfPlotYr$`simulated streamflow`, type="l", lwd=2, col="indianred2")
        lines(dfPlotYr$dateHyd, dfPlotYr$`surface runoff`, type="l", lwd=2, col="forestgreen")
        lines(dfPlotYr$dateHyd, dfPlotYr$`groundwater flow`, type="l", lwd=2, col="gold1")
        lines(dfPlotYr$dateHyd, dfPlotYr$interflow, type="l", lwd=2, col="darkorchid3")
        lines(dfPlotYr$dateHyd, dfPlotYr$`hortonian runoff`, type="l", lty=3, lwd=2, col="darkolivegreen")
        lines(dfPlotYr$dateHyd, dfPlotYr$`dunnian runoff`, type="l", lty=3, lwd=2, col="darkolivegreen3")
        par(new=TRUE)
        plot(dfPlotYr$dateHyd, dfPlotYr$precipitation, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
             ylab="", ylim=rev(range(dfPlotYr$precipitation)))
        axis(4)
        mtext("Precipitation (inches)", side=4, line=3)
        legend("topright", legend=c("observed streamflow", "simulated streamflow", "groundwater flow", 
                                    "interflow", "surface runoff", "hortonian runoff", "dunnian runoff", 
                                    "precipitation"), 
               col=c("cornflowerblue", "indianred2", "gold1", "darkorchid3", "forestgreen", 
                     "darkolivegreen", "darkolivegreen3",  "palegoldenrod"), 
               lty=c(1,1,1,1,1,3,3,3), lwd=3, bty="n")
        grid()
        
        # close plotting device
        dev.off()
        
      }
      
    }
    
    
  }
  
  
  
  ##############################################################################################
  # 7) Plot for each subbasin: annual streamflow components as grouped and stacked bar plots
  #     (sub_gwflow, sub_interflow, sub_sroff, sub_cfs)
  ##############################################################################################
  
  # a <- c(3,3,2,1,0)
  # b <- c(3,2,2,2,2)
  # c <- 0:4
  # barplot(rbind(a,c), beside=TRUE)
  # barplot(rbind(a,b), beside=FALSE)
  # mydat <- cbind(rbind(a,b,0),rbind(0,0,c))[,c(1,6,2,7,3,8,4,9,5,10)]
  # barplot(mydat,space=c(.75,.25))
  
  # select allVar
  allVar = allVarSubbasin
  allVar_hydYear = allVarSubbasin_hydYear
  allVar_hydYearMonth = allVarSubbasin_hydYearMonth
  
  
  ##############################################################################################
  # 8) Plot for each subbasin: annual runoff ratios
  ##############################################################################################
  
  # Change plotting function for this 
  reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                      variableValue, typeValue, idVarsInput, castFormula, 
                                      idVarsOutput){
    
    # inputData = data frame of dates and variables
    # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
    #                        want to convert to volumes, if not, just set it to 1)
    # numDateCol = number of date columns
    # typeValue = either "simulated" or "measured" to place in a type column that is used 
    # for plotting subsets of the data later on
    # variableValue = either "precipitation" or "streamflow" to place in variable column that
    # is used for plotting subsets of the data later on
    # idVarsInput = name of variables to use as id.vars in first melt function
    # castFormula = formula to use for "formula" in dcast function
    # idVarsOutput = name of variables to use as id.vars in second melt function
    
    # first data column index
    firstDataColIdx <- numDateCol + 1
    
    # convert mean daily simulated cfs to daily volumes
    inputData[, firstDataColIdx:ncol(inputData)] <- 
      inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
    
    # calculate simulated [time frame] volumes
    meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                       variable.name = "site")
    castData <- dcast(meltedData, castFormula, fun.aggregate = sum, 
                      na.rm=TRUE)
    
    # reformat simulated [time frame] volumes
    variable <- rep(variableValue, nrow(castData))
    type <- rep(typeValue, nrow(castData))
    colNames <- names(castData)[2:ncol(castData)]
    castData <- data.frame(year = castData[,1], variable=variable, type=type,
                           castData[,2:ncol(castData)])
    names(castData)[4:ncol(castData)] <- colNames
    castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
    
    return(castDataMelt)
    
  }
  
  
  if (plots_OnOff[8] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    # reformat subinc_precip_hyd for plotting annual totals
    inputData <- allVar_hydYearMonth$subinc_precip[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "precipitation"
    typeValue="watershed"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    subinc_precip_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                             numDateCol, variableValue, typeValue, 
                                                             idVarsInput, castFormula, idVarsOutput)
    
    
    #reformat sub_cfs_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "simulated streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_cfs_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue,typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    
    
    #reformat runoff_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "measured streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    runoff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                      numDateCol, variableValue, typeValue, 
                                                      idVarsInput, castFormula, idVarsOutput)
    
    
    ####
    
    # place variables requiring units conversion from cfs to inches in the same data frame
    convertUnitsDf <- rbind(sub_cfs_hyd_annual_melt, runoff_hyd_annual_melt)
    convertUnitsDf_beforeConversion <- convertUnitsDf
    
    # create vector of site names
    siteNames <- unique(convertUnitsDf$site)
    
    # create vector of subbasin areas in square feet (in same order as siteNames)
    subbasinAreas <- c(183639662.433,
                       519000171.356,
                       2135840088.53,
                       390839981.924,
                       626560246.394,
                       932039752.807,
                       8800030.411188,
                       178279884,
                       269520211.269,
                       799520305.87,
                       132039704.767,
                       221680169.704) 
    subbasinAreasIdx <- which(subbasin_OnOff==1)
    subbasinAreas <- subbasinAreas[subbasinAreasIdx]  
    
    # # create vector of subwatershed areas in square feet (in same order as siteNames)
    # # divide by these instead of the subbasin areas for sub_cfs and runoff
    # subwatershedAreas <- rep(0,12)
    # subwatershedAreas[1] <- subbasinAreas[1]
    # subwatershedAreas[2] <- subbasinAreas[2]
    # subwatershedAreas[3] <- subbasinAreas[3]
    # subwatershedAreas[4] <- sum(subbasinAreas[1,2,4])
    # subwatershedAreas[5] <- sum(subbasinAreas[3,5])
    # subwatershedAreas[6] <- subbasinAreas[6]
    # subwatershedAreas[7] <- sum(subbasinAreas[6,7]) 
    # subwatershedAreas[8] <- sum(subbasinAreas[3,5,6,7,8]) 
    # subwatershedAreas[9] <- sum(subbasinAreas[3,5,6,7,8,9])
    # subwatershedAreas[10] <- sum(subbasinAreas)
    # subwatershedAreas[11] <- sum(subbasinAreas[3,5,6,7,8,9,11])
    # subwatershedAreas[12] <- sum(subbasinAreas[-10])
    
    
    # create an empty list to subset into 
    convertUnitsDfSubset <- list()
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # subset
      convertUnitsDfSubset[[i]] <- subset(convertUnitsDf, site %in% siteNames[i])
      idx <- which(convertUnitsDf$site %in% siteNames[i])
      
      # divide volume (cubic ft) by area (square ft) to get depth (ft)
      # then convert ft. to inches (multiply by 12)
      #temp <- (convertUnitsDfSubset[[i]]$value / subwatershedAreas[i]) * 12  # use this later
      temp <- (convertUnitsDfSubset[[i]]$value / subbasinAreas[i]) * 12   # remove this later
      convertUnitsDfSubset[[i]]$value <- temp
      
      # replace subset in convertUnitsDf
      convertUnitsDf[idx,] <- convertUnitsDfSubset[[i]]
      
    }
    
    
    sub_cfs_hyd_annual_melt_inches <- subset(convertUnitsDf, variable %in% "simulated streamflow")
    
    runoff_hyd_annual_melt_inches <- subset(convertUnitsDf, variable %in% "measured streamflow")
    
    
    ####
    
    
    # calculate annual runoff ratio for simulated data
    runoffRatioSim <- sub_cfs_hyd_annual_melt_inches$value / subinc_precip_hyd_annual_melt$value
    
    # calculate annual runoff ratio for observed data
    runoffRatioObs <- runoff_hyd_annual_melt_inches$value / subinc_precip_hyd_annual_melt$value
    
    # create runoff ratio data frame
    runoffRatioDf <- data.frame(year=sub_cfs_hyd_annual_melt_inches$year, 
                                site=sub_cfs_hyd_annual_melt_inches$site,
                                simulated=runoffRatioSim, observed=runoffRatioObs)
    
    # plot runoff ratios
    for (i in 1:length(siteNames)){
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/runoffRatio_0",i,".jpg")
      
      # set plot title                   
      plotTitle <- paste0(siteNames[i], ": runoff ratio = runoff / precipitation\n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # select site
      runoffRatioDfSite <- subset(runoffRatioDf, runoffRatioDf$site %in% siteNames[i])
      
      # set min and max runoff ratio values for use in ylim
      minRR <- min(runoffRatioDfSite$simulated, runoffRatioDfSite$observed)
      maxRR <- max(runoffRatioDfSite$simulated, runoffRatioDfSite$observed)
      
      # plot
      plot(runoffRatioDfSite$year, runoffRatioDfSite$observed, type="b", col="cornflowerblue", 
           ylim=c(minRR, maxRR), main=plotTitle, ylab="Runoff ratio", 
           xlab = "Hydrologic year", xaxt="n")
      axis(1, at=seq(1996,2014,by=1))
      lines(runoffRatioDfSite$year, runoffRatioDfSite$simulated, type="b", col="indianred2")
      legend("topright", legend=c("observed", "simulated"), 
             col=c("cornflowerblue", "indianred2"), lty=1, lwd=3, bty="n")
      grid()
      
      # close plotting device
      dev.off()
      
    }
    
    
  }
  
  
  
  
  # Change plotting function back to original
  reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                      variableValue, typeValue, idVarsInput, castFormula, 
                                      idVarsOutput){
    
    # inputData = data frame of dates and variables
    # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
    #                        want to convert to volumes, if not, just set it to 1)
    # numDateCol = number of date columns
    # typeValue = either "simulated" or "measured" to place in a type column that is used 
    # for plotting subsets of the data later on
    # variableValue = either "precipitation" or "streamflow" to place in variable column that
    # is used for plotting subsets of the data later on
    # idVarsInput = name of variables to use as id.vars in first melt function
    # castFormula = formula to use for "formula" in dcast function
    # idVarsOutput = name of variables to use as id.vars in second melt function
    
    # first data column index
    firstDataColIdx <- numDateCol + 1
    
    # convert mean daily simulated cfs to daily volumes
    inputData[, firstDataColIdx:ncol(inputData)] <- 
      inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
    
    # calculate simulated [time frame] volumes
    meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                       variable.name = "site")
    castData <- dcast(meltedData, castFormula, fun.aggregate = sum, 
                      na.rm=TRUE)
    
    # reformat simulated [time frame] volumes
    variable <- rep(variableValue, nrow(castData))
    type <- rep(typeValue, nrow(castData))
    castData <- data.frame(year = castData[,1], variable=variable, type=type,
                           castData[,2:ncol(castData)])
    castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
    
    return(castDataMelt)
    
  }
  
  
  
  ##############################################################################################
  # 9) Plot for each subbasin: distributed monthly precipitation, monthly measured streamflow 
  #    volume, monthly simulated streamflow volume 
  ##############################################################################################
  
  
  if (plots_OnOff[9] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    # leaving out distributed monthly precipitation for now
    
    
    #reformat sub_cfs_hyd for plotting
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    sub_cfs_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                        numDateCol, variableValue, typeValue,  
                                                        idVarsInput, castFormula, idVarsOutput)
    
    #reformat runoff_hyd for plotting
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    runoff_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue, typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    
    
    
    # place simulated streamflow and measured streamflow in the same data frame
    monthlyVolumeHyd <- rbind(sub_cfs_hyd_monthly_melt, runoff_hyd_monthly_melt)
    monthlyVolumeHyd$month <- as.factor(monthlyVolumeHyd$month)
    
    
    # create vector of site names
    siteNames <- unique(monthlyVolumeHyd$site)
    
    # create an empty list to subset into 
    monthlyVolumeHydSubset <- list()
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # subset
      monthlyVolumeHydSubset[[i]] <- subset(monthlyVolumeHyd, site %in% siteNames[i])
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/monthlyVolume_simulatedStreamflowHyd_measuredStreamflowHyd_0",i, 
                         ".jpg")
      
      plotTitle <- paste0(siteNames[i], ": monthly simulated vs. measured streamflow volume\n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 10, 
           units = "in", quality = 75, res = 300)  
      
      # plot
      monthlyVolumeHydSubsetPlot <- ggplot(data=monthlyVolumeHydSubset[[i]], aes(month, value)) + 
        geom_bar(aes(fill=type), position = "dodge", stat="identity") + 
        ylab("Streamflow (ft^3)") +
        xlab("Hydrologic month") + 
        ggtitle(plotTitle) +
        facet_wrap(facets = ~ year, nrow = 5, ncol=4, scales="free")
      
      # print plot
      print(monthlyVolumeHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
    }
    
    
  }
  
  
  
  ##############################################################################################
  # 10) Plot for each subbasin: distributed daily precipitation, simulated daily streamflow, 
  #    measured daily streamflow (using line plots)
  ##############################################################################################
  
  #if (plots_OnOff[10] == 1){
  
  # # select allVar
  # allVar = allVarSubbasin
  # allVar_hydYear = allVarSubbasin_hydYear
  # allVar_hydYearMonth = allVarSubbasin_hydYearMonth
  
  # leave out precipitation for now
  
  # #reformat subinc_precip_hyd for daily plotting
  # inputData <- subinc_precip_hyd
  # multiplicationFactor <- 1
  # numDateCol <- 6
  # variableValue <- "precipitation"
  # typeValue="distributed"
  # idVarsInput <- c("year", "month", "day",
  #                  "hour", "minute", 
  #                  "second")
  # castFormula <- year + month + day ~ site
  # idVarsOutput <- c("year", "month", "day", "variable", "type")
  # subinc_precip_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
  #                                                          numDateCol, variableValue, typeValue, 
  #                                                          idVarsInput, castFormula, idVarsOutput)
  
  
  # #reformat sub_cfs_hyd for daily plotting
  # inputData <- sub_cfs_hyd[,c(1:6,9,12)]
  # multiplicationFactor <- 1
  # numDateCol <- 6
  # variableValue <- "streamflow"
  # typeValue="simulated"
  # idVarsInput <- c("year", "month", "day",
  #                  "hour", "minute", 
  #                  "second")
  # castFormula <- year + month + day ~ site
  # idVarsOutput <- c("year", "month", "day", "variable", "type")
  # sub_cfs_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
  #                                                     numDateCol, variableValue, typeValue,  
  #                                                     idVarsInput, castFormula, idVarsOutput)
  # 
  # #reformat runoff_hyd for daily plotting
  # inputData <- runoff_hyd[,c(1:6,9,12)]
  # multiplicationFactor <- 1
  # numDateCol <- 6
  # variableValue <- "streamflow"
  # typeValue="measured"
  # idVarsInput <- c("year", "month", "day",
  #                  "hour", "minute", 
  #                  "second")
  # castFormula <- year + month + day ~ site
  # idVarsOutput <- c("year", "month", "day", "variable", "type")
  # runoff_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
  #                                                    numDateCol, variableValue, typeValue,  
  #                                                    idVarsInput, castFormula, idVarsOutput)
  # 
  # 
  # # make one data frame of all data
  # # dailyPrecipStreamflowHyd <- rbind(subinc_precip_hyd_daily_melt, sub_cfs_hyd_daily_melt, 
  # #                                runoff_hyd_daily_melt)
  # dailyPrecipStreamflowHyd <- rbind(sub_cfs_hyd_daily_melt, runoff_hyd_daily_melt)
  #                                
  # 
  # 
  # # create hydrologic date 
  # monthPrep <- formatC(dailyPrecipStreamflowHyd$month, width = 2, format = "d", flag = "0")
  # dayPrep <- formatC(dailyPrecipStreamflowHyd$day, width = 2, format = "d", flag = "0")
  # dateHydPrep <- paste0(dailyPrecipStreamflowHyd$year, monthPrep, dayPrep)
  # dateHyd <- as.Date(dateHydPrep, format = "%Y%m%d")
  # 
  # 
  # # cbind hydrologic date to data frame of all data
  # dailyPrecipStreamflowHyd <- cbind(dateHyd, dailyPrecipStreamflowHyd)
  # 
  # 
  # # make line plot for each year-site combo with streamflow on primary y-axis and precip on 
  # # secondary y-axis 
  # 
  # # create vector of site names
  # siteNames <- unique(dailyPrecipStreamflowHyd$site)
  # 
  # # create an empty list to subset into 
  # dailyPrecipStreamflowHydSubset <- list()
  # 
  # # loop through site names
  # for (i in 1:length(siteNames)){
  #   
  #   # subset
  #   dailyPrecipStreamflowHydSubset[[i]] <- subset(dailyPrecipStreamflowHyd, site %in% siteNames[i])
  #   
  #   # set file name
  #   #filename <- paste0("daily_distributedPrecipHyd_simulatedStreamflowHyd_measuredStreamflowHyd_0",i, 
  #   #                   ".jpg")
  #   filename <- paste0("daily_simulatedStreamflowHyd_measuredStreamflowHyd_0",i, 
  #                    ".jpg")
  #   
  #   #plotTitle <- paste0(siteNames[i], ": daily precipitation, simulated vs. measured streamflow")
  #   plotTitle <- paste0(siteNames[i], ": simulated vs. measured streamflow\n")
  #   
  #   # open plotting device
  #   jpeg(filename=filename, width = 12, height = 10, 
  #        units = "in", quality = 75, res = 300)  
  #   
  #   # plot
  #   # can't do secondary y-axis in ggplot2
  #   # decide whether to include precip in separate plot or keep in this plot 
  #   # maybe use nested facets?
  #   # maybe download new version of ggplot2 so that can use dir parameter?
  #   # or download and use facet_multiple to split up onto several pages
  #   dailyPrecipStreamflowHydSubsetPlot <- ggplot(data=dailyPrecipStreamflowHydSubset[[i]], aes(dateHyd, value)) + 
  #     geom_line(aes(colour=type)) + 
  #     scale_x_date(labels = date_format("%m/%d")) + 
  #     #ylab("Streamflow (ft^3 / s) and precipitation (in.)") +
  #     ylab("Streamflow (ft^3 / s)") +
  #     xlab("Hydrologic date") + 
  #     ggtitle(plotTitle) +
  #     #facet_grid(variable ~ year, scales="free")
  #     facet_wrap(facets = ~ year, nrow = 5, ncol=4, scales="free")
  #   
  #   # print plot
  #   print(dailyPrecipStreamflowHydSubsetPlot)
  #   
  #   # close plotting device
  #   dev.off()
  #   
  # }
  
  #}
  
  
  
  
  ##############################################################################################
  # 11) Plot for each subbasin: distributed daily precipitation, simulated daily streamflow, 
  #    measured daily streamflow (using line plots) - put precip on secondary y axis with axis 
  #    reversed
  ##############################################################################################
  
  
  if (plots_OnOff[11] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    
    #reformat subinc_precip for daily plotting
    inputData <- allVar$subinc_precip[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "precipitation"
    typeValue="distributed"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    subinc_precip_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                            numDateCol, variableValue, typeValue, 
                                                            idVarsInput, castFormula, idVarsOutput)
    
    
    #reformat sub_cfs for daily plotting
    inputData <- allVar$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    sub_cfs_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                      numDateCol, variableValue, typeValue,  
                                                      idVarsInput, castFormula, idVarsOutput)
    
    #reformat runoff for daily plotting
    inputData <- allVar$runoff[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    runoff_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                     numDateCol, variableValue, typeValue,  
                                                     idVarsInput, castFormula, idVarsOutput)
    
    
    # make one data frame of all data
    dailyPrecipStreamflowHyd <- rbind(subinc_precip_hyd_daily_melt, sub_cfs_hyd_daily_melt, 
                                      runoff_hyd_daily_melt)
    
    
    # create regular date (but keep variable name as hydrologic date for now)
    monthPrep <- formatC(dailyPrecipStreamflowHyd$month, width = 2, format = "d", flag = "0")
    dayPrep <- formatC(dailyPrecipStreamflowHyd$day, width = 2, format = "d", flag = "0")
    dateHydPrep <- paste0(dailyPrecipStreamflowHyd$year, monthPrep, dayPrep)
    dateHyd <- as.Date(dateHydPrep, format = "%Y%m%d")
    
    
    # cbind date to data frame of all data
    dailyPrecipStreamflowHyd <- cbind(dateHyd, dailyPrecipStreamflowHyd)
    
    # create new variable column that has the categories: 
    # precipitation, simulated flow, observed flow
    newVariableVec <- vector(mode="character", length=length(dailyPrecipStreamflowHyd$variable))
    for (i in 1:length(newVariableVec)){
      
      if (dailyPrecipStreamflowHyd$variable[i] %in% "precipitation"){
        newVariableVec[i] <- "precipitation"
      }
      
      if (dailyPrecipStreamflowHyd$variable[i] %in% "streamflow" & dailyPrecipStreamflowHyd$type[i] %in% "simulated"){
        newVariableVec[i] <- "simulated flow"
      }
      
      if (dailyPrecipStreamflowHyd$variable[i] %in% "streamflow" & dailyPrecipStreamflowHyd$type[i] %in% "measured"){
        newVariableVec[i] <- "observed flow"
      }
      
    }
    dailyPrecipStreamflowHyd$variable <- newVariableVec
    
    
    
    # create hydrologic year for dailyPrecipStreamflowHyd
    hydYear <- dailyPrecipStreamflowHyd$year
    for (i in 1:length(hydYear)){
      
      if ( (dailyPrecipStreamflowHyd$month[i] == 10) | (dailyPrecipStreamflowHyd$month[i] == 11) | (dailyPrecipStreamflowHyd$month[i] ==12)) {
        hydYear[i] <- dailyPrecipStreamflowHyd$year[i] + 1
      }
      
    }
    dailyPrecipStreamflowHyd <- data.frame(dailyPrecipStreamflowHyd, hydYear=hydYear)
    
    
    # create separate data frame for each subbasin 
    siteNames <- unique(dailyPrecipStreamflowHyd$site)
    dailyPrecipStreamflowHydList <- list()
    for (i in 1:length(siteNames)){
      
      dailyPrecipStreamflowHydList[[i]] <- subset(dailyPrecipStreamflowHyd, dailyPrecipStreamflowHyd$site %in% siteNames[i])
      
    }
    
    
    # create wide format data set for each subbasin
    dailyPrecipStreamflowHydWideList <- list()
    for (i in 1:length(siteNames)){
      
      dailyPrecipStreamflowHydWideList[[i]] <- dcast(dailyPrecipStreamflowHydList[[i]][,-6], 
                                                     dateHyd + hydYear + year + month + day + site ~ variable)
      
    }
    
    
    
    # make line plot for each year-site combo with streamflow on primary y-axis and precip on 
    # secondary y-axis 
    
    # create vector of site names
    siteNames <- unique(dailyPrecipStreamflowHyd$site)
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    # plot daily data for entire study period
    for (i in 1:length(siteNames)){
      
      # select data frame for plotting
      dfPlot <- dailyPrecipStreamflowHydWideList[[i]]
      
      # calculate min and max flows
      minFlow <- min(dfPlot$`observed flow`, dfPlot$`simulated flow`)
      maxFlow <- max(dfPlot$`observed flow`, dfPlot$`simulated flow`)
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/daily_precipHyd_simulatedFlowHyd_measuredFlowHyd_0",i, 
                         ".jpg")
      
      # set plot title
      plotTitle <- paste0(siteNamesForTitle[i], ": daily precipitation and streamflow\n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      
      # plot 
      par(mar=c(5,4,4,5) + 0.1)
      plot(dfPlot$dateHyd, dfPlot$`observed flow`, type="l", col="cornflowerblue", main=plotTitle, 
           xlab = "Date", ylab="Flow (cfs)", ylim=c(minFlow,maxFlow))
      lines(dfPlot$dateHyd, dfPlot$`simulated flow`, type="l", col="indianred2")
      par(new=TRUE)
      plot(dfPlot$dateHyd, dfPlot$precipitation, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
           ylab="", ylim=rev(range(dfPlot$precipitation)))
      axis(4)
      mtext("Precipitation (inches)", side=4, line=3)
      legend("topright", legend=c("observed flow", "simulated flow", "precipitation"), 
             col=c("cornflowerblue", "indianred2", "palegoldenrod"), lty=c(1,1,3), lwd=3, bty="n")
      grid()
      
      
      
      # print plot
      #print(dailyPrecipStreamflowHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
    }
    
    
    
    # for each site: plot daily data for one year at a time
    for (i in 1:length(siteNames)){
      
      # select data frame for plotting
      dfPlot <- dailyPrecipStreamflowHydWideList[[i]]
      
      years <- unique(dfPlot$hydYear)
      
      for (j in 1:length(years)){
        
        dfPlotYr <- subset(dfPlot, dfPlot$hydYear == years[j])
        
        # calculate min and max flows
        minFlow <- min(dfPlotYr$`observed flow`, dfPlotYr$`simulated flow`)
        maxFlow <- max(dfPlotYr$`observed flow`, dfPlotYr$`simulated flow`)
        
        # set file name
        filename <- paste0("./R_outputs/", runFolder, "/plots/daily_precipHyd_simulatedFlowHyd_measuredFlowHyd_",siteNames[i],"_0",j, 
                           ".jpg")
        
        # set plot title
        plotTitle <- paste0(siteNamesForTitle[i], ", ", years[j], ": daily precipitation and streamflow\n")
        
        # open plotting device
        jpeg(filename=filename, width = 12, height = 8, 
             units = "in", quality = 75, res = 300)  
        
        # plot 
        par(mar=c(5,4,4,5) + 0.1)
        plot(dfPlotYr$dateHyd, dfPlotYr$`observed flow`, type="l", col="cornflowerblue", main=plotTitle, 
             xlab = "Month", ylab="Flow (cfs)", xaxt="n", ylim=c(minFlow, maxFlow))
        axis.Date(1, x= dfPlotYr$dateHyd, format="%m")
        lines(dfPlotYr$dateHyd, dfPlotYr$`simulated flow`, type="l", col="indianred2")
        par(new=TRUE)
        plot(dfPlotYr$dateHyd, dfPlotYr$precipitation, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
             ylab="", ylim=rev(range(dfPlotYr$precipitation)))
        axis(4)
        mtext("Precipitation (inches)", side=4, line=3)
        legend("topright", legend=c("observed flow", "simulated flow", "precipitation"), 
               col=c("cornflowerblue", "indianred2", "palegoldenrod"), lty=c(1,1,3), lwd=3, bty="n")
        grid()
        
        # print plot
        #print(p)
        
        # close plotting device
        dev.off()
        
      }
      
    }
    
    
    
    # for each site: plot daily data for one year at a time on log scale
    for (i in 1:length(siteNames)){
      
      # select data frame for plotting
      dfPlot <- dailyPrecipStreamflowHydWideList[[i]]
      
      years <- unique(dfPlot$hydYear)
      
      for (j in 1:length(years)){
        
        dfPlotYr <- subset(dfPlot, dfPlot$hydYear == years[j])
        
        # calculate min and max flows
        minFlow <- min(dfPlotYr$`observed flow`, dfPlotYr$`simulated flow`)
        maxFlow <- max(dfPlotYr$`observed flow`, dfPlotYr$`simulated flow`)
        
        # set file name
        filename <- paste0("./R_outputs/", runFolder, "/plots/daily_precipHyd_simulatedFlowHyd_measuredFlowHyd_logScale_",siteNames[i],"_0",j, 
                           ".jpg")
        
        # set plot title
        plotTitle <- paste0(siteNamesForTitle[i], ", ", years[j], ": daily precipitation and streamflow\n")
        
        # open plotting device
        jpeg(filename=filename, width = 12, height = 8, 
             units = "in", quality = 75, res = 300)  
        
        # plot 
        par(mar=c(5,4,4,5) + 0.1)
        plot(dfPlotYr$dateHyd, dfPlotYr$`observed flow`, type="l", col="cornflowerblue", main=plotTitle, 
             xlab = "Month", ylab="Flow (cfs)", xaxt="n", ylim=c(minFlow+0.000001, maxFlow), log="y")
        axis.Date(1, x= dfPlotYr$dateHyd, format="%m")
        lines(dfPlotYr$dateHyd, dfPlotYr$`simulated flow`, type="l", col="indianred2")
        par(new=TRUE)
        plot(dfPlotYr$dateHyd, dfPlotYr$precipitation, type='l', lty=3, col="palegoldenrod", xaxt="n", yaxt="n", xlab="", 
             ylab="", ylim=rev(range(dfPlotYr$precipitation)))
        axis(4)
        mtext("Precipitation (inches)", side=4, line=3)
        legend("topright", legend=c("observed flow", "simulated flow", "precipitation"), 
               col=c("cornflowerblue", "indianred2", "palegoldenrod"), lty=c(1,1,3), lwd=3, bty="n")
        grid()
        
        # print plot
        #print(p)
        
        # close plotting device
        dev.off()
        
      }
      
    }
    
  }
  
  
  
  
  ##############################################################################################
  # 12) Plot for the entire basin: measured vs. simulated PPT/ET ratio (averaged over the period 
  #    of record)
  ##############################################################################################
  
  # # select allVar
  # allVar = allVarSubbasin
  # allVar_hydYear = allVarSubbasin_hydYear
  # allVar_hydYearMonth = allVarSubbasin_hydYearMonth
  
  
  
  
  ##############################################################################################
  # 13) Plot the measured vs. simulated solar radiation
  ##############################################################################################
  
  # # select allVar
  # allVar = allVarSubbasin
  # allVar_hydYear = allVarSubbasin_hydYear
  # allVar_hydYearMonth = allVarSubbasin_hydYearMonth
  
  
  
  
  
  
  ##############################################################################################
  # 14) Plot annual water balance for each subwatershed (in inches)
  ##############################################################################################
  
  # if (plots_OnOff[14] == 1){
  
  # # select allVar
  # allVar = allVarSubbasin
  # allVar_hydYear = allVarSubbasin_hydYear
  # allVar_hydYearMonth = allVarSubbasin_hydYearMonth
  
  # # reformat subinc_precip_hyd for plotting annual totals
  # inputData <- subinc_precip_hyd[,c(1:6,9,12)]
  # multiplicationFactor <- 1
  # numDateCol <- 6
  # variableValue <- "precipitation"
  # typeValue="distributed"
  # idVarsInput <- c("year", "month", "day",
  #                  "hour", "minute", 
  #                  "second")
  # castFormula <- year ~ site
  # idVarsOutput <- c("year","variable", "type")
  # subinc_precip_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
  #                                                          numDateCol, variableValue, typeValue, 
  #                                                          idVarsInput, castFormula, idVarsOutput)
  # 
  # 
  # 
  # # convert subinc_actet_hyd from subbasins to subwatersheds
  # subinc_actet_hyd_subwatershed <- subinc_actet_hyd
  # subinc_actet_hyd_subwatershed[7] <- subinc_actet_hyd[,7]
  # subinc_actet_hyd_subwatershed[8] <- subinc_actet_hyd[,8]
  # subinc_actet_hyd_subwatershed[9] <- subinc_actet_hyd[,9]
  # subinc_actet_hyd_subwatershed[10] <- rowSums(subinc_actet_hyd[, c(7,8,10)])
  # subinc_actet_hyd_subwatershed[11] <- rowSums(subinc_actet_hyd[, c(9,11)])
  # subinc_actet_hyd_subwatershed[12] <- subinc_actet_hyd[,12]
  # subinc_actet_hyd_subwatershed[13] <- rowSums(subinc_actet_hyd[, c(12,13)])
  # subinc_actet_hyd_subwatershed[14] <- rowSums(subinc_actet_hyd[, c(9,11,12,13,14)])
  # subinc_actet_hyd_subwatershed[15] <- rowSums(subinc_actet_hyd[, c(9,11,12,13,14,15)])
  # subinc_actet_hyd_subwatershed[16] <- rowSums(subinc_actet_hyd[, c(7:18)])
  # subinc_actet_hyd_subwatershed[17] <- rowSums(subinc_actet_hyd[, c(9,11,12,13,14,15,17)])
  # subinc_actet_hyd_subwatershed[18] <- rowSums(subinc_actet_hyd[, c(7:15,17:18)])
  # 
  # 
  # #reformat subinc_actet_hyd_subwatershed for plotting annual total
  # inputData <- subinc_actet_hyd_subwatershed
  # multiplicationFactor <- 1
  # numDateCol <- 6
  # variableValue <- "ET"
  # typeValue="simulated"
  # idVarsInput <- c("year", "month", "day",
  #                  "hour", "minute", 
  #                  "second")
  # castFormula <- year ~ site
  # idVarsOutput <- c("year","variable", "type")
  # subinc_actet_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
  #                                                          numDateCol, variableValue, typeValue, 
  #                                                          idVarsInput, castFormula, idVarsOutput)
  # 
  # 
  # 
  # # convert subinc_deltastor_hyd from subbasins to subwatersheds
  # subinc_deltastor_hyd_subwatershed <- subinc_deltastor_hyd
  # subinc_deltastor_hyd_subwatershed[7] <- subinc_deltastor_hyd[,7]
  # subinc_deltastor_hyd_subwatershed[8] <- subinc_deltastor_hyd[,8]
  # subinc_deltastor_hyd_subwatershed[9] <- subinc_deltastor_hyd[,9]
  # subinc_deltastor_hyd_subwatershed[10] <- rowSums(subinc_deltastor_hyd[, c(7,8,10)])
  # subinc_deltastor_hyd_subwatershed[11] <- rowSums(subinc_deltastor_hyd[, c(9,11)])
  # subinc_actet_hyd_subwatershed[12] <- subinc_actet_hyd[,12]
  # subinc_deltastor_hyd_subwatershed[13] <- rowSums(subinc_deltastor_hyd[, c(12,13)])
  # subinc_deltastor_hyd_subwatershed[14] <- rowSums(subinc_deltastor_hyd[, c(9,11,12,13,14)])
  # subinc_deltastor_hyd_subwatershed[15] <- rowSums(subinc_deltastor_hyd[, c(9,11,12,13,14,15)])
  # subinc_deltastor_hyd_subwatershed[16] <- rowSums(subinc_deltastor_hyd[, c(7:18)])
  # subinc_deltastor_hyd_subwatershed[17] <- rowSums(subinc_deltastor_hyd[, c(9,11,12,13,14,15,17)])
  # subinc_deltastor_hyd_subwatershed[18] <- rowSums(subinc_deltastor_hyd[, c(7:15,17:18)])
  # 
  # 
  # 
  # #reformat subinc_deltastor_hyd for plotting annual volume
  # inputData <- subinc_deltastor_hyd_subwatershed
  # multiplicationFactor <- 86400
  # numDateCol <- 6
  # variableValue <- "storage"
  # typeValue="simulated"
  # idVarsInput <- c("year", "month", "day",
  #                  "hour", "minute", 
  #                  "second")
  # castFormula <- year ~ site
  # idVarsOutput <- c("year","variable", "type")
  # subinc_deltastor_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
  #                                                    numDateCol, variableValue,typeValue,  
  #                                                    idVarsInput, castFormula, idVarsOutput)
  # 
  # 
  # 
  # 
  # #reformat sub_cfs_hyd for plotting annual volume
  # inputData <- sub_cfs_hyd
  # multiplicationFactor <- 86400
  # numDateCol <- 6
  # variableValue <- "simulated streamflow"
  # typeValue="simulated"
  # idVarsInput <- c("year", "month", "day",
  #                  "hour", "minute", 
  #                  "second")
  # castFormula <- year ~ site
  # idVarsOutput <- c("year","variable", "type")
  # sub_cfs_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
  #                                                    numDateCol, variableValue,typeValue,  
  #                                                    idVarsInput, castFormula, idVarsOutput)
  # 
  # 
  # #reformat runoff_hyd for plotting annual volume
  # inputData <- runoff_hyd
  # multiplicationFactor <- 86400
  # numDateCol <- 6
  # variableValue <- "measured streamflow"
  # typeValue="measured"
  # idVarsInput <- c("year", "month", "day",
  #                  "hour", "minute", 
  #                  "second")
  # castFormula <- year ~ site
  # idVarsOutput <- c("year","variable", "type")
  # runoff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
  #                                                   numDateCol, variableValue, typeValue, 
  #                                                   idVarsInput, castFormula, idVarsOutput)
  # 
  # 
  # 
  # 
  # ####
  # 
  # # place variables requiring units conversion from cfs to inches in the same data frame
  # convertUnitsDf <- rbind(subinc_deltastor_hyd_annual_melt, sub_cfs_hyd_annual_melt, runoff_hyd_annual_melt)
  # convertUnitsDf_beforeConversion <- convertUnitsDf
  # 
  # # create vector of site names
  # siteNames <- unique(convertUnitsDf$site)
  # siteNames <- siteNames[1:12]
  # siteNames <- siteNames[c(3,6)] # take this out later
  # 
  # # create vector of subbasin areas in square feet (in same order as siteNames)
  # subbasinAreas <- c(183639662.433,
  #                    519000171.356,
  #                    2135840088.53,
  #                    390839981.924,
  #                    626560246.394,
  #                    932039752.807,
  #                    8800030.411188,
  #                    178279884,
  #                    269520211.269,
  #                    799520305.87,
  #                    132039704.767,
  #                    221680169.704) 
  # 
  # # create vector of subwatershed areas in square feet (in same order as siteNames)
  # # divide by these instead of the subbasin areas for sub_cfs and runoff
  # subwatershedAreas <- rep(0,12)
  # subwatershedAreas[1] <- subbasinAreas[1]
  # subwatershedAreas[2] <- subbasinAreas[2]
  # subwatershedAreas[3] <- subbasinAreas[3]
  # subwatershedAreas[4] <- sum(subbasinAreas[c(1,2,4)])
  # subwatershedAreas[5] <- sum(subbasinAreas[c(3,5)])
  # subwatershedAreas[6] <- subbasinAreas[6]
  # subwatershedAreas[7] <- sum(subbasinAreas[c(6,7)]) 
  # subwatershedAreas[8] <- sum(subbasinAreas[c(3,5,6,7,8)]) 
  # subwatershedAreas[9] <- sum(subbasinAreas[c(3,5,6,7,8,9)])
  # subwatershedAreas[10] <- sum(subbasinAreas)
  # subwatershedAreas[11] <- sum(subbasinAreas[c(3,5,6,7,8,9,11)])
  # subwatershedAreas[12] <- sum(subbasinAreas[-10])
  # 
  # 
  # # create an empty list to subset into 
  # convertUnitsDfSubset <- list()
  # 
  # # loop through site names
  # for (i in 1:length(siteNames)){
  #   
  #   # subset
  #   convertUnitsDfSubset[[i]] <- subset(convertUnitsDf, site %in% siteNames[i])
  #   idx <- which(convertUnitsDf$site %in% siteNames[i])
  # 
  #   # divide volume (cubic ft) by area (square ft) to get depth (ft)
  #   # then convert ft. to inches (multiply by 12)
  #   temp <- (convertUnitsDfSubset[[i]]$value / subwatershedAreas[i]) * 12
  #   convertUnitsDfSubset[[i]]$value <- temp
  # 
  #   # replace subset in convertUnitsDf
  #   convertUnitsDf[idx,] <- convertUnitsDfSubset[[i]]
  #   
  # }
  # 
  # subinc_deltastor_hyd_annual_melt_inches <- subset(convertUnitsDf, variable %in% "storage")
  # 
  # sub_cfs_hyd_annual_melt_inches <- subset(convertUnitsDf, variable %in% "simulated streamflow")
  # 
  # runoff_hyd_annual_melt_inches <- subset(convertUnitsDf, variable %in% "measured streamflow")
  # 
  # ####
  # 
  # 
  # 
  # # place all variables in the same data frame - put storage back in later (subinc_deltastor_hyd_annual_melt_inches)
  # annualWaterBalanceHyd <- rbind(subinc_precip_hyd_annual_melt, subinc_actet_hyd_annual_melt,
  #                                sub_cfs_hyd_annual_melt_inches, runoff_hyd_annual_melt_inches)
  # 
  # # remove other site names
  # annualWaterBalanceHyd <- subset(annualWaterBalanceHyd, subset=site %in% siteNames)
  # 
  # 
  # 
  # # create an empty list to subset into 
  # annualWaterBalanceHydSubset <- list()
  # 
  # # loop through site names
  # for (i in 1:length(siteNames)){
  #   
  #   # subset
  #   annualWaterBalanceHydSubset[[i]] <- subset(annualWaterBalanceHyd, site %in% siteNames[i])
  # 
  #   
  #   # set file name
  #   filename <- paste0("annualWaterBalance_0",i, 
  #                      ".jpg")
  #   
  #   plotTitle <- paste0(siteNames[i], ": annual water balance\n")
  #   
  #   # open plotting device
  #   jpeg(filename=filename, width = 12, height = 10, 
  #        units = "in", quality = 75, res = 300)  
  #   
  #   # plot
  #   annualWaterBalanceHydSubsetPlot <- ggplot(data=annualWaterBalanceHydSubset[[i]], aes(variable, value)) + 
  #     geom_bar(aes(fill=variable), position = "dodge", stat="identity") + 
  #     ylab("Water Balance Componenet (in.)\n") +
  #     xlab("Variable") + 
  #     ggtitle(plotTitle) +
  #     facet_wrap(facets = ~ year, nrow = 5, ncol=4, scales="free") + 
  #     theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
  #   
  #   # print plot
  #   print(annualWaterBalanceHydSubsetPlot)
  #   
  #   # close plotting device
  #   dev.off()
  #   
  # }
  
  # }
  
  
  
  
  ##############################################################################################
  # 15) Plot volumetric efficiency and nash-sutcliffe efficiency using daily flows
  ##############################################################################################
  
  if (plots_OnOff[15] == 1){
    
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    #reformat sub_cfs for daily plotting
    inputData <- allVar$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    sub_cfs_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                      numDateCol, variableValue, typeValue,  
                                                      idVarsInput, castFormula, idVarsOutput)
    
    #reformat runoff for daily plotting
    inputData <- allVar$runoff[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month + day ~ site
    idVarsOutput <- c("year", "month", "day", "variable", "type")
    runoff_hyd_daily_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                     numDateCol, variableValue, typeValue,  
                                                     idVarsInput, castFormula, idVarsOutput)
    
    
    # make one data frame of all data
    dailyFlow <- rbind(sub_cfs_hyd_daily_melt, runoff_hyd_daily_melt)
    
    
    # create regular date (but keep variable name as hydrologic date for now)
    monthPrep <- formatC(dailyFlow$month, width = 2, format = "d", flag = "0")
    dayPrep <- formatC(dailyFlow$day, width = 2, format = "d", flag = "0")
    dateHydPrep <- paste0(dailyFlow$year, monthPrep, dayPrep)
    dateHyd <- as.Date(dateHydPrep, format = "%Y%m%d")
    
    
    # cbind date to data frame of all data
    dailyFlow <- cbind(dateHyd, dailyFlow)
    
    
    # create new variable column that has the categories: 
    # simulated flow, observed flow
    newVariableVec <- vector(mode="character", length=length(dailyFlow$variable))
    for (i in 1:length(newVariableVec)){
      
      if (dailyFlow$variable[i] %in% "streamflow" & dailyFlow$type[i] %in% "simulated"){
        newVariableVec[i] <- "simulated flow"
      }
      
      if (dailyFlow$variable[i] %in% "streamflow" & dailyFlow$type[i] %in% "measured"){
        newVariableVec[i] <- "observed flow"
      }
      
    }
    dailyFlow$variable <- newVariableVec
    
    
    
    # create hydrologic year for dailyPrecipStreamflowHyd
    hydYear <- dailyFlow$year
    for (i in 1:length(hydYear)){
      
      if ( (dailyFlow$month[i] == 10) | (dailyFlow$month[i] == 11) | (dailyFlow$month[i] ==12)) {
        hydYear[i] <- dailyFlow$year[i] + 1
        
      }
      
    }
    dailyFlow <- data.frame(dailyFlow, hydYear=hydYear)
    
    
    # create separate data frame for each subbasin 
    siteNames <- unique(dailyFlow$site)
    dailyFlowList <- list()
    for (i in 1:length(siteNames)){
      
      dailyFlowList[[i]] <- subset(dailyFlow, dailyFlow$site %in% siteNames[i])
      
    }
    
    
    # create wide format data set for each subbasin
    dailyFlowWideList <- list()
    for (i in 1:length(siteNames)){
      
      dailyFlowWideList[[i]] <- dcast(dailyFlowList[[i]][,-6], 
                                      dateHyd + hydYear + year + month + day + site ~ variable)
      
    }
    
    
    # create siteNamesForTitle - will need to update this once plotting more than just ArroyoHondo 
    # and AlamedaCreekAboveACDD
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    
    ### calculate volumetric efficiency and nash-sutcliffe efficiency for each HY #############################
    
    for (i in 1:length(siteNames)){
      
      # select one site
      flow <- dailyFlowWideList[[i]]
      
      # create vector of hydrologic years
      hydYear <- unique(flow$hydYear)
      
      # create data frame for storing volumetric efficiencies for each HY
      calibEff <- data.frame(hydYear=hydYear, VE=vector(mode="numeric", length(length(hydYear))), 
                             NSE=vector(mode="numeric", length(length(hydYear))))
      
      
      # cycle through hydrologic years
      # why are some of the volumetric efficiencies negative? 
      # because the sum of errors is greater than the sum of observed flows
      # so the criss and winston (2008) paper is wrong in saying that VE is bounded between 0 and 1
      for (j in 1:length(hydYear)){
        
        # select year
        flowHydYear <- flow[flow$hydYear == hydYear[j],]
        
        # volumetric efficiency
        numeratorVE <- sum(abs(flowHydYear$`simulated flow` - flowHydYear$`observed flow`))
        denominatorVE <- sum(flowHydYear$`observed flow`)
        calibEff$VE[j] <- 1 - (numeratorVE / denominatorVE)
        
        # nash-sutcliff efficiency
        numeratorNSE <- sum( (flowHydYear$`simulated flow` - flowHydYear$`observed flow`)^2)
        denominatorNSE <- sum( (mean(flowHydYear$`observed flow`) - flowHydYear$`observed flow`)^2)
        calibEff$NSE[j] <- 1 - (numeratorNSE / denominatorNSE)
        
        
        
      }
      
      
      # set plot title
      plotTitle <- paste0(siteNamesForTitle[i], ": model efficiency calculated from daily flows\n summed by hydrologic year\n")
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/model_efficiency_dailyQ_sumOverHY_",siteNames[i], 
                         ".jpg")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # set up 2-figure plot
      par(mfrow=c(2,1))
      
      # plot volumetric efficiency
      plot(calibEff$hydYear, calibEff$VE, type="b", lwd=2, xaxt="n", col="royalblue4", xlab="Hydrologic year",
           ylab="Volumetric efficiency", main=plotTitle)
      axis(1, at= calibEff$hydYear)
      grid()
      
      #plot nash-sutcliff efficiency
      plot(calibEff$hydYear, calibEff$NSE, type="b", lwd=2, xaxt="n", col="royalblue4", xlab="Hydrologic year",
           ylab="Nash-Sutcliffe efficiency")
      axis(1, at= calibEff$hydYear)
      grid()
      
      # close device
      dev.off()
      
      # get back to 1-figure plot
      par(mfrow=c(1,1))
      
      # export csv
      csvFilename <- paste0("./R_outputs/", runFolder, "/tables/model_efficiency_dailyQ_sumOverHY_",siteNames[i], ".csv")
      write.csv(calibEff, file=csvFilename, row.names=FALSE)
      
    }
    
    
    
    
    
    ### calculate volumetric efficiency and nash-sutcliffe efficiency for each month over all years #######
    
    
    for (i in 1:length(siteNames)){
      
      # select one site
      flow <- dailyFlowWideList[[i]]
      
      # create vector of hydrologic years
      hydYear <- unique(flow$hydYear)
      
      # create vector of months
      month <- unique(flow$month)
      
      # create data frame for storing volumetric efficiencies for each month
      calibEff <- data.frame(month=month, VE=vector(mode="numeric", length=length(month)), 
                             NSE=vector(mode="numeric", length=length(month)))
      
      
      # cycle through hydrologic years
      # why are some of the volumetric efficiencies negative? 
      # because the sum of errors is greater than the sum of observed flows
      # so the criss and winston (2008) paper is wrong in saying that VE is bounded between 0 and 1
      for (j in 1:length(month)){
        
        # select month
        flowMonth <- flow[flow$month == month[j],]
        
        # volumetric efficiency
        numeratorVE <- sum(abs(flowMonth$`simulated flow` - flowMonth$`observed flow`))
        denominatorVE <- sum(flowMonth$`observed flow`)
        calibEff$VE[j] <- 1 - (numeratorVE / denominatorVE)
        
        # nash-sutcliff efficiency
        numeratorNSE <- sum( (flowMonth$`simulated flow` - flowMonth$`observed flow`)^2)
        denominatorNSE <- sum( (mean(flowMonth$`observed flow`) - flowMonth$`observed flow`)^2)
        calibEff$NSE[j] <- 1 - (numeratorNSE / denominatorNSE)
        
        
        
      }
      
      # sort calibEff so that months are in ascending order
      calibEff <- calibEff[ with(calibEff, order(month)), ]
      
      # set plot title
      plotTitle <- paste0(siteNamesForTitle[i], ": model efficiency calculated from daily flows\n summed by month over study period\n")
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/model_efficiency_dailyQ_sumMonthlyOverStudyPeriod_",siteNames[i], 
                         ".jpg")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # set up 2-figure plot
      par(mfrow=c(2,1))
      
      # plot volumetric efficiency
      plot(calibEff$month, calibEff$VE, type="b", lwd=2, xaxt="n", col="royalblue", xlab="Month",
           ylab="Volumetric efficiency", main=plotTitle)
      axis(1, at= calibEff$month)
      text(calibEff$month, calibEff$VE, labels=round(calibEff$VE, digits=1), cex=0.7, pos=1, col="royalblue4")
      grid()
      
      #plot nash-sutcliff efficiency
      plot(calibEff$month, calibEff$NSE, type="b", lwd=2, xaxt="n", col="royalblue", xlab="Month",
           ylab="Nash-Sutcliffe efficiency")
      axis(1, at= calibEff$month)
      text(calibEff$month, calibEff$NSE, labels=round(calibEff$NSE, digits=1), cex=0.7, pos=1, col="royalblue4")
      grid()
      
      # close device
      dev.off()
      
      # get back to 1-figure plot
      par(mfrow=c(1,1))
      
      # export csv
      csvFilename <- paste0("./R_outputs/", runFolder, "/tables/model_efficiency_dailyQ_sumMonthlyOverStudyPeriod_",siteNames[i], ".csv")
      write.csv(calibEff, file=csvFilename, row.names=FALSE)
      
    }
    
    
    
    
    
    
    
    ### calculate volumetric efficiency and nash-sutcliffe efficiency for each month within each HY #######
    
    
    for (i in 1:length(siteNames)){
      
      # select one site
      flow <- dailyFlowWideList[[i]]
      
      # create vector of hydrologic years
      hydYear <- unique(flow$hydYear)
      
      # create vector of months
      month <- sort(unique(flow$month))
      
      # create data frame for storing volumetric efficiencies for each month of each HY
      yearMonth <- aggregate.data.frame(flow[,2:5], by=list(flow$hydYear, flow$month), FUN=mean)
      yearMonth <- yearMonth[,c(3:5)]
      calibEff <- data.frame(hydYear=yearMonth$hydYear, month=yearMonth$month,  
                             VE=vector(mode="numeric", length(length(month))),
                             NSE=vector(mode="numeric", length(length(month))))
      calibEff <- calibEff[ with(calibEff, order(hydYear)), ]
      
      #   # sort calibEff so that months are in ascending order
      #   calibEff <- calibEff[ with(calibEff, order(month)), ]
      
      
      # cycle through hydrologic years
      # why are some of the volumetric efficiencies negative? 
      # because the sum of errors is greater than the sum of observed flows
      # so the criss and winston (2008) paper is wrong in saying that VE is bounded between 0 and 1
      for (j in 1:length(hydYear)){
        
        for (k in 1:length(month)){
          
          
          # select year and month
          flowYear <- flow[flow$hydYear == hydYear[j], ]
          flowYearMonth <- flowYear[flowYear$month == month[k], ]
          
          # volumetric efficiency
          numeratorVE <- sum(abs(flowYearMonth$`simulated flow` - flowYearMonth$`observed flow`))
          denominatorVE <- sum(flowYearMonth$`observed flow`)
          calibEff$VE[k+(12*(j-1))] <- 1 - (numeratorVE / denominatorVE)
          
          # nash-sutcliff efficiency
          numeratorNSE <- sum( (flowYearMonth$`simulated flow` - flowYearMonth$`observed flow`)^2)
          denominatorNSE <- sum( (mean(flowYearMonth$`observed flow`) - flowYearMonth$`observed flow`)^2)
          calibEff$NSE[k+(12*(j-1))] <- 1 - (numeratorNSE / denominatorNSE)
          
          
          #       # volumetric efficiency
          #       numeratorVE <- sum(abs(flowYearMonth$`simulated flow` - (flowYearMonth$`observed flow`+0.000001)))
          #       denominatorVE <- sum(flowYearMonth$`observed flow`+0.000001)
          #       calibEff$VE[k+(12*(j-1))] <- 1 - (numeratorVE / denominatorVE)
          #       
          #       # nash-sutcliff efficiency
          #       numeratorNSE <- sum( (flowYearMonth$`simulated flow` - (flowYearMonth$`observed flow`+0.000001))^2)
          #       denominatorNSE <- sum( (mean(flowYearMonth$`observed flow`+0.000001) - flowYearMonth$`observed flow`)^2)
          #       calibEff$NSE[k+(12*(j-1))] <- 1 - (numeratorNSE / denominatorNSE)
          
          
        }
        
        
        # select for plottiing
        calibEffSelect <- calibEff[calibEff$hydYear == hydYear[j],]
        
        # set file name
        filename <- paste0("./R_outputs/", runFolder, "/plots/model_efficiency_dailyQ_sumMonthlyOverEachYear_",siteNames[i],"_",hydYear[j], 
                           ".jpg")
        
        # set plot title
        plotTitle <- paste0(siteNamesForTitle[i], ", HY ", hydYear[j], ": model efficiency calculated\n from daily flows summed by month\n")
        
        # open plotting device
        jpeg(filename=filename, width = 12, height = 8, 
             units = "in", quality = 75, res = 300) 
        
        # set up 2-figure plot
        par(mfrow=c(2,1))
        
        # plot volumetric efficiency
        plot(calibEffSelect$month, calibEffSelect$VE, type="b", lwd=2, xaxt="n", col="royalblue", xlab="Month",
             ylab="Volumetric efficiency", main=plotTitle)
        axis(1, at= calibEff$month)
        text(calibEffSelect$month, calibEffSelect$VE, labels=round(calibEffSelect$VE, digits=1), cex=0.7, pos=1, col="royalblue4")
        grid()
        
        #plot nash-sutcliff efficiency
        plot(calibEffSelect$month, calibEffSelect$NSE, type="b", lwd=2, xaxt="n", col="royalblue", xlab="Month",
             ylab="Nash-Sutcliffe efficiency")
        axis(1, at= calibEff$month)
        text(calibEffSelect$month, calibEffSelect$NSE, labels=round(calibEffSelect$NSE, digits=1), cex=0.7, pos=1, col="royalblue4")
        grid()
        
        # close device
        dev.off()
        
        # get back to 1-figure plot
        par(mfrow=c(1,1))
        
        
      }
      
      # export csv
      csvFilename <- paste0("./R_outputs/", runFolder, "/tables/model_efficiency_dailyQ_sumMonthlyOverEachYear_",siteNames[i], ".csv")
      write.csv(calibEff, file=csvFilename, row.names=FALSE)
      
    }
    
  }
  
  
  
  
  
  
  #####################################################################################################
  # 16) Plot volumetric efficiency and Nash-Sutcliffe efficiency on monthly mean flows summed over HY
  ####################################################################################################
  
  if (plots_OnOff[16] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    
    # change reformatting function to do mean 
    reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                        variableValue, typeValue, idVarsInput, castFormula, 
                                        idVarsOutput){
      
      # inputData = data frame of dates and variables
      # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
      #                        want to convert to volumes, if not, just set it to 1)
      # numDateCol = number of date columns
      # typeValue = either "simulated" or "measured" to place in a type column that is used 
      # for plotting subsets of the data later on
      # variableValue = either "precipitation" or "streamflow" to place in variable column that
      # is used for plotting subsets of the data later on
      # idVarsInput = name of variables to use as id.vars in first melt function
      # castFormula = formula to use for "formula" in dcast function
      # idVarsOutput = name of variables to use as id.vars in second melt function
      
      # first data column index
      firstDataColIdx <- numDateCol + 1
      
      # convert mean daily simulated cfs to daily volumes
      inputData[, firstDataColIdx:ncol(inputData)] <- 
        inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
      
      # calculate simulated [time frame] volumes
      meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                         variable.name = "site")
      castData <- dcast(meltedData, castFormula, fun.aggregate = mean, 
                        na.rm=TRUE)
      
      # reformat simulated [time frame] volumes
      variable = rep(variableValue, nrow(castData))
      type = rep(typeValue, nrow(castData))
      castData <- data.frame(year = castData[,1], variable=variable, type=type,
                             castData[,2:ncol(castData)])
      castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
      
      return(castDataMelt)
      
    }
    
    
    #reformat sub_cfs_hyd for plotting
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    sub_cfs_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                        numDateCol, variableValue, typeValue,  
                                                        idVarsInput, castFormula, idVarsOutput)
    
    #reformat runoff_hyd for plotting
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    runoff_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue, typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    
    
    # change reformatting back to sum
    reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                        variableValue, typeValue, idVarsInput, castFormula, 
                                        idVarsOutput){
      
      # inputData = data frame of dates and variables
      # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
      #                        want to convert to volumes, if not, just set it to 1)
      # numDateCol = number of date columns
      # typeValue = either "simulated" or "measured" to place in a type column that is used 
      # for plotting subsets of the data later on
      # variableValue = either "precipitation" or "streamflow" to place in variable column that
      # is used for plotting subsets of the data later on
      # idVarsInput = name of variables to use as id.vars in first melt function
      # castFormula = formula to use for "formula" in dcast function
      # idVarsOutput = name of variables to use as id.vars in second melt function
      
      # first data column index
      firstDataColIdx <- numDateCol + 1
      
      # convert mean daily simulated cfs to daily volumes
      inputData[, firstDataColIdx:ncol(inputData)] <- 
        inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
      
      # calculate simulated [time frame] volumes
      meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                         variable.name = "site")
      castData <- dcast(meltedData, castFormula, fun.aggregate = sum, 
                        na.rm=TRUE)
      
      # reformat simulated [time frame] volumes
      variable = rep(variableValue, nrow(castData))
      type = rep(typeValue, nrow(castData))
      castData <- data.frame(year = castData[,1], variable=variable, type=type,
                             castData[,2:ncol(castData)])
      castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
      
      return(castDataMelt)
      
    }
    
    
    # place simulated streamflow and measured streamflow in the same data frame
    monthlyMeanHyd <- rbind(sub_cfs_hyd_monthly_melt, runoff_hyd_monthly_melt)
    monthlyMeanHyd$month <- as.numeric(monthlyMeanHyd$month)
    
    
    # create new variable column that has the categories: 
    # precipitation, simulated flow, observed flow
    newVariableVec <- vector(mode="character", length=length(monthlyMeanHyd$variable))
    for (i in 1:length(newVariableVec)){
      
      if (monthlyMeanHyd$variable[i] %in% "precipitation"){
        newVariableVec[i] <- "precipitation"
      }
      
      if (monthlyMeanHyd$variable[i] %in% "streamflow" & monthlyMeanHyd$type[i] %in% "simulated"){
        newVariableVec[i] <- "simulated flow"
      }
      
      if (monthlyMeanHyd$variable[i] %in% "streamflow" & monthlyMeanHyd$type[i] %in% "measured"){
        newVariableVec[i] <- "observed flow"
      }
      
    }
    monthlyMeanHyd$variable <- newVariableVec
    
    
    
    # create separate data frame for each subbasin 
    siteNames <- unique(monthlyMeanHyd$site)
    monthlyMeanHydList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydList[[i]] <- subset(monthlyMeanHyd, monthlyMeanHyd$site %in% siteNames[i])
      
    }
    
    
    # create wide format data set for each subbasin
    monthlyMeanHydWideList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydWideList[[i]] <- dcast(monthlyMeanHydList[[i]][,-4], 
                                           year + month + site ~ variable)
      
    }
    
    
    # create siteNamesForTitle
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    
    
    for (i in 1:length(siteNames)){
      
      # select one site
      flow <- monthlyMeanHydWideList[[i]]
      
      # create vector of hydrologic years
      hydYear <- unique(flow$year)
      
      # create vector of months
      hydMonth <- unique(flow$month)
      
      # create data frame for storing volumetric efficiencies for each month
      calibEff <- data.frame(hydYear=hydYear, VE=vector(mode="numeric", length((hydYear))), 
                             NSE=vector(mode="numeric", length((hydYear))))
      
      
      # cycle through hydrologic years
      # why are some of the volumetric efficiencies negative? 
      # because the sum of errors is greater than the sum of observed flows
      # so the criss and winston (2008) paper is wrong in saying that VE is bounded between 0 and 1
      for (j in 1:length(hydYear)){
        
        # select year
        flowHydYear <- flow[flow$year == hydYear[j], ]
        
        # volumetric efficiency
        numeratorVE <- sum(abs(flowHydYear$`simulated flow` - flowHydYear$`observed flow`), na.rm=TRUE)
        denominatorVE <- sum(flowHydYear$`observed flow`, na.rm=TRUE)
        calibEff$VE[j] <- 1 - (numeratorVE / denominatorVE)
        
        # nash-sutcliff efficiency
        numeratorNSE <- sum( (flowHydYear$`simulated flow` - flowHydYear$`observed flow`)^2, na.rm=TRUE)
        denominatorNSE <- sum( (mean(flowHydYear$`observed flow`,na.rm=TRUE) - flowHydYear$`observed flow`)^2, na.rm=TRUE)
        calibEff$NSE[j] <- 1 - (numeratorNSE / denominatorNSE)
        
        
      }
      
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/model_efficiency_monthlyMeanQ_sumHY_",siteNames[i], 
                         ".jpg")
      
      # set plot title
      plotTitle <- paste0(siteNamesForTitle[i], ": model efficiency calculated\n from monthly mean flows summed by year\n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # set up 2-figure plot
      par(mfrow=c(2,1))
      
      # plot volumetric efficiency
      plot(calibEff$hydYear, calibEff$VE, type="b", lwd=2, col="royalblue", xlab="Hydrologic year",
           ylab="Volumetric efficiency", main=plotTitle)
      axis(1, at= calibEff$hydYear)
      grid()
      
      #plot nash-sutcliff efficiency
      plot(calibEff$hydYear, calibEff$NSE, type="b", lwd=2, col="royalblue", xlab="Hydrologic year",
           ylab="Nash-Sutcliffe efficiency")
      axis(1, at= calibEff$hydYear)
      grid()
      
      # close plotting device
      dev.off()
      
      # get back to 1-figure plot
      par(mfrow=c(1,1))
      
      # export csv
      csvFilename <- paste0("./R_outputs/", runFolder, "/tables/model_efficiency_monthlyMeanQ_sumHY_",siteNames[i], ".csv")
      write.csv(calibEff, file=csvFilename, row.names=FALSE)
      
    }
    
  }
  
  
  
  
  
  
  
  
  #####################################################################################################
  # 17) Plot volumetric efficiency and Nash-Sutcliffe efficiency on monthly mean flows summed over
  #     that month during study period
  ####################################################################################################
  
  if (plots_OnOff[17] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    
    # change reformatting function to do mean 
    reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                        variableValue, typeValue, idVarsInput, castFormula, 
                                        idVarsOutput){
      
      # inputData = data frame of dates and variables
      # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
      #                        want to convert to volumes, if not, just set it to 1)
      # numDateCol = number of date columns
      # typeValue = either "simulated" or "measured" to place in a type column that is used 
      # for plotting subsets of the data later on
      # variableValue = either "precipitation" or "streamflow" to place in variable column that
      # is used for plotting subsets of the data later on
      # idVarsInput = name of variables to use as id.vars in first melt function
      # castFormula = formula to use for "formula" in dcast function
      # idVarsOutput = name of variables to use as id.vars in second melt function
      
      # first data column index
      firstDataColIdx <- numDateCol + 1
      
      # convert mean daily simulated cfs to daily volumes
      inputData[, firstDataColIdx:ncol(inputData)] <- 
        inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
      
      # calculate simulated [time frame] volumes
      meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                         variable.name = "site")
      castData <- dcast(meltedData, castFormula, fun.aggregate = mean, 
                        na.rm=TRUE)
      
      # reformat simulated [time frame] volumes
      variable = rep(variableValue, nrow(castData))
      type = rep(typeValue, nrow(castData))
      castData <- data.frame(year = castData[,1], variable=variable, type=type,
                             castData[,2:ncol(castData)])
      castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
      
      return(castDataMelt)
      
    }
    
    
    #reformat sub_cfs_hyd for plotting
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    sub_cfs_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                        numDateCol, variableValue, typeValue,  
                                                        idVarsInput, castFormula, idVarsOutput)
    
    #reformat runoff_hyd for plotting
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    runoff_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue, typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    
    
    # change reformatting back to sum
    reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                        variableValue, typeValue, idVarsInput, castFormula, 
                                        idVarsOutput){
      
      # inputData = data frame of dates and variables
      # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
      #                        want to convert to volumes, if not, just set it to 1)
      # numDateCol = number of date columns
      # typeValue = either "simulated" or "measured" to place in a type column that is used 
      # for plotting subsets of the data later on
      # variableValue = either "precipitation" or "streamflow" to place in variable column that
      # is used for plotting subsets of the data later on
      # idVarsInput = name of variables to use as id.vars in first melt function
      # castFormula = formula to use for "formula" in dcast function
      # idVarsOutput = name of variables to use as id.vars in second melt function
      
      # first data column index
      firstDataColIdx <- numDateCol + 1
      
      # convert mean daily simulated cfs to daily volumes
      inputData[, firstDataColIdx:ncol(inputData)] <- 
        inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
      
      # calculate simulated [time frame] volumes
      meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                         variable.name = "site")
      castData <- dcast(meltedData, castFormula, fun.aggregate = sum, 
                        na.rm=TRUE)
      
      # reformat simulated [time frame] volumes
      variable = rep(variableValue, nrow(castData))
      type = rep(typeValue, nrow(castData))
      castData <- data.frame(year = castData[,1], variable=variable, type=type,
                             castData[,2:ncol(castData)])
      castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
      
      return(castDataMelt)
      
    }
    
    
    # place simulated streamflow and measured streamflow in the same data frame
    monthlyMeanHyd <- rbind(sub_cfs_hyd_monthly_melt, runoff_hyd_monthly_melt)
    monthlyMeanHyd$month <- as.numeric(monthlyMeanHyd$month)
    
    
    # create new variable column that has the categories: 
    # precipitation, simulated flow, observed flow
    newVariableVec <- vector(mode="character", length=length(monthlyMeanHyd$variable))
    for (i in 1:length(newVariableVec)){
      
      if (monthlyMeanHyd$variable[i] %in% "precipitation"){
        newVariableVec[i] <- "precipitation"
      }
      
      if (monthlyMeanHyd$variable[i] %in% "streamflow" & monthlyMeanHyd$type[i] %in% "simulated"){
        newVariableVec[i] <- "simulated flow"
      }
      
      if (monthlyMeanHyd$variable[i] %in% "streamflow" & monthlyMeanHyd$type[i] %in% "measured"){
        newVariableVec[i] <- "observed flow"
      }
      
    }
    monthlyMeanHyd$variable <- newVariableVec
    
    
    
    ### calculate for years 1996 - 2014 ######################################################################
    
    
    # create separate data frame for each subbasin 
    siteNames <- unique(monthlyMeanHyd$site)
    monthlyMeanHydList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydList[[i]] <- subset(monthlyMeanHyd, monthlyMeanHyd$site %in% siteNames[i])
      
    }
    
    
    # create wide format data set for each subbasin
    monthlyMeanHydWideList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydWideList[[i]] <- dcast(monthlyMeanHydList[[i]][,-4], 
                                           year + month + site ~ variable)
      
    }
    
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    # calculate efficiencies and plot
    for (i in 1:length(siteNames)){
      
      # select one site
      flow <- monthlyMeanHydWideList[[i]]
      
      # create vector of hydrologic years
      hydYear <- unique(flow$year)
      
      # create vector of months
      hydMonth <- unique(flow$month)
      
      # create data frame for storing volumetric efficiencies for each month
      calibEff <- data.frame(hydMonth=hydMonth, VE=vector(mode="numeric", length((hydMonth))), 
                             NSE=vector(mode="numeric", length((hydMonth))))
      
      
      # cycle through hydrologic months
      # why are some of the volumetric efficiencies negative? 
      # because the sum of errors is greater than the sum of observed flows
      # so the criss and winston (2008) paper is wrong in saying that VE is bounded between 0 and 1
      for (j in 1:length(hydMonth)){
        
        # select year
        flowHydMonth <- flow[flow$month == hydMonth[j], ]
        
        # volumetric efficiency
        numeratorVE <- sum(abs(flowHydMonth$`simulated flow` - flowHydMonth$`observed flow`), na.rm=TRUE)
        denominatorVE <- sum(flowHydMonth$`observed flow`, na.rm=TRUE)
        calibEff$VE[j] <- 1 - (numeratorVE / denominatorVE)
        
        # nash-sutcliff efficiency
        numeratorNSE <- sum( (flowHydMonth$`simulated flow` - flowHydMonth$`observed flow`)^2, na.rm=TRUE)
        denominatorNSE <- sum( (mean(flowHydMonth$`observed flow`, na.rm=TRUE) - flowHydMonth$`observed flow`)^2, na.rm=TRUE)
        calibEff$NSE[j] <- 1 - (numeratorNSE / denominatorNSE)
        
        
      }
      
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/model_efficiency_monthlyMeanQ_monthlySum_",siteNames[i], 
                         ".jpg")
      
      # set plot title
      plotTitle <- paste0(siteNamesForTitle[i], ": model efficiency calculated\n from monthly mean flows summed by month over study period\n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # set up 2-figure plot
      par(mfrow=c(2,1))
      
      # plot volumetric efficiency
      plot(calibEff$hydMonth, calibEff$VE, type="b", lwd=2, col="royalblue", xlab="Month",
           ylab="Volumetric efficiency", main=plotTitle, xaxt="n")
      axis(1, at= calibEff$hydMonth, labels=hydMonth[c(10,11,12,1:9)])
      text(calibEff$hydMonth, calibEff$VE, labels=round(calibEff$VE, digits=1), cex=0.7, pos=1, col="royalblue4")
      grid()
      
      #plot nash-sutcliff efficiency
      plot(calibEff$hydMonth, calibEff$NSE, type="b", lwd=2, col="royalblue", xlab="Month",
           ylab="Nash-Sutcliffe efficiency", xaxt="n")
      axis(1, at= calibEff$hydMonth, labels=hydMonth[c(10,11,12,1:9)])
      text(calibEff$hydMonth, calibEff$NSE, labels=round(calibEff$NSE, digits=1), cex=0.7, pos=1, col="royalblue4")
      grid()
      
      # close plotting device
      dev.off()
      
      # export csv
      csvFilename <- paste0("./R_outputs/", runFolder, "/tables/model_efficiency_monthlyMeanQ_monthlySum_",siteNames[i], ".csv")
      write.csv(calibEff, file=csvFilename, row.names=FALSE)
      
    }
    
    # get back to 1-figure plot
    par(mfrow=c(1,1))
    
    
    
    
    
    
    ### calculate for years 2000 - 2014 ######################################################################
    
    
    # remove years 1996 - 1999 (this will remove it for both watersheds even though want it for Arroyo Hondo)
    monthlyMeanHyd <- subset(monthlyMeanHyd, monthlyMeanHyd$year %in% c(2000:2014))
    
    
    # create separate data frame for each subbasin 
    siteNames <- unique(monthlyMeanHyd$site)
    monthlyMeanHydList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydList[[i]] <- subset(monthlyMeanHyd, monthlyMeanHyd$site %in% siteNames[i])
      
    }
    
    
    # create wide format data set for each subbasin
    monthlyMeanHydWideList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydWideList[[i]] <- dcast(monthlyMeanHydList[[i]][,-4], 
                                           year + month + site ~ variable)
      
    }
    
    
    # create siteNamesForTitle
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    # calculate efficiencies and plot
    for (i in 1:length(siteNames)){
      
      # select one site
      flow <- monthlyMeanHydWideList[[i]]
      
      # create vector of hydrologic years
      hydYear <- unique(flow$year)
      
      # create vector of months
      hydMonth <- unique(flow$month)
      
      # create data frame for storing volumetric efficiencies for each month
      calibEff <- data.frame(hydMonth=hydMonth, VE=vector(mode="numeric", length((hydMonth))), 
                             NSE=vector(mode="numeric", length((hydMonth))))
      
      
      # cycle through hydrologic months
      # why are some of the volumetric efficiencies negative? 
      # because the sum of errors is greater than the sum of observed flows
      # so the criss and winston (2008) paper is wrong in saying that VE is bounded between 0 and 1
      for (j in 1:length(hydMonth)){
        
        # select year
        flowHydMonth <- flow[flow$month == hydMonth[j], ]
        
        # volumetric efficiency
        numeratorVE <- sum(abs(flowHydMonth$`simulated flow` - flowHydMonth$`observed flow`), na.rm=TRUE)
        denominatorVE <- sum(flowHydMonth$`observed flow`, na.rm=TRUE)
        calibEff$VE[j] <- 1 - (numeratorVE / denominatorVE)
        
        # nash-sutcliff efficiency
        numeratorNSE <- sum( (flowHydMonth$`simulated flow` - flowHydMonth$`observed flow`)^2, na.rm=TRUE)
        denominatorNSE <- sum( (mean(flowHydMonth$`observed flow`, na.rm=TRUE) - flowHydMonth$`observed flow`)^2, na.rm=TRUE)
        calibEff$NSE[j] <- 1 - (numeratorNSE / denominatorNSE)
        
        
      }
      
      
      #   # set file name
      #   filename <- paste0("model_efficiency_monthlyMeanQ_monthlySum_",siteNames[i], 
      #                      ".jpg")
      #   
      #   # set plot title
      #   plotTitle <- paste0(siteNamesForTitle[i], ": model efficiency calculated\n from monthly mean flows summed by month over study period\n")
      #   
      #   # open plotting device
      #   jpeg(filename=filename, width = 12, height = 8, 
      #        units = "in", quality = 75, res = 300)  
      #   
      #   # set up 2-figure plot
      #   par(mfrow=c(2,1))
      #   
      #   # plot volumetric efficiency
      #   plot(calibEff$hydMonth, calibEff$VE, type="b", lwd=2, col="royalblue", xlab="Month",
      #        ylab="Volumetric efficiency", main=plotTitle, xaxt="n")
      #   axis(1, at= calibEff$hydMonth, labels=hydMonth[c(10,11,12,1:9)])
      #   text(calibEff$hydMonth, calibEff$VE, labels=round(calibEff$VE, digits=1), cex=0.7, pos=1, col="royalblue4")
      #   grid()
      #   
      #   #plot nash-sutcliff efficiency
      #   plot(calibEff$hydMonth, calibEff$NSE, type="b", lwd=2, col="royalblue", xlab="Month",
      #        ylab="Nash-Sutcliffe efficiency", xaxt="n")
      #   axis(1, at= calibEff$hydMonth, labels=hydMonth[c(10,11,12,1:9)])
      #   text(calibEff$hydMonth, calibEff$NSE, labels=round(calibEff$NSE, digits=1), cex=0.7, pos=1, col="royalblue4")
      #   grid()
      #   
      #   # close plotting device
      #   dev.off()
      
      # export csv
      csvFilename <- paste0("./R_outputs/", runFolder, "/tables/model_efficiency_monthlyMeanQ_monthlySum_starting2000",siteNames[i], ".csv")
      write.csv(calibEff, file=csvFilename, row.names=FALSE)
      
    }
    
    # get back to 1-figure plot
    par(mfrow=c(1,1))
    
    
  }
  
  
  
  ##############################################################################################
  # 18) Plot volumetric efficiency and Nash-Sutcliffe efficiency on annual volumes 
  ##############################################################################################
  
  if (plots_OnOff[18] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    
    #reformat sub_cfs_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_cfs_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue,typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_cfs_hyd_annual_melt$value <- sub_cfs_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat runoff_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    runoff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                      numDateCol, variableValue, typeValue, 
                                                      idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    runoff_hyd_annual_melt$value <- runoff_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    
    # place simulated streamflow and measured streamflow in the same data frame
    annualTotalHyd <- rbind(sub_cfs_hyd_annual_melt, runoff_hyd_annual_melt)
    
    # create vector of site names
    siteNames <- unique(annualTotalHyd$site)
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    # create new variable column that has the categories: 
    # precipitation, simulated flow, observed flow
    newVariableVec <- vector(mode="character", length=length(annualTotalHyd$variable))
    for (i in 1:length(newVariableVec)){
      
      if (annualTotalHyd$variable[i] %in% "precipitation"){
        newVariableVec[i] <- "precipitation"
      }
      
      if (annualTotalHyd$variable[i] %in% "streamflow" & annualTotalHyd$type[i] %in% "simulated"){
        newVariableVec[i] <- "simulated flow"
      }
      
      if (annualTotalHyd$variable[i] %in% "streamflow" & annualTotalHyd$type[i] %in% "measured"){
        newVariableVec[i] <- "observed flow"
      }
      
    }
    annualTotalHyd$variable <- newVariableVec
    
    
    
    # create separate data frame for each subbasin 
    siteNames <- unique(annualTotalHyd$site)
    annualTotalHydList <- list()
    for (i in 1:length(siteNames)){
      
      annualTotalHydList[[i]] <- subset(annualTotalHyd, annualTotalHyd$site %in% siteNames[i])
      
    }
    
    
    # create wide format data set for each subbasin
    annualTotalHydWideList <- list()
    for (i in 1:length(siteNames)){
      
      annualTotalHydWideList[[i]] <- dcast(annualTotalHydList[[i]][,-3], 
                                           year + site ~ variable)
      
    }
    
    
    
    ### sum over all years #######################################################################
    
    
    # calculate efficiencies and plot
    for (i in 1:length(siteNames)){
      
      # select one site
      flow <- annualTotalHydWideList[[i]]
      
      # create vector of hydrologic years
      hydYear <- unique(flow$year)
      
      # create data frame for storing model calibration efficiencies for each year
      calibEff <- data.frame(VE=vector(mode="numeric", length=1), 
                             NSE=vector(mode="numeric", length=1))
      
      
      
      # why are some of the volumetric efficiencies negative? 
      # because the sum of errors is greater than the sum of observed flows
      # so the criss and winston (2008) paper is wrong in saying that VE is bounded between 0 and 1
      
      
      # volumetric efficiency
      numeratorVE <- sum(abs(flow$`simulated flow` - flow$`observed flow`))
      denominatorVE <- sum(flow$`observed flow`)
      calibEff$VE <- 1 - (numeratorVE / denominatorVE)
      
      # nash-sutcliff efficiency
      numeratorNSE <- sum( (flow$`simulated flow` - flow$`observed flow`)^2)
      denominatorNSE <- sum( (mean(flow$`observed flow`) - flow$`observed flow`)^2)
      calibEff$NSE <- 1 - (numeratorNSE / denominatorNSE)
      
      # export csv
      csvFilename <- paste0("./R_outputs/", runFolder, "/tables/model_efficiency_annualVolume_sum_",siteNames[i], ".csv")
      write.csv(calibEff, file=csvFilename, row.names=FALSE)
      
    }
    
    
    
    
    ### don't sum over anything ##################################################################
    
    # is it a valid volumetric efficiency if not summing over anything?
    
    # can't do Nash-Sutcliffe efficiency on annual volumes when not summing over anything because 
    # would end up dividing by 0 since the mean(Qobs) = Qobs because there is only one annual 
    # volume per year
    
    # set 1-figure
    par(mfrow=c(1,1))
    
    
    # calculate efficiencies and plot
    for (i in 1:length(siteNames)){
      
      # select one site
      flow <- annualTotalHydWideList[[i]]
      
      # create vector of hydrologic years
      hydYear <- unique(flow$year)
      
      # create data frame for storing model calibration efficiencies for each year
      calibEff <- data.frame(hydYear=hydYear, VE=vector(mode="numeric", length=length(hydYear)))
      
      # why are some of the volumetric efficiencies negative? 
      # because the sum of errors is greater than the sum of observed flows
      # so the criss and winston (2008) paper is wrong in saying that VE is bounded between 0 and 1
      
      
      # volumetric efficiency
      numeratorVE <- abs(flow$`simulated flow` - flow$`observed flow`)
      denominatorVE <- flow$`observed flow`
      calibEff$VE <- 1 - (numeratorVE / denominatorVE)
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/model_efficiency_annualVolume_noSum_",siteNames[i],".jpg")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)
      
      # set plot title
      plotTitle <- paste0(siteNamesForTitle[i], ": ", "calculated from annual volumes\n")
      
      # plot volumetric efficiency
      plot(calibEff$hydYear, calibEff$VE, type="b", lwd=2, xaxt="n", col="royalblue4", xlab="Hydrologic year",
           ylab="Volumetric efficiency", main=plotTitle)
      axis(1, at= calibEff$hydYear)
      text(calibEff$hydYear, calibEff$VE, labels=round(calibEff$VE, digits=1), cex=0.7, pos=1, col="royalblue4")
      grid()
      
      # close device
      dev.off()
      
      # export csv
      csvFilename <- paste0("./R_outputs/", runFolder, "/tables/model_efficiency_annualVolume_noSum_",siteNames[i], ".csv")
      write.csv(calibEff, file=csvFilename, row.names=FALSE)
      
    }
    
    
    
  }
  
  
  
  
  ##############################################################################################
  # 19) Plot correlation coefficient 
  ##############################################################################################
  
  # # select allVar
  # allVar = allVarSubbasin
  # allVar_hydYear = allVarSubbasin_hydYear
  # allVar_hydYearMonth = allVarSubbasin_hydYearMonth
  
  
  
  ##############################################################################################
  # 20) Plot monthly mean flows with monthly precip sums 
  ##############################################################################################
  
  
  if (plots_OnOff[20] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    
    # reformat subinc_precip_hyd for plotting monthly totals
    inputData <- allVar_hydYearMonth$subinc_precip[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue = "precipitation"
    typeValue="estimated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    subinc_precip_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                              numDateCol, variableValue, typeValue, 
                                                              idVarsInput, castFormula, idVarsOutput)
    #subinc_precip_hyd_monthly_melt$month <- as.factor(subinc_precip_hyd_monthly_melt$month)
    
    
    
    # change reformatting function to do mean 
    reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                        variableValue, typeValue, idVarsInput, castFormula, 
                                        idVarsOutput){
      
      # inputData = data frame of dates and variables
      # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
      #                        want to convert to volumes, if not, just set it to 1)
      # numDateCol = number of date columns
      # typeValue = either "simulated" or "measured" to place in a type column that is used 
      # for plotting subsets of the data later on
      # variableValue = either "precipitation" or "streamflow" to place in variable column that
      # is used for plotting subsets of the data later on
      # idVarsInput = name of variables to use as id.vars in first melt function
      # castFormula = formula to use for "formula" in dcast function
      # idVarsOutput = name of variables to use as id.vars in second melt function
      
      # first data column index
      firstDataColIdx <- numDateCol + 1
      
      # convert mean daily simulated cfs to daily volumes
      inputData[, firstDataColIdx:ncol(inputData)] <- 
        inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
      
      # calculate simulated [time frame] volumes
      meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                         variable.name = "site")
      castData <- dcast(meltedData, castFormula, fun.aggregate = mean, 
                        na.rm=TRUE)
      
      # reformat simulated [time frame] volumes
      variable = rep(variableValue, nrow(castData))
      type = rep(typeValue, nrow(castData))
      castData <- data.frame(year = castData[,1], variable=variable, type=type,
                             castData[,2:ncol(castData)])
      castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
      
      return(castDataMelt)
      
    }
    
    
    #reformat sub_cfs_hyd for plotting
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    sub_cfs_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                        numDateCol, variableValue, typeValue,  
                                                        idVarsInput, castFormula, idVarsOutput)
    
    #reformat runoff_hyd for plotting
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    runoff_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue, typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    
    
    # change reformatting back to sum
    reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                        variableValue, typeValue, idVarsInput, castFormula, 
                                        idVarsOutput){
      
      # inputData = data frame of dates and variables
      # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
      #                        want to convert to volumes, if not, just set it to 1)
      # numDateCol = number of date columns
      # typeValue = either "simulated" or "measured" to place in a type column that is used 
      # for plotting subsets of the data later on
      # variableValue = either "precipitation" or "streamflow" to place in variable column that
      # is used for plotting subsets of the data later on
      # idVarsInput = name of variables to use as id.vars in first melt function
      # castFormula = formula to use for "formula" in dcast function
      # idVarsOutput = name of variables to use as id.vars in second melt function
      
      # first data column index
      firstDataColIdx <- numDateCol + 1
      
      # convert mean daily simulated cfs to daily volumes
      inputData[, firstDataColIdx:ncol(inputData)] <- 
        inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
      
      # calculate simulated [time frame] volumes
      meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                         variable.name = "site")
      castData <- dcast(meltedData, castFormula, fun.aggregate = sum, 
                        na.rm=TRUE)
      
      # reformat simulated [time frame] volumes
      variable = rep(variableValue, nrow(castData))
      type = rep(typeValue, nrow(castData))
      castData <- data.frame(year = castData[,1], variable=variable, type=type,
                             castData[,2:ncol(castData)])
      castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
      
      return(castDataMelt)
      
    }
    
    
    
    
    # place watershed precipitation, simulated streamflow, and measured streamflow in the same data frame
    monthlyMeanHyd <- rbind(subinc_precip_hyd_monthly_melt, sub_cfs_hyd_monthly_melt, runoff_hyd_monthly_melt)
    monthlyMeanHyd$month <- as.numeric(monthlyMeanHyd$month)
    
    
    # create new variable column that has the categories: 
    # precipitation, simulated flow, observed flow
    newVariableVec <- vector(mode="character", length=length(monthlyMeanHyd$variable))
    for (i in 1:length(newVariableVec)){
      
      if (monthlyMeanHyd$variable[i] %in% "precipitation"){
        newVariableVec[i] <- "precipitation"
      }
      
      if (monthlyMeanHyd$variable[i] %in% "streamflow" & monthlyMeanHyd$type[i] %in% "simulated"){
        newVariableVec[i] <- "simulated flow"
      }
      
      if (monthlyMeanHyd$variable[i] %in% "streamflow" & monthlyMeanHyd$type[i] %in% "measured"){
        newVariableVec[i] <- "observed flow"
      }
      
    }
    monthlyMeanHyd$variable <- newVariableVec
    
    
    
    # create separate data frame for each subbasin 
    siteNames <- unique(monthlyMeanHyd$site)
    monthlyMeanHydList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydList[[i]] <- subset(monthlyMeanHyd, monthlyMeanHyd$site %in% siteNames[i])
      
    }
    
    
    # create wide format data set for each subbasin
    monthlyMeanHydWideList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydWideList[[i]] <- dcast(monthlyMeanHydList[[i]][,-4], 
                                           year + month + site ~ variable)
      
    }
    
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # select data frame
      monthlyMeanHydSite <- monthlyMeanHydWideList[[i]]
      
      # loop through years
      year <- unique(monthlyMeanHydSite$year)
      for (j in 1:length(year)){
        
        # set file name
        filename <- paste0("./R_outputs/", runFolder, "/plots/monthlyMeanFlowPrecip_", siteNames[i], "_", year[j], 
                           ".jpg")
        
        # open plotting device
        jpeg(filename=filename, width = 12, height = 8, 
             units = "in", quality = 75, res = 300)  
        
        # set plot title
        plotTitle <- paste0(siteNamesForTitle[i], ", HY ", year[j], ": monthly mean simulated vs. measured streamflow\n")
        
        # select year
        monthlyMeanHydSiteYear <- monthlyMeanHydSite[ monthlyMeanHydSite$year == year[j], ]
        
        
        # set min and max flows
        minFlow <- min(monthlyMeanHydSiteYear$`observed flow`, monthlyMeanHydSiteYear$`simulated flow`, na.rm=TRUE)
        maxFlow <- max(monthlyMeanHydSiteYear$`observed flow`, monthlyMeanHydSiteYear$`simulated flow`, na.rm=TRUE)
        
        # plot 
        par(mar=c(5,4,4,5) + 0.1)
        plot(monthlyMeanHydSiteYear$month, monthlyMeanHydSiteYear$`observed flow`, type="l", lwd=2, col="cornflowerblue", main=plotTitle, 
             xlab = "Month", ylab="Flow (cfs)", ylim=c(minFlow,maxFlow), xaxt="n")
        axis(1, at=c("1","2","3","4","5","6","7","8","9","10","11","12"), 
             labels=c("10","11","12","1","2","3","4","5","6","7","8","9"))
        lines(monthlyMeanHydSiteYear$month, monthlyMeanHydSiteYear$`simulated flow`, type="l", lwd=2, col="indianred2")
        grid()
        par(new=TRUE)
        plot(monthlyMeanHydSiteYear$month, monthlyMeanHydSiteYear$precipitation, type='l', lty=3, lwd=2, col="yellow3", xaxt="n", yaxt="n", xlab="", 
             ylab="", ylim=rev(range(monthlyMeanHydSiteYear$precipitation)))
        axis(4)
        mtext("Precipitation (inches)", side=4, line=3)
        legend("topright", legend=c("observed flow", "simulated flow", "precipitation"), 
               col=c("cornflowerblue", "indianred2", "yellow3"), lty=c(1,1,3), lwd=3, bty="n")
        
        
        
        # close plotting device
        dev.off()
        
        
      }
      
      
    }
    
    
    
  }
  
  
  
  ##############################################################################################
  # 21) Plot monthly observed and simulated flow averaged over all years
  ##############################################################################################
  
  if (plots_OnOff[21] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    
    # reformat subinc_precip_hyd for plotting monthly totals
    inputData <- allVar_hydYearMonth$subinc_precip[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue = "precipitation"
    typeValue="estimated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    subinc_precip_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                              numDateCol, variableValue, typeValue, 
                                                              idVarsInput, castFormula, idVarsOutput)
    #subinc_precip_hyd_monthly_melt$month <- as.factor(subinc_precip_hyd_monthly_melt$month)
    
    
    
    # change reformatting function to do mean 
    reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                        variableValue, typeValue, idVarsInput, castFormula, 
                                        idVarsOutput){
      
      # inputData = data frame of dates and variables
      # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
      #                        want to convert to volumes, if not, just set it to 1)
      # numDateCol = number of date columns
      # typeValue = either "simulated" or "measured" to place in a type column that is used 
      # for plotting subsets of the data later on
      # variableValue = either "precipitation" or "streamflow" to place in variable column that
      # is used for plotting subsets of the data later on
      # idVarsInput = name of variables to use as id.vars in first melt function
      # castFormula = formula to use for "formula" in dcast function
      # idVarsOutput = name of variables to use as id.vars in second melt function
      
      # first data column index
      firstDataColIdx <- numDateCol + 1
      
      # convert mean daily simulated cfs to daily volumes
      inputData[, firstDataColIdx:ncol(inputData)] <- 
        inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
      
      # calculate simulated [time frame] volumes
      meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                         variable.name = "site")
      castData <- dcast(meltedData, castFormula, fun.aggregate = mean, 
                        na.rm=TRUE)
      
      # reformat simulated [time frame] volumes
      variable = rep(variableValue, nrow(castData))
      type = rep(typeValue, nrow(castData))
      castData <- data.frame(year = castData[,1], variable=variable, type=type,
                             castData[,2:ncol(castData)])
      castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
      
      return(castDataMelt)
      
    }
    
    
    #reformat sub_cfs_hyd for plotting
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="simulated"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    sub_cfs_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                        numDateCol, variableValue, typeValue,  
                                                        idVarsInput, castFormula, idVarsOutput)
    
    #reformat runoff_hyd for plotting
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="measured"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year + month ~ site
    idVarsOutput <- c("year", "month", "variable", "type")
    runoff_hyd_monthly_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue, typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    
    
    # change reformatting back to sum
    reformatDataForPlotting <- function(inputData, multiplicationFactor, numDateCol,
                                        variableValue, typeValue, idVarsInput, castFormula, 
                                        idVarsOutput){
      
      # inputData = data frame of dates and variables
      # multiplicationFactor = factor to multiply data columns by to convert them to volumes (if 
      #                        want to convert to volumes, if not, just set it to 1)
      # numDateCol = number of date columns
      # typeValue = either "simulated" or "measured" to place in a type column that is used 
      # for plotting subsets of the data later on
      # variableValue = either "precipitation" or "streamflow" to place in variable column that
      # is used for plotting subsets of the data later on
      # idVarsInput = name of variables to use as id.vars in first melt function
      # castFormula = formula to use for "formula" in dcast function
      # idVarsOutput = name of variables to use as id.vars in second melt function
      
      # first data column index
      firstDataColIdx <- numDateCol + 1
      
      # convert mean daily simulated cfs to daily volumes
      inputData[, firstDataColIdx:ncol(inputData)] <- 
        inputData[, firstDataColIdx:ncol(inputData)] * multiplicationFactor
      
      # calculate simulated [time frame] volumes
      meltedData <- melt(inputData, na.rm=FALSE, id.vars = idVarsInput, 
                         variable.name = "site")
      castData <- dcast(meltedData, castFormula, fun.aggregate = sum, 
                        na.rm=TRUE)
      
      # reformat simulated [time frame] volumes
      variable = rep(variableValue, nrow(castData))
      type = rep(typeValue, nrow(castData))
      castData <- data.frame(year = castData[,1], variable=variable, type=type,
                             castData[,2:ncol(castData)])
      castDataMelt <- melt(castData, id.vars=idVarsOutput, variable.name = "site")
      
      return(castDataMelt)
      
    }
    
    
    
    
    # place watershed precipitation, simulated streamflow, and measured streamflow in the same data frame
    monthlyMeanHyd <- rbind(subinc_precip_hyd_monthly_melt, sub_cfs_hyd_monthly_melt, runoff_hyd_monthly_melt)
    monthlyMeanHyd$month <- as.numeric(monthlyMeanHyd$month)
    
    
    # create new variable column that has the categories: 
    # precipitation, simulated flow, observed flow
    newVariableVec <- vector(mode="character", length=length(monthlyMeanHyd$variable))
    for (i in 1:length(newVariableVec)){
      
      if (monthlyMeanHyd$variable[i] %in% "precipitation"){
        newVariableVec[i] <- "precipitation"
      }
      
      if (monthlyMeanHyd$variable[i] %in% "streamflow" & monthlyMeanHyd$type[i] %in% "simulated"){
        newVariableVec[i] <- "simulated flow"
      }
      
      if (monthlyMeanHyd$variable[i] %in% "streamflow" & monthlyMeanHyd$type[i] %in% "measured"){
        newVariableVec[i] <- "observed flow"
      }
      
    }
    monthlyMeanHyd$variable <- newVariableVec
    
    
    
    # create separate data frame for each subbasin 
    siteNames <- unique(monthlyMeanHyd$site)
    monthlyMeanHydList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydList[[i]] <- subset(monthlyMeanHyd, monthlyMeanHyd$site %in% siteNames[i])
      
    }
    
    
    # create wide format data set for each subbasin
    # also take mean over all years here
    monthlyMeanHydWideList <- list()
    for (i in 1:length(siteNames)){
      
      monthlyMeanHydWideList[[i]] <- dcast(monthlyMeanHydList[[i]][,-4], 
                                           month + site ~ variable, 
                                           fun.aggregate = mean)
      
    }
    
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # select data frame
      monthlyMeanHydSite <- monthlyMeanHydWideList[[i]]
      
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/monthlyMeanFlowPrecipAvgAll_", siteNames[i], ".jpg")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8,
           units = "in", quality = 75, res = 300)
      
      # set plot title
      plotTitle <- paste0(siteNamesForTitle[i], ", all HY ", ": monthly mean simulated vs. measured streamflow\n")
      
      # set min and max flows
      minFlow <- min(monthlyMeanHydSite$`observed flow`, monthlyMeanHydSite$`simulated flow`, na.rm=TRUE)
      maxFlow <- max(monthlyMeanHydSite$`observed flow`, monthlyMeanHydSite$`simulated flow`, na.rm=TRUE)
      
      # plot
      par(mar=c(5,4,4,5) + 0.1)
      plot(monthlyMeanHydSite$month, monthlyMeanHydSite$`observed flow`, type="l", lwd=2, col="cornflowerblue", main=plotTitle,
           xlab = "Month", ylab="Flow (cfs)", ylim=c(minFlow,maxFlow), xaxt="n")
      axis(1, at=c("1","2","3","4","5","6","7","8","9","10","11","12"), 
           labels=c("10","11","12","1","2","3","4","5","6","7","8","9"))
      lines(monthlyMeanHydSite$month, monthlyMeanHydSite$`simulated flow`, type="l", lwd=2, col="indianred2")
      grid()
      par(new=TRUE)
      plot(monthlyMeanHydSite$month, monthlyMeanHydSite$precipitation, type='l', lty=3, lwd=2, col="yellow3", xaxt="n", yaxt="n", xlab="",
           ylab="", ylim=rev(range(monthlyMeanHydSite$precipitation)))
      axis(4)
      mtext("Precipitation (inches)", side=4, line=3)
      legend("topright", legend=c("observed flow", "simulated flow", "precipitation"),
             col=c("cornflowerblue", "indianred2", "yellow3"), lty=c(1,1,3), lwd=3, bty="n")
      
      
      
      # close plotting device
      dev.off()
      
      
    }
    
    
    
  }
  
  
  ##############################################################################################
  # 22) Plot comparison of Dunnian vs. Hortonian HY volumes (along with sub_sroff)
  ##############################################################################################
  
  if (plots_OnOff[22] == 1){
    
    # select allVar
    allVar = allVarWatershed
    allVar_hydYear = allVarWatershed_hydYear
    allVar_hydYearMonth = allVarWatershed_hydYearMonth
    
    
    #reformat sub_sroff_hyd for plotting annual volume
    inputData <- allVar_hydYear$sub_sroff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "surface runoff"
    typeValue="total"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_sroff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                         numDateCol, variableValue, typeValue, 
                                                         idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_sroff_hyd_annual_melt$value <- sub_sroff_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    # reformat hortonian flow for plotting annual volume
    inputData <- allVar_hydYear$hortonian_flow[,subbasinIdx]  
    multiplicationFactor <- 1   
    numDateCol <- 7
    variableValue <- "hortonian runoff"
    typeValue="component"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year", "variable", "type")
    hortonian_flow_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                             numDateCol, variableValue, typeValue,  
                                                             idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    hortonian_flow_hyd_annual_melt$value <- hortonian_flow_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    
    # reformat dunnian flow for plotting HY volume
    inputData <- allVar_hydYear$dunnian_flow[,subbasinIdx]  
    multiplicationFactor <- 1  #(1/12)  
    numDateCol <- 7
    variableValue <- "dunnian runoff"
    typeValue="component"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year", "variable", "type")
    dunnian_flow_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                           numDateCol, variableValue, typeValue,  
                                                           idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    dunnian_flow_hyd_annual_melt$value <- dunnian_flow_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    # place all streamflow components in the same data frame
    annualTotalHyd <- rbind(sub_sroff_hyd_annual_melt, hortonian_flow_hyd_annual_melt, dunnian_flow_hyd_annual_melt)
    
    
    # create vector of site names
    siteNames <- unique(annualTotalHyd$site)
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    # create an empty list to subset into 
    annualTotalHydSubset <- list()
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # subset
      annualTotalHydSubset <- subset(annualTotalHyd, site %in% siteNames[i])
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/annualTotalAF_hortonionDunnian_",siteNames[i], 
                         "_01.jpg")
      
      plotTitle <- paste0(siteNamesForTitle[i], ": annual Hortonian and Dunnian volumes \n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # plot
      annualTotalHydSubsetPlot <- ggplot() +
        geom_bar(data=annualTotalHydSubset, aes(x=type, y=value, fill=variable), position='stack', stat='identity') + 
        ylab("Flow volume (acre-ft)\n") +
        xlab("\nSurface runoff: total and components ") + 
        ggtitle(plotTitle) + 
        facet_wrap(~ year) + 
        theme(axis.text.x=element_text(angle=90,hjust=1)) + 
        guides(fill=guide_legend(title=NULL))  
      
      # print plot
      print(annualTotalHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/annualTotalAF_hortonionDunnian_",siteNames[i], 
                         "_02.jpg")
      
      plotTitle <- paste0(siteNamesForTitle[i], ": annual Hortonian and Dunnian volumes \n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # plot
      annualTotalHydSubsetPlot <- ggplot() +
        geom_bar(data=annualTotalHydSubset, aes(x=type, y=value, fill=variable), position='stack', stat='identity') + 
        ylab("Flow volume (acre-ft)\n") +
        xlab("\nSurface runoff: total and components ") + 
        ggtitle(plotTitle) + 
        facet_wrap(~ year, scales = "free_y") + 
        theme(axis.text.x=element_text(angle=90,hjust=1)) + 
        guides(fill=guide_legend(title=NULL))  
      
      # print plot
      print(annualTotalHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
      
    }
    
  }
  
  
  
  
  ##############################################################################################
  # 23) Plot water balance (watershed precip vs. actual ET, runoff, storage) for HY volumes
  # NOTE: something is wrong here - either I've messed up a conversion, I'm choosing the wrong
  # variables for the water balance, or the water balance in the beta version of the model is off
  # PROBLEM IDENTIFIED: need to subtract out initial storage values (soil_moist_init + ssstor_init + 
  # gwstor_init + inital canopy storage?) or only calculate it for 1997 - 2014 (by calculating 
  # change in storage between each consecutive set of years)
  # because change in storage = in - out
  # UPDATE: PRMS won't output the inital storage values (why?  Ask Rich/Steve Regan) so going 
  # to just calculate it for 1997 - 2014
  # ANOTHER UPDATE: there's something wrong with these plots and I'm not sure what 
  # (maybe the storage term?)
  # TRY: use hru_storage to calculate delta storage for 1997:2014 - San Antonio Creek
  # watershed is still slightly off, waiting to hear back from Rich/Steve about possible lake
  # effects
  ##############################################################################################
  
  if (plots_OnOff[23] == 1){
    
    # select allVar
    allVar = allVarWatershed
    allVar_hydYear = allVarWatershed_hydYear
    allVar_hydYearMonth = allVarWatershed_hydYearMonth
    
    
    # create delta hru_storage
    delta_hru_storage <- allVar_hydYear$hru_storage
    delta_hru_storage[,8:19] <- 0
    delta_hru_storage[2:6940,8:19] <- diff(as.matrix(allVar_hydYear$hru_storage[,8:19]))
    
    
    
    #reformat sub_cfs_hyd for plotting annual volume
    inputData <- allVar_hydYear$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "streamflow"
    typeValue="other"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_cfs_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                         numDateCol, variableValue, typeValue, 
                                                         idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_cfs_hyd_annual_melt$value <- sub_cfs_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    #reformat subinc_deltastor for plotting annual volume
    inputData <- allVar_hydYear$subinc_deltastor[,subbasinIdx]    
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "delta storage"
    typeValue="other"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    subinc_deltastor_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue, typeValue, 
                                                       idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    subinc_deltastor_hyd_annual_melt$value <- -1 * (subinc_deltastor_hyd_annual_melt$value / cubicFt_to_AF_convFactor)
    

    #reformat delta_hru_storage for plotting annual volume
    inputData <-  delta_hru_storage[,subbasinIdx]
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "storage"
    typeValue="other"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute",
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    delta_hru_storage_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor,
                                                           numDateCol, variableValue, typeValue,
                                                           idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    delta_hru_storage_hyd_annual_melt$value <- delta_hru_storage_hyd_annual_melt$value / cubicFt_to_AF_convFactor


    
    # reformat watershed precip for plotting annual volume
    inputData <- allVar_hydYear$hru_ppt[,subbasinIdx]   
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "precipitation"
    typeValue="precipitation"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute",
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year", "variable", "type")
    hru_ppt_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor,
                                                              numDateCol, variableValue, typeValue,
                                                              idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    hru_ppt_hyd_annual_melt$value <- hru_ppt_hyd_annual_melt$value / cubicFt_to_AF_convFactor




    # reformat hru_actet flow for plotting HY volume
    inputData <- allVar_hydYear$hru_actet[,subbasinIdx]   
    multiplicationFactor <- 1
    numDateCol <- 7
    variableValue <- "actual ET"
    typeValue="other"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute",
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year", "variable", "type")
    hru_actet_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor,
                                                            numDateCol, variableValue, typeValue,
                                                            idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    hru_actet_hyd_annual_melt$value <- hru_actet_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    
    # place all variables in the same data frame
    annualTotalHyd <- rbind(hru_ppt_hyd_annual_melt, sub_cfs_hyd_annual_melt,
                            hru_actet_hyd_annual_melt, subinc_deltastor_hyd_annual_melt)

    # create vector of site names
    siteNames <- unique(annualTotalHyd$site)
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    # create an empty list to subset into 
    annualTotalHydSubset <- list()
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # subset
      annualTotalHydSubset <- subset(annualTotalHyd, site %in% siteNames[i])
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/annualTotalAF_waterBalance_",siteNames[i], 
                         "_01.jpg")
      
      # set plot title
      plotTitle <- paste0(siteNamesForTitle[i], ": annual water balance volumes \n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # plot
      annualTotalHydSubsetPlot <- ggplot() +
        geom_bar(data=annualTotalHydSubset, aes(x=type, y=value, fill=variable), position='stack', stat='identity') + 
        ylab("Volume (acre-ft)\n") +
        xlab("\nWater balance components ") + 
        ggtitle(plotTitle) + 
        facet_wrap(~ year) + 
        theme(axis.text.x=element_text(angle=90,hjust=1)) + 
        guides(fill=guide_legend(title=NULL))  
      
      # print plot
      print(annualTotalHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
      
      # # set file name
      # filename <- paste0("./R_outputs/", runFolder, "/plots/annualTotalAF_waterBalance_",siteNames[i],
      #                    "_02.jpg")
      # 
      # plotTitle <- paste0(siteNamesForTitle[i], ": annual water balance volumes \n")
      # 
      # # open plotting device
      # jpeg(filename=filename, width = 12, height = 8,
      #      units = "in", quality = 75, res = 300)
      # 
      # # plot
      # annualTotalHydSubsetPlot <- ggplot() +
      #   geom_bar(data=annualTotalHydSubset, aes(x=type, y=value, fill=variable), position='stack', stat='identity') +
      #   ylab("Volume (acre-ft)\n") +
      #   xlab("\nWater balance components ") +
      #   ggtitle(plotTitle) +
      #   facet_wrap(~ year, scales = "free_y") +
      #   theme(axis.text.x=element_text(angle=90,hjust=1)) +
      #   guides(fill=guide_legend(title=NULL))
      # 
      # # print plot
      # print(annualTotalHydSubsetPlot)
      # 
      # # close plotting device
      # dev.off()
      
      
    }
    
  }
  
  
  
  
  
  ################################################################################################
  # 24) Plot flow components (streamflow vs. groundwater, interflow, surface flow) for HY volumes
  ################################################################################################
  
  if (plots_OnOff[24] == 1){
    
    # TO DO: change remaining code to account for allVarWatershed
    
    # select allVar
    allVar = allVarWatershed
    allVar_hydYear = allVarWatershed_hydYear
    allVar_hydYearMonth = allVarWatershed_hydYearMonth
    
    
    #reformat sub_cfs_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_cfs[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "simulated streamflow"
    typeValue="simulated streamflow"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_cfs_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                       numDateCol, variableValue,typeValue,  
                                                       idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_cfs_hyd_annual_melt$value <- sub_cfs_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat runoff_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$runoff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "observed streamflow"
    typeValue="observed streamflow"
    idVarsInput <- c("date","year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    runoff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                      numDateCol, variableValue, typeValue, 
                                                      idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    runoff_hyd_annual_melt$value <- runoff_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat sub_gwflow_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_gwflow[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "groundwater flow"
    typeValue="simulated component"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_gwflow_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                          numDateCol, variableValue, typeValue, 
                                                          idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_gwflow_hyd_annual_melt$value <- sub_gwflow_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat sub_interflow_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_interflow[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "interflow"
    typeValue="simulated component"
    idVarsInput <- c("date","year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_interflow_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                             numDateCol, variableValue, typeValue, 
                                                             idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_interflow_hyd_annual_melt$value <- sub_interflow_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    #reformat sub_sroff_hyd for plotting annual volume
    inputData <- allVar_hydYearMonth$sub_sroff[,subbasinIdx]
    multiplicationFactor <- 86400
    numDateCol <- 7
    variableValue <- "surface runoff"
    typeValue="simulated component"
    idVarsInput <- c("date", "year", "month", "day",
                     "hour", "minute", 
                     "second")
    castFormula <- year ~ site
    idVarsOutput <- c("year","variable", "type")
    sub_sroff_hyd_annual_melt <- reformatDataForPlotting(inputData, multiplicationFactor, 
                                                         numDateCol, variableValue, typeValue, 
                                                         idVarsInput, castFormula, idVarsOutput)
    cubicFt_to_AF_convFactor <- 43559.9  # 43559.9 cubic ft per acre-foot
    sub_sroff_hyd_annual_melt$value <- sub_sroff_hyd_annual_melt$value / cubicFt_to_AF_convFactor
    
    
    
    # place all streamflow components in the same data frame
    annualTotalHyd <- rbind(runoff_hyd_annual_melt, sub_cfs_hyd_annual_melt, sub_gwflow_hyd_annual_melt,
                            sub_interflow_hyd_annual_melt, sub_sroff_hyd_annual_melt)
    
    
    # create vector of site names
    siteNames <- unique(annualTotalHyd$site)
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    # create an empty list to subset into 
    annualTotalHydSubset <- list()
    
    # loop through site names
    for (i in 1:length(siteNames)){
      
      # subset
      annualTotalHydSubset <- subset(annualTotalHyd, site %in% siteNames[i])
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/annualTotalAF_stackedStreamflowComponents_",siteNames[i], 
                         ".jpg")
      
      plotTitle <- paste0(siteNamesForTitle[i], ": streamflow components \n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # plot
      annualTotalHydSubsetPlot <- ggplot() +
        geom_bar(data=annualTotalHydSubset, aes(x=type, y=value, fill=variable), position='stack', stat='identity') + 
        ylab(" Flow volume (acre-ft)\n") +
        xlab("\nWater balance components ") + 
        ggtitle(plotTitle) + 
        facet_wrap(~ year) + 
        theme(axis.text.x=element_text(angle=90,hjust=1)) + 
        guides(fill=guide_legend(title=NULL))  
      
      # print plot
      print(annualTotalHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
      
      
 
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/annualTotalAF_stackedStreamflowComponents_",siteNames[i], 
                         "_02.jpg")
      
      plotTitle <- paste0(siteNamesForTitle[i], ": streamflow components \n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8,
           units = "in", quality = 75, res = 300)
      
      # plot
      annualTotalHydSubsetPlot <- ggplot() +
        geom_bar(data=annualTotalHydSubset, aes(x=type, y=value, fill=variable), position='stack', stat='identity') +
        ylab("Flow volume (acre-ft)\n") +
        xlab("\nSurface runoff: total and components ") +
        ggtitle(plotTitle) +
        facet_wrap(~ year, scales = "free_y") +
        theme(axis.text.x=element_text(angle=90,hjust=1)) +
        guides(fill=guide_legend(title=NULL))
      
      # print plot
      print(annualTotalHydSubsetPlot)
      
      # close plotting device
      dev.off()
      
    }
    
  }
  
  
  
  
  
  ##############################################################################################
  # 25) Plot flow duration curves for all years together; > 100 cfs and < 100 cfs separately
  ##############################################################################################
  
  if (plots_OnOff[25] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    
    # prep
    numDateCol <- 7
    subbasinIdxNoDate <- subbasinIdx[(numDateCol + 1): length(subbasinIdx)]
    flowList <- list(allVar_hydYear$sub_cfs[,subbasinIdxNoDate],
                     allVar_hydYear$runoff[,subbasinIdxNoDate])
    flowSortedList <- list()
    nList <- list()
    
    
    # sort flow from largest to smallest values
    for (i in 1:length(flowList)){
      flow <- flowList[[i]]
      flowSorted <- flow
      nVec <- numeric()
      
      for (j in (1:ncol(flow))){
        
        # sort
        flowSorted[,j] <- sort(flow[,j], decreasing = TRUE, na.last = TRUE)
        
        
        # calculate length of vector (excluding NA)
        nVec[j] <- length(flow[,j][!is.na(flow[,j])])
        
      }
      
      #flowSorted <- cbind(rank, flowSorted)
      flowSortedList[[i]] <- flowSorted
      nList[[i]] <- nVec
      
    }
    
    
    
    # calculate rank
    rank <- c(1:length(flowSorted[,j]))
    
    
    
    # calculate exceedence probability
    Plist <- list()
    for (i in 1:length(flowSortedList)){
      
      flowSorted <- flowSortedList[[i]]
      nVec <- nList[[i]]
      
      P <- flowSorted
      for (j in 1:ncol(flowSorted)){
        
        for (k in 1:nrow(flowSorted)){
          
          P[k,j] <- 100 * (rank[k] / (nVec[j] + 1))
          
        }
        
      }
      
      Plist[[i]] <- P
      
    }
    
    # create vector of site names
    siteNames <- names(allVar_hydYear$sub_cfs[,subbasinIdxNoDate])
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    
    for (i in 1:ncol(P)){
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/FDC_allHY_gt100cfs_",siteNames[i], 
                         ".jpg")
      
      plotTitle <- paste0(siteNamesForTitle[i], ": flow duration curve, flow > 100 cfs \n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # select values > 100 cfs
      idx1 <- which(flowSortedList[[1]][,i] > 100)
      idx2 <- which(flowSortedList[[2]][,i] > 100)
      
      # calculate xlim and ylim
      xmin <- min(flowSortedList[[1]][idx1,i], flowSortedList[[2]][idx2,i])
      xmax <- max(flowSortedList[[1]][idx1,i], flowSortedList[[2]][idx2,i])
      ymin <- min(Plist[[1]][idx1,i], Plist[[2]][idx2,i])
      ymax <- max(Plist[[1]][idx1,i], Plist[[2]][idx2,i])
      
      # plot > 100 cfs
      plot(flowSortedList[[1]][idx1,i], Plist[[1]][idx1,i], type="l", col = "red", lwd=2, 
           main = plotTitle, ylab = "Exceedence probability (%)",
           xlab = "Streamflow (cfs)", xlim = c(xmin, xmax), ylim = c(ymin, ymax))
      lines(flowSortedList[[2]][idx2,i], Plist[[2]][idx2,i], type= "l", col = "blue", lwd=2)
      legend("topright", legend = c("Simulated", "Observed"), col = c("red", "blue"), 
             border = null, lwd=2)
      
      
      # close plotting device
      dev.off()
      
      
      
      
      
      ##
      
      
      
      
      # set file name
      filename <- paste0("./R_outputs/", runFolder, "/plots/FDC_allHY_lte100cfs_",siteNames[i], 
                         ".jpg")
      
      plotTitle <- paste0(siteNamesForTitle[i], ": flow duration curve, flow </= 100 cfs \n")
      
      # open plotting device
      jpeg(filename=filename, width = 12, height = 8, 
           units = "in", quality = 75, res = 300)  
      
      # select values </= 100 cfs
      idx1 <- which(flowSortedList[[1]][,i] <= 100)
      idx2 <- which(flowSortedList[[2]][,i] <= 100)
      
      # calculate xlim and ylim
      xmin <- min(flowSortedList[[1]][idx1,i], flowSortedList[[2]][idx2,i])
      xmax <- max(flowSortedList[[1]][idx1,i], flowSortedList[[2]][idx2,i])
      ymin <- min(Plist[[1]][idx1,i], Plist[[2]][idx2,i])
      ymax <- max(Plist[[1]][idx1,i], Plist[[2]][idx2,i])
      
      # plot <= 100 cfs
      plot(flowSortedList[[1]][idx1,i], Plist[[1]][idx1,i], type="l", col = "red", lwd=2, 
           main = plotTitle, ylab = "Exceedence probability (%)", xlab = "Streamflow (cfs)", 
           xlim = c(xmin, xmax), ylim = c(ymin, ymax))
      lines(flowSortedList[[2]][idx2,i], Plist[[2]][idx2,i], type= "l", col = "blue", lwd=2)
      legend("topright", legend = c("Simulated", "Observed"), col = c("red", "blue"), 
             border = null, lwd=2)
      
      
      
      # close plotting device
      dev.off()
      
      
    }
    
    
    
  }
  
  
  
  
  
  
  
  ##############################################################################################
  # 26) Plot flow duration curves for each HY; > 100 cfs and < 100 cfs separately
  ##############################################################################################

  if (plots_OnOff[26] == 1){
    
    # select allVar
    allVar = allVarSubbasin
    allVar_hydYear = allVarSubbasin_hydYear
    allVar_hydYearMonth = allVarSubbasin_hydYearMonth
    
    
    # prep
    numDateCol <- 7
    subbasinIdxNoDate <- subbasinIdx[(numDateCol + 1): length(subbasinIdx)]
    flowList <- list(allVar_hydYear$sub_cfs[,subbasinIdxNoDate],
                     allVar_hydYear$runoff[,subbasinIdxNoDate])
    
    years <- unique(allVar_hydYear$sub_cfs$year)
    
    tmp <- vector("list", length(years))
    flowListHY <- list(tmp, tmp)
    for (i in 1:length(flowList)){
      
      for (q in 1:length(years)){
        
        idxYr <- which(allVar_hydYear$sub_cfs$year == years[q])
        flowListHY[[i]][[q]] <- flowList[[i]][idxYr,]
        
      }
      
    }
    
    
    
    
    
    
    tmp <- vector("list", length(years))
    flowSortedList <- list(tmp, tmp)
    nList <- list(tmp, tmp)
    
    for (i in 1:length(flowList)){
      
      nVec <- numeric()
      
      for (q in 1:length(years)){
        
        flow <- flowListHY[[i]][[q]]
        flowSorted <- flow
        
        for (j in (1:ncol(flow))){
          
          # sort
          flowSorted[,j] <- sort(flow[,j], decreasing = TRUE, na.last = TRUE)
          
          
          # calculate length of vector (excluding NA)
          nVec[j] <- length(flow[,j][!is.na(flow[,j])])
          
          
        }
        
        flowSortedList[[i]][[q]] <- flowSorted
        nList[[i]][[q]] <- nVec
        
      }
      
      
    }
    
    
    
    
    # calculate exceedence probability
    Plist <- list(tmp, tmp)
    for (i in 1:length(flowSortedList)){
      
      for (q in 1:length(years)){
        
        
        flowSorted <- flowSortedList[[i]][[q]]
        nVec <- nList[[i]][[q]]
        
        P <- flowSorted
        for (j in 1:ncol(flowSorted)){
          
          # calculate rank
          rank <- c(1:length(flowSorted[,j]))  
          
          
          for (k in 1:nrow(flowSorted)){
            
            P[k,j] <- 100 * (rank[k] / (nVec[j] + 1))
            
          }
          
        }
        
        Plist[[i]][[q]] <- P
        
      }
      
    }
    
    
    
    # create vector of site names
    siteNames <- names(allVar_hydYear$sub_cfs[,subbasinIdxNoDate])
    
    
    # create siteNamesForTitle 
    siteNamesIdx <- which(subbasin_OnOff == 1)
    siteNamesForTitle <- subbasinNamesPretty[siteNamesIdx]
    
    
    for (q in 1:length(years)){
      
      
      for (i in 1:ncol(P)){
        
        
        # select values > 100 cfs
        idx1 <- which(flowSortedList[[1]][[q]][,i] > 100)
        idx2 <- which(flowSortedList[[2]][[q]][,i] > 100)
        
        # calculate xlim and ylim
        xmin <- min(flowSortedList[[1]][[q]][idx1,i], flowSortedList[[2]][[q]][idx2,i], na.rm=TRUE)
        xmax <- max(flowSortedList[[1]][[q]][idx1,i], flowSortedList[[2]][[q]][idx2,i], na.rm=TRUE)
        ymin <- min(Plist[[1]][[q]][idx1,i], Plist[[2]][[q]][idx2,i], na.rm=TRUE)
        ymax <- max(Plist[[1]][[q]][idx1,i], Plist[[2]][[q]][idx2,i], na.rm=TRUE)
        
        
        # plot if xlim and ylim values are finite
        if (is.finite(xmin) & is.finite(xmax) & is.finite(ymin) & is.finite(ymax)){
          
          # set file name
          filename <- paste0("./R_outputs/", runFolder, "/plots/FDC_eachHY_gt100cfs_",siteNames[i], "_", years[q],
                             ".jpg")
          
          plotTitle <- paste0(siteNamesForTitle[i], ": flow duration curve, ", years[q], ", flow > 100 cfs \n")
          
          # open plotting device
          jpeg(filename=filename, width = 12, height = 8, 
               units = "in", quality = 75, res = 300) 
          
          # plot > 100 cfs
          plot(flowSortedList[[1]][[q]][idx1,i], Plist[[1]][[q]][idx1,i], type="l", col = "red", lwd=2, 
               main = plotTitle, ylab = "Exceedence probability (%)", xlab = "Streamflow (cfs)",
               xlim = c(xmin, xmax), ylim = c(ymin, ymax))
          lines(flowSortedList[[2]][[q]][idx2,i], Plist[[2]][[q]][idx2,i], type= "l", col = "blue", lwd=2)
          legend("topright", legend = c("Simulated", "Observed"), col = c("red", "blue"), 
                 border = null, lwd=2)
          
          # close plotting device
          dev.off()
          
        }
        
  

      
        
        
        ##
        
        
        
        
        
        
        # select values </= 100 cfs
        idx1 <- which(flowSortedList[[1]][[q]][,i] <= 100)
        idx2 <- which(flowSortedList[[2]][[q]][,i] <= 100)
        
        # calculate xlim and ylim
        xmin <- min(flowSortedList[[1]][[q]][idx1,i], flowSortedList[[2]][[q]][idx2,i], na.rm=TRUE)
        xmax <- max(flowSortedList[[1]][[q]][idx1,i], flowSortedList[[2]][[q]][idx2,i], na.rm=TRUE)
        ymin <- min(Plist[[1]][[q]][idx1,i], Plist[[2]][[q]][idx2,i], na.rm=TRUE)
        ymax <- max(Plist[[1]][[q]][idx1,i], Plist[[2]][[q]][idx2,i], na.rm=TRUE)
        
        # plot if xlim and ylim values are finite
        if (is.finite(xmin) & is.finite(xmax) & is.finite(ymin) & is.finite(ymax)){
          
          # set file name
          filename <- paste0("./R_outputs/", runFolder, "/plots/FDC_eachHY_lte100cfs_",siteNames[i], "_", years[q], 
                             ".jpg")
          
          plotTitle <- paste0(siteNamesForTitle[i], ": flow duration curve, ", years[q], ", flow </= 100 cfs \n")
          
          # open plotting device
          jpeg(filename=filename, width = 12, height = 8, 
               units = "in", quality = 75, res = 300)  
          
          # plot <= 100 cfs
          plot(flowSortedList[[1]][[q]][idx1,i], Plist[[1]][[q]][idx1,i], type="l", col = "red", lwd=2, 
               main = plotTitle, ylab = "Exceedence probability (%)", xlab = "Streamflow (cfs)",
               xlim = c(xmin, xmax), ylim = c(ymin, ymax))
          lines(flowSortedList[[2]][[q]][idx2,i], Plist[[2]][[q]][idx2,i], type= "l", col = "blue", lwd=2)
          legend("topright", legend = c("Simulated", "Observed"), col = c("red", "blue"), 
                 border = null, lwd=2)
          
          # close plotting device
          dev.off()
          
        }
        
        
        
      }
      
      
    }
    
    
    
  }
  
  


}

