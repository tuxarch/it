#Общее количество позиций в заказах по категориям


select a.name, count(e.id) from category as a
	left join category_has_good as b on a.id = b.category_id 
    left join good as c on b.good_id = c.id 
    left join sale_has_good as d on c.id = d.good_id
    left join sale as e on d.sale_id = e.id group by a.name