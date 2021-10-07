﻿#Область ПрограммныйИнтерфейс

// Вызывается при выполнении команды "ВозобновитьПроверку" из форм прикладных документов
//   в конфигурации - потребителе библиотеки ГосИС.
// 
// Параметры:
// 	 * Форма - ФормаКлиентскогоПриложения - форма прикладного документа, в который встраивается функциональность библиотеки ГосИС
//
Процедура ВозобновитьПроверку(Форма, ВидМаркируемойПродукции) Экспорт
	
	ПараметрыОткрытияФормыПроверки = ПараметрыОткрытияФормыПроверкиИПодбора(Форма, ВидМаркируемойПродукции);
	
	ТребуетсяВопрос = Ложь;
	
	Если Форма.Модифицированность Тогда
		
		Если НЕ ПустаяСтрока(ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект)
			И ПараметрыОткрытияФормыПроверки.ПроверятьМодифицированность Тогда
	
			Объект = Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект];
			
			ТребуетсяВопрос  = Истина;
			ПровестиЗаписать = ?(Объект.Проведен, НСтр("ru = 'Провести'"), НСтр("ru = 'Записать'"));
			ТекстВопроса     = СтрШаблон(НСтр("ru = 'Документ был изменен. %1?'"), ПровестиЗаписать);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТребуетсяВопрос Тогда
		
		ПараметрыВопроса = Новый Структура();
		ПараметрыВопроса.Вставить("Форма", Форма);
		ПараметрыВопроса.Вставить("ПараметрыОткрытияФормыПроверки", ПараметрыОткрытияФормыПроверки);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВозобновитьПроверкуИПодборПриОтветеНаВопрос",
			ЭтотОбъект, ПараметрыВопроса);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ВозобновитьПроверкуОткрытьФормуПроверкиИПодбораМаркируемойПродукции(Форма, ПараметрыОткрытияФормыПроверки);
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает форму проверки и подбора маркируемой продукции
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Источник события
// 	ВидМаркируемойПродукции - ПеречислениеСсылка.ВидыПродукцииИС - Вид продукции.
Процедура ОткрытьФормуПроверкиИПодбора(Форма, ВидМаркируемойПродукции) Экспорт
	
	Отказ           = Ложь;
	ТребуетсяВопрос = Ложь;
	
	ПараметрыОткрытияФормыПроверки = ПараметрыОткрытияФормыПроверкиИПодбора(Форма, ВидМаркируемойПродукции);
	
	Если НЕ ПустаяСтрока(ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект) Тогда
		Объект = Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект];

		Если ПроверкаИПодборПродукцииИСМПКлиентСервер.ЭтоДокументПриобретения(Форма)
			И ПараметрыОткрытияФормыПроверки.ПроверкаЭлектронногоДокумента Тогда
			Отказ = НЕ Форма.ПроверитьЗаполнение();
		КонецЕсли;
		
		Если Отказ Тогда
		ИначеЕсли НЕ ПараметрыОткрытияФормыПроверки.ПроверятьМодифицированность Тогда
		ИначеЕсли Объект.Ссылка.Пустая() Тогда
			ТребуетсяВопрос = Истина;
			ТекстВопроса    = НСтр("ru = 'Сканирование маркируемой продукции возможно только в записанном документе. Записать?'");
		ИначеЕсли Форма.Модифицированность Тогда
			ТребуетсяВопрос  = Истина;
			ПровестиЗаписать = ?(Объект.Проведен, НСтр("ru = 'Провести'"), НСтр("ru = 'Записать'"));
			ТекстВопроса     = СтрШаблон(НСтр("ru = 'Документ был изменен. %1?'"), ПровестиЗаписать);
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		
		Возврат;
	
	ИначеЕсли ТребуетсяВопрос Тогда
		
		ПараметрыВопроса = Новый Структура();
		ПараметрыВопроса.Вставить("Форма", Форма);
		ПараметрыВопроса.Вставить("ПараметрыОткрытияФормыПроверки", ПараметрыОткрытияФормыПроверки);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуПроверкиИПодбораПриОтветеНаВопрос",
			ЭтотОбъект, ПараметрыВопроса);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		ОткрытьФормуПроверкиИПодбораМаркируемойПродукции(Форма, ПараметрыОткрытияФормыПроверки);
		
	КонецЕсли;
	
