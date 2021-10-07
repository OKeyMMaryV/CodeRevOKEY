﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция СчетУчетаРасчетовПоУмолчанию(ТипОплаты) Экспорт
	
	СчетУчетаРасчетов = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	
	Если ТипОплаты = Перечисления.ТипыОплат.ПодарочныйСертификатСобственный Тогда
		СчетУчетаРасчетов = ПланыСчетов.Хозрасчетный.РасчетыПоАвансамПолученным;
	ИначеЕсли ТипОплаты = Перечисления.ТипыОплат.ПодарочныйСертификатСторонний Тогда
		СчетУчетаРасчетов = ПланыСчетов.Хозрасчетный.ПрочиеРасчетыСРазнымиДебиторамиИКредиторами;
	ИначеЕсли ТипОплаты = Перечисления.ТипыОплат.ПлатежнаяКарта Тогда
		СчетУчетаРасчетов = ПланыСчетов.Хозрасчетный.ПродажиПоПлатежнымКартам;
	ИначеЕсли ТипОплаты = Перечисления.ТипыОплат.БанковскийКредит Тогда
		СчетУчетаРасчетов = ПланыСчетов.Хозрасчетный.РасчетыСПрочимиПокупателямиИЗаказчиками;
	КонецЕсли;
	
	Возврат СчетУчетаРасчетов;
	
КонецФункции

Функция ВидОплатыНаличные() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыОплатОрганизаций.Ссылка
	|ИЗ
	|	Справочник.ВидыОплатОрганизаций КАК ВидыОплатОрганизаций
	|ГДЕ
	|	ВидыОплатОрганизаций.ТипОплаты = ЗНАЧЕНИЕ(Перечисление.ТипыОплат.Наличные)
	|	И НЕ ВидыОплатОрганизаций.ПометкаУдаления";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		
		НовыйЭлемент = Справочники.ВидыОплатОрганизаций.СоздатьЭлемент();
		
		НовыйЭлемент.ТипОплаты    = Перечисления.ТипыОплат.Наличные;
		НовыйЭлемент.Наименование = "Наличные";
		
		НовыйЭлемент.Записать();
		
		Возврат НовыйЭлемент.Ссылка;
		
	КонецЕсли;
	
КонецФункции

Функция ВидОплатыПоДоговору(Организация, Контрагент, ДоговорКонтрагента) Экспорт
	
	ВидОплаты = Справочники.ВидыОплатОрганизаций.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация",        Организация);
	Запрос.УстановитьПараметр("Контрагент",         Контрагент);
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыОплатОрганизаций.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыОплатОрганизаций КАК ВидыОплатОрганизаций
	|ГДЕ
	|	ВидыОплатОрганизаций.Организация = &Организация
	|	И ВидыОплатОрганизаций.Контрагент = &Контрагент
	|	И ВидыОплатОрганизаций.ДоговорКонтрагента = &ДоговорКонтрагента
	|	И НЕ ВидыОплатОрганизаций.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка УБЫВ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ВидОплаты = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат ВидОплаты;
	
КонецФункции

Функция ЭтоРасчетыСЭмитентамиПодарочныхСертификатов(ДоговорКонтрагента) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ДоговорКонтрагента", ДоговорКонтрагента);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыОплатОрганизаций.Ссылка
	|ИЗ
	|	Справочник.ВидыОплатОрганизаций КАК ВидыОплатОрганизаций
	|ГДЕ
	|	ВидыОплатОрганизаций.ДоговорКонтрагента = &ДоговорКонтрагента
	|	И ВидыОплатОрганизаций.ТипОплаты = ЗНАЧЕНИЕ(Перечисление.ТипыОплат.ПодарочныйСертификатСторонний)"
	;
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ВидыДоговоровПоТипуОплаты(ТипОплаты) Экспорт
	
	ВидыДоговоров = Новый Массив;
	
	Если ТипОплаты = Перечисления.ТипыОплат.ПодарочныйСертификатСобственный Тогда
		ВидыДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
	ИначеЕсли ТипОплаты = Перечисления.ТипыОплат.ПодарочныйСертификатСторонний Тогда
		ВидыДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);
	Иначе
		ВидыДоговоров.Добавить(Перечисления.ВидыДоговоровКонтрагентов.Прочее);
	КонецЕсли;
	
	Возврат ВидыДоговоров;
	
КонецФункции

