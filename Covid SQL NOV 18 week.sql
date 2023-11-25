-- All data overview
select  *  from  
[SQL Portfolio Project].dbo.CovidDeaths
where location ='world'
order by 3 

--Useable Data from Death table
select  continent,location,date,total_cases ,
new_cases,total_deaths,new_deaths,population
from  
[SQL Portfolio Project].dbo.CovidDeaths
order by location,date

--deathpercantage compared to total cases
select  continent,location,date,total_cases ,
total_deaths,
(total_deaths/total_cases)*100 as death_percantage
from  
[SQL Portfolio Project].dbo.CovidDeaths
where location ='Bangladesh'
order by location,date

--case by population percentage
select  continent,location,date,total_cases ,
total_deaths,population,
(total_deaths/total_cases)*100 as death_percantage,
Round((total_cases/population)*100 ,5) casebypopulation
from  
[SQL Portfolio Project].dbo.CovidDeaths
where location ='Bangladesh'
order by location,date

--Higheest infection rate by population
select location,MAX(total_cases) highestinfection,
MAX(total_cases/population)*100 higestinfection_percentage
--Max((total_cases/population))*100  infectionratebypop
from  
[SQL Portfolio Project].dbo.CovidDeaths
where continent is not null  --and location= 'Bangladesh'
group by location
order by higestinfection_percentage Desc


--location and death 
select  location,MAX(cast(total_deaths as int)) death
from  
[SQL Portfolio Project].dbo.CovidDeaths
where continent is not null
group by location
order by death desc

--continent and death 
select  continent,MAX(cast(total_deaths as int)) death
from  
[SQL Portfolio Project].dbo.CovidDeaths
where continent is not null
group by continent
order by death desc

--continent and death 
select  continent,MAX(cast(total_deaths as int)) death
from  
[SQL Portfolio Project].dbo.CovidDeaths
where continent is not null
group by continent
order by death desc

--join the tables
select dea.location,dea.population, max(cast(vac.total_vaccinations as int)) vacinnation from 
[SQL Portfolio Project].dbo.CovidDeaths dea
join [SQL Portfolio Project].dbo.CovidVaccinations vac
on dea.location=vac.location --and dea.date=vac.date
group by dea.location,dea.population

--population vs new vaccination
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int))
over (partition by dea.location order by dea.location ,dea.date) new_vacper_date from 
[SQL Portfolio Project].dbo.CovidDeaths dea
join [SQL Portfolio Project].dbo.CovidVaccinations vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--group by dea.location,dea.population
order by dea.location 

--use CTE 
with popvsvac (continent,location,date,population,new_vaccinations,new_vacper_date)
As
(
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int))
over (partition by dea.location order by dea.location ,dea.date) new_vacper_date from 
[SQL Portfolio Project].dbo.CovidDeaths dea
join [SQL Portfolio Project].dbo.CovidVaccinations vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--group by dea.location,dea.population
--order by dea.location 
)
select *,(new_vacper_date/population)*100 as vac_percentage 
from popvsvac
--where location ='Bangladesh'
--order by vac_percentage desc


--create table

create table #newtable
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric, 
new_vaccinations numeric, 
new_vacper_date numeric
)
insert into #newtable
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int))
over (partition by dea.location order by dea.location ,dea.date) new_vacper_date from 
[SQL Portfolio Project].dbo.CovidDeaths dea
join [SQL Portfolio Project].dbo.CovidVaccinations vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--group by dea.location,dea.population
--order by dea.location 

select * from #newtable
 

--Create view for future use.
create view 
continentVSDeath as
select  continent,MAX(cast(total_deaths as int)) death
from  
[SQL Portfolio Project].dbo.CovidDeaths
where continent is not null
group by continent
--order by death desc





--Useable Data from Death table
create view useabledata as 

select  continent,location,date,total_cases ,
new_cases,total_deaths,new_deaths,population
from  
[SQL Portfolio Project].dbo.CovidDeaths
--order by location,date