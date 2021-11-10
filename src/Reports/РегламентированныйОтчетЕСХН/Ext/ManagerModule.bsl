﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату > '20090101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	ИначеЕсли НаДату > '20050101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия300;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв1";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина РФ от 22.06.2009 №57н.";
	НоваяФорма.РедакцияФормы      = "от 22.06.2009 №57н.";
	НоваяФорма.ДатаНачалоДействия = '20090101';
	НоваяФорма.ДатаКонецДействия  = '20131231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 28.07.2014 № ММВ-7-3/384@.";
	НоваяФорма.РедакцияФормы      = "от 28.07.2014 № ММВ-7-3/384@.";
	НоваяФорма.ДатаНачалоДействия = '20140101';
	НоваяФорма.ДатаКонецДействия  = '20151231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 28.07.2014 № ММВ-7-3/384@ (в ред. приказа ФНС России от 01.02.2016 № ММВ-7-3/51@).";
	НоваяФорма.РедакцияФормы      = "от 01.02.2016 № ММВ-7-3/51@.";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2015Кв1"
	 ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2014Кв1" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Раздел 1.
		// 001 - ОКТМО.
		// 004 - сумма.
		
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел12") Тогда
			
			Раздел1 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел12;
			
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			КодСтрокиОКТМО = "П000120000103";
			КодСтрокиСумма = "П000120000403";
			
			Сумма = ТаблицаДанныхРеглОтчета.Добавить();
			Сумма.ВидНалога = Перечисления.ВидыНалогов.ЕСХН;
			Сумма.Период = Период;
			Сумма.ОКАТО  = Раздел1[КодСтрокиОКТМО];
			Сумма.Сумма  = Раздел1[КодСтрокиСумма];
			
		КонецЕсли;
		
	ИначеЕсли ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2009Кв1" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Раздел 1.
		// 001 - КБК.
		// 002 - ОКАТО.
		// 003 - сумма.
		
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел12") Тогда
			
			Раздел1 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел12;
			
			Период = ЭкземплярРеглОтчета.ДатаОкончания;
			КодСтрокиКБК   = "П000120000103";
			КодСтрокиОКАТО = "П000120000203";
			КодСтрокиСумма = "П000120000503";
			
			Сумма = ТаблицаДанныхРеглОтчета.Добавить();
			Сумма.Период = Период;
			Сумма.КБК    = Раздел1[КодСтрокиКБК];
			Сумма.ОКАТО  = Раздел1[КодСтрокиОКАТО];
			Сумма.Сумма  = Раздел1[КодСтрокиСумма];
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаДанныхРеглОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20090101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151059", '20090622', "57н", "ФормаОтчета2009Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20090101, "5.01", , , , '2013-12-31');
	ОпределитьФорматВДеревеФормИФорматов(Форма20090101, "5.02", , , '2014-01-01');
	
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151059", '20140728', "ММВ-7-3/384@", "ФормаОтчета2014Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20140101, "5.03");
	
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1151059", '20160201', "ММВ-7-3/51@", "ФормаОтчета2015Кв1");
	ОпределитьФорматВДеревеФормИФорматов(Форма20150101, "5.04");
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли