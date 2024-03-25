select*
from portfolioproject.dbo.sheet1
--step 1 standardize the data
select SaleDate,convert(Date,Saledate)
from portfolioproject.dbo.sheet1

update portfolioproject..sheet1
set SaleDate=Convert(Date,SaleDate)

alter table sheet1
add SaleDateConverted Date;

update portfolioproject..sheet1
set SaleDateConverted=Convert(Date,SaleDate)

--populate property address date
select  *
from portfolioproject.dbo.sheet1
order by ParcelID

select  a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.sheet1 a
join portfolioproject.dbo.sheet1 b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.sheet1 a
join portfolioproject.dbo.sheet1 b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--seperate address,city,state
select PropertyAddress
from portfolioproject.dbo.sheet1

select
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as Address,
CHARINDEX(',',PropertyAddress) as v
from portfolioproject.dbo.sheet1

select
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Address
from portfolioproject.dbo.sheet1

Alter table portfolioproject..sheet1
add PropertySplitAddress nvarchar(255);

update sheet1
set PropertySplitAddress=convert(Date,SaleDate)

alter table sheet1
add PropertySplitCity nvarchar(255);

update sheet1
set PropertySplitCity=convert(Date,SaleDate)

select OwnerAddress
from portfolioproject.dbo.sheet1
where OwnerAddress is not null

select
parsename(replace(OwnerAddress,',','.')1)
from portfolioproject.dbo.sheet1

--remove duplicates
select*,
    row_number() over(
	partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	order by 
	    UniqueID) row_num
from portfolioproject.dbo.sheet1
order by ParcelID
with rownumcte as(
select*,
    row_number() over(
	partition by ParcelID,
	PropertyAddress,
	SalePrice,
	SaleDate,
	LegalReference
	order by 
	    UniqueID) row_num
from portfolioproject.dbo.sheet1
)
--Delete
--from rownumcte
--where row_num>1

select*
from rownumcte
where row_num>1

alter table portfolioproject.dbo.sheet1
drop column OwnerAddress,TaxDistrict,PropertyAddress

Alter table portfolioproject.dbo.sheet1
drop column SaleDate
