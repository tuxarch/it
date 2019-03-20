use store;

#Выведите названия товаров, которые относятся к категории 'Cakes' или фигурируют в заказах 
#текущий статус которых 'delivering'. Результат не должен содержать одинаковых записей. 
#В запросе необходимо использовать оператор UNION для объединения выборок по разным условиям.

select good.name from good inner join sale_has_good on good.id = sale_has_good.good_id
  inner join sale on sale_has_good.sale_id = sale.id where sale.status_id=5 
  union 
  select good.name from good left join category_has_good on category_has_good.good_id = good.id 
  where category_has_good.category_id = 3