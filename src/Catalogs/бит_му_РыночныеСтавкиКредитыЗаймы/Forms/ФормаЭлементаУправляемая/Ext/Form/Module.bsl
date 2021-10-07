﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	
	
	// Вызов механизма защиты
	 
	
	ЗакрыватьПриВыборе = Ложь;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ВыполнитьПроверкуЗаполнения(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	ОповеститьОВыборе(Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	Объект.Период = НачалоМесяца(Объект.Период);
	СформироватьНаименование();
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Объект.Период = НачалоМесяца(ДобавитьМесяц(Объект.Период, Направление));
	СформироватьНаименование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура проверят, правильно ли заполнена табличная часть.
// 
// Параметры:
//  Отказ - Булево, по умолчанию Ложь.
// 
&НаСервере
Процедура ВыполнитьПроверкуЗаполнения(Отказ)

	ТабЗнач = Объект.Ставки.Выгрузить();
	ТабЗнач.Колонки.Добавить("Счетчик");
	ТабЗнач.ЗаполнитьЗначения(1, "Счетчик");
	
	ТабЗнач.Свернуть("ЧислоДней", "Счетчик");
	
	СтрокаСообщений = "";
	
	Для каждого ТекСтр Из ТабЗнач Цикл
		Если ТекСтр.Счетчик > 1 Тогда
			СтрокаСообщений = СтрокаСообщений + НСтр("ru = 'число дней %1% встречается в таблице более одного раза'") + Символы.ПС;
			СтрокаСообщений = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(СтрокаСообщений, ТекСтр.ЧислоДней);
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокаСообщений <> "" Тогда
		СтрокаСообщений = НСтр("ru = 'Невозможно записать элемент по причине:'") + Символы.ПС + СтрокаСообщений;	
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(СтрокаСообщений, Объект, , Отказ);
		Возврат;
	КонецЕсли;

КонецПроцедуры // ВыполнитьПроверкуЗаполнения() 

// Процедура формирует наименование элемента.
//
&НаКлиенте
Процедура СформироватьНаименование()
	
	СписокВыбора = Элементы.Наименование.СписокВыбора;
	СписокВыбора.Очистить();
	СписокВыбора.Добавить(Формат(Объект.Период, "ДФ='MMMM yyyy'") + ", " + Объект.Валюта);
	
КонецПроцедуры

#КонецОбласти