#language: ru

Функционал: Демонстрация заполнения зависимых данных

Как пользователь
Я хочу заполнить контрагента 
Чтобы система заполнила зависимые данные: договор, счет контрагента, валюта расчетов 

Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
	И В командном интерфейсе я выбираю 'Демо' 'Заявка на операцию'
	И в таблице "Список" я выбираю текущую строку
	В открытой форме заявки нужно заполнить организацию
		Когда в поле с именем "Организация" я ввожу текст "ПАО Рога и Копыта"
		И я перехожу к следующему реквизиту
		Тогда поле с именем "БанковскийСчет" заполнено

Сценарий: Заполнение контрагента

	Когда в поле с именем "Контрагент" я ввожу текст "Первая компания"
	И я перехожу к следующему реквизиту
	Проверка результата
		Тогда поле с именем "ДоговорКонтрагента" заполнено
		И поле с именем "СчетКонтрагента" заполнено
		И элемент формы "Валюта расчетов" отсутствует на форме
		Но элемент формы с именем "ВалютаВзаиморасчетов" присутствует на форме
		И элемент с именем "ВалютаВзаиморасчетов" доступен только для просмотра
