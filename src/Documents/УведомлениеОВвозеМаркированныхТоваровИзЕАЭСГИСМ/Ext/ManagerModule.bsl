﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Панель1СМаркировка

// Возвращает текст запроса для получения общего количества документов в работе
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОВвозеИзЕАЭС() Экспорт
	
	ТекстЗапросаУведомленияОВвозеИзЕАЭС = "";
	ИнтеграцияГИСМПереопределяемый.ТекстЗапросаУведомленияОВвозеИзЕАЭС(ТекстЗапросаУведомленияОВвозеИзЕАЭС);
	Возврат ТекстЗапросаУведомленияОВвозеИзЕАЭС;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для оформления
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОВвозеИзЕАЭСОформите() Экспорт
	
	ТекстЗапросаУведомленияОВвозеИзЕАЭС = "";
	ИнтеграцияГИСМПереопределяемый.ТекстЗапросаУведомленияОВвозеИзЕАЭСОформите(ТекстЗапросаУведомленияОВвозеИзЕАЭС);
	Возврат ТекстЗапросаУведомленияОВвозеИзЕАЭС;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОВвозеИзЕАЭСОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ КАК УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.ТекущееУведомление = УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен))
	|	И (УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания.
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОВвозеИзЕАЭСОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыИнформированияГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ КАК УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ
	|ПО
	|	СтатусыИнформированияГИСМ.ТекущееУведомление = УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Ссылка
	|ГДЕ
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие В 
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации))
	|	И (УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ДействияПриОбменеГИСМ

// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияГИСМ - Новый статус.
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	ИспользоватьАвтоматическийОбмен = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ");
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.КПередаче;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийГИСМ - Статус обработки сообщения.
// 
// Возвращаемое значение:
//  Перечисления.СтатусыИнформированияГИСМ - Новый статус.
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.Передано;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ПринятоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыИнформированияГИСМ.ОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыИнформированияГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

#КонецОбласти

#Область СообщенияГИСМ

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ.
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		Возврат УведомлениеОВвозеМаркированныхТоваровИзЕАЭСXML(ДокументСсылка);
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхПолучениеКвитанции Тогда
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Формирует текст запроса ограничения доступа для RLS формата БСП 3.0
//
// Параметры:
//   Ограничение - (См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа).
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	ИнтеграцияГИСМПереопределяемый.ПриЗаполненииОграниченияДоступа(Ограничение,
		ОбщегоНазначения.ИмяТаблицыПоСсылке(ПустаяСсылка()));

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СообщенияГИСМ

Функция УведомлениеОВвозеМаркированныхТоваровИзЕАЭСXML(ДокументСсылка)
	
	Если ИнтеграцияГИСМ.ИспользоватьВозможностиВерсии("2.41") Тогда
		Возврат УведомлениеОВвозеМаркированныхТоваровИзЕАЭСXML2_41(ДокументСсылка);
	Иначе
		Возврат УведомлениеОВвозеМаркированныхТоваровИзЕАЭСXML2_40(ДокументСсылка);
	КонецЕсли;
	
КонецФункции

#Область Версия2_40

Функция УведомлениеОВвозеМаркированныхТоваровИзЕАЭСXML2_40(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = "2.40";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанных)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Дата          КАК Дата,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Номер         КАК Номер,
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0)            КАК ПоследнийНомерВерсии,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Основание     КАК Основание,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Организация   КАК Организация,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Подразделение КАК Подразделение,
	|	
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Контрагент                                             КАК Контрагент,
	|	ЕСТЬNULL(УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Контрагент.СтранаРегистрации.КодАльфа2, """") КАК Страна,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Контрагент.РегистрационныйНомер                        КАК РегистрационныйНомер,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Контрагент.Наименование                                КАК Наименование,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Контрагент.НаименованиеПолное                          КАК НаименованиеПолное
	|	
	|ИЗ
	|	Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ КАК УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НомераКиЗ.НомерСтроки КАК НомерСтроки,
	|	НомераКиЗ.НомерКиЗ КАК НомерКиЗ,
	|	НомераКиЗ.RFIDTID КАК TID,
	|	НомераКиЗ.RFIDEPC КАК EPC,
	|	НомераКиЗ.СуммаНДС КАК СуммаНДС,
	|	НомераКиЗ.Стоимость КАК Стоимость
	|ИЗ
	|	Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.НомераКиЗ КАК НомераКиЗ
	|ГДЕ
	|	НомераКиЗ.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомераКиЗ.НомерСтроки");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[1].Выбрать();
	Товары = Результат[2].Выгрузить();
	Если Не Шапка.Следующий()
		Или Товары.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВвозМаркированнойПродукцииИзЕАЭС, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВвозМаркированнойПродукцииИзЕАЭС, ДокументСсылка, НомерВерсии);
	
	ИмяТипа   = "query";
	ИмяПакета = "import_signs";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
	
	УведомлениеОВвозе = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
	УведомлениеОВвозе.action_id  = УведомлениеОВвозе.action_id;
	
	Попытка
		УведомлениеОВвозе.sender_gln = РеквизитыОгранизации.GLN;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
	КонецПопытки;
	
	Свойство_transborder_info = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОВвозе, "transborder_info", Версия);
	
	Попытка
		Свойство_transborder_info.country = Шапка.Страна;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, СтрШаблон(НСтр("ru = 'Для контрагента %1 не заполнена страна регистрации.'"), Шапка.Контрагент));
	КонецПопытки;
	
	Попытка
		Свойство_transborder_info.org_number = Шапка.РегистрационныйНомер;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, СтрШаблон(НСтр("ru = 'Для контрагента %1 не заполнен регистрационный номер.'"), Шапка.Контрагент));
	КонецПопытки;
	
	УведомлениеОВвозе.transborder_info = Свойство_transborder_info;
	
	ХранилищеВременныхДат = Новый Соответствие;
	ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
		УведомлениеОВвозе,
		"import_date",
		Шапка.Дата,
		ХранилищеВременныхДат);
	
	УведомлениеОВвозе.payment_doc_num  = Шапка.Номер;
	УведомлениеОВвозе.payment_doc_date = Шапка.Дата;
	
	УведомлениеОВвозе.import_details = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОВвозе, "import_details", Версия);
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ)
			И Не ЗначениеЗаполнено(СтрокаТЧ.TID)
			И Не ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
				СообщениеXML,
				СтрШаблон(НСтр("ru = 'В строке %1 не указаны данные о КиЗ.'"),
					СтрокаТЧ.НомерСтроки));
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОВвозе.import_details, "sign", Версия);
		
		Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
			Попытка
				НоваяСтрока.sign_num.Добавить(СтрокаТЧ.НомерКиЗ);
			Исключение
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный номер КиЗ ""%2"".'"),
						СтрокаТЧ.НомерСтроки,
						СтрокаТЧ.НомерКиЗ));
			КонецПопытки;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.TID) Тогда
			Попытка
				НоваяСтрока.sign_tid.Добавить(СтрокаТЧ.TID);
			Исключение
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный TID ""%2"".'"),
						СтрокаТЧ.НомерСтроки,
						СтрокаТЧ.TID));
			КонецПопытки;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
			Попытка
				НоваяСтрока.sign_sgtin.Добавить(МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВБинарнуюСтроку(СтрокаТЧ.EPC));
			Исключение
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный EPC ""%2"".'"),
						СтрокаТЧ.НомерСтроки,
						СтрокаТЧ.EPC));
			КонецПопытки;
		КонецЕсли;
		
		Попытка
			НоваяСтрока.total_cost = СтрокаТЧ.Стоимость;
		Исключение
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
				СообщениеXML,
				СтрШаблон(НСтр("ru = 'В строке %1 указана некорректная стоимость ""%2"".'"),
					СтрокаТЧ.НомерСтроки,
					Формат(СтрокаТЧ.Стоимость, "ЧН=0")));
		КонецПопытки;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.СуммаНДС) Тогда
			НоваяСтрока.vat_value = СтрокаТЧ.СуммаНДС;
		КонецЕсли;
		
		УведомлениеОВвозе.import_details.sign.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = УведомлениеОВвозе;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
	ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
	СообщениеXML.Организация  = Шапка.Организация;
	СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных;
	СообщениеXML.Документ     = ДокументСсылка;
	СообщениеXML.Основание    = Шапка.Основание;
	СообщениеXML.Версия       = НомерВерсии;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#Область Версия2_41

Функция УведомлениеОВвозеМаркированныхТоваровИзЕАЭСXML2_41(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Версия = ИнтеграцияГИСМ.ВерсииСхемОбмена().Клиент;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла КАК Ссылка,
	|	КОЛИЧЕСТВО(ГИСМПрисоединенныеФайлы.Ссылка) КАК ПоследнийНомерВерсии
	|ПОМЕСТИТЬ ВременнаяТаблица
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|ГДЕ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла = &Ссылка
	|	И ГИСМПрисоединенныеФайлы.Операция = ЗНАЧЕНИЕ(Перечисление.ОперацииОбменаГИСМ.ПередачаДанных)
	|	И ГИСМПрисоединенныеФайлы.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|
	|СГРУППИРОВАТЬ ПО
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Дата          КАК Дата,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Номер         КАК Номер,
	|	ЕСТЬNULL(ВременнаяТаблица.ПоследнийНомерВерсии, 0)            КАК ПоследнийНомерВерсии,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Основание     КАК Основание,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Основание.Дата  КАК ДатаДокументаОснования,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Основание.Номер КАК НомерДокументаОснования,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Организация   КАК Организация,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Подразделение КАК Подразделение,
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Контрагент    КАК Контрагент
	|ИЗ
	|	Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ КАК УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВременнаяТаблица КАК ВременнаяТаблица
	|		ПО УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Ссылка = ВременнаяТаблица.Ссылка
	|ГДЕ
	|	УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НомераКиЗ.НомерСтроки КАК НомерСтроки,
	|	НомераКиЗ.НомерКиЗ    КАК НомерКиЗ,
	|	НомераКиЗ.RFIDTID     КАК TID,
	|	НомераКиЗ.RFIDEPC     КАК EPC,
	|	НомераКиЗ.СуммаНДС    КАК СуммаНДС,
	|	НомераКиЗ.Стоимость   КАК Стоимость
	|ИЗ
	|	Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.НомераКиЗ КАК НомераКиЗ
	|ГДЕ
	|	НомераКиЗ.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомераКиЗ.НомерСтроки");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка  = Результат[1].Выбрать();
	Товары = Результат[2].Выгрузить();
	Если Не Шапка.Следующий()
		Или Товары.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВвозМаркированнойПродукцииИзЕАЭС, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	НомерВерсии = Шапка.ПоследнийНомерВерсии + 1;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	РеквизитыКонтрагента = ИнтеграцияГИСМВызовСервера.РеквизитыКонтрагента(Шапка.Контрагент);
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаДанныхВвозМаркированнойПродукцииИзЕАЭС, ДокументСсылка, НомерВерсии);
	
	ИмяТипа   = "query";
	ИмяПакета = "import_signs";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа, Версия);
	
	УведомлениеОВвозе = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета, Версия);
	УведомлениеОВвозе.action_id  = УведомлениеОВвозе.action_id;
	
	Попытка
		УведомлениеОВвозе.sender_gln = РеквизитыОгранизации.GLN;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибкиНеЗаполненGLNОрганизации(СообщениеXML, РеквизитыОгранизации.GLN, Шапка);
	КонецПопытки;
	
	Попытка
		УведомлениеОВвозе.country = РеквизитыКонтрагента.Страна;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, СтрШаблон(НСтр("ru = 'Для контрагента %1 указана неверно или не заполнена страна регистрации.'"), Шапка.Контрагент));
	КонецПопытки;
	
	Попытка
		УведомлениеОВвозе.org_name = РеквизитыКонтрагента.НаименованиеПолное;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, СтрШаблон(НСтр("ru = 'Для контрагента %1 указан неверно или не заполнено полное наименование.'"), Шапка.Контрагент));
	КонецПопытки;
	
	УведомлениеОВвозе.transborder_info = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОВвозе, "transborder_info", Версия);
	
	Попытка
		УведомлениеОВвозе.transborder_info.country = РеквизитыКонтрагента.Страна;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, СтрШаблон(НСтр("ru = 'Для контрагента %1 указана неверно или не заполнена страна регистрации.'"), Шапка.Контрагент));
	КонецПопытки;
	
	Попытка
		УведомлениеОВвозе.transborder_info.org_number = РеквизитыКонтрагента.РегистрационныйНомер;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, СтрШаблон(НСтр("ru = 'Для контрагента %1 указан неверно или не заполнен регистрационный номер.'"), Шапка.Контрагент));
	КонецПопытки;
	
	Попытка
		УведомлениеОВвозе.transborder_info.org_address = РеквизитыКонтрагента.ЮридическийАдрес;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(СообщениеXML, СтрШаблон(НСтр("ru = 'Для контрагента %1 указан неверно или не заполнен юридический адрес.'"), Шапка.Контрагент));
	КонецПопытки;
	
	ХранилищеВременныхДат = Новый Соответствие;
	ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
		УведомлениеОВвозе,
		"import_date",
		Шапка.Дата,
		ХранилищеВременныхДат);
		
	Попытка
		УведомлениеОВвозе.payment_doc_num = Шапка.НомерДокументаОснования;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
			СообщениеXML,
			СтрШаблон(
				НСтр("ru = 'Не указан или указан неверно номер документа-основания.'"), Шапка.Контрагент));
	КонецПопытки;
	
	Попытка
		УведомлениеОВвозе.payment_doc_date = Шапка.ДатаДокументаОснования;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
			СообщениеXML,
			СтрШаблон(
				НСтр("ru = 'Не указана или указана неверно дата документа-основания.'"), Шапка.Контрагент));
	КонецПопытки;
	
	Попытка
		УведомлениеОВвозе.confirm_doc = Шапка.Основание.Метаданные().Синоним;
	Исключение
		ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
		СообщениеXML,
			СтрШаблон(
				НСтр("ru = 'Не удалось определить наименование документа-основания.'"), Шапка.Контрагент));
	КонецПопытки;
	
	УведомлениеОВвозе.import_details = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОВвозе, "import_details", Версия);
	
	Для Каждого СтрокаТЧ Из Товары Цикл
		
		Если Не ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ)
			И Не ЗначениеЗаполнено(СтрокаТЧ.TID)
			И Не ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
				СообщениеXML,
				СтрШаблон(НСтр("ru = 'В строке %1 не указаны данные о КиЗ.'"),
					СтрокаТЧ.НомерСтроки));
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(УведомлениеОВвозе.import_details, "sign", Версия);
		
		Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
			Попытка
				НоваяСтрока.sign_num.Добавить(СтрокаТЧ.НомерКиЗ);
			Исключение
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный номер КиЗ ""%2"".'"),
						СтрокаТЧ.НомерСтроки,
						СтрокаТЧ.НомерКиЗ));
			КонецПопытки;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.TID) Тогда
			Попытка
				НоваяСтрока.sign_tid.Добавить(СтрокаТЧ.TID);
			Исключение
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный TID ""%2"".'"),
						СтрокаТЧ.НомерСтроки,
						СтрокаТЧ.TID));
			КонецПопытки;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
			Попытка
				НоваяСтрока.sign_sgtin.Добавить(МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВБинарнуюСтроку(СтрокаТЧ.EPC));
			Исключение
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный EPC ""%2"".'"),
						СтрокаТЧ.НомерСтроки,
						СтрокаТЧ.EPC));
			КонецПопытки;
		КонецЕсли;
		
		Попытка
			НоваяСтрока.total_cost = СтрокаТЧ.Стоимость;
		Исключение
			ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
				СообщениеXML,
				СтрШаблон(НСтр("ru = 'В строке %1 указана некорректная стоимость ""%2"".'"),
					СтрокаТЧ.НомерСтроки,
					Формат(СтрокаТЧ.Стоимость, "ЧН=0")));
		КонецПопытки;
		
		Если ЗначениеЗаполнено(СтрокаТЧ.СуммаНДС) Тогда
			НоваяСтрока.vat_value = СтрокаТЧ.СуммаНДС;
		КонецЕсли;
		
		УведомлениеОВвозе.import_details.sign.Добавить(НоваяСтрока);
		
	КонецЦикла;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = УведомлениеОВвозе;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа, Версия);
	ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
	
	СообщениеXML.ТекстСообщенияXML = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
	СообщениеXML.Организация  = Шапка.Организация;
	СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных;
	СообщениеXML.Документ     = ДокументСсылка;
	СообщениеXML.Основание    = Шапка.Основание;
	СообщениеXML.Версия       = НомерВерсии;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли