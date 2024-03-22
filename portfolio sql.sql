
select *
from portfolioproject..coviddeaths$
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population_density
from portfolioproject..coviddeaths$
where continent is not null
order by 1,2

select location,date,population_density,total_cases,(cast(total_cases as int)/population_density)*100 as percentpopulationinfected
from portfolioproject..coviddeaths$
order by 1,2


select continent,max(cast(total_deaths as int)) as TotalDeathCount
From portfolioproject..coviddeaths$
where continent is not null
group by continent
order by TotalDeathCount desc



select location,date,total_case,total,deaths,(cast(total_deaths as int)/cast(total_cases as int))*100 as Deathpercent
from portfolioproject..coviddeaths$
where continent is not null
order by 1,2


with popsvac (continent,location,date,population_density,vac,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population_density,vac.new_vaccinations,SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location,dea.date) as RollingPeopleVaccinated
from portfolioproject..coviddeaths$ dea
join portfolioproject..covidvaccinations$ vac
		on dea.location=vac.location
		and dea.date=vac.date
where dea.continent is not null
----order by 2,3
)
select *,(RollingPeopleVaccinated/population_density)*100
from pops

Insert into

select dea.continent,dea.location,dea.date,dea.population_density,vac.new_vaccinations,SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location,dea.date) as RollingPeopleVaccinated
from portfolioproject..coviddeaths$ dea
join portfolioproject..covidvaccinations$ vac
		on dea.location=vac.location
		and dea.date=vac.date
where dea.continent is not null
----order by 2,3






