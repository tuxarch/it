use store;

#Выведите список всех источников клиентов и суммарный объем заказов по каждому 
#источнику. Результат должен включать также записи для источников, по которым не было заказов.

select source.name, SUM(sale.sale_sum) from source left outer join client on source.id = client.source_id 
left outer join sale on client.id = sale.client_id group by source.name

#+---------------+--------------------+
#| name          | SUM(sale.sale_sum) |
#+---------------+--------------------+
#| Direct link   | 72362.00           |
#| Google search | 17330.00           |
#| Campaign      | 49214.00           |
#| AdWords       | 21623.00           |
#| Advertisement | 89188.00           |
#| Banner        | <null>             |
#| SN            | 57043.00           |
#+---------------+--------------------+