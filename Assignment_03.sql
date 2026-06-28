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