КонецПроцедуры

// Предназначена для открытия формы проверки и подбора маркируемой продукции
// 
// Параметры:
//   * Форма - ФормаКлиентскогоПриложения - форма прикладного документа или общая форма, в который встраивается функциональность библиотеки ГосИС:
//   * ПараметрыОткрытияФормыПроверки - Структура - (См. ПараметрыОткрытияФормыПроверкиИПодбора)
//                                    - ПеречислениеСсылка.ВидыПродукцииИС - для получения параметров открытия из формы
//
Процедура ОткрытьФормуПроверкиИПодбораМаркируемойПродукции(Форма, Знач ПараметрыОткрытияФормыПроверки) Экспорт

	ОчиститьСообщения();
	
	Если ТипЗнч(ПараметрыОткрытияФормыПроверки) = Тип("ПеречислениеСсылка.ВидыПродукцииИС") Тогда
		ПараметрыОткрытияФормыПроверки = Форма.ПараметрыИнтеграцииГосИС.Получить(ПараметрыОткрытияФормыПроверки);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РедактированиеФормыНедоступно",        ПараметрыОткрытияФормыПроверки.РедактированиеФормыНедоступно);
	ПараметрыФормы.Вставить("ПроверятьНеобходимостьПеремаркировки", ПараметрыОткрытияФормыПроверки.ПроверятьНеобходимостьПеремаркировки);
	ПараметрыФормы.Вставить("РасчитыватьХешСуммуУпаковок",          ПараметрыОткрытияФормыПроверки.РасчитыватьХешСуммуУпаковок);
	ПараметрыФормы.Вставить("АдресПроверяемыхДанных",               ПараметрыОткрытияФормыПроверки.АдресПроверяемыхДанных);
	ПараметрыФормы.Вставить("ДоступнаПечатьЭтикеток",               ПараметрыОткрытияФормыПроверки.ДоступнаПечатьЭтикеток);
	ПараметрыФормы.Вставить("ДопустимыйСпособВводаВОборот",         ПараметрыОткрытияФормыПроверки.ДопустимыйСпособВводаВОборот);
	ПараметрыФормы.Вставить("ДанныеВыбораПоМаркируемойПродукции",   ПараметрыОткрытияФормыПроверки.ДанныеВыбораПоМаркируемойПродукции);
	ПараметрыФормы.Вставить("СохраненВыборПоМаркируемойПродукции",  ПараметрыОткрытияФормыПроверки.СохраненВыборПоМаркируемойПродукции);
	ПараметрыФормы.Вставить("ПроверкаЭлектронногоДокумента",        ПараметрыОткрытияФормыПроверки.ПроверкаЭлектронногоДокумента);
	ПараметрыФормы.Вставить("ДоступноСозданиеНовыхУпаковок",        ПараметрыОткрытияФормыПроверки.ДоступноСозданиеНовыхУпаковок);
	
	Если ПустаяСтрока(ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект) Тогда
		
		ПараметрыФормы.Вставить("Организация",             Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаОрганизация]);
		ПараметрыФормы.Вставить("ПроверкаНеПоДокументу",   Истина);
		ПараметрыФормы.Вставить("НачальныйСтатусПроверки", ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии"));
		ПараметрыФормы.Вставить("РежимПодбораСуществующихУпаковок", Истина);
		
		Если ЗначениеЗаполнено(ПараметрыОткрытияФормыПроверки.ИмяРеквизитаСклад) Тогда
			ПараметрыФормы.Вставить("Склад", Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаСклад]);
		КонецЕсли;
	
	Иначе
		
		Объект = Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект];
		
		ПараметрыФормы.Вставить("ПроверяемыйДокумент", Объект.Ссылка);
		ПараметрыФормы.Вставить("Организация",         Объект[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаОрганизация]);
		
		Если ЗначениеЗаполнено(ПараметрыОткрытияФормыПроверки.ИмяРеквизитаСклад) Тогда
			ПараметрыФормы.Вставить("Склад", Объект[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаСклад]);
		КонецЕсли;
		
		Если ПроверкаИПодборПродукцииИСМПКлиентСервер.ЭтоЧекККМ(Форма)
		 Или ПроверкаИПодборПродукцииИСМПКлиентСервер.ЭтоЧекККМВозврат(Форма) Тогда
			ПараметрыФормы.Вставить("ПроверкаНеПоДокументу",   Истина);
			ПараметрыФормы.Вставить("НачальныйСтатусПроверки", ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.ВНаличии"));
			ПараметрыФормы.Вставить("КонтролироватьСканируемуюПродукциюПоДокументуОснованию", Ложь);
		Иначе
			ПараметрыФормы.Вставить("ПроверкаНеПоДокументу",   Ложь);
			ПараметрыФормы.Вставить("НачальныйСтатусПроверки", ПредопределенноеЗначение("Перечисление.СтатусыПроверкиНаличияПродукцииИС.НеПроверялась"));
			
			Если НЕ ПустаяСтрока(ПараметрыОткрытияФормыПроверки.ИмяРеквизитаДокументОснование) Тогда
				ПараметрыФормы.Вставить("КонтролироватьСканируемуюПродукциюПоДокументуОснованию",
					ЗначениеЗаполнено(Объект[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаДокументОснование]));
			КонецЕсли;
		КонецЕсли;
		
		Если ПроверкаИПодборПродукцииИСМПКлиентСервер.ЭтоДокументПриобретения(Форма) Тогда
			ПараметрыФормы.Вставить("ПриЗавершенииСохранятьРезультатыПроверки", Истина);
			ПараметрыФормы.Вставить("РежимПодбораСуществующихУпаковок",         Ложь);
		Иначе
			ПараметрыФормы.Вставить("ПриЗавершенииСохранятьРезультатыПроверки", Ложь);
			ПараметрыФормы.Вставить("РежимПодбораСуществующихУпаковок",         Истина);
		КонецЕсли;
		
		Если НЕ ПараметрыФормы.РежимПодбораСуществующихУпаковок Тогда
			ПараметрыФормы.Вставить("Контрагент", Объект[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаКонтрагент]);
		КонецЕсли;
		
	КонецЕсли;
	
	Отказ = Ложь;
	
	ПроверкаИПодборПродукцииИСМПКлиентПереопределяемый.ПередОткрытиемФормыПроверкиПодбора(
		Форма, ПараметрыОткрытияФормыПроверки, ПараметрыФормы, Отказ);
	
	Если Отказ Тогда
		Возврат;
	Иначе
		Если ПараметрыОткрытияФормыПроверки.ВидМаркируемойПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табачная") Тогда
			ИмяФормыПроверкиИПодбора = "Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ПроверкаИПодбор";
		ИначеЕсли ПараметрыОткрытияФормыПроверки.ВидМаркируемойПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Обувная") Тогда
			ИмяФормыПроверкиИПодбора = "Обработка.ПроверкаИПодборПродукцииИСМП.Форма.ПроверкаИПодбор";
		Иначе
			Возврат;
		КонецЕсли;

		ОткрытьФорму(ИмяФормыПроверкиИПодбора,
			ПараметрыФормы,
			Форма,
			Форма.УникальныйИдентификатор, , ,
			ПараметрыОткрытияФормыПроверки.ОписаниеОповещенияПриЗакрытии,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

// Предназначена для открытия формы проверки и подбора маркируемой продукции в режиме возобновления проверки
// 
// Параметры:
// 	 * Форма - ФормаКлиентскогоПриложения - форма прикладного документа или общая форма, в который встраивается функциональность библиотеки ГосИС:
// 	 * ПараметрыОткрытияФормыПроверки - Структура - (См. ПараметрыОткрытияФормыПроверкиИПодбора)
//
Процедура ВозобновитьПроверкуОткрытьФормуПроверкиИПодбораМаркируемойПродукции(Форма, ПараметрыОткрытияФормыПроверки) Экспорт
	
	Если ПроверкаИПодборПродукцииИСМПВызовСервера.ВозобновитьПроверкуПоДокументу(
		Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект].Ссылка,
		ПараметрыОткрытияФормыПроверки.ВидМаркируемойПродукции) Тогда
		
		Если ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Форма, "Документ.МаркировкаТоваровИСМП")
		 Или ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Форма, "Документ.ВыводИзОборотаИСМП")
		 Или ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Форма, "Документ.СписаниеКодовМаркировкиИСМП") Тогда
			Форма.СтатусПроверкиИПодбора = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиИПодбораИС.Выполняется");
			ОпределитьДоступностьФормыПроверкиИподбора(Форма, ПараметрыОткрытияФормыПроверки);
		КонецЕсли;
		
		ОткрытьФормуПроверкиИПодбораМаркируемойПродукции(Форма, ПараметрыОткрытияФормыПроверки);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область Серии

