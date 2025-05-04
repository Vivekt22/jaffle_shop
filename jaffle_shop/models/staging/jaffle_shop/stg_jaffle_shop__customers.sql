with customers_source as (
    
    select * from {{ source('jaffle_shop', 'customers') }}

),

customers_transformed as (

    select
        id as customer_id,
        first_name as customer_first_name,
        last_name as customer_last_name,
        concat_ws(' ', first_name, last_name) as customer_full_name

    from customers_source

)

select * from customers_transformed
