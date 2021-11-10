﻿
&НаКлиенте
Процедура ВыбратьСертификат(Команда)
	
	Оповещение = Новый ОписаниеОповещения(
		"ПослеВводаПараметровКриптографии",
		ЭтотОбъект);
		
	ПараметрыОтбора = УниверсальныйОбменСБанкамиКлиентСервер.
		ПараметрыОтбораСертификата(Запись.Сервис, Запись.Организация);
	ПараметрыОтбора.ПредставлениеОтбора = СтрШаблон(НСтр("ru='Организация = ""%1""'"), Запись.Организация);
		
	Если НЕ ФильтроватьПоРеквизитам Тогда
		ПараметрыОтбора = Неопределено;
	КонецЕсли;
		
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Сервис", Запись.Сервис);
	ПараметрыФормы.Вставить("Организация", Запись.Организация);
	ПараметрыФормы.Вставить("ОтображатьПолеВводаПароля", Ложь);
	ПараметрыФормы.Вставить("НазваниеКнопки", "Сохранить");
	ПараметрыФормы.Вставить("Заголовок", "Выберите сертификат");
	ПараметрыФормы.Вставить("ПараметрыОтбора", ПараметрыОтбора);
	
	ОткрытьФорму("ОбщаяФорма.ВводПараметровКриптографииОбменаСБанками", 
		ПараметрыФормы,
		ЭтаФорма,
		,
		,
		,
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаПараметровКриптографии(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Запись.СертификатОтпечаток                  = Результат.Сертификат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСертификат(Команда)
	
	ПараметрыОтбора = УниверсальныйОбменСБанкамиКлиентСервер.
		ПараметрыОтбораСертификата(Запись.Сервис, Запись.Организация);
		
	Оповещение = Новый ОписаниеОповещения("ПодобратьСертификатПослеПодбора", ЭтотОбъект);
	УниверсальныйОбменСБанкамиКлиент.
		ПодобратьСертификатОрганизации(ПараметрыОтбора, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьСертификатПослеПодбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат.Выполнено Тогда
		Запись.СертификатОтпечаток = Результат.ОтпечатокСертификата;
	КонецЕсли;
	
КонецПроцедуры