// Готовит данные для генерации серий
// 
// Параметры:
// 	ПодобраннаяМаркируемаяПродукция - ТаблицаЗначений - таблица подобранной маркируемой продукции.
// Возвращаемое значение:
// 	Массив - содержит структуры (См. ИнтеграцияИСМПУТКлиентСервер.СтруктураДанныхДляГенерацииСерии)
//
Функция ДанныеДляГенерацииСерийПоПодобраннойПродукции(ТаблицаПродукции, ВидМаркируемойПродукции) Экспорт
	
	ДанныеДляГенерации = Новый Массив;
	
	СтатусыСерийСерияНеУказана = ПроверкаИПодборПродукцииИСМПКлиентСервер.СтатусыСерийСерияНеУказана();
	
	Для Каждого СтрокаПродукции Из ТаблицаПродукции Цикл
		
		Если СтатусыСерийСерияНеУказана.Найти(СтрокаПродукции.СтатусУказанияСерий) <> Неопределено Тогда
			
			ДанныеПоСтроке = СтруктураДанныхДляГенерацииСерии(ВидМаркируемойПродукции);
			ЗаполнитьЗначенияСвойств(ДанныеПоСтроке, СтрокаПродукции);
			
			ДанныеСерииСуществуют = Ложь;
			
			Для Каждого ДанныеСерии Из ДанныеДляГенерации Цикл
				ДанныеСерииСовпадают = Истина;
				
				Для Каждого КлючИЗначение Из ДанныеПоСтроке Цикл
					ДанныеСерииСовпадают = ДанныеСерииСовпадают И (ДанныеСерии[КлючИЗначение.Ключ] = КлючИЗначение.Значение);
					Если НЕ ДанныеСерииСовпадают Тогда
						Прервать;
					КонецЕсли;
				КонецЦикла;
				
				Если ДанныеСерииСовпадают Тогда
					ДанныеСерииСуществуют = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если НЕ ДанныеСерииСуществуют Тогда
				ДанныеДляГенерации.Добавить(ДанныеПоСтроке);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ДанныеДляГенерации;

