with source as (

    select * from {{ ref('raw_sales_stepped_forecast') }}

),

renamed as (

    select
        product_code,
        customer_code,
        cast(snapshot_date  as date)    as snapshot_date,
        cast(forecast_month as date)    as forecast_month,
        forecast_quantity,
        forecast_unit_price,
        forecast_unit_cost,
        cast(is_locked as boolean)      as is_locked,
        'FCST'                          as scenario_code

    from source

)

select * from renamed