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
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 22.01.2014 № 43.";
	НоваяФорма.РедакцияФормы	  = "от 22.01.2014 № 43.";
	НоваяФорма.ДатаНачалоДействия = '20140101';
	НоваяФорма.ДатаКонецДействия  = '20141231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 21.01.2015 № 9.";
	НоваяФорма.РедакцияФормы	  = "от 21.01.2015 № 9.";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = '20151231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 05.02.2016 № 49.";
	НоваяФорма.РедакцияФормы	  = "от 05.02.2016 № 49.";
	НоваяФорма.ДатаНачалоДействия = '20160101';
	НоваяФорма.ДатаКонецДействия  = '20161231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 06.02.2017 № 81.";
	НоваяФорма.РедакцияФормы	  = "от 06.02.2017 № 81.";
	НоваяФорма.ДатаНачалоДействия = '20170101';
	НоваяФорма.ДатаКонецДействия  = '20171231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2018Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 29.01.2018 № 35.";
	НоваяФорма.РедакцияФормы	  = "от 29.01.2018 № 35.";
	НоваяФорма.ДатаНачалоДействия = '20180101';
	НоваяФорма.ДатаКонецДействия  = '20181231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 31.01.2019 № 34.";
	НоваяФорма.РедакцияФормы	  = "от 31.01.2019 № 34.";
	НоваяФорма.ДатаНачалоДействия = '20190101';
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
	
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "608017", '20140122', "43", "ФормаОтчета2014Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "608017", '20150121', "9", "ФормаОтчета2015Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "608017", '20160205', "49", "ФормаОтчета2016Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "608017", '20170206', "81", "ФормаОтчета2017Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "608017", '20180129', "35", "ФормаОтчета2018Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФорма9ФСС", "ФормаОтчета2018Кв1");
	РегламентированнаяОтчетность.ОпределитьФорматВДеревеФормИФорматов(Форма20150101, ВерсияВыгрузки);
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "608017", '20190131', "34", "ФормаОтчета2019Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФорма9ФСС", "ФормаОтчета2019Кв1");
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

#Если Не ВнешнееСоединение Тогда
#Область ФормированиеТекстаВыгрузки

Функция ТекстВыгрузкиОтчетаСтатистики(мСохраненныйДок, ВыбраннаяФорма) Экспорт 
	ТекстВыгрузки = "";
	Если ВыбраннаяФорма = "ФормаОтчета2018Кв1" Тогда 
		КонтекстФормы = УниверсальныйОтчетСтатистики.СформироватьКонтекстФормыДляПоказателей(мСохраненныйДок);
		ПараметрыВыгрузки = УниверсальныйОтчетСтатистики.СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, "АтрибВыгрузкиXML2018Кв1");
		
		ПараметрыВыгрузки.Вставить("ОКАТО", СокрЛП(КонтекстФормы.мДанныеОтчета.ПолеТабличногоДокументаФормаОтчета.ОргКодОКАТО));
		МесПериод = 12 / ПараметрыВыгрузки.КодПериодичности;
		ПараметрыВыгрузки.ОтчПериод = "" + Месяц(мСохраненныйДок.ДатаОкончания) / МесПериод;
		
		ДеревоВыгрузки = РегламентированнаяОтчетность.ПолучитьДеревоВыгрузки(КонтекстФормы, "СхемаВыгрузкиXML2018Кв1");
		УниверсальныйОтчетСтатистики.ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки);
		ТекстВыгрузки = РегламентированнаяОтчетность.ВыгрузитьДеревоВXML(ДеревоВыгрузки, ПараметрыВыгрузки);
	ИначеЕсли ВыбраннаяФорма = "ФормаОтчета2019Кв1" Тогда 
		КонтекстФормы = УниверсальныйОтчетСтатистики.СформироватьКонтекстФормыДляПоказателей(мСохраненныйДок);
		ПараметрыВыгрузки = УниверсальныйОтчетСтатистики.СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, "АтрибВыгрузкиXML2019Кв1");
		
		ПараметрыВыгрузки.Вставить("ОКАТО", СокрЛП(КонтекстФормы.мДанныеОтчета.ПолеТабличногоДокументаФормаОтчета.ОргКодОКАТО));
		МесПериод = 12 / ПараметрыВыгрузки.КодПериодичности;
		ПараметрыВыгрузки.ОтчПериод = "" + Месяц(мСохраненныйДок.ДатаОкончания) / МесПериод;
		
		ДеревоВыгрузки = РегламентированнаяОтчетность.ПолучитьДеревоВыгрузки(КонтекстФормы, "СхемаВыгрузкиXML2019Кв1");
		УниверсальныйОтчетСтатистики.ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки);
		ТекстВыгрузки = РегламентированнаяОтчетность.ВыгрузитьДеревоВXML(ДеревоВыгрузки, ПараметрыВыгрузки);
	КонецЕсли;
	
	Возврат ТекстВыгрузки;
КонецФункции

#КонецОбласти
#КонецЕсли

#КонецЕсли