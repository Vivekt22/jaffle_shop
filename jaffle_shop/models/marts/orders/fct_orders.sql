with orders_staged as (

    select * from {{ ref('stg_jaffle_shop__orders') }}

),

payments_staged as (

  select * from {{ ref('stg_stripe__payments') }}

),

order_payments as (

    select
        order_id,
        sum (case when payment_status = 'success' then payment_amount end) as payment_amount
    from payments_staged
    group by order_id

),

orders as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_placed_at,
        coalesce(order_payments.payment_amount, 0) as amount
    from orders_staged as orders
    left join order_payments using (order_id)

)

select * from orders