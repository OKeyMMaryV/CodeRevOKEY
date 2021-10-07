﻿////////////////////////////////////////////////////////////////////////////////
// ОбменСБанкамиСлужебныйПовтИсп: механизм обмена электронными документами с банками.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Заполняет массив актуальными видами электронных документов.
//
// Возвращаемое значение:
//  Массив - виды актуальных ЭД.
//
Функция АктуальныеВидыЭД() Экспорт
	
	МассивЭД = Новый Массив;
	ОбменСБанкамиПереопределяемый.ПолучитьАктуальныеВидыЭД(МассивЭД);
	
	МассивЭД.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросНаОтзывЭД);
	
	// Служебные виды ЭД требуются для добавления в сертификат
	МассивЭД.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросОСостоянииЭД);
	МассивЭД.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросЗонд);
	
	МассивВозврата = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивЭД);
	
	Возврат МассивВозврата;
	
КонецФункции

// Возвращает список видов документов, которые могут подписываться по пользовательскому маршруту.
//
// Параметры:
//  ТолькоСоСложнымМаршрутом - Булево - если Истина, будут возвращены только те виды, которым можно назначить маршрут
//                                      со сложными правилами подписания.
// 
// Возвращаемое значение:
//  Массив - содержит элементы типа "Перечисление.ВидыЭДОбменСБанками".
//
Функция ВидыДокументовПодписываемыхПоМаршруту(ТолькоСоСложнымМаршрутом = Истина) Экспорт

	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыЭДОбменСБанками.ПлатежноеПоручение);
	Результат.Добавить(Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПереводВалюты);
	Результат.Добавить(Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПокупкуВалюты);
	Результат.Добавить(Перечисления.ВидыЭДОбменСБанками.ПоручениеНаПродажуВалюты);
	Результат.Добавить(Перечисления.ВидыЭДОбменСБанками.РаспоряжениеНаОбязательнуюПродажуВалюты);
	Результат.Добавить(Перечисления.ВидыЭДОбменСБанками.ПлатежноеТребование);
	Результат.Добавить(Перечисления.ВидыЭДОбменСБанками.Письмо);
	
	Если Не ТолькоСоСложнымМаршрутом Тогда
		Результат.Добавить(Перечисления.ВидыЭДОбменСБанками.ЗапросНаОтзывЭД);
	КонецЕсли;
	
	Возврат Результат;

КонецФункции 

// Возвращает текст программы с указанием версии, используемой для обмена с банком.
//
// Параметры:
//  КоличествоСимволов - Число - ограничение на количество символов по версии программы, по умолчанию 100.
//
// Возвращаемое значение:
//  Строка - текст программы с указанием версии.
//
Функция ВерсияПрограммыКлиентаДляБанка(КоличествоСимволов = 100) Экспорт
	
	ВерсияПрограммы = СтрШаблон(НСтр("ru = '1С - БЭД: %1; %2: %3'"),
		ОбновлениеИнформационнойБазыБЭД.ВерсияБиблиотеки(),
		Метаданные.Имя,
		бит_ОбщегоНазначения.МетаданныеВерсия());

	Если КоличествоСимволов > 0 Тогда
		ВерсияПрограммы = Лев(ВерсияПрограммы, КоличествоСимволов);
	КонецЕсли;
	
	Возврат СокрЛП(ВерсияПрограммы);
	
КонецФункции

// Возвращает данные по банкам, поддерживающих прямой обмен.
//
// Возвращаемое значение:
//   ТабличныйДокумент - содержит данные по банкам.
//
Функция СписокБанков() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИспользуетсяТестовыйРежим = Ложь;
	ОбменСБанкамиПереопределяемый.ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим);
	
	Если ИспользуетсяТестовыйРежим Тогда
		Макет = Справочники.НастройкиОбменСБанками.ПолучитьМакет("СписокБанковВТестовомРежиме");
		Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
	Иначе
		ДанныеВнешнихФайлов = Константы.ОбщиеФайлыОбменСБанками.Получить().Получить();
		Если ДанныеВнешнихФайлов = Неопределено ИЛИ НЕ ДанныеВнешнихФайлов.Свойство("СписокБанков")
				ИЛИ ДанныеВнешнихФайлов.СписокБанков = Неопределено Тогда  // список еще не подкачивался из интернета
			Макет = Справочники.НастройкиОбменСБанками.ПолучитьМакет("СписокБанков");
			Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
		Иначе
			Попытка
				ВремФайл = ПолучитьИмяВременногоФайла("mxl");
				ДанныеВнешнихФайлов.СписокБанков.Записать(ВремФайл);
				Макет = Новый ТабличныйДокумент;
				Макет.Прочитать(ВремФайл);
				ФайловаяСистема.УдалитьВременныйФайл(ВремФайл);
			Исключение
				// Если не удалось прочитать файл, то берем список из конфигурации
				ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
				ВидОперации = НСтр("ru = 'Чтение списка банков сервиса 1С:ДиректБанк из скачанного файла.'");
				ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ТекстОшибки, , "ОбменСБанками");
				Макет = Справочники.НастройкиОбменСБанками.ПолучитьМакет("СписокБанков");
				Макет.КодЯзыка = Метаданные.Языки.Русский.КодЯзыка;
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;

	Возврат Макет;
	
