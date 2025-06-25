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

------
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

------
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
------
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

-- =================================================================
-- queries on the materials
-- потребление сырья (RM) по заводам и годам
SELECT
    plant_id,
    year,
    component_material,
    SUM(component_material_quantity) AS total_raw_material_consumed
FROM
    materials
WHERE
    component_material_release_type = 'RM'
GROUP BY
    plant_id,
    year,
    component_material
ORDER BY
    plant_id,
    year,
    total_raw_material_consumed DESC;


-- месячноe производства для топ-5 конечных продуктов
WITH RankedProducts AS (
    SELECT
        produced_material,
        SUM(produced_material_quantity) AS yearly_quantity,
        RANK() OVER (ORDER BY SUM(produced_material_quantity) DESC) as product_rank
    FROM
        materials
    WHERE
        produced_material_release_type = 'FIN'
    GROUP BY
        produced_material
)
SELECT
    m.year,
    m.month,
    m.produced_material,
    SUM(m.produced_material_quantity) as monthly_production,
    rp.product_rank
FROM
    materials m
JOIN
    RankedProducts rp ON m.produced_material = rp.produced_material
WHERE
    rp.product_rank <= 5
GROUP BY
    m.year,
    m.month,
    m.produced_material,
    rp.product_rank
ORDER BY
    rp.product_rank,
    m.year,
    m.month;


--  сравнение объемов производства и потребления
SELECT
    year,
    produced_material,
    produced_material_release_type,
    sum(produced_material_quantity) as produced_quant,
    sum(component_material_quantity) as component_consumption_quant,
    plant_id as plant
FROM materials
GROUP BY
    year,
    produced_material,
    produced_material_release_type,
    plant_id;


-- Функция: месячный анализ произволства для конкретного типа


CREATE OR REPLACE FUNCTION get_monthly_analysis_by_prod_type(p_prod_type INT)
RETURNS TABLE(
    year INT,
    month INT,
    produced_material INT,
    produced_material_production_type INT,
    total_produced_quantity NUMERIC,
    total_component_consumption NUMERIC
)
LANGUAGE sql
AS $$
    SELECT
        m.year,
        m.month,
        m.produced_material,
        m.produced_material_production_type,
        SUM(m.produced_material_quantity)::numeric,
        SUM(m.component_material_quantity)::numeric
    FROM
        materials m
    WHERE
        m.produced_material_production_type = p_prod_type
    GROUP BY
        m.year,
        m.month,
        m.produced_material,
        m.produced_material_production_type
    ORDER BY
        m.year,
        m.month,
        m.produced_material;
$$;

 SELECT * FROM get_monthly_analysis_by_prod_type(81);


-- общее годовое потребление вспомогательных компонентов 
SELECT
    year,
    component_material,
    SUM(component_material_quantity) AS total_consumed_quantity
FROM
    materials
WHERE
    component_material_release_type = 'ADD'
GROUP BY
    year,
    component_material
ORDER BY
    year,
    total_consumed_quantity DESC;


-- =================================================================
-- queries on the bom_explosion
-- Ф. Отчет о применяемости для конкретного компонента
CREATE OR REPLACE FUNCTION get_where_used_report(p_component_id INT)
RETURNS TABLE(
    plant VARCHAR(10),
    fin_material_id INT,
    fin_material_production_type INT
)
LANGUAGE sql
AS $$
    SELECT
        DISTINCT b.plant,
        b.fin_material_id,
        b.fin_material_production_type
    FROM
        bom_explosion b
    WHERE
        b.component_id = p_component_id
    ORDER BY
        b.plant,
        b.fin_material_id;
$$;

SELECT * FROM get_where_used_report(70000);
SELECT * FROM get_where_used_report(803);




-- Ф. Потреблениe компонентов в конечномм продукте 
CREATE OR REPLACE FUNCTION get_component_impact_for_product(p_fin_material_id INT)
RETURNS TABLE(
    fin_material_id INT,
    year INT,
    component_id INT,
    total_consumed NUMERIC
)
LANGUAGE sql
AS $$
    SELECT
        b.fin_material_id,
        b.year,
        b.component_id,
        SUM(b.component_consumption_quantity)::numeric as total_consumed
    FROM
        bom_explosion b
    WHERE
        b.fin_material_id = p_fin_material_id
    GROUP BY
        b.fin_material_id,
        b.year,
        b.component_id
    ORDER BY
        total_consumed DESC;
$$;

SELECT * FROM get_component_impact_for_product(10000);


SELECT * FROM get_component_impact_for_product(101);
---

-- Функция полная спецификация для пролукта, завода и года
CREATE OR REPLACE FUNCTION get_full_bom_explosion(p_fin_material_id INT, p_plant_id VARCHAR(10), p_year INT)
RETURNS TABLE(
    plant VARCHAR(10),
    year INT,
    fin_material_id INT,
    fin_material_release_type VARCHAR(5),
    fin_material_production_type INT,
    fin_production_quantity DOUBLE PRECISION,
    prod_material_id INT,
    prod_material_release_type VARCHAR(5),
    prod_material_production_type INT,
    prod_material_production_quantity NUMERIC,
    component_id INT,
    component_material_release_type VARCHAR(5),
    component_material_production_type INT,
    component_consumption_quantity NUMERIC
)
LANGUAGE sql
AS $$
    SELECT
        b.plant,
        b.year,
        b.fin_material_id,
        b.fin_material_release_type,
        b.fin_material_production_type,
        b.fin_production_quantity,
        b.prod_material_id,
        b.prod_material_release_type,
        b.prod_material_production_type,
        b.prod_material_production_quantity,
        b.component_id,
        b.component_material_release_type,
        b.component_material_production_type,
        b.component_consumption_quantity
    FROM
        bom_explosion b
    WHERE
        b.fin_material_id = p_fin_material_id
        AND b.plant = p_plant_id
        AND b.year = p_year;
