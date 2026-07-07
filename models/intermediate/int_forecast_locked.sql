with forecast as (

    select * from {{ ref('stg_sales_stepped_fc') }}

),

locked_latest as (

    select *
    from forecast
    where is_locked = true
    qualify row_number() over (
        partition by product_code, customer_code, forecast_month
        order by snapshot_date desc
    ) = 1

)

select * from locked_latest