КонецФункции

Процедура ЗаполнитьСерииВПодобраннойМаркируемойПродукции(Форма, ДанныеСерий, ТаблицаПродукции) Экспорт
	
	Для Каждого ДанныеСерии Из ДанныеСерий Цикл
		Для Каждого СтрокаПродукции Из ТаблицаПродукции Цикл
			Если ЗначениеЗаполнено(СтрокаПродукции.Серия) Тогда
				Продолжить;
			КонецЕсли;
			
			КлючевыеЗначенияСовпадают = Истина;
			
			Для Каждого КлючИЗначение Из ДанныеСерии Цикл
				Если КлючИЗначение.Ключ = "Серия" Тогда
					Продолжить;
				ИначеЕсли НЕ ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(СтрокаПродукции, КлючИЗначение.Ключ) Тогда
					Продолжить;
				КонецЕсли;
				
				КлючевыеЗначенияСовпадают = КлючевыеЗначенияСовпадают
					И (СтрокаПродукции[КлючИЗначение.Ключ] = КлючИЗначение.Значение);
				
				Если НЕ КлючевыеЗначенияСовпадают Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если КлючевыеЗначенияСовпадают Тогда
				Если ДанныеСерии.ЕстьОшибка Тогда
					
					ТекстСообщения = СтрШаблон(
						НСтр("ru = 'В строке %1 произошла ошибка при создании серии по причине %2'"),
						СтрокаПродукции.НомерСтроки,
						ДанныеСерии.ТекстОшибки);
					
					ИмяПоля = Форма.ПараметрыУказанияСерий.ИмяТЧСерии + "["
						+ ТаблицаПродукции.Индекс(СтрокаПродукции)
						+ "].Серия";
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, ИмяПоля);
					
				Иначе
					
					СтрокаПродукции.Серия = ДанныеСерии.Серия;
					
					СобытияФормИСМПКлиентПереопределяемый.ПриИзмененииСерии(Форма,
						СтрокаПродукции, Неопределено, Форма.ПараметрыУказанияСерий);
						
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Добавляет специфичные параметры указания серий для товаров, указанных в форме.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма с товарами, для которой необходимо определить параметры указания серий.
//	ПараметрыУказанияСерий - Структура - дополняемые параметры указания серий.
//
Процедура ДополнитьПараметрыУказанияСерий(Форма, ПараметрыУказанияСерий) Экспорт
	
	ПроверкаИПодборПродукцииИСМПКлиентПереопределяемый.ДополнитьПараметрыУказанияСерий(Форма, ПараметрыУказанияСерий);
	
