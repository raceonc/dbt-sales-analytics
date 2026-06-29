with source as (
    select * from {{ ref('raw_customers')}}
),

renamed as (
    select
        customer_code,
        customer_name,
        customer_segment,
        region
    from source
)

select * from renamed