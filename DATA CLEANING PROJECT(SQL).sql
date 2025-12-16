-- Data Cleaning

Select * from layoffs;

-- 1.Remove Duplicates
-- 2.Standardize the Data
-- 3.NULL OR Blank Values
-- 4.Remove any Columns

Create Table layoffs_staging
Like layoffs;

Select * from layoffs_staging;



INSERT INTO layoffs_staging
select * from layoffs;

-- Removing Duplicates
Select *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
from layoffs_staging;

WITH duplicate_cte AS
(
Select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from layoffs_staging
)
select * from duplicate_cte
Where row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Select * from layoffs_staging2
where row_num > 1;

Insert into layoffs_staging2
Select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from layoffs_staging;

Delete
from layoffs_staging2
where row_num>1;

SET SQL_SAFE_UPDATES = 0;

Select * from layoffs_staging2;

-- Standardizing the Data

SELECT company,TRIM(company)
from layoffs_staging2;

select * from layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT distinct industry
from layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = "Crypto"
Where industry LIKE "Crypto%";

SELECT DISTINCT LOCATION
from layoffs_staging2;

SELECT DISTINCT COUNTRY
from layoffs_staging2
order by 1;

SELECT distinct Country,TRIM(TRAILING "." FROM COUNTRY)
From layoffs_staging2
ORDER BY 1;


UPDATE layoffs_staging2
SET COUNTRY = TRIM(TRAILING "." FROM COUNTRY)
Where COUNTRY LIKE "United St%";





