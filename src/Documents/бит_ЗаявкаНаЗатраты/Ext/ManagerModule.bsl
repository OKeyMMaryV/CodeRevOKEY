﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура на основании расходных позиций создает документы затрат.
// 
// Параметры:
// 	ДокЗаявка - ДокументСсылка.бит_ЗаявкаНаЗатраты.
// 
Функция СоздатьДокументыЗатратПоЗаявке(ДокЗаявка) Экспорт
	
	СписокДокументов = Новый Массив();
	Если НЕ ТипЗнч(ДокЗаявка) = Тип("ДокументСсылка.бит_ЗаявкаНаЗатраты") Тогда
		Возврат СписокДокументов;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДокументОснование", ДокЗаявка);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_РасходнаяПозиция.Ссылка,
	|	бит_РасходнаяПозиция.ДатаРасхода
	|ИЗ
	|	Документ.бит_РасходнаяПозиция КАК бит_РасходнаяПозиция
	|ГДЕ
	|	бит_РасходнаяПозиция.ДокументОснование = &ДокументОснование";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Отсутствуют расходные позиции по документу ""%1"".'"), ДокЗаявка);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат СписокДокументов;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	СтруктураПараметров = Новый Структура;
	
	Пока Выборка.Следующий() Цикл
		СтруктураПараметров.Вставить("ДатаРасхода", Выборка.ДатаРасхода);
		ДокументЗатрат = бит_ДоговораСервер.СоздатьДокументЗатрат(Выборка.Ссылка,, СтруктураПараметров, "Ошибки");
		Если ДокументЗатрат <> Неопределено Тогда
			СписокДокументов.Добавить(ДокументЗатрат);
		КонецЕсли;
	КонецЦикла;
	
	ТекстСообщения = НСтр("ru = 'Создание документов затрат завершено.'");
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	Возврат СписокДокументов;
	
КонецФункции

// Функция формирует таблицу с остатками по заявке.
// 
// Параметры:
//  Заявка  - ДокументСсылка.бит_ЗаявкаНаЗатраты - заявка.
//  РасходнаяПозиция  - ДокументСсылка.бит_РасходнаяПозиция - расходная позиция.
// 
// Возвращаемое значение:
//   Структура.
// 
Функция ПолучитьОстаткиПоЗаявке(Заявка, РасходнаяПозиция = Неопределено) Экспорт

	ОстаткиПоЗаявке = Новый Структура;
	ОстаткиПоЗаявке.Вставить("СуммаЗаявки",	0);
	ОстаткиПоЗаявке.Вставить("СуммаРП",		0);
	ОстаткиПоЗаявке.Вставить("Сумма",		0);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Заявка",				Заявка);
	Запрос.УстановитьПараметр("РасходнаяПозиция",	РасходнаяПозиция);
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_РасходнаяПозиция.ДокументОснование КАК ДокументОснование,
	|	СУММА(бит_РасходнаяПозиция.Сумма) КАК СуммаРП
	|ПОМЕСТИТЬ СуммыРП
	|ИЗ
	|	Документ.бит_РасходнаяПозиция КАК бит_РасходнаяПозиция
	|ГДЕ
	|	бит_РасходнаяПозиция.ДокументОснование = &Заявка
	|	И бит_РасходнаяПозиция.Ссылка <> &РасходнаяПозиция
	|
	|СГРУППИРОВАТЬ ПО
	|	бит_РасходнаяПозиция.ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	бит_ЗаявкаНаЗатраты.Сумма КАК СуммаЗаявки,
	|	ЕСТЬNULL(СуммыРП.СуммаРП, 0) КАК СуммаРП,
	|	бит_ЗаявкаНаЗатраты.Сумма - ЕСТЬNULL(СуммыРП.СуммаРП, 0) КАК Сумма
	|ИЗ
	|	Документ.бит_ЗаявкаНаЗатраты КАК бит_ЗаявкаНаЗатраты
	|		ЛЕВОЕ СОЕДИНЕНИЕ СуммыРП КАК СуммыРП
	|		ПО бит_ЗаявкаНаЗатраты.Ссылка = СуммыРП.ДокументОснование
	|ГДЕ
	|	бит_ЗаявкаНаЗатраты.Ссылка = &Заявка";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(ОстаткиПоЗаявке, Выборка);
	КонецЕсли;
	
    Возврат ОстаткиПоЗаявке;
	
КонецФункции

#КонецОбласти

#КонецЕсли
