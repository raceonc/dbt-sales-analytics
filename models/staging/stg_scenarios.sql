with source as (
    select * from {{ ref('raw_scenario')}}
),

renamed as (
    select 
        scenario_code,
        scenario_name,
        scenario_type
    from source
)

select * from renamed