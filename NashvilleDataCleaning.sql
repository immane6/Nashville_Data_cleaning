/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]


  select * from PortfolioProject.dbo.NashvilleHousing

  -- Standardizing Sales date

  select  SaleDate2, cast(SaleDate as date)
  from PortfolioProject.dbo.NashvilleHousing

  alter table PortfolioProject.dbo.NashvilleHousing
  add SaleDate2 Date;

  update PortfolioProject.dbo.NashvilleHousing
  set SaleDate2 = cast(SaleDate as date);

  select * from PortfolioProject.dbo.NashvilleHousing


  -- Populate property address data

  select *
  from PortfolioProject..NashvilleHousing
  --where PropertyAddress is null
  order by ParcelID


select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




--Breaking out Address into individual columns (Address, city, satate)

  select PropertyAddress
  from PortfolioProject..NashvilleHousing
  --where PropertyAddress is null
  --order by ParcelID


  select
  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
  , SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City

  from PortfolioProject.dbo.NashvilleHousing


  alter table PortfolioProject.dbo.NashvilleHousing
  add PropertySplitAddress Nvarchar(255);

  update PortfolioProject.dbo.NashvilleHousing
  set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);


  alter table PortfolioProject.dbo.NashvilleHousing
  add PropertySplitCity Nvarchar(255);

  update PortfolioProject.dbo.NashvilleHousing
  set PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress));


  SELECT *
  from PortfolioProject.dbo.NashvilleHousing




  SELECT 
  parsename(replace(OwnerAddress, ',', '.'), 3)
  ,parsename(replace(OwnerAddress, ',', '.'), 2)
  ,parsename(replace(OwnerAddress, ',', '.'), 1)
  from PortfolioProject.dbo.NashvilleHousing


  
  alter table PortfolioProject.dbo.NashvilleHousing
  add OwnerSplitAddress Nvarchar(255);

  update PortfolioProject.dbo.NashvilleHousing
  set OwnerSplitAddress =  parsename(replace(OwnerAddress, ',', '.'), 3);


  alter table PortfolioProject.dbo.NashvilleHousing
  add OwnerSplitCity Nvarchar(255);

  update PortfolioProject.dbo.NashvilleHousing
  set PropertySplitCity = parsename(replace(OwnerAddress, ',', '.'), 2);

   alter table PortfolioProject.dbo.NashvilleHousing
  add OwnerSplitState Nvarchar(255);

  update PortfolioProject.dbo.NashvilleHousing
  set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 3)



SELECT *
  from PortfolioProject.dbo.NashvilleHousing 



--Change Y and N to Yes and No in "sold as vaccant" field

select Distinct (SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant
, CASE when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  END
from PortfolioProject.dbo.NashvilleHousing


update portfolioproject.dbo.NashvilleHousing
 set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
      when SoldAsVacant = 'N' then 'No'
	  else SoldAsVacant
	  END


--Remove duplicates
WITH RowNumCTE AS (
select *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
				UniqueID
				) row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
DELETE
from RowNumCTE
where row_num > 1
--order by PropertyAddress

select *
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate
