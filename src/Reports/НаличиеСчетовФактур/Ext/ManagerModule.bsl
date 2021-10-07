﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Формирует табличную часть отчета.
Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища)Экспорт 
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ПараметрыПоискаСчетовФактур = ПараметрыПоискаСчетовФактур(ПараметрыОтчета);
	Результат = УчетНДСПереопределяемый.ОпределитьНаличиеСчетовФактурПолученных(ПараметрыПоискаСчетовФактур);
	
	СформироватьНаличиеСчетовФактур(ПараметрыОтчета, ТабличныйДокумент, Результат);
	
	ПоместитьВоВременноеХранилище(ТабличныйДокумент, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура формирует табличный документ с отчетом по наличию счетов-фактур.
//
// Параметры:
//  ДокументРезультат - ТабличныйДокумент - отчет по наличию счетов-фактур.
//  ТаблицаРезультат - ТаблицаЗначений - содержит данные для построения отчета.
//
// Возвращаемое значение:
//  Нет.
//
Процедура СформироватьНаличиеСчетовФактур(ПараметрыОтчета, ДокументРезультат, ТаблицаРезультат)
	
	ДокументРезультат.Очистить();
	
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ДокументРезультат.ПолеСверху         = 10;
	ДокументРезультат.ПолеСнизу          = 10;
	ДокументРезультат.ПолеСлева          = 20;
	ДокументРезультат.ПолеСправа         = 20;
	
	ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_НаличиеСчетовФактур";
	
	// Получим макет и области макета.
	Макет = ПолучитьМакет("НаличиеСчетовФактур");
	
	СтрокаСчетФактураОбласть = Макет.Область("Строка|СчетФактура");
	СтрокаАвтоЦвет           = Макет.ПолучитьОбласть("Строка");

	Если НЕ ЗначениеЗаполнено(ПараметрыОтчета.НаличиеСчетаФактуры) Тогда
		СтрокаСчетФактураОбласть.ЦветТекста = Новый Цвет(255,0,0);
	КонецЕсли;
	
	ЗаголовокОтчета    = Макет.ПолучитьОбласть("Заголовок");
	Шапка              = Макет.ПолучитьОбласть("Шапка");
	СтрокаЦветКрасный  = Макет.ПолучитьОбласть("Строка");
	Подвал             = Макет.ПолучитьОбласть("Подвал");
	
	// Выведем заголовок отчета.
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(
		ПараметрыОтчета.Организация, 
		?(НЕ ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода), ТекущаяДатаСеанса(), ПараметрыОтчета.КонецПериода));
	
	ЗаголовокОтчета.Параметры.НаименованиеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм");;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) И НЕ ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		ЗаголовокОтчета.Параметры.ОписаниеПериода = "С " + Формат(ПараметрыОтчета.НачалоПериода, "ДЛФ=DD");
	ИначеЕсли НЕ ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) И ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		ЗаголовокОтчета.Параметры.ОписаниеПериода = "По " + Формат(ПараметрыОтчета.КонецПериода, "ДЛФ=DD");
	ИначеЕсли ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) И ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		ЗаголовокОтчета.Параметры.ОписаниеПериода = ПредставлениеПериода(НачалоДня(ПараметрыОтчета.НачалоПериода), КонецДня(ПараметрыОтчета.КонецПериода), "ФП=Истина");
	Иначе
		ЗаголовокОтчета.Параметры.ОписаниеПериода = НСтр("ru = '(Без ограничения периода)'");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыОтчета.НаличиеСчетаФактуры) Тогда // Показывать документы = Все.
	
		ЗаголовокОтчета.Параметры.УстановленныйОтбор = "Отбор: Показывать документы Равно ""Все""";
		Шапка.Параметры.СтрокаДокументОснование      = "Документ";
		Шапка.Параметры.СтрокаСчетФактура            = "Счет-фактура/Ошибка";
	
	ИначеЕсли НЕ ПараметрыОтчета.НаличиеСчетаФактуры Тогда // Показывать документы = С ошибками.
	
		ЗаголовокОтчета.Параметры.УстановленныйОтбор = "Отбор: Показывать документы Равно ""С ошибками""";
		Шапка.Параметры.СтрокаДокументОснование      = "Документ";
		Шапка.Параметры.СтрокаСчетФактура            = "Ошибка";
	
	Иначе // Показывать документы = Без ошибок
	
		ЗаголовокОтчета.Параметры.УстановленныйОтбор = "Отбор: Показывать документы Равно ""Без ошибок""";
		Шапка.Параметры.СтрокаДокументОснование      = "Документ-основание";
		Шапка.Параметры.СтрокаСчетФактура            = "Счет-фактура";
	
	КонецЕсли;

	ДокументРезультат.Вывести(ЗаголовокОтчета);
	
	// Выведем шапку таблицы.
	ДокументРезультат.Вывести(Шапка);
	
	// Выведем строки таблицы.
	Для Каждого СтрокаРезультат Из ТаблицаРезультат Цикл

		Если СтрокаРезультат.СчетФактура = Неопределено Тогда
			Строка = СтрокаЦветКрасный;
		ИначеЕсли НЕ СтрокаРезультат.СчетФактураПроведен Тогда
			Строка = СтрокаЦветКрасный;
		Иначе
			Строка = СтрокаАвтоЦвет;
		КонецЕсли;
		
		Строка.Параметры.Заполнить(СтрокаРезультат);
		
		Если СтрокаРезультат.ЭтоСчетФактураПолученный Тогда
			ТекстСчетФактура = НСтр("ru='Счет-фактура полученный %1 от %2'");
			ТекстСчетФактура = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСчетФактура, 
				СтрокаРезультат.СчетФактураНомер,Формат(СтрокаРезультат.СчетФактураДата,"ДЛФ=Д"));
			Строка.Параметры.СчетФактура = ТекстСчетФактура;
		КонецЕсли;

		Если СтрокаРезультат.СчетФактура = Неопределено Тогда
			Строка.Параметры.СчетФактура = НСтр("ru='Нет счета-фактуры'");
		ИначеЕсли НЕ СтрокаРезультат.СчетФактураПроведен Тогда
			Строка.Параметры.СчетФактура = НСтр("ru='Счет-фактура не проведен'");
		КонецЕсли;
		
		Строка.Параметры.СчетФактураРасшифровка = СтрокаРезультат.СчетФактура;
		
		Строка.Параметры.НомерСтроки = ТаблицаРезультат.Индекс(СтрокаРезультат) + 1;
		
		СтрокаСПодвалом = Новый Массив;
		СтрокаСПодвалом.Добавить(Строка);
		СтрокаСПодвалом.Добавить(Подвал);
		
		Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ДокументРезультат, СтрокаСПодвалом) Тогда
			
			ДокументРезультат.Вывести(Подвал);
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
			ДокументРезультат.Вывести(Шапка);
			
		КонецЕсли;
		
		ДокументРезультат.Вывести(Строка);
		
	КонецЦикла;
	
	ДокументРезультат.Вывести(Подвал);
	
	ДокументРезультат.ТолькоПросмотр = Истина;
	
КонецПроцедуры

Функция ПараметрыПоискаСчетовФактур(ПараметрыОтчета)
	
	Результат = УчетНДС.НовыйПараметрыПоискаСчетовФактур();
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.НачалоПериода) Тогда
		Результат.НачалоПериода = ПараметрыОтчета.НачалоПериода;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.КонецПериода) Тогда
		Результат.КонецПериода =  КонецДня(ПараметрыОтчета.КонецПериода);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.Организация) Тогда
		Результат.Организация = ПараметрыОтчета.Организация;
	КонецЕсли;
	
	Результат.НаличиеСчетаФактуры = ПараметрыОтчета.НаличиеСчетаФактуры;
	Результат.ИскатьПоОборотам    = Истина;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли