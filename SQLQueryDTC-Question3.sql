--query 3, all good
SELECT DISTINCT dates.[Sales Year]
	,dates.[Sales Group]
	,dates.[Sales Country]
	,format(sum(a.[Internet Sales]),'c') [Internet Sales]
	,format(sum(b.[Reseller Sales]),'c') [Reseller Sales]
	,FORMAT(SUM(isnull(a.[Internet Sales],0) + isnull(b.[Reseller Sales],0)), 'c') as [Joint Sales]
FROM (select distinct case
			when dst.SalesTerritoryCountry = 'United Kingdom' then 'United Kingdom'
			else dst.SalesTerritoryGroup end [Sales Group]
		,dst.SalesTerritoryCountry [Sales Country]
		,year(fis.OrderDate) [Sales Year]
	from DimSalesTerritory dst
	join FactInternetSales fis on dst.SalesTerritoryKey = fis.SalesTerritoryKey
	union select distinct case
			when dst.SalesTerritoryCountry = 'United Kingdom' then 'United Kingdom'
			else dst.SalesTerritoryGroup end [Sales Group]
		,dst.SalesTerritoryCountry [Sales Country]
		,year(frs.OrderDate) [Sales Year]
	from DimSalesTerritory dst
	join FactResellerSales frs on dst.SalesTerritoryKey = frs.SalesTerritoryKey
	) dates join (select year(fis.OrderDate) [Sales Year],case
			when dst.SalesTerritoryCountry = 'United Kingdom' then 'United Kingdom'
			else dst.SalesTerritoryGroup end [Sales Group]
		,dst.SalesTerritoryCountry [Sales Country]
		,sum(fis.OrderQuantity*fis.UnitPrice) [Internet Sales]
	from FactInternetSales fis
	full join DimSalesTerritory dst on dst.SalesTerritoryKey = fis.SalesTerritoryKey
	group by year(fis.OrderDate), dst.SalesTerritoryCountry, dst.SalesTerritoryGroup
	) a on a.[Sales Group] = dates.[Sales Group] and a.[Sales Year] = dates.[Sales Year] and a.[Sales Country] = dates.[Sales Country]
full join (select year(frs.OrderDate) [Sales Year]
		,case
			when dst.SalesTerritoryCountry = 'United Kingdom' then 'United Kingdom'
			else dst.SalesTerritoryGroup end [Sales Group]
		,dst.SalesTerritoryCountry [Sales Country]
		,sum(frs.OrderQuantity*frs.UnitPrice) [Reseller Sales]
	from FactResellerSales frs
	full join DimSalesTerritory dst on dst.SalesTerritoryKey = frs.SalesTerritoryKey
	group by year(frs.OrderDate), dst.SalesTerritoryCountry, dst.SalesTerritoryGroup
	) b on dates.[Sales Group] = b.[Sales Group] and b.[Sales Year] = dates.[Sales Year] and b.[Sales Country] = dates.[Sales Country]
​
GROUP BY rollup(dates.[Sales Year], dates.[Sales Group], dates.[Sales Country])
--Refined slightly: old version
--SELECT TOP 10 YEAR(fis.OrderDate) as [Sales Year], dst.SalesTerritoryCountry as [Sales Country], 
--(CASE WHEN dst.SalesTerritoryCountry = 'United Kingdom' THEN 'UK'
--ELSE dst.SalesTerritoryRegion END) as [New Sales Region], 
--FORMAT(SUM(fis.OrderQuantity * fis.UnitPrice + frs.OrderQuantity * frs.UnitPrice), 'c2') as [Joint Sales]
--FROM (FactInternetSales as fis INNER JOIN FactResellerSales as frs on fis.CurrencyKey=frs.CurrencyKey) 
--INNER JOIN DimSalesTerritory as dst on dst.SalesTerritoryKey =fis.SalesTerritoryKey 
--GROUP BY ROLLUP (fis.OrderDate, dst.SalesTerritoryCountry, dst.SalesTerritoryRegion)
--GROUP BY ROLLUP (YEAR(fis.OrderDate), dst.SalesTerritoryCountry, dst.SalesTerritoryRegion)