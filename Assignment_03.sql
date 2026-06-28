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

select * from orders
order by order_id desc
limit 5;


create or replace procedure add_product_to_order(
    p_order_id int,
    p_product_id int,
    p_quantity int
)
LANGUAGE plpgsql
AS $$
BEGIN
	if p_quantity <= 0 then
		raise exception 'Sorry, but quantity must be more then 0';
	end if;

	if (select stock_quantity from products where product_id = p_product_id) < p_quantity then
		raise exception 'Sorry, but products are not enough stock.';
	end if;

    INSERT INTO order_items (order_id, product_id, quantity, price)
    VALUES (p_order_id, p_product_id, p_quantity, (select price from products where product_id = p_product_id));

	update products
	set stock_quantity = stock_quantity - p_quantity
	where product_id = p_product_id;
end;
$$;


call add_product_to_order(3, 3, 10);


select * from order_items 
where order_id = 3;

select product_id, stock_quantity 
from products 
where product_id = 3;








