///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Загрузка переданных параметров.
	ПереданныйМассивФорматов = Новый Массив;
	Если Параметры.НастройкиФормата <> Неопределено Тогда
		ПереданныйМассивФорматов = Параметры.НастройкиФормата.ФорматыСохранения;
		УпаковатьВАрхив = Параметры.НастройкиФормата.УпаковатьВАрхив;
		ПереводитьИменаФайловВТранслит = Параметры.НастройкиФормата.ПереводитьИменаФайловВТранслит;
	КонецЕсли;
	
	// заполнение списка форматов
	Для Каждого ФорматСохранения Из СтандартныеПодсистемыСервер.НастройкиФорматовСохраненияТабличногоДокумента() Цикл
		Пометка = Ложь;
		Если Параметры.НастройкиФормата <> Неопределено Тогда 
			ПереданныйФормат = ПереданныйМассивФорматов.Найти(Строка(ФорматСохранения.ТипФайлаТабличногоДокумента));
			Если ПереданныйФормат <> Неопределено Тогда
				Пометка = Истина;
			КонецЕсли;
		КонецЕсли;
		ВыбранныеФорматыСохранения.Добавить(Строка(ФорматСохранения.ТипФайлаТабличногоДокумента), Строка(ФорматСохранения.Ссылка), Пометка, ФорматСохранения.Картинка);
	КонецЦикла;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	Если Параметры.НастройкиФормата <> Неопределено Тогда
		Если Параметры.НастройкиФормата.ФорматыСохранения.Количество() > 0 Тогда
			Настройки.Удалить("ВыбранныеФорматыСохранения");
		КонецЕсли;
		Если Параметры.НастройкиФормата.Свойство("УпаковатьВАрхив") Тогда
			Настройки.Удалить("УпаковатьВАрхив");
		КонецЕсли;
		Если Параметры.НастройкиФормата.Свойство("ПереводитьИменаФайловВТранслит") Тогда
			Настройки.Удалить("ПереводитьИменаФайловВТранслит");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ФорматыСохраненияИзНастроек = Настройки["ВыбранныеФорматыСохранения"];
	Если ФорматыСохраненияИзНастроек <> Неопределено Тогда
		Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл 
			ФорматИзНастроек = ФорматыСохраненияИзНастроек.НайтиПоЗначению(ВыбранныйФормат.Значение);
			ВыбранныйФормат.Пометка = ФорматИзНастроек <> Неопределено И ФорматИзНастроек.Пометка;
		КонецЦикла;
		Настройки.Удалить("ВыбранныеФорматыСохранения");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВыборФормата();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	РезультатВыбора = ВыбранныеНастройкиФормата();
	ОповеститьОВыборе(РезультатВыбора);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВыборФормата()
	
	ЕстьВыбранныйФормат = Ложь;
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			ЕстьВыбранныйФормат = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ЕстьВыбранныйФормат Тогда
		ВыбранныеФорматыСохранения[0].Пометка = Истина; // Выбор по умолчанию - первый в списке.
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеНастройкиФормата()
	
	ФорматыСохранения = Новый Массив;
	
	Для Каждого ВыбранныйФормат Из ВыбранныеФорматыСохранения Цикл
		Если ВыбранныйФормат.Пометка Тогда
			ФорматыСохранения.Добавить(ВыбранныйФормат.Значение);
		КонецЕсли;
	КонецЦикла;	
	
	Результат = Новый Структура;
	Результат.Вставить("УпаковатьВАрхив", УпаковатьВАрхив);
	Результат.Вставить("ФорматыСохранения", ФорматыСохранения);
	Результат.Вставить("ПереводитьИменаФайловВТранслит", ПереводитьИменаФайловВТранслит);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
