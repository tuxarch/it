#Выведите список источников, из которых не было клиентов, либо клиенты 
#пришедшие из которых не совершали заказов или отказывались от заказов.
# Под клиентами, которые отказывались от заказов, необходимо понимать клиентов, у которых
# есть заказы, которые на момент выполнения запроса находятся в состоянии 'rejected'. В запросе необходимо 
#использовать оператор UNION для объединения выборок по разным условиям.
#Ожидаемый формат результата:

use store;

SELECT source.name FROM source
  WHERE NOT EXISTS (SELECT * FROM client WHERE client.source_id = source.id)
UNION
SELECT source.name FROM source
    INNER JOIN client ON client.source_id = source.id
    INNER JOIN sale ON sale.client_id = client.id
    INNER JOIN status ON status.id = sale.status_id WHERE status.name = "rejected";