#указываем с какой базой будем работать
use billing_simple;

# смотрим кто отправил деньги Пете
select * from billing where recipient_email='petya@mail.com'