КонецПроцедуры

// Подготовливает структуру, массив которых в дальнейшем будет передан в процедуру генерации серий.
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Описание:
// * Номенклатура - ОпределяемыйТип.Номенклатура - Номенклатура, для которой будет генерироваться серия.
// * Серия        - ОпределяемыйТип.СерияНоменклатуры   - В данное значение будет записана сгенерированная серия.
// * ЕстьОшибка   - Булево - Будет установлено в Истина, если по каким то причинам серия сгенерирована не будет.
// * ТекстОшибки  - Строка - причина, по которой серия не генерировалась.
// * МРЦ          - Число - только для табачной продукции, максимальная розничная цена.
//
Функция СтруктураДанныхДляГенерацииСерии(ВидМаркируемойПродукции) Экспорт
	
	СтруктураДанных = Новый Структура();
	
	ПроверкаИПодборПродукцииИСМПКлиентПереопределяемый.ПолучитьДанныеДляГенерацииСерии(СтруктураДанных, ВидМаркируемойПродукции);
	
	Возврат СтруктураДанных;
	
КонецФункции

#КонецОбласти

#Область РасчетХешСумм

// Пересчитывает хеш-суммы всех упаковок формы. На клиенте формируется структура для расчета, на сервере
// вычисляются хеш-суммы и проверяется необходимость перемаркировки.
//
// Параметры:
//	Форма - ФормаКлиентскогоПриложения - форма проверки и подбора маркируемой продкуции.
//
Процедура ПересчитатьХешСуммыВсехУпаковок(Форма) Экспорт

	Если НЕ Форма.РасчитыватьХешСуммуУпаковок Тогда
		Возврат;
	КонецЕсли;

	Если Форма.ДетализацияСтруктурыХранения = ПредопределенноеЗначение("Перечисление.ДетализацияСтруктурыХраненияПродукцииИСМП.ПотребительскиеУпаковки") Тогда
		Форма.КоличествоУпаковокКоторыеНеобходимоПеремаркировать = 0;
		ПроверкаИПодборПродукцииИСМПКлиентСервер.ОтобразитьИнформациюОНеобходимостиПеремаркировки(Форма);
		Возврат;
	КонецЕсли;
	
	ЗначенияСтрокДерева = Новый Массив();
	
	ПроверкаИПодборПродукцииИСКлиент.ЗаполнитьЗначенияСтрокДереваДляРасчетаХешСумм(ЗначенияСтрокДерева, Форма.ДеревоМаркированнойПродукции.ПолучитьЭлементы());

	ТаблицаПеремаркировки = ПроверкаИПодборПродукцииИСМПВызовСервера.ПересчитатьХешСуммыВсехУпаковок(ЗначенияСтрокДерева);
	
	ПроверкаИПодборПродукцииИСКлиент.ЗаполнитьХешСуммыВСтрокахДереваУпаковок(ЗначенияСтрокДерева, Форма.ДеревоМаркированнойПродукции);
	
	ПроверкаИПодборПродукцииИСМПКлиентСервер.ПроверитьНеобходимостьПеремаркировки(Форма, ТаблицаПеремаркировки, Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Предназначена для установки параметров открытия формы проверки и подбора маркируемой продукции
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма прикладного документа или общая форма, в который встраивается функциональность библиотеки ГосИС:
// Возвращаемое значение:
//  * ПараметрыОткрытия - Структура - значения, используемые для управления открытием формы проверки и подбора:
//  ** ИмяРеквизитаФормыОбъект              - Строка - имя реквизита формы документа, содержащего объект документа. Для открытия не из формы документа должен быть пустой строкой
//  ** ИмяРеквизитаОрганизация              - Строка - имя реквизита документа или реквизита формы, содержащего организацию
//  ** ИмяРеквизитаКонтрагент               - Строка - имя реквизита документа или реквизита формы, содержащего контрагента
//  ** ИмяРеквизитаСклад                    - Строка - имя реквизита документа или реквизита формы, содержащего склад
//  ** ИмяРеквизитаДокументОснование        - Строка - имя реквизита документа, содержащего его основание. Если основания нет, должен быть пустой строкой.
//  ** ПроверятьНеобходимостьПеремаркировки - Булево - признак необходимости контроля состава упаковок в форме проверки.
//  ** РасчитыватьХешСуммуУпаковок          - Булево - признак необходимости расчета хеш-сумм упаковок.
//  ** РедактированиеФормыНедоступно        - Булево - признак недоступности редактирования формы, из которой открывается форма проверки
//  ** АдресПроверяемыхДанных               - Строка - адрес данных для загрузки в форму проверки, если передача данных происходит не через ссылку на документ
//  ** ОписаниеОповещенияПриЗакрытии        - ОписаниеОповещения - описание процедуры, которая будет вызвана после закрытия формы проверки
//  ** ПроверятьМодифицированность          - Булево - признак необходимости записи документа перед открытием формы проверки
//  ** ВидМаркируемойПродукции              - ПеречислениеСсылка.ВидыПродукцииИС - вид маркируемой продукции, для проверки которого будет открыта форма
//  ** ПроверкаЭлектронногоДокумента        - Булево - признак режима проверки входящего электронного документа
//
Функция ПараметрыОткрытияФормыПроверкиИПодбора(Форма, ВидМаркируемойПродукции)
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("ИмяРеквизитаФормыОбъект",             "Объект");
	ПараметрыОткрытия.Вставить("ИмяРеквизитаОрганизация",             "Организация");
	ПараметрыОткрытия.Вставить("ИмяРеквизитаКонтрагент",              "Контрагент");
	ПараметрыОткрытия.Вставить("ИмяРеквизитаСклад",                   "Склад");
	ПараметрыОткрытия.Вставить("ИмяРеквизитаДокументОснование",       "ДокументОснование");
	ПараметрыОткрытия.Вставить("ПроверятьНеобходимостьПеремаркировки", Истина);
	ПараметрыОткрытия.Вставить("РасчитыватьХешСуммуУпаковок",          Истина);
	ПараметрыОткрытия.Вставить("РедактированиеФормыНедоступно",        Ложь);
	ПараметрыОткрытия.Вставить("АдресПроверяемыхДанных",               "");
	ПараметрыОткрытия.Вставить("ПроверятьМодифицированность",          Истина);
	ПараметрыОткрытия.Вставить("ПроверкаЭлектронногоДокумента",        Ложь);
	ПараметрыОткрытия.Вставить("ДоступнаПечатьЭтикеток",               Ложь);
	ПараметрыОткрытия.Вставить("ДопустимыйСпособВводаВОборот",         Неопределено);
	ПараметрыОткрытия.Вставить("ДанныеВыбораПоМаркируемойПродукции",   Неопределено);
	ПараметрыОткрытия.Вставить("СохраненВыборПоМаркируемойПродукции",  Неопределено);
	ПараметрыОткрытия.Вставить("ДоступноСозданиеНовыхУпаковок",        Ложь);
	
	ДопПараметрыЗакрытия = Новый Структура();
	ДопПараметрыЗакрытия.Вставить("ВидМаркируемойПродукции", ВидМаркируемойПродукции);
	ДопПараметрыЗакрытия.Вставить("Форма",                   Форма);
	
	ОповещениеПриЗакрытии = Новый ОписаниеОповещения("ПриЗакрытииФормыПроверкиИПодбора",
		ЭтотОбъект, ДопПараметрыЗакрытия);
		
	ПараметрыОткрытия.Вставить("ОписаниеОповещенияПриЗакрытии", ОповещениеПриЗакрытии);
	ПараметрыОткрытия.Вставить("ВидМаркируемойПродукции",       ВидМаркируемойПродукции);
	
	ПриУстановкеПараметровОткрытияФормыПроверкиИПодбора(Форма, ПараметрыОткрытия);
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

Процедура ПриУстановкеПараметровОткрытияФормыПроверкиИПодбора(Форма, ПараметрыОткрытия)
	
	Если ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Форма, "Документ.МаркировкаТоваровИСМП") Тогда
		ПараметрыОткрытия.ИмяРеквизитаКонтрагент               = "Контрагент";
		ПараметрыОткрытия.ИмяРеквизитаСклад                    = Неопределено;
		ПараметрыОткрытия.ДоступнаПечатьЭтикеток               = Истина;
		ПараметрыОткрытия.ПроверятьНеобходимостьПеремаркировки = Ложь;
		ПараметрыОткрытия.ДоступноСозданиеНовыхУпаковок        = Истина;
		ПараметрыОткрытия.ДопустимыйСпособВводаВОборот         =
			ШтрихкодированиеИСМПКлиентСервер.СпособВводаВОборотСУЗПоВидуОперации(Форма.Объект.Операция);
		ПараметрыОткрытия.ДанныеВыбораПоМаркируемойПродукции   = Форма.ДанныеВыбораПоМаркируемойПродукции;
		ПараметрыОткрытия.СохраненВыборПоМаркируемойПродукции  = Форма.СохраненВыборПоМаркируемойПродукции;
		ОпределитьДоступностьФормыПроверкиИподбора(Форма, ПараметрыОткрытия);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Форма, "Документ.ВыводИзОборотаИСМП") Тогда
		ПараметрыОткрытия.ИмяРеквизитаСклад = Неопределено;
		ОпределитьДоступностьФормыПроверкиИподбора(Форма, ПараметрыОткрытия);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Форма, "Документ.СписаниеКодовМаркировкиИСМП") Тогда
		ПараметрыОткрытия.ИмяРеквизитаСклад = Неопределено;
		ОпределитьДоступностьФормыПроверкиИподбора(Форма, ПараметрыОткрытия);
	ИначеЕсли ШтрихкодированиеИСКлиентСервер.ЭтоКонтекстОбъекта(Форма, "Документ.ПеремаркировкаТоваровИСМП") Тогда
		ПараметрыОткрытия.ИмяРеквизитаСклад = Неопределено;
	КонецЕсли;
	
	ПроверкаИПодборПродукцииИСМПКлиентПереопределяемый.ПриУстановкеПараметровОткрытияФормыПроверкиИПодбора(Форма, ПараметрыОткрытия);
	
