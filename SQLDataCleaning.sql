--Cleaning Data---------------------------	

Select * from PortfolioProject..NashvilleHousing

--SaleDate format-----------------------------

Select SaleDate, CONVERT(date,SaleDate) from PortfolioProject..NashvilleHousing

Update NashvilleHousing --update is not working because update do not change data type and for that use ALTER
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE NashvilleHousing ALTER COLUMN SaleDate DATE

Select * from PortfolioProject..NashvilleHousing

--Property Address Formatting----------------------------------

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

Select PropertyAddress from PortfolioProject..NashvilleHousing


--Breaking Address-------------------------------

Select PropertyAddress from PortfolioProject..NashvilleHousing


select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as City
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add Property_Address Nvarchar(255)

UPDATE NashvilleHousing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


ALTER TABLE NashvilleHousing
Add Property_City Nvarchar(255)

UPDATE NashvilleHousing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

Select * from PortfolioProject..NashvilleHousing



--Owner Address-------------------------------

Select OwnerAddress from PortfolioProject..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3) as Owner_Address,
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2) as Owner_City,
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1) as Owner_State
from PortfolioProject..NashvilleHousing



ALTER TABLE NashvilleHousing
Add Owner_Address Nvarchar(255)

UPDATE NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)

ALTER TABLE NashvilleHousing
Add Owner_City Nvarchar(255)

UPDATE NashvilleHousing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

ALTER TABLE NashvilleHousing
Add Owner_State Nvarchar(255)

UPDATE NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)



Select * from PortfolioProject..NashvilleHousing



-- Changing Y and N to Yes and No----------------------------------

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
from PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END



-- Remove Duplicae-----------------------------

WITH RowNumberCTE AS(
Select *, ROW_NUMBER() OVER(PARTITION BY ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference ORDER BY UniqueID) row_number
from PortfolioProject..NashvilleHousing
)

--Delete from RowNumberCTE   --{To Delete Dublicates}
Select * From RowNumberCTE
where row_number>1



-- Delete Extra Columns-----------------------------


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate


Select * from PortfolioProject..NashvilleHousing
