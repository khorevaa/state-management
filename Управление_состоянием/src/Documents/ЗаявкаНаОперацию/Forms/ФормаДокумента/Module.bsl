#Область УправлениеСостоянием

&НаСервере
Процедура УправлениеФормойНаСервере(ИзмененныеРеквизиты = Неопределено, ЗависимыеЭлементы = Неопределено)
	Модель = РаботаСМодельюКлиентСервер.МодельОбъекта(ЭтотОбъект);
	РаботаСФормойКлиентСервер.УправлениеФормой(ЭтотОбъект, Модель, ИзмененныеРеквизиты, ЗависимыеЭлементы);	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой(ИзмененныеРеквизиты = Неопределено)
	Перем ЗависимыеЭлементы;
	НаСервере = Ложь;
	Модель = РаботаСМодельюКлиентСервер.МодельОбъекта(ЭтотОбъект);
	РаботаСФормойКлиентСервер.УправлениеФормой(ЭтотОбъект, Модель, ИзмененныеРеквизиты, ЗависимыеЭлементы, НаСервере);
	Если НаСервере Тогда
		УправлениеФормойНаСервере(ИзмененныеРеквизиты, ЗависимыеЭлементы);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеФормой();
КонецПроцедуры


#Область ОбработчикиСобытийФормы

//@skip-warning
&НаКлиенте
Процедура ПриАктивизацииСтроки(Элемент)
	РаботаСФормойКлиентСервер.ПриАктивизацииСтроки(ЭтотОбъект, Элемент);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	РаботаСФормойКлиентСервер.НачалоВыбора(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

#Область ПриИзменении // При расчете может потребоваться изменить контекст, а сделать это можно только в модуле формы

//  Процедура продолжает расчет уже в контексте сервера. Такое разделение процедуры нужно для программного переключения контекста
&НаСервере
Процедура РассчитатьСостояниеНаСервере(ИзмененныеРеквизиты, ОбработанныеРеквизиты, Последовательность, ИспользованныеСвязи)
	Модель = РаботаСМодельюКлиентСервер.МодельОбъекта(ЭтотОбъект);
	РаботаСМодельюКлиентСервер.РассчитатьСостояние(ЭтотОбъект, Модель, ИзмененныеРеквизиты, ОбработанныеРеквизиты, Последовательность, ИспользованныеСвязи);
	УправлениеФормойНаСервере(ОбщийКлиентСервер.СоответствиеВМассив(ОбработанныеРеквизиты));
КонецПроцедуры

//  Процедура выполняет расчет в контексте клиента
&НаКлиенте
Процедура РассчитатьСостояние(ИзмененныеРеквизиты)
	Модель = РаботаСМодельюКлиентСервер.МодельОбъекта(ЭтотОбъект);
	Последовательность = Новый Структура("Список, Словарь", Новый СписокЗначений, Новый Соответствие);
	ОбработанныеРеквизиты = Новый Соответствие;
	ИспользованныеСвязи = Новый Соответствие;
	НаСервере = Ложь;
	РаботаСМодельюКлиентСервер.РассчитатьСостояние(ЭтотОбъект, Модель, ИзмененныеРеквизиты, ОбработанныеРеквизиты, Последовательность, ИспользованныеСвязи, НаСервере);
	Если НаСервере Тогда
		РассчитатьСостояниеНаСервере(ИзмененныеРеквизиты, ОбработанныеРеквизиты, Последовательность, ИспользованныеСвязи);
	Иначе
		УправлениеФормой(ОбщийКлиентСервер.СоответствиеВМассив(ОбработанныеРеквизиты));
	КонецЕсли;
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура ПриИзменении(Элемент)
	ОчиститьСообщения();
	Модель = РаботаСМодельюКлиентСервер.МодельОбъекта(ЭтотОбъект); 
	Параметр = Модель.Параметры[Модель.ПараметрыЭлементов[Элемент.Имя]];
	Если Параметр = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Параметр.ЭтоЭлементКоллекции Тогда
		ИзмененныеРеквизиты = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РаботаСМодельюКлиентСервер.Реквизит(Параметр.Идентификатор, РаботаСМодельюКлиентСервер.ЗначениеПараметра(ЭтотОбъект, Модель, Модель.Параметры[Параметр.Коллекция + ".ИндексСтроки"])));
	Иначе
		ИзмененныеРеквизиты = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РаботаСМодельюКлиентСервер.Реквизит(Параметр.Идентификатор));
	КонецЕсли;
	РассчитатьСостояние(ИзмененныеРеквизиты);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Модель = Новый ФиксированнаяСтруктура(РаботаСМодельюКлиентСервер.Модель("МодельЗаявкаНаОперацию"));

	РаботаСМодельюКлиентСервер.Связь(ЭтотОбъект, Модель, "СуммаВзаиморасчетов", "СуммаДокумента", "Сумма");
	Модель.Параметры["СуммаДокумента"].НаСервере = Ложь;
	Модель.Параметры["СуммаВзаиморасчетов"].НаСервере = Ложь;
	Модель.Параметры["СуммаВзаиморасчетов"].ВыражениеЗначения = "Параметры.Сумма";

	РаботаСМодельюКлиентСервер.Связь(ЭтотОбъект, Модель, "ДвиженияОперации.СуммаВзаиморасчетов", "ДвиженияОперации.Сумма", "Сумма");
	Модель.Параметры["ДвиженияОперации.Сумма"].НаСервере = Ложь;
	Модель.Параметры["ДвиженияОперации.СуммаВзаиморасчетов"].НаСервере = Ложь;
	Модель.Параметры["ДвиженияОперации.СуммаВзаиморасчетов"].ВыражениеЗначения = "Параметры.Сумма";
	
	Параметр = РаботаСМодельюКлиентСервер.Параметр(ЭтотОбъект, Модель, "ДвиженияОперации.ИндексСтроки");
	Параметр.НаСервере = Ложь;
	Параметр.ПроверкаЗаполнения = Ложь;
	Параметр.ЭтоСсылка = Ложь;

	РаботаСМодельюКлиентСервер.Связь(ЭтотОбъект, Модель, "Комментарий", "_Комментарий", "Комментарий");
	Модель.Параметры["_Комментарий"].НаСервере = Ложь;
	Модель.Параметры["_Комментарий"].ВыражениеЗначения = "Контекст.Объект.Комментарий";
	Модель.Параметры["Комментарий"].НаСервере = Ложь;
	Модель.Параметры["Комментарий"].ВыражениеЗначения = "Параметры.Комментарий";

	РаботаСМодельюКлиентСервер.ОпределитьПорядок(Модель);

	Элемент = РаботаСФормойКлиентСервер.Элемент(ЭтотОбъект, Модель, Элементы.СчетКонтрагента, "ВидДенежныхСредств");
	Элемент.НаСервере = Ложь;

	РаботаСФормой.УстановитьСвязьСЭлементамиФормы(ЭтотОбъект, Модель, Элементы);
	
	Модель.Параметры["ВидДенежныхСредств"].НаСервере = Ложь;
	
	РаботаСМоделью.ХранилищеЗначений(ЭтотОбъект, Модель);
	
	РаботаСМоделью.РассчитатьПроизводныеПараметры(ЭтотОбъект, Модель);
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти
