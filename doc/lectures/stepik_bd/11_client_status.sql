use store;
select * from client;

Выведите список клиентов (имя, фамилия) и количество заказов данных клиентов, имеющих статус "new".
Ожидаемый формат результата:

select client.first_name, client.last_name, count(sale.status_id) 
                               from client 
                               inner join sale  
                               on client.id=sale.client_id  
                               inner join status 
                               on sale.status_id=status.id 
                               where status.name='new' 
                               group by client.first_name, client.last_name; 

