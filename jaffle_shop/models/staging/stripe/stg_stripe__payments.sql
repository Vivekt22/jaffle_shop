with payments_source as (
  
  select * from {{ source('stripe', 'payments') }}

),

orders_transformed as (

  select
    id as payment_id,
    orderid as order_id,
    created as payment_created_at,
    status as payment_status,
    paymentmethod as payment_method,
    {{ cents_to_dollars('amount', 4) }} as payment_amount

  from payments_source

)

select * from orders_transformed