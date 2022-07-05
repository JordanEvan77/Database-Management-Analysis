--Query 4: ALL BELOW RUNS WELL
-----promotion amount per terittory with total rev INTERNET--
SELECT FORMAT(dp.DiscountPct, 'P') as [% Discount], 
	FORMAT(SUM(fis.OrderQuantity * fis.UnitPrice), 'c2') as [Total Revenue], 
	dst.SalesTerritoryCountry as [Territory Country],
	FORMAT((SUM(fis.OrderQuantity * fis.UnitPrice) / (SELECT SUM(OrderQuantity * UnitPrice) FROM FactInternetSales)), 'P') as [Portion of Total Sales], 
	dst.SalesTerritoryRegion as [Territory Region], 
	'Internet Sales' as [Sale Area]
FROM (((DimPromotion as dp INNER JOIN FactInternetSales as fis on dp.PromotionKey=fis.PromotionKey)
	INNER JOIN DimProduct as prod on fis.ProductKey=prod.ProductKey) 
	INNER JOIN DimSalesTerritory as dst on fis.SalesTerritoryKey=dst.SalesTerritoryKey)
	INNER JOIN DimProductSubcategory as pc on prod.ProductSubcategoryKey=pc.ProductSubCategoryKey
GROUP BY ROLLUP(dp.DiscountPct, dst.SalesTerritoryCountry, dst.SalesTerritoryRegion)

UNION ALL
-----promotion amount per terittory with total rev RESELLER--
SELECT FORMAT(dp.DiscountPct,'P') as [% Discount],
	FORMAT(SUM(frs.OrderQuantity * frs.UnitPrice),'c2') as [Total Revenue],
	dst.SalesTerritoryCountry as [Territory Country], 
	FORMAT((SUM(frs.OrderQuantity * frs.UnitPrice) / (SELECT SUM(OrderQuantity * UnitPrice) FROM FactResellerSales)), 'P') as [Portion of Total Sales],
	dst.SalesTerritoryRegion as [Territory Region], 
	'Reseller Sales' as [Sale Area]
FROM (((DimPromotion as dp INNER JOIN FactResellerSales as frs on dp.PromotionKey=frs.PromotionKey) 
	INNER JOIN DimProduct as prod on frs.ProductKey=prod.ProductKey) 
	INNER JOIN DimSalesTerritory as dst on frs.SalesTerritoryKey=dst.SalesTerritoryKey)
	INNER JOIN DimProductSubcategory as pc on prod.ProductSubcategoryKey=pc.ProductSubCategoryKey
GROUP BY ROLLUP(dp.DiscountPct, dst.SalesTerritoryCountry, dst.SalesTerritoryRegion)
ORDER BY FORMAT(dp.DiscountPct, 'P') DESC

-----promotion amount per sub category with total rev INTERNET--
SELECT pc.EnglishProductSubcategoryName as [SubCategory Name], 
	'Internet Sales' as [Sale Area],
	dp.EnglishPromotionCategory as [Promo Category], 
	FORMAT(dp.DiscountPct,+
	'P') as [% Discount], 
	FORMAT(SUM(fis.OrderQuantity * fis.UnitPrice), 'c2') as [Total Revenue],
	FORMAT((SUM(fis.OrderQuantity * fis.UnitPrice) / (SELECT SUM(OrderQuantity * UnitPrice) FROM FactInternetSales)), 'P') as [Portion of Total Sales]
FROM (((DimPromotion as dp INNER JOIN FactInternetSales as fis on dp.PromotionKey=fis.PromotionKey)
	INNER JOIN DimProduct as prod on fis.ProductKey=prod.ProductKey) 
	INNER JOIN DimSalesTerritory as dst on fis.SalesTerritoryKey=dst.SalesTerritoryKey)
	INNER JOIN DimProductSubcategory as pc on prod.ProductSubcategoryKey=pc.ProductSubCategoryKey
GROUP BY ROLLUP(dp.DiscountPct, pc.EnglishProductSubcategoryName, dp.EnglishPromotionCategory)

UNION ALL
-----promotion amount per sub category with total rev RESELLER--
SELECT pc.EnglishProductSubcategoryName as [SubCategory Name], 
	'Reseller Sales' as [Sale Area],
	dp.EnglishPromotionCategory as [Promo Category], 
	FORMAT(dp.DiscountPct,'P') as [% Discount], 
	FORMAT(SUM(frs.OrderQuantity * frs.UnitPrice),'c2') as [Total Revenue],
	FORMAT((SUM(frs.OrderQuantity * frs.UnitPrice) / (SELECT SUM(OrderQuantity * UnitPrice) FROM FactResellerSales)), 'P') as [Portion of Total Sales]
FROM (((DimPromotion as dp INNER JOIN FactResellerSales as frs on dp.PromotionKey=frs.PromotionKey) 
	INNER JOIN DimProduct as prod on frs.ProductKey=prod.ProductKey) 
	INNER JOIN DimSalesTerritory as dst on frs.SalesTerritoryKey=dst.SalesTerritoryKey)
	INNER JOIN DimProductSubcategory as pc on prod.ProductSubcategoryKey=pc.ProductSubCategoryKey
GROUP BY ROLLUP(dp.DiscountPct, pc.EnglishProductSubcategoryName, dp.EnglishPromotionCategory)
ORDER BY [% Discount] DESC