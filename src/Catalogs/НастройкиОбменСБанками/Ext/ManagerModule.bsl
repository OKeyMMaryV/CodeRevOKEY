﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Обработчик обновления. Заполняет версию формата в настройках обмена.
//
// Параметры:
//  Параметры - Структура - структура вида:
//    * ОбработкаЗавершена - Булево - (не заполнять) признак того что обработка заполнения версии формата завершена.
//
Процедура ЗаполнитьВерсиюФормата(Параметры) Экспорт
	
	Параметры.ОбработкаЗавершена = Ложь;
	
	НачатьТранзакцию();
	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиОбменСБанками.Ссылка
		|ИЗ
		|	Справочник.НастройкиОбменСБанками КАК НастройкиОбменСБанками
		|ГДЕ
		|	НастройкиОбменСБанками.ПрограммаБанка = ЗНАЧЕНИЕ(Перечисление.ПрограммыБанка.АсинхронныйОбмен)
		|	И НастройкиОбменСБанками.ВерсияФормата = """"";
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
			СправочникОбъект.ВерсияФормата = ОбменСБанкамиКлиентСервер.БазоваяВерсияФорматаАсинхронногоОбмена();
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		Операция = НСтр("ru = '1С:ДиректБанк: Заполнение версии формата.'");
		ПодробныйТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ТекстСообщения = НСтр("ru = '1С:ДиректБанк: При заполнении версии формата произошла ошибка.'");
		ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(Операция, ПодробныйТекстОшибки, , "ОбменСБанками");
		ВызватьИсключение;
		
	КонецПопытки;
	
	Параметры.ОбработкаЗавершена = Истина;

КонецПроцедуры

// Регистрирует данные для обработчика обновления
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
		ПустойМаршрут = Справочники.МаршрутыПодписания.ПустаяСсылка();
		ВидыДокументовСНесколькимиПодписями = ОбменСБанкамиСлужебныйПовтИсп.ВидыДокументовПодписываемыхПоМаршруту();
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкиОбменСБанками.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НастройкиОбменСБанками КАК НастройкиОбменСБанками
		|ГДЕ
		|	НастройкиОбменСБанками.ПрограммаБанка = ЗНАЧЕНИЕ(Перечисление.ПрограммыБанка.СбербанкОнлайн)
		|	И НЕ НастройкиОбменСБанками.УдалитьВерсияВнешнейКомпоненты = """"
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Настройки.Ссылка
		|ИЗ
		|	Справочник.НастройкиОбменСБанками.ИсходящиеДокументы КАК Настройки
		|ГДЕ
		|	Настройки.МаршрутПодписания = &ПустойМаршрут
		|	И Настройки.ИспользоватьЭП = ИСТИНА
		|	И Настройки.Ссылка.Недействительна = ЛОЖЬ
		|	И Настройки.ИсходящийДокумент В(&ВидыДокументовСНесколькимиПодписями)
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкиОбменСБанкамиСертификатыПодписейОрганизации.Ссылка
		|ИЗ
		|	Справочник.НастройкиОбменСБанками.СертификатыПодписейОрганизации КАК НастройкиОбменСБанкамиСертификатыПодписейОрганизации
		|ГДЕ
		|	НастройкиОбменСБанкамиСертификатыПодписейОрганизации.Ссылка.ПрограммаБанка = ЗНАЧЕНИЕ(Перечисление.ПрограммыБанка.СбербанкОнлайн)
		|	И НЕ НастройкиОбменСБанкамиСертификатыПодписейОрганизации.Ссылка.ИспользуетсяКриптография
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	НастройкиОбменСБанками.Ссылка
		|ИЗ
		|	Справочник.НастройкиОбменСБанками КАК НастройкиОбменСБанками
		|ГДЕ
		|	НастройкиОбменСБанками.ПрограммаБанка = ЗНАЧЕНИЕ(Перечисление.ПрограммыБанка.ОбменЧерезДопОбработку)
		|	И НастройкиОбменСБанками.ДополнительнаяОбработка = &ПустаяСсылкаДополнительнаяОбработка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	НастройкиОбменСБанками.Ссылка
		|ИЗ
		|	Справочник.НастройкиОбменСБанками КАК НастройкиОбменСБанками
		|ГДЕ
		|	НЕ НастройкиОбменСБанками.УдалитьОбновленоПодтвердитьВБанке";
		Запрос.УстановитьПараметр("ПустойМаршрут", ПустойМаршрут);
		Запрос.УстановитьПараметр("ВидыДокументовСНесколькимиПодписями", ВидыДокументовСНесколькимиПодписями);
		Запрос.УстановитьПараметр(
			"ПустаяСсылкаДополнительнаяОбработка", Справочники.ДополнительныеОтчетыИОбработки.ПустаяСсылка());
		Результат = Запрос.Выполнить().Выгрузить();
		МассивСсылок = Результат.ВыгрузитьКолонку("Ссылка");
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);

