with orders_source as (

    select * from {{ source('jaffle_shop', 'orders') }}

),

orders_transformed as (
    select
        id as order_id,
        user_id as customer_id,
        order_date as order_placed_at,
        status as order_status,
        
        case
            when order_status not in ('returned', 'pending')
            then order_date
            end as valid_order_date

    from orders_source

)

select * from orders_transformed