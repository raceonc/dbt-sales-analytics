with source as (
    select * from {{ ref('raw_sales_budget') }}
),
renamed as (
    select
        product_code,
        customer_code,
        cast(budget_date as date) as budget_date,
        budget_quantity,
        budget_unit_price,
        budget_unit_cost,
        (budget_quantity * budget_unit_price) as bud_gross_sales,
        (budget_quantity * budget_unit_cost) as bud_standard_cost,
        (budget_quantity * budget_unit_price)
            - (budget_quantity * budget_unit_cost) as bud_gross_margin
    from source
)
select * from renamed