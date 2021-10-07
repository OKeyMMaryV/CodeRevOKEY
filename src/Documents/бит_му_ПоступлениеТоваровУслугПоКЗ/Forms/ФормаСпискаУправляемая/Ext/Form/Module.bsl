﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		бит_РаботаСДиалогамиКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, ,Параметр);		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ НА СЕРВЕРЕ

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// стандартные действия при создании на сервере
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);
	
	бит_РаботаСДиалогамиСервер.УстановитьОтборПоОсновнойОрганизации(ЭтаФорма, "Список", "Организация");
	
КонецПроцедуры

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	бит_РаботаСДиалогамиСервер.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура НРПВНАПоказать(Команда)
	
	Отбор = Новый Структура("мРегистратор", Элементы.Список.ТекущаяСтрока);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("РегистрСведений.бит_му_НРП_ВНА.ФормаСписка", ПараметрыФормы);
	
КонецПроцедуры
