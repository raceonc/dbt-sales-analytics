{{
    config(
        materialized = 'incremental'
    )
}}

-- Append-only log of forecast-vs-actuals price & cost drift.
-- One row per product / customer / month, retained forever. Each run appends
-- drift for any newly-closed month; history is never overwritten. Turns "the
-- forecast was wrong" from a finger-pointing email into a dated, auditable fact.

with variance as (

    select * from {{ ref('fct_forecast_vs_actuals') }}

),

drift as (

    select
        product_code,
        customer_code,
        month as drift_month,          -- 'month' is reserved in DuckDB; alias it

        fc_unit_price,
        act_unit_price,
        price_variance,

        fc_unit_cost,
        act_unit_cost,
        cost_variance,

        current_timestamp as logged_at

    from variance

    -- Drift is only defined for a CLOSED month you actually forecast:
    -- both a locked forecast AND a realized actual must exist.
    where fc_unit_price  is not null
      and act_unit_price is not null

)

select * from drift

{% if is_incremental() %}
  where drift_month > (select max(drift_month) from {{ this }})
{% endif %}