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
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 09.08.2012 № 441.";
	НоваяФорма.РедакцияФормы	  = "от 09.08.2012 № 441.";
	НоваяФорма.ДатаНачалоДействия = '20130101';
	НоваяФорма.ДатаКонецДействия  = '20141231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 29.08.2014 № 540.";
	НоваяФорма.РедакцияФормы	  = "от 29.08.2014 № 540.";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = '20151231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2016Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от  28.07.2015 № 344.";
	НоваяФорма.РедакцияФормы	  = "от  28.07.2015 № 344.";
	НоваяФорма.ДатаНачалоДействия = '20160101';
	НоваяФорма.ДатаКонецДействия  = '20161231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2017Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 04.08.2016 № 387.";
	НоваяФорма.РедакцияФормы	  = "от 04.08.2016 № 387.";
	НоваяФорма.ДатаНачалоДействия = '20170101';
	НоваяФорма.ДатаКонецДействия  = '20181231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2019Кв1";
	НоваяФорма.ОписаниеОтчета     = "Форма утверждена приказом Росстата от 01.08.2018 № 473.";
	НоваяФорма.РедакцияФормы	  = "от 01.08.2018 № 473.";
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
	
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "611012", '20120809', "441", "ФормаОтчета2014Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "611012", '20140829', "540", "ФормаОтчета2015Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "611012", '20150728', "344", "ФормаОтчета2016Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "611012", '20160804', "387", "ФормаОтчета2017Кв1");
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "611012", '20180801', "473", "ФормаОтчета2019Кв1");
	ВерсияВыгрузки = РегламентированнаяОтчетность.ПолучитьВерсиюВыгрузкиСтатОтчета("РегламентированныйОтчетСтатистикаФормаП1СХ", "ФормаОтчета2019Кв1");
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

