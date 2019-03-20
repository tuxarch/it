
use store_medium		;

# все множество
select * from product cross join category;

#общее между таблицами
select product.product_name, product.price, category.category_name from product inner join category on product.category_id = category.category_id;
