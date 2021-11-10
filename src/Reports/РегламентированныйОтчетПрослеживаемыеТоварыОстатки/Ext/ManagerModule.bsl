﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	
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
	
	Если ТекущаяДатаСеанса() >= ДатаПримененияФормыВНовойРедакции() Тогда
		
		// Форма действует с 11.09.2021. Форма, рекомендованная письмом ФНС России
		// от 14.04.2021 № ЕА-4-15/5042@ с 11.09.2021 не применяется (основание - СФНД).
		//
		НоваяФорма = ТаблицаФормОтчета.Добавить();
		НоваяФорма.ФормаОтчета        = "ФормаОтчета2021Кв3";
		НоваяФорма.ОписаниеОтчета     = "Приложение № 3 к приказу ФНС России от 08.07.2021 № ЕД-7-15/645@.";
		НоваяФорма.РедакцияФормы	  = "от 08.07.2021 № ЕД-7-15/645@.";
		НоваяФорма.ДатаНачалоДействия = '20210622';
		НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
		
	Иначе
		
		НоваяФорма = ТаблицаФормОтчета.Добавить();
		НоваяФорма.ФормаОтчета        = "ФормаОтчета2021Кв3";
		НоваяФорма.ОписаниеОтчета     = "Приложение № 3 к письму ФНС России от 14.04.2021 № ЕА-4-15/5042@.";
		НоваяФорма.РедакцияФормы	  = "от 14.04.2021 № ЕА-4-15/5042@.";
		НоваяФорма.ДатаНачалоДействия = '20210622';
		НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
		
	КонецЕсли;
	
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
	
	Если ТекущаяДатаСеанса() >= ДатаПримененияФормыВНовойРедакции() Тогда
		
		ФормаОтчета2021Кв3 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,
		"1169011", '2021-07-08', "ЕД-7-15/645@", "ФормаОтчета2021Кв3");
		ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2021Кв3, "5.02");
		
	Иначе
		
		ФормаОтчета2021Кв3 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы,
		"1169011", '2021-04-14', "ЕА-4-15/5042@", "ФормаОтчета2021Кв3");
		ОпределитьФорматВДеревеФормИФорматов(ФормаОтчета2021Кв3, "5.01");
		
	КонецЕсли;
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "",
			ИмяОбъекта = "", ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
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

Функция ДатаПримененияФормыВНовойРедакции()
	
	Возврат '20210911';
	
КонецФункции

#КонецОбласти

#КонецЕсли