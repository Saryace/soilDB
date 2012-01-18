get_veg_species_from_MT_veg_db <- function(dsn) {
	
	#pull site and plot data and total production value
	q <- "SELECT tblESD_DK.PlotKey, tblESD_DK.DKKey, tblSites.SiteID, SpeciesSymbol, Spec.CommonName as species_common_name, Spec.ScientificName as species_scientific, DKClass, Production 
  FROM (
	(
	(tblSites LEFT OUTER JOIN tblPlots ON tblSites.SiteKey = tblPlots.SiteKey) 
	LEFT OUTER JOIN tblESD_DK ON tblPlots.PlotKey = tblESD_DK.PlotKey) 
	LEFT OUTER JOIN (SELECT * FROM tblSpecies) AS Spec ON Spec.SpeciesCode = tblESD_DK.SpeciesSymbol)
	WHERE (DKClass IS NOT NULL)
	ORDER BY tblESD_DK.PlotKey, Production DESC;"

	# setup connection to our pedon database
	channel <- odbcConnectAccess(dsn, readOnlyOptimize=TRUE)
	
	# exec query
	d <- sqlQuery(channel, q, stringsAsFactors=FALSE)
	
	# close connection
	odbcClose(channel)
	
	# done
	return(d)
}
