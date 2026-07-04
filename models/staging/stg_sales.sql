with source as (
    select * from {{ ref('raw_sales')}}
),

renamed as (
    select
        sop_number,
        sop_line,
        cast(transaction_date as date) as transaction_date,
        customer_code,
        product_code,
        quantity,
        unit_price,
        unit_cost,
        (quantity * unit_price) as gross_sales,
        (quantity * unit_cost) as standard_cost,
        (quantity * unit_price) 
            - (quantity * unit_cost) as gross_margin,
        'ACT' as scenario_code
        from source
)


select * from renamed