КонецПроцедуры

Процедура ОпределитьДоступностьФормыПроверкиИподбора(Форма, ПараметрыОткрытия)
	
	Если Форма.РедактированиеФормыНеДоступно Тогда
		ПараметрыОткрытия.РедактированиеФормыНедоступно = Истина;
	ИначеЕсли Форма.СтатусПроверкиИПодбора = ПредопределенноеЗначение("Перечисление.СтатусыПроверкиИПодбораИС.Завершено") Тогда
		ПараметрыОткрытия.РедактированиеФормыНедоступно = Истина;
	Иначе
		ПараметрыОткрытия.РедактированиеФормыНедоступно = НЕ Форма.ПравоИзменения;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуПроверкиИПодбораПриОтветеНаВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПараметрыОткрытияФормыПроверки = ДополнительныеПараметры.ПараметрыОткрытияФормыПроверки;
	
	Объект = Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект];
	
	СтандартнаяОбработка = Ложь;
	ДействиеПослеЗаписи = Новый ОписаниеОповещения("ОткрытьФормуПроверкиИПодбораПослеЗаписиОбъекта", ЭтотОбъект, ДополнительныеПараметры);
	ИнтеграцияИСКлиентПереопределяемый.ВыполнитьЗаписьОбъектаВФорме(Форма, Объект, ДействиеПослеЗаписи, СтандартнаяОбработка);
	
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	РезультатЗаписи = Ложь;
	Если Объект.Проведен Тогда
		Если Форма.ПроверитьЗаполнение() Тогда
			РезультатЗаписи = Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		КонецЕсли;
	Иначе
		РезультатЗаписи = Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДействиеПослеЗаписи, РезультатЗаписи);
	
