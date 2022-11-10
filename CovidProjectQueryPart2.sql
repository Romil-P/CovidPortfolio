--New cases vs new Vaccinations
select dea.continent, dea.location, dea.date, dea.new_cases, vac.new_vaccinations
from CovidDeaths dea
join CovidVaccinations vac on vac.location = dea.location and vac.date = dea.date
where dea.continent is not null

--Total tests done per continent
select continent, date, sum(cast(total_tests as bigint)) as TotalTests
from CovidVaccinations
where continent is not null
group by continent, date
order by date

-- Global positive rate vs vaccine and death
select dea.date, positive_rate, people_fully_vaccinated, dea.total_deaths 
from CovidVaccinations vac
join CovidDeaths dea on vac.location = dea.location and vac.date = dea.date
order by positive_rate desc

--create views
create view CasesVsVaccine as (
select dea.continent, dea.location, dea.date, dea.new_cases, vac.new_vaccinations
from CovidDeaths dea
join CovidVaccinations vac on vac.location = dea.location and vac.date = dea.date
where dea.continent is not null
)

create view ContinentTests as (
select continent, date, sum(cast(total_tests as bigint)) as TotalTests
from CovidVaccinations
where continent is not null
group by continent, date
)

create view PositiveRates as (
select dea.date, positive_rate, people_fully_vaccinated, dea.total_deaths 
from CovidVaccinations vac
join CovidDeaths dea on vac.location = dea.location and vac.date = dea.date
)