КонецПроцедуры

// Обработчик обновления.
// 
// Параметры:
//  Параметры - Структура - параметры.
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПустойМаршрут = Справочники.МаршрутыПодписания.ПустаяСсылка();
	ВидыДокументовСНесколькимиПодписями = ОбменСБанкамиСлужебныйПовтИсп.ВидыДокументовПодписываемыхПоМаршруту();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(
		Параметры.Очередь, "Справочник.НастройкиОбменСБанками");
		
	ЕстьОбработанныйОбъект = Ложь; ПроизошлаОшибка = Ложь;

	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Попытка
			ОбъектОбработки = Выборка.Ссылка.ПолучитьОбъект();
				
			// Перенос внешней компоненты в отдельный справочник
			Если ОбъектОбработки.ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн
				И НЕ ОбъектОбработки.УдалитьВерсияВнешнейКомпоненты = "" Тогда
				ОбъектОбработки.ИмяВнешнегоМодуля = ОбменСБанкамиКлиентСервер.ИдентификаторВнешнейКомпонентыСбербанк();
				ОбъектОбработки.УдалитьВерсияВнешнейКомпоненты = "";
			КонецЕсли;
			
			// Заполнение маршрутов в таблице исходящих документов
			ПараметрыОтбора = Новый Структура("МаршрутПодписания", ПустойМаршрут);
			СтрокиСПустымМаршрутом = ОбъектОбработки.ИсходящиеДокументы.НайтиСтроки(ПараметрыОтбора);
			Для Каждого СтрокаНастройки Из СтрокиСПустымМаршрутом Цикл
				Если ВидыДокументовСНесколькимиПодписями.Найти(СтрокаНастройки.ИсходящийДокумент) = Неопределено Тогда
					СтрокаНастройки.МаршрутПодписания = Справочники.МаршрутыПодписания.ОднойДоступнойПодписью;
				Иначе	
					МаршрутИзНесколькихПодписей = ОбменСБанкамиСлужебный.НовыйМаршрутПоСертификатамНастройки(
						Выборка.Ссылка, СтрокаНастройки.ИсходящийДокумент);
						
					Если Не ЗначениеЗаполнено(МаршрутИзНесколькихПодписей) Тогда
						МаршрутИзНесколькихПодписей = Справочники.МаршрутыПодписания.ОднойДоступнойПодписью;
					КонецЕсли;
					СтрокаНастройки.МаршрутПодписания = МаршрутИзНесколькихПодписей;
				КонецЕсли;
			КонецЦикла;
			
			// Установка флажка ИспользуетсяКриптография для настроек обмена Сбербанка
			Если ОбъектОбработки.ПрограммаБанка = Перечисления.ПрограммыБанка.СбербанкОнлайн
				И НЕ ОбъектОбработки.ИспользуетсяКриптография И ОбъектОбработки.СертификатыПодписейОрганизации.Количество() Тогда
					ОбъектОбработки.ИспользуетсяКриптография = Истина;
				КонецЕсли;
				
			// Установка флага ПодтвердитьВБанке в таблице ИсходящиеДокументы
			Если НЕ ОбъектОбработки.УдалитьОбновленоПодтвердитьВБанке Тогда
				Если ОбъектОбработки.ПрограммаБанка = Перечисления.ПрограммыБанка.АсинхронныйОбмен Тогда
					ВидыПлатежныхДокументов = ОбменСБанкамиСлужебный.ВидыПлатежныхДокументов();
					Для каждого ЭлементКоллекции Из ОбъектОбработки.ИсходящиеДокументы Цикл
						Если НЕ ЭлементКоллекции.ИспользоватьЭП
							И ВидыПлатежныхДокументов.Найти(ЭлементКоллекции.ИсходящийДокумент) <> Неопределено Тогда
							ЭлементКоллекции.ПодтвердитьВБанке = Истина;
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
				ОбъектОбработки.УдалитьОбновленоПодтвердитьВБанке = Истина;
			КонецЕсли;
			
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ОбъектОбработки);
			ЕстьОбработанныйОбъект = Истина;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ПроизошлаОшибка = Истина;
			ТекстСообщения = НСтр("ru = 'Не удалось обработать справочник: %Регистратор% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Регистратор%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			СобытиеЖурналаРегистрации = ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации();
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации, УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Справочники.НастройкиОбменСБанками, , ТекстСообщения);
			Продолжить;
		КонецПопытки;
	КонецЦикла;

	Если Не ЕстьОбработанныйОбъект И ПроизошлаОшибка Тогда
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;

	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(
		Параметры.Очередь, "Справочник.НастройкиОбменСБанками");

