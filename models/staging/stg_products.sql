with source as (
    select * from {{ref('raw_products')}}
),

renamed as (
    select
        product_code,
        product_name,
        product_category,
        unit_of_measure
    from source
)

select * from renamed