КонецФункции

// Получение фабрики XDTO в соответствии с версией схемы асинхронного обмена.
//
// Параметры:
//  ВерсияФормата - Строка - версия схемы.
// 
// Возвращаемое значение:
//  ФабрикаXDTO - фабрика, созданная на основании схемы.
//
Функция ФабрикаAsyncXDTO(ВерсияФормата) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВерсииСхемАсинхронногоОбмена = ВерсииСхемАсинхронногоОбмена();
	ТекущаяСхема = ВерсииСхемАсинхронногоОбмена.Получить(ВерсияФормата);
	
	// Если версия схемы не известна конфигурации, то идет попытка чтения по актуальной версии
	Если ТекущаяСхема = Неопределено Тогда
		ВерсияФормата = ОбменСБанкамиКлиентСервер.АктуальнаяВерсияФорматаАсинхронногоОбмена();
		ТекущаяСхема = ВерсииСхемАсинхронногоОбмена.Получить(ВерсияФормата);
	КонецЕсли;
	
	ДвоичныеДанныеСхемы = Обработки.ОбменСБанками.ПолучитьМакет(ТекущаяСхема);
	ВремФайлСхемы = ПолучитьИмяВременногоФайла("xsd");
	ДвоичныеДанныеСхемы.Записать(ВремФайлСхемы);
	Фабрика = СоздатьФабрикуXDTO(ВремФайлСхемы);
	ФайловаяСистема.УдалитьВременныйФайл(ВремФайлСхемы);
	Возврат Фабрика;
	
КонецФункции

// Создает объект для обмена с сервером Сбербанка
// 
// Возвращаемое значение:
// WSПрокси - Клиентский прокси для вызова веб-сервиса.
//
Функция WSПроксиСбербанк(Таймаут = 30) Экспорт
	
	URI = "http://upg.sbns.bssys.com/";
	ИмяСервиса = "UniversalPaymentGate";
	ИмяТочкиПодключения = "UniversalPaymentGateSbrfImplPort";
	
	ИспользуетсяТестовыйРежим = Ложь;
	ОбменСБанкамиПереопределяемый.ПроверитьИспользованиеТестовогоРежима(ИспользуетсяТестовыйРежим);
	Если ИспользуетсяТестовыйРежим Тогда
		Местоположение = "https://eduhfsms.testsbi.sberbank.ru:9443/sbns-upg/upg";
	КонецЕсли;
	
	Прокси = ЭлектронноеВзаимодействиеСлужебный.СформироватьПрокси("https");
	СертификатыУдостоверяющихЦентров = Новый СертификатыУдостоверяющихЦентровОС;
	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение( , СертификатыУдостоверяющихЦентров);
	
	Возврат Новый WSПрокси(WSОпределениеСбербанк(), URI, ИмяСервиса, ИмяТочкиПодключения, Прокси, Таймаут, ЗащищенноеСоединение, Местоположение);
	
КонецФункции

// Определяет название счета в метаданных
// 
// Возвращаемое значение:
//  Строка - название справочника банковских счетов организации.
//
Функция НазваниеСчетаВМетаданных() Экспорт
	
	ОписаниеТипаБанковскийСчет = Метаданные.ОпределяемыеТипы.СчетОрганизацииОбменСБанками.Тип;
	ТипСчет = ОписаниеТипаБанковскийСчет.Типы().Получить(0);
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипСчет);
	Возврат ОбъектМетаданных.Имя;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВерсииСхемАсинхронногоОбмена()
	
	СоответствиеВозврата = Новый Соответствие;
	СоответствиеВозврата.Вставить("2.01", "Схема201");
	СоответствиеВозврата.Вставить("2.02", "Схема202");
	СоответствиеВозврата.Вставить("2.03", "Схема203");
	СоответствиеВозврата.Вставить("2.1.1", "Схема211");
	СоответствиеВозврата.Вставить("2.1.2", "Схема212");
	СоответствиеВозврата.Вставить("2.2.1", "Схема221");
	Возврат СоответствиеВозврата;
	
КонецФункции

Функция WSОпределениеСбербанк()
	
	УстановитьПривилегированныйРежим(Истина);
	ВремФайл = ПолучитьИмяВременногоФайла("wsdl");
	ДвоичныеДанные = Обработки.ОбменСБанками.ПолучитьМакет("SBRFWSDL");
	ДвоичныеДанные.Записать(ВремФайл);
	Прокси = ЭлектронноеВзаимодействиеСлужебный.СформироватьПрокси("https");
	СертификатыУдостоверяющихЦентров = Новый СертификатыУдостоверяющихЦентровОС;
	ЗащищенноеСоединение = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение( , СертификатыУдостоверяющихЦентров);
	WSОпределение = Новый WSОпределения(ВремФайл, , , Прокси, 15, ЗащищенноеСоединение);
	ФайловаяСистема.УдалитьВременныйФайл(ВремФайл);
	Возврат WSОпределение;
	
КонецФункции

#КонецОбласти