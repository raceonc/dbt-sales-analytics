with actuals as (
    select * from {{ ref('stg_sales')}}
),

customers as (
    select * from {{ ref('stg_customers')}}
),

products as (
    select * from {{ ref('stg_products')}}
),

scenarios as (
    select * from {{ ref('stg_scenarios')}}
),

final as (
    select
        -- keys
        a.sop_number,
        a.sop_line,
        a.transaction_date,
        
        -- dimensions
        a.customer_code,
        c.customer_name,
        c.customer_segment,
        c.region,

        a.product_code,
        p.product_name,
        p.product_category,

        a.scenario_code,
        s.scenario_name,
        s.scenario_type,

        -- measures
        a.quantity,
        a.unit_price,
        a.unit_cost,
        a.gross_sales,
        a.standard_cost,
        a.gross_margin

    from actuals a
    left join customers c on a.customer_code = c.customer_code
    left join products p on a.product_code = p.product_code
    left join scenarios s on a.scenario_code = s.scenario_code
)

select * from final