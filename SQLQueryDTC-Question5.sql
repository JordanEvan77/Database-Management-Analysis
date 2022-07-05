--query 5
--Our customers are always a big discussion topic with management and the sales team. The Customer table has a wealth of data categories that could be 
--joined with Internet sales and all the extra data that brings along. This request will likely separate the high-performing analysts from the rest.
SELECT dc.CustomerKey as [Customer Key]
	,dc.FirstName + ' ' + dc.LastName as [Customer Name]
	,convert(varchar(10), dc.BirthDate, 101) as [Birth Date]
	,(Case dc.MaritalStatus
		WHEN 'M' THEN 'Married'
		WHEN 'S' THEN 'Single'
		WHEN 'D' THEN 'Divorced'
		WHEN 'W' THEN 'Widowed'
		Else 'Unkown'
		END) as [Marital Status]
	,(CASE dc.Gender WHEN 'M' THEN 'Male' Else 'Female' END) as [Gender]
	,format(dc.YearlyIncome, 'c') as [Yearly Income]
	,dc.EnglishEducation as [Education]
	,convert(varchar(10), fis.OrderDate, 101) as [Order Date]
	,format(fis.SalesAmount, 'c') as [Sales Amount]
	,fis.SalesTerritoryKey as [Territory]
	,dst.SalesTerritoryCountry as [Country]
FROM (
		DimCustomer as dc
		INNER JOIN FactInternetSales as fis on dc.CustomerKey=fis.CustomerKey)
INNER JOIN DimSalesTerritory as dst on dst.SalesTerritoryKey = fis.SalesTerritoryKey
ORDER BY [Sales Amount] DESC