Функция ОрганизацииДляОтбораВидовОплат(Организация) Экспорт
	
	Организации = Новый Массив;
	Организации.Добавить(Организация);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ГоловнаяОрганизация = ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(Организация);
		Если ГоловнаяОрганизация <> Организация Тогда
			Организации.Добавить(ГоловнаяОрганизация);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Организации;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЭтотСписок
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК ОбособленныеПодразделения 
	|	ПО ОбособленныеПодразделения.ГоловнаяОрганизация = ЭтотСписок.Организация
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЭтоГруппа
	|ИЛИ ЗначениеРазрешено(ОбособленныеПодразделения.Ссылка)
	|";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

// Проверяет наличие видов оплат с типом "Платежная карта" в справочнике "ВидыОплатОрганизаций"
//
// Параметры:
//  Организация - СправочникСсылка.Организации - организация, по которой будет установлен отбор на виды оплат
// 
// Возвращаемое значение:
//  Структура - со следующими свойствами
//              * ВидОплатыПоУмолчанию - СправочникСсылка.ВидыОплатОрганизаций - вид оплаты, который можно использовать по-умолчанию, в случае
//                если это единственный элемент справочника, подходящий по установленному отбору
//              * ТребуетсяВыбратьВидОплаты - Булево - Истина, если по установленному отбору найдено несколько видов оплат
//
Функция ВидыОплатПлатежнойКартой(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	ВидыОплатОрганизаций.Ссылка
	|ИЗ
	|	Справочник.ВидыОплатОрганизаций КАК ВидыОплатОрганизаций
	|ГДЕ
	|	ВидыОплатОрганизаций.Организация = &Организация
	|	И ВидыОплатОрганизаций.ТипОплаты = ЗНАЧЕНИЕ(Перечисление.ТипыОплат.ПлатежнаяКарта)
	|	И НЕ ВидыОплатОрганизаций.ПометкаУдаления";
	
	ДанныеВидовОплат = НовыеДанныеОВидахОплат();
	Выборка = Запрос.Выполнить().Выбрать();
	ДанныеВидовОплат.ТребуетсяВыбратьВидОплаты = Выборка.Количество() > 1;
	Если Выборка.Следующий() Тогда
		ДанныеВидовОплат.ВидОплатыПоУмолчанию = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат ДанныеВидовОплат;
	
КонецФункции

// Проверяет наличие в справочнике "ВидыОплат" хотя бы одного элемента, соответствующего заданному отбору
//
// Параметры:
//  Организация - СправочникСсылка.Организации - при поиске вида оплаты будет наложен отбор по значению организации
//  ТипОплаты - ПеречислениеСсылка.ТипыОплат - при поиске вида оплаты будет наложен отбор по значению типа оплаты
// 
// Возвращаемое значение:
//  Булево - Истина, если найден хоть один элемент справочника, соответствующий наложенному отбору
//
Функция ПроверитьЗаполненностьВидовОплат(Организация, ТипОплаты) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВидыОплатОрганизаций.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыОплатОрганизаций КАК ВидыОплатОрганизаций
		|ГДЕ
		|	ВидыОплатОрганизаций.Организация = &Организация
		|	И ВидыОплатОрганизаций.ТипОплаты = &ТипОплаты
		|	И НЕ ВидыОплатОрганизаций.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ТипОплаты", ТипОплаты);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

#КонецОбласти

#Область ОбработчикиОбновленияИБ

Процедура ДобавитьСтрокиТабличнойЧастиКомиссияБанка() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВидыОплатОрганизаций.Ссылка,
	|	ВидыОплатОрганизаций.ПроцентБанковскойКомиссии
	|ИЗ
	|	Справочник.ВидыОплатОрганизаций КАК ВидыОплатОрганизаций
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыОплатОрганизаций.КомиссияБанка КАК ВидыОплатОрганизацийКомиссияБанка
	|		ПО ВидыОплатОрганизаций.Ссылка = ВидыОплатОрганизацийКомиссияБанка.Ссылка
	|ГДЕ
	|	ВидыОплатОрганизацийКомиссияБанка.Ссылка ЕСТЬ NULL 
	|	И ВидыОплатОрганизаций.ПроцентБанковскойКомиссии > 0";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ВидыОплатыОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ВидыОплатыОбъект.КомиссияБанка.Добавить().ПроцентБанковскойКомиссии = ВидыОплатыОбъект.ПроцентБанковскойКомиссии;
		
		Попытка
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(ВидыОплатыОбъект);
		Исключение
			// Записать предупреждение в журнал регистрации.
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать Вид оплаты: %1 по причине:
					|%2'"),
				ВидыОплатыОбъект.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение, Метаданные.Справочники.ВидыОплатОрганизаций, ВидыОплатыОбъект.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ИдентификаторыЗаданийПереключениеОтложенногоПроведения() Экспорт
	
	Результат = Новый Массив;
	
	НайденныеЗадания = ФоновыеЗаданияПереключениеОтложенногоПроведения();
	
	Для Каждого НайденноеЗадание Из НайденныеЗадания Цикл
		Результат.Добавить(НайденноеЗадание.УникальныйИдентификатор);
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Результат);
	