Функция СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, ИмяМакетаАттрибутов) Экспорт 
	
	Перем ПолученноеЗначение;
	
	ТабДокументТитульный = КонтекстФормы.мДанныеОтчета.ПолеТабличногоДокументаТитульный;
	ТабДокументПодписи   = КонтекстФормы.мДанныеОтчета.ПолеТабличногоДокументаПодписи;
	
	ИмяФормы = КонтекстФормы.ИмяФормы;
	ДопАтрибуты = РегламентированнаяОтчетность.СформироватьСтруктуруДопАтрибутов("Отчет."+Сред(Лев(ИмяФормы, СтрНайти(ИмяФормы, ".Форма.") - 1), 7)+".Форма.ФормаОтчета2016Кв1", ИмяМакетаАттрибутов);
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(мСохраненныйДок, "Организация, ДатаПодписи");
	СтрокаСведений = "ФИОРук";
	СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(РеквизитыДокумента.Организация, РеквизитыДокумента.ДатаПодписи, СтрокаСведений);
	
	ПараметрыВыгрузки = Новый Структура;
	
	ДопАтрибуты.Свойство("code", ПолученноеЗначение);
	ПараметрыВыгрузки.Вставить("КодШаблона", ПолученноеЗначение);
	ДопАтрибуты.Свойство("idf", ПолученноеЗначение);
	ПараметрыВыгрузки.Вставить("КодФормы", ПолученноеЗначение);
	ДопАтрибуты.Свойство("shifr", ПолученноеЗначение);
	ПараметрыВыгрузки.Вставить("ШифрФормы", ПолученноеЗначение);
	ДопАтрибуты.Свойство("version", ПолученноеЗначение);
	ПараметрыВыгрузки.Вставить("ВерсияШаблона", ПолученноеЗначение);
	ДопАтрибуты.Свойство("format_version", ПолученноеЗначение);
	ПараметрыВыгрузки.Вставить("ВерсияФормата", ПолученноеЗначение);
	
	ОтчПериод  = Месяц(мСохраненныйДок.ДатаОкончания);
	РасчПериод = Формат(Год(мСохраненныйДок.ДатаОкончания),"ЧГ=0");
	
	ПараметрыВыгрузки.Вставить("ОКПО", СокрЛП(ТабДокументТитульный.ОргКодОКПО));
	ПараметрыВыгрузки.Вставить("ОтчПериод", СокрЛП(ОтчПериод));
	ПараметрыВыгрузки.Вставить("РасчПериод", СокрЛП(РасчПериод));
	ПараметрыВыгрузки.Вставить("ОргНазв", СокрЛП(ТабДокументТитульный.ОргНазв));
	ПараметрыВыгрузки.Вставить("ОргДиректор", СокрЛП(СведенияОбОрганизации.ФИОРук));
	ПараметрыВыгрузки.Вставить("ОргДолжностьИсп", СокрЛП(ТабДокументПодписи.ОргДолжностьИсп));
	ПараметрыВыгрузки.Вставить("ОргИсполнитель", СокрЛП(ТабДокументПодписи.ОргИсполнитель));
	ПараметрыВыгрузки.Вставить("ОргТелефонИсп", СокрЛП(ТабДокументПодписи.ОргТелефонИсп));
	ПараметрыВыгрузки.Вставить("ОргЭлектроннаяПочта", СокрЛП(ТабДокументПодписи.ОргАдресЭлектроннойПочты));
	
	// Преобразование выгружаемых атрибутов, в соответствии
	// с форматом выгрузки статотчетности.
	ДопАтрибуты.Свойство("idp", ПолученноеЗначение);
	ПараметрыВыгрузки.Вставить("КодПериодичности", Число(СокрЛП(ПолученноеЗначение)));
	ПараметрыВыгрузки.Вставить("Документ", мСохраненныйДок);
	
	РегламентированнаяОтчетность.АтрибутыВФорматеВыгрузки(ПараметрыВыгрузки);
	
	ПараметрыВыгрузки.Вставить("ИмяФайла", Строка(Новый УникальныйИдентификатор) + ".xml");
	
	ПараметрыВыгрузки.Вставить("ИмяКлючевогоУзлаСодержательнойЧасти", "row");
	
	ТабДокументРаздел3_5 = КонтекстФормы.мДанныеОтчета.ПолеТабличногоДокументаРаздел3_5;
	ТабДокументРаздел5   = КонтекстФормы.мДанныеОтчета.ПолеТабличногоДокументаРаздел5;
	
	КодПоказателя = "П000005008601_";
	НомКол = 1;
	Пока РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(ТабДокументРаздел3_5, КодПоказателя + Формат(НомКол, "ЧГ=")) Цикл
		КодПоОКАТО = СокрЛП(ТабДокументРаздел3_5[Лев(КодПоказателя, 11) + "04_" + Формат(НомКол, "ЧГ=")]);
		КодПоОКСМ  = СокрЛП(ТабДокументРаздел3_5[Лев(КодПоказателя, 11) + "05_" + Формат(НомКол, "ЧГ=")]);
		ПараметрыВыгрузки.Вставить("ПД" + Сред(КодПоказателя, 3) + Формат(НомКол, "ЧГ="),
			СокрЛП(?(ЗначениеЗаполнено(КодПоОКАТО), КодПоОКАТО, КодПоОКСМ)));
		НомКол = НомКол + 1;
	КонецЦикла;
	КодПоказателя = "П000005008701_";
	НомКол = 1;
	Пока РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(ТабДокументРаздел3_5, КодПоказателя + Формат(НомКол, "ЧГ=")) Цикл
		КодПоОКАТО = СокрЛП(ТабДокументРаздел3_5[Лев(КодПоказателя, 11) + "04_" + Формат(НомКол, "ЧГ=")]);
		КодПоОКСМ  = СокрЛП(ТабДокументРаздел3_5[Лев(КодПоказателя, 11) + "05_" + Формат(НомКол, "ЧГ=")]);
		ПараметрыВыгрузки.Вставить("ПД" + Сред(КодПоказателя, 3) + Формат(НомКол, "ЧГ="),
			СокрЛП(?(ЗначениеЗаполнено(КодПоОКАТО), КодПоОКАТО, КодПоОКСМ)));
		НомКол = НомКол + 1;
	КонецЦикла;
	КодПоказателя = "П000005008801_";
	НомКол = 1;
	Пока РегламентированнаяОтчетностьКлиентСервер.СвойствоОпределено(ТабДокументРаздел5, КодПоказателя + Формат(НомКол, "ЧГ=")) Цикл
		КодПоОКАТО = СокрЛП(ТабДокументРаздел5[Лев(КодПоказателя, 11) + "04_" + Формат(НомКол, "ЧГ=")]);
		КодПоОКСМ  = СокрЛП(ТабДокументРаздел5[Лев(КодПоказателя, 11) + "05_" + Формат(НомКол, "ЧГ=")]);
		ПараметрыВыгрузки.Вставить("ПД" + Сред(КодПоказателя, 3) + Формат(НомКол, "ЧГ="),
			СокрЛП(?(ЗначениеЗаполнено(КодПоОКАТО), КодПоОКАТО, КодПоОКСМ)));
		НомКол = НомКол + 1;
	КонецЦикла;
	
	Возврат ПараметрыВыгрузки;
	
