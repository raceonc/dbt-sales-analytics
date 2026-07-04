with source as (
    select * from {{ ref('raw_sales_plan') }}
),
renamed as (
    select
        product_code,
        customer_code,
        cast(plan_date as date) as plan_date,
        plan_quantity as plan_quantity,
        plan_unit_price as plan_unit_price,
        plan_unit_cost as plan_unit_cost,
        (plan_quantity * plan_unit_price) as plan_gross_sales,
        (plan_quantity * plan_unit_cost) as plan_standard_cost,
        (plan_quantity * plan_unit_price)
            - (plan_quantity * plan_unit_cost) as plan_gross_margin,
        'PLAN' as scenario_code
    from source
)
select * from renamed