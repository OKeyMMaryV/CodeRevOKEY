﻿////////////////////////////////////////////////////////////////////////////////
// Ввод целей расхода материалов
// Обеспечивает быстрое создание элемента без открытия формы
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Переопределяет обработчик АвтоПодбор поля цели расхода
//
// Параметры:
//  Элемент				 - ПолеФормы - элемент формы, с которым связано событие.
//  Текст				 - Строка - см. описание параметра обработчика АвтоПодбор.
//  ДанныеВыбора		 - СписокЗначений - см. описание параметра обработчика АвтоПодбор.
//  Параметры			 - Структура - см. описание параметра обработчика АвтоПодбор.
//  Ожидание			 - Число - см. описание параметра обработчика АвтоПодбор.
//  СтандартнаяОбработка - Булево - см. описание параметра обработчика АвтоПодбор.
//
Процедура ЦельРасходаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка) Экспорт
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ВводЦелейРасходаМатериаловВызовСервера.ДанныеВыбораЦелиРасхода(Параметры, Ложь);
	
КонецПроцедуры

// Переопределяет обработчик ОкончаниеВводаТекста поля цели расхода
//
// Параметры:
//  Элемент				 - ПолеФормы - элемент формы, с которым связано событие.
//  Текст				 - Строка - см. описание параметра обработчика ОкончаниеВводаТекста.
//  ДанныеВыбора		 - СписокЗначений - см. описание параметра обработчика ОкончаниеВводаТекста.
//  Параметры			 - Структура - см. описание параметра обработчика ОкончаниеВводаТекста.
//  СтандартнаяОбработка - Булево - см. описание параметра обработчика ОкончаниеВводаТекста.
//
Процедура ЦельРасходаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;
	ДанныеВыбора = ВводЦелейРасходаМатериаловВызовСервера.ДанныеВыбораЦелиРасхода(Параметры, Истина);
	
КонецПроцедуры

// Переопределяет обработчик ОбработкаВыбора поля цели расхода для быстрого создания элемента справочника
//
// Параметры:
//  Элемент				 - ПолеФормы - элемент формы, с которым связано событие.
//  ВыбранноеЗначение	 - Произвольный - см. описание параметра обработчика ОбработкаВыбора.
//  СтандартнаяОбработка - Булево - см. описание параметра обработчика ОбработкаВыбора.
//
Процедура ЦельРасходаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("Строка") ИЛИ ПустаяСтрока(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;

	ВыбранноеЗначение = ВводЦелейРасходаМатериаловВызовСервера.СоздатьЭлементСправочника(ВыбранноеЗначение);

КонецПроцедуры

#КонецОбласти

