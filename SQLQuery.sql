select location,date, total_cases,new_cases,total_deaths,population_density from PortfolioProject..CovidDeaths
order by 1,2

--Total case vs Total Deaths

select location,date, total_cases,total_deaths,(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
Where location like '%India%'
order by 1,2


--total case vs population

select location,date, total_cases,population_density,(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population_density), 0))*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
Where location like '%India%'
order by 1,2

--continent death

select continent,MAX(CAST(total_deaths as bigint)) as TotalDeath
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeath desc

--global numbers


select date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/NULLIF(SUM(new_cases),0)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
--Where location like '%India%'
WHERE continent is not null
group by date
order by 1,2


select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/NULLIF(SUM(new_cases),0)*100 as DeathPercentage 
from PortfolioProject..CovidDeaths
--Where location like '%India%'
WHERE continent is not null
--group by date
order by 1,2

--join

select dea.continent,dea.location,dea.date, dea.population_density,vac.new_vaccinations , 
SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidVaccinations vac
JOIN PortfolioProject..CovidDeaths dea
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


--CTE

With PopvsVac (continent,location,date,population_density,new_vaccinations,RollingPeopleVaccinated)
as
(select dea.continent,dea.location,dea.date, dea.population_density,vac.new_vaccinations , 
SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidVaccinations vac
JOIN PortfolioProject..CovidDeaths dea
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)

select * ,(RollingPeopleVaccinated/population_density)*100
from PopvsVac

--TempTable

Drop table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
cotinent nvarchar(255),
location nvarchar(255),
date datetime,
population_density numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
select dea.continent,dea.location,dea.date, dea.population_density,vac.new_vaccinations , 
SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidVaccinations vac
JOIN PortfolioProject..CovidDeaths dea
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3

select *,(CONVERT(float,RollingPeopleVaccinated)/NULLIF(CONVERT(float,population_density),0))*100 from  #PercentagePopulationVaccinated


--Creating View

Create view PercentagePopulationVaccinated as
select dea.continent,dea.location,dea.date, dea.population_density,vac.new_vaccinations , 
SUM(cast(vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidVaccinations vac
JOIN PortfolioProject..CovidDeaths dea
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3

select * from PercentagePopulationVaccinated
