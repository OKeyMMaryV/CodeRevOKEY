﻿#Область СлужебныйПрограммныйИнтерфейс

// Выполняет попытку обновления ключа сессии на сервере
// (на сервере предприятия должны быть установлены сертификаты для подписания и пароль).
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии) - Параметры запроса ключа сессии для организации для которой необходимо обновить ключ сессии.
// Возвращаемое значение:
// 	Булево - Истина, если обновление ключа сессии выполнено успешно.
Функция ОбновитьКлючСессииНаСервере(ПараметрыЗапроса) Экспорт
	
	СертификатыДляПодписанияНаСервере = ИнтерфейсАвторизацииИСМПСлужебный.СертификатыДляПодписанияНаСервере();
	Если СертификатыДляПодписанияНаСервере = Неопределено
		Или СертификатыДляПодписанияНаСервере.Сертификаты.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	РезультатЗапроса = ИнтерфейсАвторизацииИСМПВызовСервера.ЗапроситьПараметрыАвторизации(ПараметрыЗапроса);
	Если РезультатЗапроса.ПараметрыАвторизации = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ПараметрыЗапроса.Организация = Неопределено Тогда
		СтрокаСертификата = СертификатыДляПодписанияНаСервере.Сертификаты[0];
	Иначе
		СтрокаСертификата = СертификатыДляПодписанияНаСервере.Сертификаты.Найти(ПараметрыЗапроса.Организация, "Организация");
	КонецЕсли;
	
	Если СтрокаСертификата <> Неопределено Тогда
		
		// Для авторизации требуется прикрепленная подпись
		ПараметрыCMS = ЭлектроннаяПодпись.ПараметрыCMS();
		ПараметрыCMS.Открепленная = Ложь;
		
		СертификатыДляПодписанияНаСервере.МенеджерКриптографии.ПарольДоступаКЗакрытомуКлючу = СтрокаСертификата.Пароль;
		РезультатПодписания = ИнтерфейсАвторизацииИСМПСлужебный.Подписать(
			РезультатЗапроса.ПараметрыАвторизации.Данные,
			ПараметрыCMS,
			СтрокаСертификата.СертификатКриптографии,
			СертификатыДляПодписанияНаСервере.МенеджерКриптографии);
		
	КонецЕсли;
	
	Если СтрокаСертификата = Неопределено
		Или Не РезультатПодписания.Успех Тогда
		
		Возврат Ложь;
		
	Иначе
		
		Возврат ЗапроситьУстановитьКлючСессии(
			ПараметрыЗапроса,
			РезультатЗапроса.ПараметрыАвторизации,
			РезультатПодписания.Подпись).КлючСессииУстановлен;
		
	КонецЕсли;
	
КонецФункции

// Запрашивает ключ сессии и установливает его в параметры сеанса.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии) - Параметры запроса ключа сессии для организации для которой необходимо обновить ключ сессии.
// 	ПараметрыАвторизации - (См. ИнтерфейсАвторизацииИСМПСлужебный.ПараметрыАвторизации).
// 	Подпись - Строка - Подпись.
// Возвращаемое значение:
// 	Булево - Ключ сессии успешно запрошен и установлен
Функция ЗапроситьУстановитьКлючСессии(ПараметрыЗапроса, ПараметрыАвторизации, Подпись) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("КлючСессииУстановлен", Ложь);
	ВозвращаемоеЗначение.Вставить("ТекстОшибки",          "");
	
	СвойстваПодписи = Новый Структура("Подпись", Подпись);
	
	ПараметрыЗапросаПоОрганизации = Новый Структура;
	ПараметрыЗапросаПоОрганизации.Вставить("ПараметрыЗапроса",     ПараметрыЗапроса);
	ПараметрыЗапросаПоОрганизации.Вставить("ПараметрыАвторизации", ПараметрыАвторизации);
	ПараметрыЗапросаПоОрганизации.Вставить("СвойстваПодписи",      СвойстваПодписи);
	
	РезультатЗапросаКлючаСессии = ИнтерфейсАвторизацииИСМПВызовСервера.ЗапроситьКлючСессии(ПараметрыЗапросаПоОрганизации);
	Если РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии <> Неопределено Тогда
		
		ИнтерфейсАвторизацииИСМПСлужебный.УстановитьКлючСессии(
			ПараметрыЗапросаПоОрганизации.ПараметрыЗапроса,
			РезультатЗапросаКлючаСессии.ПараметрыКлючаСессии);
		
		ВозвращаемоеЗначение.КлючСессииУстановлен = Истина;
		
		Возврат ВозвращаемоеЗначение;
		
	Иначе
		
		ВозвращаемоеЗначение.КлючСессииУстановлен = Ложь;
		ВозвращаемоеЗначение.ТекстОшибки          = РезультатЗапросаКлючаСессии.ТекстОшибки;
		
		Возврат ВозвращаемоеЗначение;
		
	КонецЕсли;
	
