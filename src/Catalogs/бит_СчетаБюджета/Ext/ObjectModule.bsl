﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ПометкаУдаления Тогда
		ПроверитьСчетБюджетаУникальный(Отказ);	
	КонецЕсли;
	
КонецПроцедуры
	
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ДополнительныеСвойства); 	
	
	Если Не ЭтоНовый() И Не ПометкаУдаления=Ссылка.ПометкаУдаления Тогда
		// В случае установки или снятия пометки удаления не производить проверку.
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры
	
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ДополнительныеСвойства, Метаданные().ПолноеИмя());
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяется уникальность ссылки на статью оборотов в рамках владельца. 
// Если этого не обеспечить, тогда заполнение формы ввода бюджета по бюджету
// приводит к ошибкам из-за особенности реализации связи ячейки и строки данных бюджета.
//
// Параметры:
//  Отказ	 - Булево - отменяет стандартную обработку вызывающего обработчика. 
//
Процедура ПроверитьСчетБюджетаУникальный(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",	Ссылка);
	Запрос.УстановитьПараметр("Бюджет",	Владелец);
	Запрос.УстановитьПараметр("Счет",	Счет);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	бит_СчетаБюджета.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.бит_СчетаБюджета КАК бит_СчетаБюджета
	|ГДЕ
	|	бит_СчетаБюджета.Ссылка <> &Ссылка
	|	И бит_СчетаБюджета.Владелец = &Бюджет
	|	И бит_СчетаБюджета.Счет = &Счет";
	
	Выборка = Запрос.Выполнить().Выбрать();
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ШаблонСообщения = СтрШаблон(НСтр("ru = 'Дублирование счетов бюджета в рамках одного бюджета не поддерживается. Счет уже используется в счете бюджета ""%1"".'"), Выборка.Ссылка);
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("ПОЛЕ", "КОРРЕКТНОСТЬ", НСтр("ru = 'Счет'"),,,ШаблонСообщения);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Выборка.Ссылка,,,Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
