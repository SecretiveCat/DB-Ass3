---Таск 1, створення функції

CREATE OR REPLACE FUNCTION calculate_order_total(p_order_id int)
RETURNS NUMERIC 
LANGUAGE plpgsql
AS $$
DECLARE
    v_total NUMERIC;
begin
	select sum(quantity * price)
	into v_total
	from order_items
	where order_id = p_order_id;

    return coalesce(v_total, 0);
END;
$$;


DROP FUNCTION calculate_order_total(integer);


select calculate_order_total(order_id) as Total
from orders;


---Таск 2, створення процедури

create or replace procedure create_order(p_customer_id int)
language plpgsql
as $$
begin 
  if not exists (select from customers where customer_id = p_customer_id) then
    raise exception 'Sorry, we do not fount this customer';
  end if;
    
    insert into orders (customer_id, order_date, total_amount)
    values (p_customer_id, CURRENT_TIMESTAMP, 0);
end;
$$;


call create_order(3);

SELECT * FROM orders ORDER BY order_id DESC LIMIT 5;