КонецФункции

Процедура УстановитьКлючСессии(ПараметрыЗапроса, ПараметрыКлючаСессии) Экспорт
	
	Попытка
		ДанныеКлючаСессии = ПараметрыСеанса[ПараметрыЗапроса.ИмяПараметраСеанса].Получить();
	Исключение
		ДанныеКлючаСессии = Неопределено;
	КонецПопытки;
	
	Если ДанныеКлючаСессии = Неопределено Тогда
		ДанныеКлючаСессии = Новый Соответствие;
	КонецЕсли;
	
	ДанныеКлючаСессии.Вставить(ПараметрыЗапроса.Организация, ПараметрыКлючаСессии);
	
	ПараметрыСеанса[ПараметрыЗапроса.ИмяПараметраСеанса] = Новый ХранилищеЗначения(ДанныеКлючаСессии);
	
КонецПроцедуры

// Возвращает ключ сессии для обмена с МОТП.
// 
// Параметры:
// 	ПараметрыЗапроса - (См. ИнтерфейсАвторизацииИСМПКлиентСервер.ПараметрыЗапросаКлючаСессии) - Параметры запроса ключа сессии.
// 	СрокДейтвия      - Дата, Неопределено - Срок действия ключа сессии.
// Возвращаемое значение:
// 	Строка, Неопределено - Действующий ключ сессии для организации.
Функция ПроверитьОбновитьКлючСессии(ПараметрыЗапроса, Знач СрокДействия = Неопределено, ОбновлятьКлючСессииНаСервере = Истина) Экспорт
	
	КлючСессии = ИнтерфейсАвторизацииИСМПВызовСервера.ТекущийКлючСессии(ПараметрыЗапроса, СрокДействия);
	
	ТребуетсяОбновлениеКлючаСессии = (КлючСессии = Неопределено);
	
	Если ТребуетсяОбновлениеКлючаСессии
		И ОбновлятьКлючСессииНаСервере
		И ИнтерфейсАвторизацииИСМПСлужебный.ОбновитьКлючСессииНаСервере(ПараметрыЗапроса) Тогда
		КлючСессии = ИнтерфейсАвторизацииИСМПВызовСервера.ТекущийКлючСессии(ПараметрыЗапроса);
	КонецЕсли;
	
	Возврат КлючСессии;
	
КонецФункции

// Возвращает структуру данных запроса авторизации
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Параметры авторизации:
// * Идентификатор - Строка - Идентификатор запроса
// * Данные        - Строка - Данные для подписания
Функция ПараметрыАвторизации() Экспорт
	
	ПараметрыАвторизации = Новый Структура;
	ПараметрыАвторизации.Вставить("Идентификатор");
	ПараметрыАвторизации.Вставить("Данные");
	
	Возврат ПараметрыАвторизации;
	
КонецФункции

// Возвращает структуру данных ключа сессии обмена с МОТП.
// 
// Параметры:
// Возвращаемое значение:
// 	Структура - Параметры ключа сессии:
// * КлючСессии  - Строка - Ключ сессии.
// * ДействуетДо - Дата   - Дата и время окончания действия ключа сессии.
Функция ПараметрыКлючаСессии() Экспорт
	
	ПараметрыКлючаСессии = Новый Структура;
	ПараметрыКлючаСессии.Вставить("КлючСессии",  "");
	ПараметрыКлючаСессии.Вставить("ДействуетДо", '00010101');
	
	Возврат ПараметрыКлючаСессии;
	
КонецФункции

#Область ЭлектроннаяПодпись