КонецФункции

Процедура ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки) Экспорт 
	
	РегламентированнаяОтчетность.ОбработатьУсловныеЭлементы(КонтекстФормы, ПараметрыВыгрузки, ДеревоВыгрузки);
	ДеревоВыгрузки.Строки[0].Строки[8].Строки[4].Раздел = "ПолеТабличногоДокументаРаздел5";
	РегламентированнаяОтчетность.ОбработатьУсловныеЭлементы(КонтекстФормы, ПараметрыВыгрузки, ДеревоВыгрузки);
	УниверсальныйОтчетСтатистики.ЗаполнитьДаннымиУзел(ПараметрыВыгрузки, ДеревоВыгрузки); // заполняем дерево данными
	РегламентированнаяОтчетность.ОтсечьНезаполненныеНеобязательныеУзлыСтатистики(ДеревоВыгрузки);
	
КонецПроцедуры

Функция ТекстВыгрузкиОтчетаСтатистики(мСохраненныйДок, ВыбраннаяФорма) Экспорт 
	ТекстВыгрузки = "";
	Если ВыбраннаяФорма = "ФормаОтчета2017Кв1" Тогда 
		КонтекстФормы = УниверсальныйОтчетСтатистики.СформироватьКонтекстФормыДляПоказателей(мСохраненныйДок);
		ПараметрыВыгрузки = СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, "АтрибВыгрузкиXML2017Кв1");
		ДеревоВыгрузки = РегламентированнаяОтчетность.ПолучитьДеревоВыгрузки(КонтекстФормы, "СхемаВыгрузкиXML2017Кв1");
		ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки);
		ТекстВыгрузки = РегламентированнаяОтчетность.ВыгрузитьДеревоВXML(ДеревоВыгрузки, ПараметрыВыгрузки);
	ИначеЕсли ВыбраннаяФорма = "ФормаОтчета2019Кв1" Тогда 
		КонтекстФормы = УниверсальныйОтчетСтатистики.СформироватьКонтекстФормыДляПоказателей(мСохраненныйДок);
		ПараметрыВыгрузки = СформироватьСтруктуруПараметров(КонтекстФормы, мСохраненныйДок, "АтрибВыгрузкиXML2019Кв1");
		ДеревоВыгрузки = РегламентированнаяОтчетность.ПолучитьДеревоВыгрузки(КонтекстФормы, "СхемаВыгрузкиXML2019Кв1");
		ЗаполнитьДанными(КонтекстФормы, ДеревоВыгрузки, ПараметрыВыгрузки);
		ТекстВыгрузки = РегламентированнаяОтчетность.ВыгрузитьДеревоВXML(ДеревоВыгрузки, ПараметрыВыгрузки);
	КонецЕсли;
	
	Возврат ТекстВыгрузки;
КонецФункции

#КонецОбласти
#КонецЕсли

#КонецЕсли