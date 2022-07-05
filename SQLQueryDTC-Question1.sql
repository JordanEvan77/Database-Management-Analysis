--Question 1: all good 
SELECT cat.EnglishProductCategoryName AS [Product Category],  
    dp.ModelName AS [Product Model], 
    s.CustomerKey AS [Customer Key], 
    st.SalesTerritoryRegion AS [Region], 
    FORMAT(cust.YearlyIncome, 'C') AS [Customer Yearly Income], 
    (CASE 
        WHEN cust.YearlyIncome < 40000 THEN 'Low' 
        WHEN cust.YearlyIncome > 60000 THEN 'High' 
        ELSE 'Moderate' 
    END) AS [Income Group], 
    d.CalendarYear AS [Calendar Year],  
    d.FiscalYear AS [Fiscal Year], 
    d.EnglishMonthName AS [Month], 
    s.SalesOrderNumber AS [Sales Order Number], 
    sum(s.OrderQuantity) AS [Quantity], 
    FORMAT(sum(s.SalesAmount), 'C') AS [Total Amount] 
FROM FactInternetSales AS s 
JOIN DimProduct AS dp 
    ON s.ProductKey = dp.ProductKey 
left outer JOIN DimProductSubcategory AS subcat 
    ON dp.ProductSubcategoryKey = subcat.ProductSubcategoryKey 
left outer JOIN DimProductCategory AS cat 
    ON subcat.ProductCategoryKey = cat.ProductCategoryKey 
left JOIN DimSalesTerritory AS st 
    ON s.SalesTerritoryKey = st.SalesTerritoryKey 
INNER JOIN DimCustomer AS cust 
	on s.CustomerKey = cust.CustomerKey 
    --ON geog.GeographyKey = cust.GeographyKey 
left outer join DimGeography geog 
	on cust.GeographyKey = geog.GeographyKey 
INNER JOIN DimDate AS d 
    ON s.OrderDateKey = d.DateKey 
GROUP BY cat.EnglishProductCategoryName, dp.ModelName,  
    s.CustomerKey, st.SalesTerritoryRegion, cust.YearlyIncome, 
    d.CalendarYear, d.FiscalYear, d.EnglishMonthName,  
    s.SalesOrderNumber; 