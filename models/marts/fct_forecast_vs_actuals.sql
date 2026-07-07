with forecast as (

    select * from {{ ref('int_forecast_locked') }}

),

actuals as (

    select * from {{ ref('int_actuals_monthly') }}

),

joined as (

    select
        -- grain
        coalesce(f.product_code, a.product_code)   as product_code,
        coalesce(f.customer_code, a.customer_code) as customer_code,
        coalesce(f.forecast_month, a.sales_month)  as month,

        -- forecast side (latest locked)
        f.fc_quantity,
        f.fc_unit_price,
        f.fc_unit_cost,

        -- actuals side (quantity-weighted)
        a.quantity       as act_quantity,
        a.avg_unit_price as act_unit_price,
        a.avg_unit_cost  as act_unit_cost,

        -- variances: actual minus forecast
        a.quantity       - f.fc_quantity   as qty_variance,
        a.avg_unit_price - f.fc_unit_price as price_variance,
        a.avg_unit_cost  - f.fc_unit_cost  as cost_variance

    from forecast f
    full outer join actuals a
        on  f.product_code   = a.product_code
        and f.customer_code  = a.customer_code
        and f.forecast_month = a.sales_month

)

select * from joined