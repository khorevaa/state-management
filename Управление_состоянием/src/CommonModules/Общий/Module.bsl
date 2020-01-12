Функция ИмяТаблицыПоТипу(ТипЗначения) Экспорт
	СсылкаТипа = Новый (ТипЗначения);
	Возврат СсылкаТипа.Метаданные().ПолноеИмя();
КонецФункции

//  Создает таблицу значений на основании информации о колонках.
//
// Параметры:
//  - Колонки 	- Структура - {Имя, ОписаниеТипа}|{Имя, ТипЗнч(Значение)}
//				- КоллекцияКолонокТаблицыЗначений, КоллекцияКолонокДереваЗначений, КоллекцияКолонокРезультатаЗапроса 
//				- Строка
//
Функция ТаблицаЗначений(Колонки) Экспорт 
	Таблица 	= Новый ТаблицаЗначений;
	ТипЗначения = ТипЗнч(Колонки);
	Если ТипЗначения = Тип("Строка") Тогда
		Для каждого Колонка Из ОбщийКлиентСервер.Массив(Колонки) Цикл
			Таблица.Колонки.Добавить(Колонка);
		КонецЦикла;
	ИначеЕсли ТипЗначения = Тип("Структура") Тогда
		Для каждого Колонка Из Колонки Цикл
			Значение 	= Колонка.Значение;
			Если Значение = Неопределено Тогда
				Таблица.Колонки.Добавить(Колонка.Ключ);
			Иначе
				ТипЗначения = Колонка.Значение;
				Если ТипЗнч(ТипЗначения) <> Тип("ОписаниеТипов") Тогда
					ТипЗначения = Новый ОписаниеТипов(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ТипЗнч(ТипЗначения)));
				КонецЕсли;
				Таблица.Колонки.Добавить(Колонка.Ключ, ТипЗначения);
			КонецЕсли;
		КонецЦикла;		
	Иначе 
		Для каждого Колонка Из Колонки Цикл
			ТипЗначения = Новый ОписаниеТипов(Колонка.ТипЗначения,, "Null");
			Таблица.Колонки.Добавить(Колонка.Имя, ТипЗначения);
		КонецЦикла;		
	КонецЕсли; 
	Возврат Таблица;
КонецФункции
