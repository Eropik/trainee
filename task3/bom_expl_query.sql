create or replace view bom_explosion as 
with recursive agg_data as(
	select
		year,
		plant_id,
	
		produced_material,
		produced_material_release_type,
		produced_material_production_type,
	
		component_material,
		component_material_production_type,
		component_material_release_type,
		
		sum(produced_material_quantity) as produced_material_quantity,
		
		sum(component_material_quantity) as component_material_quantity 
	from materials
	group by year,plant_id,produced_material, produced_material_production_type,
		component_material, component_material_production_type,
		produced_material_release_type, component_material,
		component_material_release_type
),
fin_materials_comb as(
	select 
		plant_id,
		year,
		produced_material as fin_material_id
	from agg_data
	where produced_material_release_type = 'FIN'
),
prod_quant as (
	select 
		plant_id,
		year,
		produced_material, 
		sum(produced_material_quantity) as prod_material_production_quantity
	from agg_data
	group by plant_id,year,produced_material
),
build_hierarchy as (
	select
		fmc.plant_id,
        fmc.year,
        fmc.fin_material_id,
        ad.produced_material_release_type as fin_release_type,
        ad.produced_material_production_type as fin_prod_type,
        sum(ad.produced_material_quantity) over (partition by fmc.plant_id, fmc.year, fmc.fin_material_id) as fin_production_quantity,
        ad.produced_material as material,
        ad.produced_material_release_type as release_type,
        ad.produced_material_production_type as prod_type,
        ad.component_material as component_id,
        ad.component_material_release_type as component_material_release_type,
        ad.component_material_production_type as component_material_production_type,
        ad.component_material_quantity as component_consumption_quantity,
        pq.prod_material_production_quantity
	
	from 
		fin_materials_comb fmc
	
		join agg_data ad on
			ad.plant_id = fmc.plant_id 
			and ad.year = fmc.year
			and ad.produced_material = fmc.fin_material_id
			
		
		join prod_quant pq on 
			pq.plant_id = ad.plant_id 
			and	pq.year = ad.year
			and pq.produced_material = ad.produced_material
	
	union all
		
	select
		
    	   bh.plant_id,
        bh.year,
        bh.fin_material_id,
        bh.fin_release_type,
        bh.fin_prod_type,
        bh.fin_production_quantity,
        ad.produced_material as aterial,
        ad.produced_material_release_type as release_type,
        ad.produced_material_production_type as prod_type,
        ad.component_material as component_id,
        ad.component_material_release_type as component_material_release_type,
        ad.component_material_production_type as component_material_production_type,
        ad.component_material_quantity as component_consumption_quantity,
        pq.prod_material_production_quantity

	
	from 
		build_hierarchy bh
	
		join agg_data ad on
			ad.plant_id = bh.plant_id 
			and ad.year = bh.year
			and ad.produced_material = bh.component_id
	
		join prod_quant pq on 
			pq.plant_id = ad.plant_id 
			and	pq.year = ad.year
			and pq.produced_material = ad.produced_material
	
)
select
    plant_id AS plant,
    fin_material_id,
    fin_release_type AS fin_material_release_type,
    fin_prod_type AS fin_material_production_type,
    fin_production_quantity,
    material AS prod_material_id,
    release_type AS prod_material_release_type,
    prod_type AS prod_material_production_type,
    prod_material_production_quantity,
    component_id,
    component_material_release_type,
    component_material_production_type,
    component_consumption_quantity,
    year
from 
	build_hierarchy
	where fin_release_type != release_type
	order by plant, year, fin_material_id, prod_material_id, component_id;

select * from bom_explosion;


_______________________________
-- data formated: | PLANT_ID | YEAR | fin_material_id ( produced_material: 101,10000,10001)
	select 
		plant_id, year, produced_material as fin_material_id
	from(
	SELECT -- aggr data
        plant_id,
        year,
        produced_material,
        component_material,
        produced_material_release_type,
        produced_material_production_type,
        component_material_release_type,
        component_material_production_type,
        SUM(produced_material_quantity) AS produced_material_quantity,
        SUM(component_material_quantity) AS component_material_quantity
    FROM materials
    GROUP BY
        plant_id, year, produced_material, component_material,
        produced_material_release_type, produced_material_production_type,
        component_material_release_type, component_material_production_type
	)
	where produced_material_release_type = 'FIN'
	order by produced_material asc


__________________


-- data formated | PLANT_ID | YEAR | PRODUCED_MATERIAL(every material) | produced_material_quantity SUM by month in year
	select 
		plant_id, 
		year,
		produced_material,
		sum(produced_material_quantity) as produced_material_quantity
	from (
	SELECT -- agg data
        plant_id,
        year,
        produced_material,
        component_material,
        produced_material_release_type,
        produced_material_production_type,
        component_material_release_type,
        component_material_production_type,
        SUM(produced_material_quantity) AS produced_material_quantity,
        SUM(component_material_quantity) AS component_material_quantity
    FROM materials
    GROUP BY
        plant_id, year, produced_material, component_material,
        produced_material_release_type, produced_material_production_type,
        component_material_release_type, component_material_production_type
	)
	group by plant_id, year, produced_material
	order by SUM(produced_material_quantity) ,
        SUM(component_material_quantity)

____________
--agg_data

	select
		year,
		plant_id,
	
		produced_material,
		produced_material_release_type, 
		produced_material_production_type,
		component_material,
		component_material_production_type,
		component_material_release_type,
		
		sum(produced_material_quantity) as produced_material_quantity,
		
		sum(component_material_quantity) as component_material_quantity
	from materials
	group by year,plant_id,produced_material, produced_material_production_type,
		component_material, component_material_production_type,
		produced_material_release_type, component_material,
		component_material_release_type


select * from materials