КонецПроцедуры

Процедура ОткрытьФормуПроверкиИПодбораПослеЗаписиОбъекта(РезультатЗаписи, ДополнительныеПараметры) Экспорт
	
	Если Не РезультатЗаписи Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПараметрыОткрытияФормыПроверки = ДополнительныеПараметры.ПараметрыОткрытияФормыПроверки;
	
	ОткрытьФормуПроверкиИПодбораМаркируемойПродукции(Форма, ПараметрыОткрытияФормыПроверки);
	
КонецПроцедуры

Процедура ВозобновитьПроверкуИПодборПриОтветеНаВопрос(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ПараметрыОткрытияФормыПроверки = ДополнительныеПараметры.ПараметрыОткрытияФормыПроверки;
	
	Объект = Форма[ПараметрыОткрытияФормыПроверки.ИмяРеквизитаФормыОбъект];
		
	ЗаписаноУспешно = Ложь;
	
	Если Объект.Проведен Тогда
		Если Форма.ПроверитьЗаполнение() Тогда
			ЗаписаноУспешно = Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		КонецЕсли;
	Иначе
		ЗаписаноУспешно = Форма.Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Запись));
	КонецЕсли;

	Если ЗаписаноУспешно Тогда
		ВозобновитьПроверкуОткрытьФормуПроверкиИПодбораМаркируемойПродукции(Форма, ПараметрыОткрытияФормыПроверки);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗакрытииФормыПроверкиИПодбора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПроверкаИПодборПродукцииИСМПКлиентПереопределяемый.ПриЗакрытииФормыПроверкиИПодбора(РезультатЗакрытия, ДополнительныеПараметры);
	
КонецПроцедуры

Функция ЕстьРасхожденияПоРезультатамПроверкиИПодбора(ПодобраннаяМаркируемаяПродукция) Экспорт
	
	Для Каждого СтрокаПодобраннойПродукции Из ПодобраннаяМаркируемаяПродукция Цикл
		
		Если СтрокаПодобраннойПродукции.Количество <> СтрокаПодобраннойПродукции.КоличествоПодобрано Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	 
	Возврат Ложь;
	
КонецФункции

#Область ТипыШтрихкодов

Функция ДоступныеТипыШтрихкодовСтрокой() Экспорт
	
	ДоступныеТипы = Новый СписокЗначений();
	
	ДоступныеТипы.Добавить("SSCC");
	
	Возврат ДоступныеТипы;
	
КонецФункции

#КонецОбласти

#КонецОбласти