--QUESTION #2: all good
select d.EnglishProductCategoryName 'Product Category'
	,c.ModelName 'Product Model'
	,e.CalendarYear 'Calendar Year'
	,e.FiscalYear 'Fiscal Year'
	,datename(month,b.OrderDate) 'Order Month'
	,b.SalesOrderNumber 'Order Number'
	,sum(b.OrderQuantity) 'Quantity'
	,format(sum(b.SalesAmount), 'c') 'Sales Amount'
from DimReseller a
join FactResellerSales b on a.ResellerKey = b.ResellerKey
join DimProduct c on b.ProductKey = c.ProductKey
join DimProductSubcategory sub on c.ProductSubcategoryKey = sub.ProductSubcategoryKey
join DimProductCategory d on sub.ProductCategoryKey = d.ProductCategoryKey
join DimDate e on b.OrderDateKey = e.DateKey
group by d.EnglishProductCategoryName, c.ModelName, e.CalendarYear, e.FiscalYear, datename(month,b.OrderDate), b.SalesOrderNumber