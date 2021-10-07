﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
    
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.СписокПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма);	
	
	МетаданныеОбъекта = Метаданные.Документы.бит_СправкаОВалютныхОперациях;
	
	// Вызов механизма защиты
	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	бит_РаботаСДиалогамиСервер.ДобавитьКнопкуРаскраситьПоСтатусам(Элементы, Команды, Элементы.ФормаКоманднаяПанель,
																  МетаданныеОбъекта);
																  
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаКлиенте
Процедура Подключаемый_РаскраситьПоСтатусам()
	
	Элементы.РаскраситьПоСтатусам.Пометка = Не Элементы.РаскраситьПоСтатусам.Пометка;
	ОформитьСписокДокументовПоСтатусам(Элементы.РаскраситьПоСтатусам.Пометка);	
		
КонецПроцедуры // Подключаемый_РаскраситьПоСтатусам()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура оформляет список документов в зависимости от статуса документа.
// 
// Параметры:
//  ПометкаКн - Булево.
//  ЭтоОткрытие - Булево.
// 
&НаСервере
Процедура ОформитьСписокДокументовПоСтатусам(ПометкаКн, ЭтоОткрытие = Ложь)

	Если ЭтоОткрытие И Не ПометкаКн Тогда
		Возврат;	
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.Документы.бит_СправкаОВалютныхОперациях;	
	
	МасОбъектов = ?(ПометкаКн, бит_РаботаСДиалогамиСервер.ПолучитьМассивОбъектов(МетаданныеОбъекта), Новый Массив);
	бит_РаботаСДиалогамиСервер.ОформитьСписокДокументовПоСтатусам(МасОбъектов, ПометкаКн, ЭтаФорма.УсловноеОформление);
	
	Если Не ЭтоОткрытие Тогда
		// Сохранение значения пометки
		РегистрыСведений.бит_СохраненныеЗначения.СохранитьЗнч(бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь")
																	,МетаданныеОбъекта
																	,"РаскраситьПоСтатусам_Пометка"
																	,ПометкаКн);
	КонецЕсли;
															
КонецПроцедуры // ОформитьСписокДокументовПоСтатусам()

#КонецОбласти 
