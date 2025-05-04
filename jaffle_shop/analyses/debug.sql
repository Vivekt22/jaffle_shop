with fct_customer_orders as (

    select
        customer_id,
        order_id,
        order_placed_at,
        order_status,
        total_amount_paid,
        payment_finalized_date,
        customer_first_name,
        customer_last_name,
        transaction_seq,
        customer_sales_seq,
        nvsr,
        customer_lifetime_value,
        fdos

    from {{ ref('fct_customer_orders') }} as fct_customer_orders

),

customer_orders as (

    select
        customer_id,
        order_id,
        order_placed_at,
        order_status,
        total_amount_paid,
        payment_finalized_date,
        customer_first_name,
        customer_last_name,
        transaction_seq,
        customer_sales_seq,
        nvsr,
        customer_lifetime_value,
        fdos

    from {{ ref('customer_orders') }} as customer_orders

),

records_in_a as (

    select * from customer_orders
    except
    select * from fct_customer_orders

),

records_in_b as (

    select * from fct_customer_orders
    except
    select * from customer_orders

),

compare as (

    select
        true as in_a,
        false as in_b,
        *

    from records_in_a

    union

    select
        false as in_a,
        true as in_b,
        *

    from records_in_b

)

select * from compare
order by
    customer_id,
    order_id,
    in_a desc,
    in_b desc