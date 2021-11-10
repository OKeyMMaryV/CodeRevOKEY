﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
	
Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
		
	Если НаДату > '20110101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.ВерсияФСГС;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(0));
	
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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2013Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 06.09.2012 № 480.";
	НоваяФорма.РедакцияФормы	  = "от 06.09.2012 № 480.";
	НоваяФорма.ДатаНачалоДействия = '20130101';
	НоваяФорма.ДатаКонецДействия  = '20131231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 07.08.2013 № 312.";
	НоваяФорма.РедакцияФормы	  = "от 07.08.2013 № 312.";
	НоваяФорма.ДатаНачалоДействия = '20140101';
	НоваяФорма.ДатаКонецДействия  = '20140930';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 19.08.2014 № 527.";
	НоваяФорма.РедакцияФормы	  = "от 19.08.2014 № 527.";
	НоваяФорма.ДатаНачалоДействия = '20141001';
	НоваяФорма.ДатаКонецДействия  = '20141231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 18.08.2015 № 378.";
	НоваяФорма.РедакцияФормы	  = "от 18.08.2015 № 378.";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = '20151231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 03.08.2016 № 385.";
	НоваяФорма.РедакцияФормы	  = "от 03.08.2016 № 385.";
	НоваяФорма.ДатаНачалоДействия = '20160101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	Возврат Неопределено;
	
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
	
	Форма20130101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "615056", '20120906', "480", "ФормаОтчета2013Кв1");
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "615056", '20130807', "312", "ФормаОтчета2014Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "615056", '20140819', "527", "ФормаОтчета2015Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "615056", '20150818', "378", "ФормаОтчета2016Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "615056", '20160803', "385", "ФормаОтчета2017Кв1");
	
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФорма65Автотранс", "ФормаОтчета2017Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20150101, ВерсияВыгрузки);
	
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

#КонецОбласти

#КонецЕсли