$$;
SELECT * FROM get_full_bom_explosion(101, 'PLANT_15', 2000);

--================================================================
-- ABC, XYZ, Time-Series

-- ABC-анализ потребления материалов
WITH MaterialConsumption AS (
    SELECT
        component_material,
        SUM(component_material_quantity) AS total_consumed
    FROM
        materials
    WHERE
        component_material_release_type = 'ADD'
    GROUP BY
        component_material
),
CumulativeConsumption AS (
    SELECT
        component_material,
        total_consumed,
        SUM(total_consumed) OVER (ORDER BY total_consumed DESC) as cumulative_sum,
        SUM(total_consumed) OVER () as grand_total
    FROM
        MaterialConsumption
)
SELECT
    component_material,
    total_consumed,
    grand_total,
    cumulative_sum,
    ROUND((cumulative_sum * 100.0 / grand_total)::numeric, 2) as cumulative_percentage,
    CASE
        WHEN (cumulative_sum * 1.0 / grand_total) <= 0.8  THEN 'A'
        WHEN (cumulative_sum * 1.0 / grand_total) <= 0.95 THEN 'B'
        ELSE 'C'
    END as abc_category
FROM
    CumulativeConsumption
ORDER BY
    total_consumed DESC;


-- XYZ-анализ стабильности потребления материалов
WITH MonthlyConsumption AS (
    SELECT
        year,
        month,
        component_material,
        SUM(component_material_quantity) as monthly_total
    FROM materials
    WHERE component_material_release_type = 'ADD'
    GROUP BY year, month, component_material
),
VariationCoeff AS (
    SELECT
        component_material,
        AVG(monthly_total) as avg_consumption,
        STDDEV(monthly_total) as stddev_consumption
    FROM MonthlyConsumption
    GROUP BY component_material
)
SELECT
    vc.component_material,
    vc.avg_consumption,
    vc.stddev_consumption,
    CASE
        WHEN vc.avg_consumption > 0 THEN ROUND((vc.stddev_consumption / vc.avg_consumption)::numeric, 2)
        ELSE 0
    END as variation,
    CASE
        WHEN vc.avg_consumption > 0 AND (vc.stddev_consumption / vc.avg_consumption) <= 0.1  THEN 'X'
        WHEN vc.avg_consumption > 0 AND (vc.stddev_consumption / vc.avg_consumption) <= 0.25 THEN 'Y'
        ELSE 'Z' 
    END as xyz_category
FROM
    VariationCoeff vc
ORDER BY
    variation;


-- Анализ годового роста (YoY) потребления для 'ADD' компонентов
WITH YearlyConsumption AS (
    SELECT
        year,
        component_material,
        SUM(component_material_quantity) AS total_consumed
    FROM materials
    WHERE component_material_release_type = 'ADD'
    GROUP BY year, component_material
),
LaggedConsumption AS (
    SELECT
        year,
        component_material,
        total_consumed,
        LAG(total_consumed, 1, 0) OVER (PARTITION BY component_material ORDER BY year) as previous_year_consumed
    FROM
        YearlyConsumption
)
SELECT
    year,
    component_material,
    previous_year_consumed,
    total_consumed,
    (total_consumed - previous_year_consumed) as growth_absolute,
    CASE
        WHEN previous_year_consumed > 0 THEN
            ROUND(((total_consumed - previous_year_consumed) * 100.0 / previous_year_consumed)::numeric, 2)
        ELSE
            NULL
    END as growth_percentage
FROM
    LaggedConsumption
WHERE previous_year_consumed > 0
ORDER BY
    component_material, year;

--Месячный рост потребления для конкретного компонента
CREATE OR REPLACE FUNCTION get_mom_growth_for_component(p_type VARCHAR,p_component_id INT)
RETURNS TABLE(
    year INT,
    month INT,
    component_material INT,
    previous_month_consumed NUMERIC,
    total_consumed NUMERIC,
    growth_absolute NUMERIC,
    growth_percentage NUMERIC
)
LANGUAGE sql
AS $$
    WITH MonthlyConsumption AS (
        SELECT
            m.year,
            m.month,
            m.component_material,
            SUM(m.component_material_quantity) AS total_consumed
        FROM materials m
        WHERE m.component_material_release_type = p_type AND m.component_material = p_component_id
        GROUP BY m.year, m.month, m.component_material
    ),
    LaggedConsumption AS (
        SELECT
            mc.year,
            mc.month,
            mc.component_material,
            mc.total_consumed,
            LAG(mc.total_consumed, 1, 0) OVER (PARTITION BY mc.component_material ORDER BY mc.year, mc.month) as previous_month_consumed
        FROM
            MonthlyConsumption mc
    )
    SELECT
        lc.year,
        lc.month,
        lc.component_material,
        lc.previous_month_consumed::numeric,
        lc.total_consumed::numeric,
        (lc.total_consumed - lc.previous_month_consumed)::numeric as growth_absolute,
        ROUND(((lc.total_consumed - lc.previous_month_consumed) * 100.0 / lc.previous_month_consumed)::numeric, 2) as growth_percentage
    FROM
        LaggedConsumption lc
    WHERE
        lc.previous_month_consumed > 0;
$$;

SELECT * FROM get_mom_growth_for_component('ADD',90000);
SELECT * FROM get_mom_growth_for_component('PROD',80000);
SELECT * FROM get_mom_growth_for_component('RM',70000);
