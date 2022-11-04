
-- General Query
--select location, date, total_cases, new_cases, total_deaths, population 
--from CovidDeaths
--order by 1,2

-- Death percentages by country
--select location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 as DeathPercentage
--from CovidDeaths
--where location = 'United states'
--order by date

-- Population that contracted covid
--select location, date, total_cases, population, (total_cases / population)*100 as CovidPopulation
--from CovidDeaths
--where location = 'United states'
--order by date

-- Population that contracted covid
--select location, population, max(total_cases) as HighestInfectionCount, max((total_cases / population)*100) as PercentInfected
--from CovidDeaths
--group by location, population
--order by PercentInfected desc

-- deaths by continents and removing income classes
--select continent, max(cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths
--where continent is not null AND location not like '%income%'
--group by continent
--order by TotalDeathCount desc

--World wide numbers
--select date, sum(new_cases)as GlobalNewCases, sum(cast(new_deaths as int)) as GlobalNewDeaths, (sum(cast(new_deaths as int)) / sum(new_cases)) *100 as GlobalDeathPercentage
--from CovidDeaths
--where continent is not null
--group by date
--order by 1,2

-- Total popluation vs vaccination
--select 
--dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinatedCount
--from CovidDeaths dea
--join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
--where dea.continent is not null and dea.location = 'united states'
--order by 2,3

----Use CTE for RollingVaccinatedCount to use it for further calculations (option 1)

--with PopulationVaccinated (Continent, location, date, population, new_vaccinations, RollingVaccinatedCount) as (
--	select 
--	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinatedCount
--	from CovidDeaths dea
--	join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
--	where dea.continent is not null
--	--order by 2,3
--	)
--Select *, (RollingVaccinatedCount / population *100) as VaccinatedPercentage from PopulationVaccinated

-- Using Temp table instead (option 2)
--drop table if exists #percentageVaccinatedPopultion -- when / if updating the table it will drop existing one to make new changes
--Create Table #percentageVaccinatedPopultion
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--RollingVaccinatedCount numeric
--)

--insert into #percentageVaccinatedPopultion
--	select 
--	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinatedCount
--	from CovidDeaths dea
--	join CovidVaccinations vac on dea.location = vac.location and dea.date = vac.date
--	where dea.continent is not null
--	--order by 2,3
--	Select *, (RollingVaccinatedCount / population *100) as VaccinatedPercentage from #percentageVaccinatedPopultion

-- Create view
--create view PopulationContractedCovid as (
--select location, date, total_cases, population, (total_cases / population)*100 as CovidPopulation
--from CovidDeaths
--where location = 'United states'
--)