КонецФункции

Функция НайтиФоновоеЗаданиеПереключениеОтложенногоПроведения(Форма) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ИдентификаторЗадания");
	Результат.Вставить("НаименованиеФоновогоЗадания", "");
	Результат.Вставить("ЗаданиеВыполнено",            Ложь);
	
	ТекущиеФоновыеЗадания = ФоновыеЗаданияПереключениеОтложенногоПроведения();
	
	НовыеИдентификаторы = Новый Массив;
	
	// Для упрощения поиска перенесем данные о заданиях в соответствие.
	СведенияОЗаданиях = Новый Соответствие;
	
	Для Каждого ФоновоеЗадание Из ТекущиеФоновыеЗадания Цикл
		Идентификатор = ФоновоеЗадание.УникальныйИдентификатор;
		НовыеИдентификаторы.Добавить(Идентификатор);
		
		СведенияОЗаданиях.Вставить(Идентификатор, ФоновоеЗадание);
	КонецЦикла;
	
	Если Форма.ФоновыеЗаданияПереключениеОтложенногоПроведения <> Неопределено Тогда
		ИдентификаторыНовыхЗаданий = ОбщегоНазначенияКлиентСервер.РазностьМассивов(
			НовыеИдентификаторы, Форма.ФоновыеЗаданияПереключениеОтложенногоПроведения);
	Иначе
		ИдентификаторыНовыхЗаданий = НовыеИдентификаторы;
	КонецЕсли;
		
	Если ИдентификаторыНовыхЗаданий.Количество() = 1 Тогда
		Результат.ИдентификаторЗадания = ИдентификаторыНовыхЗаданий[0];
		
	ИначеЕсли ИдентификаторыНовыхЗаданий.Количество() > 1 Тогда
		// Из нескольких найдем самое последнее по времени.
		МаксДатаНачала = '0001-01-01';
		МаксФоновоеЗадание = Неопределено;
		Для Каждого Идентификатор Из ИдентификаторыНовыхЗаданий Цикл
			ФоновоеЗадание = СведенияОЗаданиях[Идентификатор];
			Если ФоновоеЗадание.Начало > МаксДатаНачала Тогда
				МаксФоновоеЗадание = ФоновоеЗадание;
				МаксДатаНачала     = ФоновоеЗадание.Начало;
			КонецЕсли;
		КонецЦикла;
		
		Если МаксФоновоеЗадание <> Неопределено Тогда
			Результат.ИдентификаторЗадания = МаксФоновоеЗадание.УникальныйИдентификатор;
		КонецЕсли;
		
	КонецЕсли;
	
	// Сразу определим наименование и состояние задания.
	Если ЗначениеЗаполнено(Результат.ИдентификаторЗадания) Тогда
		ФоновоеЗадание = СведенияОЗаданиях[Результат.ИдентификаторЗадания];
		Результат.ЗаданиеВыполнено            = ФоновоеЗадание.Состояние <> СостояниеФоновогоЗадания.Активно;
		Результат.НаименованиеФоновогоЗадания = ФоновоеЗадание.Наименование;
	КонецЕсли;
	
	// Обновляем кеш идентификаторов фоновых заданий.
	Форма.ФоновыеЗаданияПереключениеОтложенногоПроведения = Новый ФиксированныйМассив(НовыеИдентификаторы);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ФоновыеЗаданияПереключениеОтложенногоПроведения()
	
	Отбор = Новый Структура();
	Отбор.Вставить("Ключ", ПроведениеСервер.КлючФоновогоЗаданияПереключениеОтложенногоПроведения());
	
	Возврат ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	
КонецФункции

Функция НовыеДанныеОВидахОплат()
	
	Данные = Новый Структура;
	Данные.Вставить("ВидОплатыПоУмолчанию",      Справочники.ВидыОплатОрганизаций.ПустаяСсылка());
	Данные.Вставить("ТребуетсяВыбратьВидОплаты", Ложь);
	Возврат Данные;
	
КонецФункции

#КонецОбласти

#КонецЕсли
