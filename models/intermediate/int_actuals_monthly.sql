with actuals as (

    select * from {{ ref('stg_sales') }}

),

monthly as (

    select
        product_code,
        customer_code,
        cast(date_trunc('month', transaction_date) as date)          as sales_month,
        sum(quantity)                                                as quantity,
        sum(gross_sales)                                             as gross_sales,
        sum(standard_cost)                            as standard_cost,
        sum(gross_margin)                                           as gross_margin,
        sum(gross_sales) / nullif(sum(quantity), 0)                 as avg_unit_price,
        sum(standard_cost) / nullif(sum(quantity), 0) as avg_unit_cost
    from actuals
    group by 1, 2, 3

)

select * from monthly