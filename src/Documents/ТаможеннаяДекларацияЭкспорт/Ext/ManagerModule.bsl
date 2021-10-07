﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаРеквизитыДокумента(НомераТаблиц);
	Результат    = Запрос.ВыполнитьПакет();
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	Реквизиты = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(ТаблицаРеквизиты[0]);
	Если НЕ УчетнаяПолитика.Существует(Реквизиты.Организация, Реквизиты.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;
	
	НомераТаблиц = Новый Структура;
	
	Запрос.Текст = ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)
		+ ТекстЗапросаСведенияТаможенныхДекларацийЭкспорт(НомераТаблиц);
	
	Результат = Запрос.ВыполнитьПакет();
	
	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросаРеквизитыДокумента(НомераТаблиц)

	НомераТаблиц.Вставить("ВременнаяТаблицаРеквизиты", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация,
	|	Реквизиты.НомерВходящегоДокумента,
	|	Реквизиты.КодОперации,
	|	Реквизиты.Примечание
	|ПОМЕСТИТЬ Реквизиты
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Период,
	|	Реквизиты.Организация
	|ИЗ
	|	Реквизиты КАК Реквизиты";

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаВременныеТаблицыДокумента(НомераТаблиц)
	
	НомераТаблиц.Вставить("ВременнаяТаблицаДокументыОснования", НомераТаблиц.Количество());
	НомераТаблиц.Вставить("ВременнаяТаблицаСопроводительныеДокументы", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаможеннаяДекларацияЭкспортДокументыОснования.ДокументОснование
	|ПОМЕСТИТЬ ДокументыОснования
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт.ДокументыОснования КАК ТаможеннаяДекларацияЭкспортДокументыОснования
	|ГДЕ
	|	ТаможеннаяДекларацияЭкспортДокументыОснования.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаможеннаяДекларацияЭкспортСопроводительныеДокументы.КодТС,
	|	ТаможеннаяДекларацияЭкспортСопроводительныеДокументы.ВидДокумента,
	|	ТаможеннаяДекларацияЭкспортСопроводительныеДокументы.НомерТСД,
	|	ТаможеннаяДекларацияЭкспортСопроводительныеДокументы.ДатаТСД
	|ПОМЕСТИТЬ СопроводительныеДокументы
	|ИЗ
	|	Документ.ТаможеннаяДекларацияЭкспорт.СопроводительныеДокументы КАК ТаможеннаяДекларацияЭкспортСопроводительныеДокументы
	|ГДЕ
	|	ТаможеннаяДекларацияЭкспортСопроводительныеДокументы.Ссылка = &Ссылка";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ТекстЗапросаСведенияТаможенныхДекларацийЭкспорт(НомераТаблиц)
	
	НомераТаблиц.Вставить("СведенияТаможенныхДекларацийЭкспорт", НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДокументыОснования.ДокументОснование КАК ДокументОтгрузки,
	|	Реквизиты.НомерВходящегоДокумента КАК НомерТаможеннойДекларации,
	|	Реквизиты.КодОперации КАК КодОперации,
	|	СопроводительныеДокументы.КодТС,
	|	СопроводительныеДокументы.ВидДокумента,
	|	СопроводительныеДокументы.НомерТСД,
	|	СопроводительныеДокументы.ДатаТСД,
	|	Реквизиты.Примечание
	|ИЗ
	|	ДокументыОснования КАК ДокументыОснования
	|		ЛЕВОЕ СОЕДИНЕНИЕ Реквизиты КАК Реквизиты
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопроводительныеДокументы КАК СопроводительныеДокументы
	|		ПО (ИСТИНА)";
	
	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();
	
КонецФункции

Функция ПредставлениеДокумента(ДокументСсылка) Экспорт
	
	ТекстОсновноеПредставление = НСтр("ru = 'Таможенная декларация (экспорт)'");
	
	Если ЗначениеЗаполнено(ДокументСсылка) И ОбщегоНазначения.СсылкаСуществует(ДокументСсылка) Тогда
		
		РеквизитыДекларации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка,
			"НомерВходящегоДокумента, Дата");
		
		ТекстПредставления = ТекстОсновноеПредставление + " " + НСтр("ru='%1 от %2'");
		ТекстПредставления = СтрШаблон(ТекстПредставления,
			РеквизитыДекларации.НомерВходящегоДокумента,
			Формат(РеквизитыДекларации.Дата, "ДЛФ=D"));
		
	Иначе
		ТекстПредставления = СтрШаблон(НСтр("ru='%1 (создание)'"), ТекстОсновноеПредставление);
		
	КонецЕсли;
	
	Возврат ТекстПредставления;
	
КонецФункции

#КонецОбласти

#КонецЕсли