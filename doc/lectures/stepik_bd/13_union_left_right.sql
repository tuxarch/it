use store ;

#Выведите список товаров с названиями категорий, в том числе товаров, не принадлежащих ни к одной из категорий,
# в том числе категорий не содержащих ни одного товара.

#union объединяет запросы
#
select good.name, category.name from good left outer join category_has_good on good.id = category_has_good
                             .good_id left outer join category on category_has_good.category_id = category.id union 
select good.name, category.name from good right outer join category_has_good on good.id = category_has_good
                             .good_id right outer join category on category_has_good.category_id = category.id