// Получает сертификаты организаций, для предназначены для подписания на сервере.
// 
// Возвращаемое значение:
//  Структура - Структура со свойствами:
//   * Сертификаты - ТаблицаЗначений - содержит сертификат и пароль.
//   * МенеджерКриптографии - МенеджерКриптографии - менеджер криптографии.
//
Функция СертификатыДляПодписанияНаСервере() Экспорт
	
	НастройкиОбмена = ИнтеграцияИС.НастройкиОбменаГосИС();
	
	Если НастройкиОбмена = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.Организация КАК Организация,
	|	Т.Сертификат  КАК Сертификат
	|ПОМЕСТИТЬ ТаблицаДанных
	|ИЗ
	|	&Таблица КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДанных.Организация          КАК Организация,
	|	ТаблицаДанных.Сертификат           КАК Сертификат,
	|	ТаблицаДанных.Сертификат.Отпечаток КАК Отпечаток
	|ИЗ
	|	ТаблицаДанных КАК ТаблицаДанных
	|");
	
	Запрос.УстановитьПараметр("Таблица", НастройкиОбмена);
	
	ДанныеСертификатовИзНастроекОбмена = Запрос.Выполнить().Выгрузить();
	
	СертификатыОрганизацийДляОбменаНаСервере = Новый ТаблицаЗначений();
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Организация");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Сертификат");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Отпечаток");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("СертификатКриптографии");
	СертификатыОрганизацийДляОбменаНаСервере.Колонки.Добавить("Пароль");
	
	Для Каждого ДанныеСертификата Из ДанныеСертификатовИзНастроекОбмена Цикл
		
		Пароль = ИнтеграцияИС.ПарольКСертификату(ДанныеСертификата.Сертификат);
		
		СертификатКриптографии = ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(ДанныеСертификата.Отпечаток, Ложь, Ложь);
		Если СертификатКриптографии = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТЧ = СертификатыОрганизацийДляОбменаНаСервере.Добавить();
		СтрокаТЧ.Организация            = ДанныеСертификата.Организация;
		СтрокаТЧ.Сертификат             = ДанныеСертификата.Сертификат;
		СтрокаТЧ.Отпечаток              = ДанныеСертификата.Отпечаток;
		СтрокаТЧ.СертификатКриптографии = СертификатКриптографии;
		Если Пароль <> Неопределено Тогда
			СтрокаТЧ.Пароль = Пароль;
		Иначе
			СтрокаТЧ.Пароль = "";
		КонецЕсли;
		
	КонецЦикла;
	
	Если СертификатыОрганизацийДляОбменаНаСервере.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МенеджерКриптографии = ЭлектроннаяПодпись.МенеджерКриптографии("Подписание", Ложь);
	
	СертификатыДляПодписанияНаСервере = Новый Структура;
	СертификатыДляПодписанияНаСервере.Вставить("Сертификаты",          СертификатыОрганизацийДляОбменаНаСервере);
	СертификатыДляПодписанияНаСервере.Вставить("МенеджерКриптографии", МенеджерКриптографии);
	
	Возврат СертификатыДляПодписанияНаСервере;
	
КонецФункции

// Подписать сообщение XML
//
// Параметры:
//  ТекстСообщенияXML - Строка - Подписываемое сообщение XML
//  СертификатКриптографии - Сертификат криптографии
//  ПараметрыCMS - (См. ЭлектроннаяПодпись.ПараметрыCMS) - Параметры подписи
//  МенеджерКриптографии - Менеджер криптографии.
// 
// Возвращаемое значение:
//  Структура - со свойствами:
//   * Успех       - Булево - Признак успешности подписания.
//   * КонвертSOAP - Строка - Конверт SOAP.
//   * ТекстОшибки - Строка - Текст ошибки.
//
Функция Подписать(ДанныеДляПодписания, ПараметрыCMS, СертификатКриптографии, МенеджерКриптографии) Экспорт
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("Успех");
	ВозвращаемоеЗначение.Вставить("Подпись");
	ВозвращаемоеЗначение.Вставить("ТекстОшибки");
	
	Попытка
		
		Подпись = ЭлектроннаяПодписьСлужебный.ПодписатьCMS(
			ДанныеДляПодписания,
			ПараметрыCMS,
			СертификатКриптографии, МенеджерКриптографии);
		
		ВозвращаемоеЗначение.Успех   = Истина;
		ВозвращаемоеЗначение.Подпись = Подпись;
		
	Исключение
		
		ВозвращаемоеЗначение.Успех       = Ложь;
		ВозвращаемоеЗначение.ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

#КонецОбласти

#КонецОбласти