КонецПроцедуры

// См. ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы.
Функция ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтбор) Экспорт
	
	Если МетаданныеИОтбор.ПолноеИмя = "Справочник.НастройкиОбменСБанками" Тогда
		МетаданныеИОтборНастройки = МетаданныеИОтбор;
	ИначеЕсли МетаданныеИОтбор.ПолноеИмя = "Документ.СообщениеОбменСБанками" Тогда
		Настройка = МетаданныеИОтбор.Отбор.НастройкаОбмена;
		МетаданныеИОтборНастройки = ОбновлениеИнформационнойБазы.МетаданныеИОтборПоДанным(Настройка);
	КонецЕсли;
	
	Возврат ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы(МетаданныеИОтборНастройки);
	
КонецФункции

// Формирует ключ, по которому будет производиться поиск настройки обмена с банком при автоматической загрузке
// настроек.
//
// Параметры:
//  НастройкаОбмена	 - СправочникСсылка.НастройкиОбменСБанками - настройка обмена с банком.
//  ВидДокумента	 - ПеречислениеСсылка.ВидыЭДОбменСБанками - вид электронного документа.
// 
// Возвращаемое значение:
//  Строка - сформированный ключ.
//
Функция КлючАвтоматическойНастройки(НастройкаОбмена, ВидДокумента) Экспорт

	Ключ = "" + НастройкаОбмена.Организация.УникальныйИдентификатор() 
			+ НастройкаОбмена.Банк.УникальныйИдентификатор() + ОбщегоНазначения.ИмяЗначенияПеречисления(ВидДокумента);
				
	Возврат Ключ;

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

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ЗначениеЗаполнено(Данные.Организация) И ЗначениеЗаполнено(Данные.Банк) Тогда
		ШаблонПредставления = "%1 - %2";
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонПредставления, Данные.Организация, Данные.Банк);
	Иначе
		Представление = НСтр("ru = 'Не заполненная настройка'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Очистить();
	Поля.Добавить("Организация");
	Поля.Добавить("Банк");
	Поля.Добавить("Код");
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Загружает настройки обмена с сервера банка.
//
// Параметры:
//  ПараметрыПолученияНастроек - Структура - данные, необходимые для получения настроек;
//  АдресХранилища - Строка - адрес хранилища в который необходимо поместить полученные данные.
//
Процедура ПолучитьНастройкиОбменаССервераБанка(Знач ПараметрыПолученияНастроек, АдресХранилища) Экспорт

	Если НЕ ЗначениеЗаполнено(ПараметрыПолученияНастроек.НомерБанковскогоСчета) Тогда
		ПараметрыПолученияНастроек.НомерБанковскогоСчета = НомерБанковскогоСчета(
			ПараметрыПолученияНастроек.Организация, ПараметрыПолученияНастроек.Банк);
	КонецЕсли;
	
	РеквизитыОрганизации = Неопределено;
	ЭлектронноеВзаимодействиеПереопределяемый.ПолучитьДанныеЮрФизЛица(
		ПараметрыПолученияНастроек.Организация, РеквизитыОрганизации);
	ПараметрыПолученияНастроек.Вставить("ИНН", РеквизитыОрганизации.ИНН);
	НастройкиОбмена = ПолучитьНастройкиОбмена(ПараметрыПолученияНастроек);
	ПоместитьВоВременноеХранилище(НастройкиОбмена, АдресХранилища);
	
КонецПроцедуры

// Загружает настройки обмена из файла настроек
//
// Параметры:
//  ДанныеНастроек - Структура - параметры процедуры. Содержит следующие элементы:
//     * ДвоичныеДанныеФайлаНастроек - ДвоичныеДанные - данные файла настроек;
//     * ЗагружатьВК - Булево - признак необходимости загрузки внешней компоненты с сервера поставщика;
//     * Организация - ОпределяемыйТип.Организация - организация, для которой создается настройка обмена;
//  АдресХранилища - Строка - адрес хранилища в который необходимо поместить полученные данные.
//
Процедура ЗагрузитьНастройкиОбменаИзФайла(Знач ДанныеНастроек, АдресХранилища) Экспорт

	АдресФайлаНастроек = ПоместитьВоВременноеХранилище(ДанныеНастроек.ДвоичныеДанныеФайлаНастроек);
	ДанныеСертификатов = Неопределено;
	НоваяНастройкаОбмена = ОбменСБанкамиСлужебный.СоздатьНастройкуОбменаИзФайла(АдресФайлаНастроек,
		ДанныеНастроек.Организация, Истина, ДанныеНастроек.ЛокальныйФайл, ДанныеСертификатов, ДанныеНастроек.ЗагружатьВК);
	ДанныеВозврата = Новый Структура;
	ДанныеВозврата.Вставить("НастройкаОбмена", НоваяНастройкаОбмена);
	ДанныеВозврата.Вставить("ДанныеСертификатов", ДанныеСертификатов);
	ПоместитьВоВременноеХранилище(ДанныеВозврата, АдресХранилища);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Осуществляет получение настроек обмена с сервера банка.
// 
// Параметры:
//    ПараметрыПолученияНастроек - Структура - Параметры получения настроек (все обязательно к заполнению), вида:
//     * АдресСервера - Строка - адрес сервера банка, с которого будут получены настройки обмена;
//     * Банк - СправочникСсылка.КлассификаторБанков - банк, для которого будут получены настройки;
//     * НомерСчета - Строка - номер банковского счета;
//     * ДанныеМаркера - ДвоичныеДанные - временный маркер банка;
//     * ИдентификаторОрганизации - Строка - идентификатор организации на сервере банка;
//     * ИНН - Строка - ИНН организации;
//     * ПробнаяОперация - Булево - признак пробного получения настроек без вывода сообщений об ошибках.
//     * НастройкаОбмена - СправочникСсылка.НастройкиОбменСБанками - ссылка на текущую настройку обмена с банком.
//
// Возвращаемое значение:
//    ДвоичныеДанные - данные файла настроек ЭДО.
//
Функция ПолучитьНастройкиОбмена(ПараметрыПолученияНастроек)
	
	ВидОперации = НСтр("ru = 'Получение настроек с сервера банка'");
	
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/xml; charset=utf-8");
	
	ИдентификаторОрганизации = ПараметрыПолученияНастроек.ИдентификаторОрганизации;
	Если Не ЗначениеЗаполнено(ИдентификаторОрганизации) Тогда
		ИдентификаторОрганизации = "0";
	КонецЕсли;
	Заголовки.Вставить("CustomerID", ИдентификаторОрганизации);
	
	Если ЗначениеЗаполнено(ПараметрыПолученияНастроек.НомерБанковскогоСчета) Тогда
		Заголовки.Вставить("Account", ПараметрыПолученияНастроек.НомерБанковскогоСчета);
	КонецЕсли;
	
	Заголовки.Вставить("Inn", ПараметрыПолученияНастроек.ИНН);
	Заголовки.Вставить("Bic", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыПолученияНастроек.Банк, "Код"));
	Маркер = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.СтрокаИзДвоичныхДанных(
		ПараметрыПолученияНастроек.ИдентификаторСессии);
	Заголовки.Вставить("SID", Маркер);
	Заголовки.Вставить("APIVersion", ОбменСБанкамиКлиентСервер.БазоваяВерсияФорматаАсинхронногоОбмена());
	Заголовки.Вставить("AvailableAPIVersion", ОбменСБанкамиКлиентСервер.АктуальнаяВерсияФорматаАсинхронногоОбмена());
	
	Результат = ОбменСБанкамиСлужебный.ОтправитьPOSTЗапрос(ПараметрыПолученияНастроек.АдресСервера, "GetSettings",
		Заголовки, Неопределено, , , ПараметрыПолученияНастроек.НастройкаОбмена);
	
	Если Не Результат.Статус Тогда
		Если ЗначениеЗаполнено(Результат.КодСостояния) Тогда
			Шаблон = НСтр("ru = 'Ошибка загрузки настроек с сервера банка.
								|Код ошибки: %1.
								|%2'");
			ТекстОшибки = СтрШаблон(Шаблон, Результат.КодСостояния, Результат.СообщениеОбОшибке);
		Иначе
			ТекстОшибки = Результат.СообщениеОбОшибке;
		КонецЕсли;
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	ИмяФайлаРезультата = ПолучитьИмяВременногоФайла("xml");
	
	Результат.Тело.Записать(ИмяФайлаРезультата);
	
	Чтение = Новый ЧтениеXML;
	Попытка
		Чтение.ОткрытьФайл(ИмяФайлаРезультата);
		ResultBank = ФабрикаXDTO.ПрочитатьXML(Чтение);
		
		Если ResultBank.Свойства().Получить("formatVersion") = Неопределено Тогда
			ВерсияФормата = ОбменСБанкамиКлиентСервер.УстаревшаяВерсияФорматаАсинхронногоОбмена();
		Иначе
			ВерсияФормата = ResultBank.formatVersion;
		КонецЕсли;
		
		ПространствоИмен = ОбменСБанкамиСлужебный.ПространствоИменАсинхронногоОбмена(ВерсияФормата);

		Фабрика = ОбменСБанкамиСлужебныйПовтИсп.ФабрикаAsyncXDTO(ВерсияФормата);

		Чтение.ОткрытьФайл(ИмяФайлаРезультата);
		ПакетТип = ОбменСБанкамиСлужебный.ТипЗначенияCML(Фабрика, ПространствоИмен, "ResultBank");
		ResultBank = Фабрика.ПрочитатьXML(Чтение, ПакетТип);
	Исключение
		Если Не ПараметрыПолученияНастроек.ПробнаяОперация Тогда
			ТекстСообщения = НСтр("ru = 'Произошла ошибка при получении настроек из банка'");
			ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ТекстОшибки = НСтр("ru = 'Ошибка чтения ответа банка.
									|Текст ошибки: %1
									|Путь к файлу: %2'");
			ТекстОшибки = СтрШаблон(ТекстОшибки, ПодробноеПредставлениеОшибки, ИмяФайлаРезультата);
			ВидОперации = НСтр("ru = 'Получение настроек обмена из банка'");
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				ВидОперации, ТекстОшибки, , "ОбменСБанками");
		КонецЕсли;
		Чтение.Закрыть();
		ВызватьИсключение ТекстСообщения;
	КонецПопытки;
		
	Если НЕ ResultBank.Error = Неопределено Тогда
		Чтение.Закрыть();
		ФайловаяСистема.УдалитьВременныйФайл(ИмяФайлаРезультата);
		ОсновнойТекст = НСтр("ru = 'Произошла ошибка при аутентификации на сервере банка.'");
		ТекстСообщения = ОбменСБанкамиСлужебный.ТекстСообщенияОбОшибкеОтветаБанка(ResultBank.Error);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Чтение.Закрыть();
	ДанныеНастроек = ResultBank.Success.GetSettingsResponse.Data.__content;
	ФайловаяСистема.УдалитьВременныйФайл(ИмяФайлаРезультата);
	Возврат ДанныеНастроек;
	
КонецФункции

// Определяет один из банковских счетов организации.
//
// Параметры:
//   Организация - СправочникСсылка.Организации - организация;
//   Банк - ОпределяемыеТипы.БанкОбменСБанками - банк.
//
// Возвращаемое значение:
//    Строка - номер банковского счета.
//
Функция НомерБанковскогоСчета(Знач Организация, Знач Банк)
	
	МассивБанковскихСчетов = Новый Массив;
	ОбменСБанкамиПереопределяемый.ПолучитьНомераБанковскихСчетов(Организация, Банк, МассивБанковскихСчетов);
	Если МассивБанковскихСчетов.Количество() Тогда
		Возврат МассивБанковскихСчетов[0];
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли

