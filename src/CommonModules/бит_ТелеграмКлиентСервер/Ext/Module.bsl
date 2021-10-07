﻿
#Область ПрограммныйИнтерфейс

// Процедура - выполняет установку/снятие/инвертирование флагов в таблице.
//
// Параметры:
//  Таблица		 - ТабличнаяЧасть - ТаблицаЗначений.
//  ИмяФлага	 - Строка - Имя реквизита, флаг в таблице.
//  ТекЗначение	 - Число - (0) ложь (1) истина (2) инвертировать.
//
Процедура ОбработатьФлаги(
			Таблица,
			ИмяФлага,
			ТекЗначение) Экспорт
	
	Для каждого ТекущаяСтрока Из Таблица Цикл
		
		Если ТекЗначение = 0 Тогда
			ТекущаяСтрока[ИмяФлага] = Ложь;
			
		ИначеЕсли ТекЗначение = 1 Тогда
			ТекущаяСтрока[ИмяФлага] = Истина;	
			
		ИначеЕсли ТекЗначение = 2 Тогда			
			ТекущаяСтрока[ИмяФлага] = Не ТекущаяСтрока[ИмяФлага];
			
		КонецЕсли;   
		
	КонецЦикла; 
	
КонецПроцедуры // ОбработатьФлаги()

// Формирует и выводит сообщение, которое может быть связано с элементом
//  управления формы.
//
// Параметры:
//  ТекстСообщенияПользователю	 - Строка	 - Текст сообщения.
//  КлючДанных					 - ЛюбаяСсылка	 - Необязательный. На объект информационной базы.
//  Поле						 - Строка		 - Необязательный. Наименование реквизита формы.
//  ПутьКДанным					 - Строка		 - Необязательный. Путь к данным (путь к реквизиту формы).
//  Отказ						 - Булево		 - Необязательный. Выходной параметр.
//
Процедура СообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач КлючДанных = Неопределено,
		Знач Поле = "",
		Знач ПутьКДанным = "",
		Отказ = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	ЭтоОбъект = Ложь;
	
#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
	Если КлючДанных <> Неопределено
	   И XMLТипЗнч(КлючДанных) <> Неопределено Тогда
		ТипЗначенияСтрокой = XMLТипЗнч(КлючДанных).ИмяТипа;
		ЭтоОбъект = СтрНайти(ТипЗначенияСтрокой, "Object.") > 0;
	КонецЕсли;
#КонецЕсли
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
		
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти