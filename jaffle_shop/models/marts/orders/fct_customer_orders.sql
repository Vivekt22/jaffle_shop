with customers_staged as (

    select * from {{ ref('stg_jaffle_shop__customers') }}

),

paid_orders as (

    select * from {{ ref('int_paid_orders') }}

),

customer_orders as (

    select
        paid_orders.order_id,
        paid_orders.customer_id,
        paid_orders.order_placed_at,
        paid_orders.order_status,
        paid_orders.total_amount_paid,
        paid_orders.payment_finalized_date,
        customers.customer_first_name,
        customers.customer_last_name,

        row_number() over (order by paid_orders.order_id) as transaction_seq,
        row_number() over (partition by customer_id order by paid_orders.order_id) as customer_sales_seq,

        case
            when rank() over (
                    partition by paid_orders.customer_id 
                    order by paid_orders.order_placed_at, paid_orders.order_id
                ) = 1
            then 'new'
            else 'return'
            end as nvsr,

        sum (paid_orders.total_amount_paid) over (
                partition by paid_orders.customer_id 
                order by paid_orders.order_placed_at
            ) as customer_lifetime_value,

        first_value (paid_orders.order_placed_at) over (
                partition by paid_orders.customer_id 
                order by paid_orders.order_placed_at
            ) as fdos

    from paid_orders

    left join customers_staged as customers using (customer_id)

)

select * 
from customer_orders    
order by order_id