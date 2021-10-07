﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИС.ОтработатьВходящийДокументПротоколаОбмена(ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	ЗаполнитьДеревоФайлов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИнтеграцияИСКлиент.РазвернутьДеревоРекурсивно(ДеревоФайлов, Элементы.ДеревоФайлов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ПерезаполнитьДерево = Ложь;
	
	Если ИмяСобытия = "#ГИСМ#ИзменениеСостоянияГИСМ"
		И (Параметр.Ссылка = Документ Или Параметр.Основание = Документ) Тогда
		
		ПерезаполнитьДерево = Истина;
		
	ИначеЕсли ИмяСобытия = "#ГИСМ#ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		ПерезаполнитьДерево = Истина;
		
	КонецЕсли;
	
	Если ПерезаполнитьДерево Тогда
		ОбновитьДерево();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапки

&НаКлиенте
Процедура ДеревоФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИнтеграцияИСКлиент.ПоказатьСообщенияОперации(ЭтотОбъект, "ГИСМ", ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСообщенияXML(Команда)
	
	ИнтеграцияИСКлиент.ПоказатьСообщенияОперации(ЭтотОбъект, "ГИСМ", Элементы.ДеревоФайлов.ТекущаяСтрока, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ДанныеСтроки = Элементы.ДеревоФайлов.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если    ДанныеСтроки.Операция = ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаАннулирования")
		Или ДанныеСтроки.Операция = ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки")
		Или ДанныеСтроки.Операция = ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаПодтверждения") Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
		ДанныеСтроки.Документ,
		ДанныеСтроки.Операция);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьЗаявку(Команда)
	
	ДанныеСтроки = Элементы.ДеревоФайлов.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
		ДанныеСтроки.Документ,
		ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки"));
	
КонецПроцедуры

&НаКлиенте
Процедура Аннулировать(Команда)
	
	ДанныеСтроки = Элементы.ДеревоФайлов.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
		ДанныеСтроки.Документ,
		ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаАннулирования"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПолучение(Команда)
	
	ДанныеСтроки = Элементы.ДеревоФайлов.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДокументыКПодтверждению = Новый Массив;
	ДокументыКПодтверждению.Добавить(ДанныеСтроки.Документ);
	ПараметрыФормы = Новый Структура("ДокументыКПодтверждению", ДокументыКПодтверждению);
	ОткрытьФорму(
		"Обработка.ПодтверждениеПоступившихКиЗГИСМ.Форма.Форма",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ПодтвердитьПоступление_ПослеПолученияДокументовКПодтверждению", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
// Обработчик завершения выбора пользователем документов к подтверждению.
//
// Параметры:
//  ДокументыКПодтверждению - СписокЗначений - список документов, по которым передаются подтверждения.
//  ДополнительныеПараметры - Структура - содержит дополнительные параметры обработчика.
//
Процедура ПодтвердитьПоступление_ПослеПолученияДокументовКПодтверждению(ДокументыКПодтверждению, ДополнительныеПараметры) Экспорт
	
	Если ДокументыКПодтверждению = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДокументыКПодтверждению.Количество() = 1 Тогда
		
		ИнтеграцияГИСМКлиент.ПодготовитьСообщениеКПередаче(
			ДокументыКПодтверждению[0],
			ПредопределенноеЗначение("Перечисление.ОперацииОбменаГИСМ.ПередачаПодтверждения"));
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'В форме протокола обмена подтверждение получения по нескольким документам не поддерживается.'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДерево()
	
	ЗаполнитьДеревоФайлов();
	ИнтеграцияИСКлиент.РазвернутьДеревоРекурсивно(ДеревоФайлов, Элементы.ДеревоФайлов);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ИнтеграцияИС.УстановитьУсловноеОформлениеПротоколаОбмена(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеОперации(Операция, ДокументСсылка, ВыборкаПоФайлам = Неопределено)
	
	//ГИСМБП
	// Исключена обработка документов:
	// - ЗаявкаНаВыпускКиЗГИСМ
	// - МаркировкаТоваровГИСМ
	//Конец ГИСМБП
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных Тогда
		
		Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ") Тогда
			
			Если ВыборкаПоФайлам = Неопределено Тогда
				Возврат НСтр("ru = 'Передача уведомления об отгрузке маркированной продукции'");
			Иначе
				Возврат СтрШаблон(НСтр("ru = 'Передача уведомления об отгрузке маркированной продукции, Версия %1'"), ВыборкаПоФайлам.Версия);
			КонецЕсли;
			
		Иначе
			
			ПредставлениеОбъекта = ДокументСсылка.Метаданные().Синоним;
			
			Если ВыборкаПоФайлам = Неопределено Тогда
				Возврат СтрШаблон(НСтр("ru = 'Передача документа ""%1""'"), ПредставлениеОбъекта);
			Иначе
				Возврат СтрШаблон(НСтр("ru = 'Передача документа ""%1"", Версия %2'"), ПредставлениеОбъекта, ВыборкаПоФайлам.Версия);
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПолучениеТоваров Тогда
		
		Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.УведомлениеОПоступленииМаркированныхТоваровГИСМ") Тогда
			Возврат НСтр("ru = 'Уведомление о поступлении маркированных товаров'");
		КонецЕсли;
		
		//ГИСМБП
		// Исключена обработка документов:
		// - ЗаявкаНаВыпускКиЗГИСМ
		//Конец ГИСМБП
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПолучениеНовогоСтатуса Тогда
		
		Возврат СтрШаблон(НСтр("ru = 'Обновлено состояние: %1'"), ВыборкаПоФайлам.СтатусОбработкиЭмитентом);
		
	ИначеЕсли ИнтеграцияГИСМ.ОперацииПередачиДанных().Найти(Операция) <> Неопределено Тогда
		
		Если ВыборкаПоФайлам = Неопределено Тогда
			Возврат ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(Операция, Неопределено, Неопределено);
		Иначе
			Возврат ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(Операция, Неопределено, ВыборкаПоФайлам.Версия);
		КонецЕсли;
		
	Иначе
		
		Возврат Строка(Операция);
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ТаблицаДокументы(Документ = Неопределено)
	
	МассивТиповСтатусов = Новый Массив;
	МассивТиповСтатусов.Добавить(Тип("ПеречислениеСсылка.СтатусыЗаявокНаВыпускКиЗГИСМ"));
	МассивТиповСтатусов.Добавить(Тип("ПеречислениеСсылка.СтатусыИнформированияГИСМ"));
	МассивТиповСтатусов.Добавить(Тип("ПеречислениеСсылка.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ"));
	МассивТиповСтатусов.Добавить(Тип("ПеречислениеСсылка.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ"));
	
	ТаблицаДокументы = Новый ТаблицаЗначений;
	ТаблицаДокументы.Колонки.Добавить("Ссылка",             Метаданные.ОпределяемыеТипы.ВладелецПрисоединенныхФайловГИСМ.Тип);
	ТаблицаДокументы.Колонки.Добавить("Статус",             Новый ОписаниеТипов(МассивТиповСтатусов));
	ТаблицаДокументы.Колонки.Добавить("ДальнейшееДействие", Новый ОписаниеТипов("ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюГИСМ"));
	
	Если Документ <> Неопределено Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	&ДокументСсылка                 КАК Ссылка,
		|	Таблица.СтатусЗаявкиНаВыпускКиЗ КАК Статус,
		|	Таблица.ДальнейшееДействие      КАК ДальнейшееДействие
		|ИЗ
		|	РегистрСведений.СтатусыЗаявокНаВыпускКиЗГИСМ КАК Таблица
		|ГДЕ
		|	Таблица.ТекущаяЗаявкаНаВыпускКиЗ = &ДокументСсылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ДокументСсылка            КАК Ссылка,
		|	Таблица.Статус             КАК Статус,
		|	Таблица.ДальнейшееДействие КАК ДальнейшееДействие
		|ИЗ
		|	РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ КАК Таблица
		|ГДЕ
		|	Таблица.ТекущееУведомлениеОбОтгрузке = &ДокументСсылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ДокументСсылка            КАК Ссылка,
		|	Таблица.Статус             КАК Статус,
		|	Таблица.ДальнейшееДействие КАК ДальнейшееДействие
		|ИЗ
		|	РегистрСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ КАК Таблица
		|ГДЕ
		|	Таблица.Документ = &ДокументСсылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	&ДокументСсылка            КАК Ссылка,
		|	Таблица.Статус             КАК Статус,
		|	Таблица.ДальнейшееДействие КАК ДальнейшееДействие
		|ИЗ
		|	РегистрСведений.СтатусыИнформированияГИСМ КАК Таблица
		|ГДЕ
		|	Таблица.Документ = &ДокументСсылка
		|	ИЛИ Таблица.ТекущееУведомление = &ДокументСсылка
		|");
		
		УстановитьПривилегированныйРежим(Истина);
		Запрос.УстановитьПараметр("ДокументСсылка", Документ);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			НоваяСтрока = ТаблицаДокументы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаДокументы;
	
КонецФункции

#Область ЗаполнениеДереваФайлов

//ГИСМБП
// Исключена обработка документов:
// - ЗаявкаНаВыпускКиЗГИСМ
// - МаркировкаТоваровГИСМ
//Конец ГИСМБП

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаУведомлениеОСписанииКиЗ(Основание)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаДокументы.Ссылка                      КАК Ссылка,
	|	СтатусыИнформированияГИСМ.Статус             КАК Статус,
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие КАК ДальнейшееДействие
	|ИЗ
	|	Документ.УведомлениеОСписанииКиЗГИСМ КАК ТаблицаДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|		ПО СтатусыИнформированияГИСМ.ТекущееУведомление = ТаблицаДокументы.Ссылка
	|ГДЕ
	|	ТаблицаДокументы.Основание = &Основание
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаДокументы.Дата");
	
	Запрос.УстановитьПараметр("Основание", Основание);
	
	ТаблицаДокументы = ТаблицаДокументы();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	ПоследовательностьОпераций = Новый Массив;
	ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
	
	ЗаполнитьПоДокументу(ТаблицаДокументы, ПоследовательностьОпераций, Неопределено, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументовИмпорта(Основание)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаДокументы.Ссылка КАК Ссылка,
	|	ТаблицаДокументы.Дата КАК Дата
	|ПОМЕСТИТЬ ТаблицаДокументы
	|ИЗ
	|	Документ.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ КАК ТаблицаДокументы
	|ГДЕ
	|	ТаблицаДокументы.Основание = &Основание
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокументы.Ссылка,
	|	ТаблицаДокументы.Дата
	|ИЗ
	|	Документ.УведомлениеОбИмпортеМаркированныхТоваровГИСМ КАК ТаблицаДокументы
	|ГДЕ
	|	ТаблицаДокументы.Основание = &Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокументы.Ссылка                      КАК Ссылка,
	|	СтатусыИнформированияГИСМ.Статус             КАК Статус,
	|	СтатусыИнформированияГИСМ.ДальнейшееДействие КАК ДальнейшееДействие
	|ИЗ
	|	ТаблицаДокументы КАК ТаблицаДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыИнформированияГИСМ КАК СтатусыИнформированияГИСМ
	|		ПО СтатусыИнформированияГИСМ.ТекущееУведомление = ТаблицаДокументы.Ссылка
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаДокументы.Дата");
	
	Запрос.УстановитьПараметр("Основание", Основание);
	
	ТаблицаДокументы = ТаблицаДокументы();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	ПоследовательностьОпераций = Новый Массив;
	ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
	
	ЗаполнитьПоДокументу(ТаблицаДокументы, ПоследовательностьОпераций, Неопределено, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОснованиюДокументаУведомлениеОбОтгрузке(Основание)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаДокументы.Ссылка                                                 КАК Ссылка,
	|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.Статус             КАК Статус,
	|	СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ДальнейшееДействие КАК ДальнейшееДействие
	|ИЗ
	|	Документ.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ КАК ТаблицаДокументы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ КАК СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ
	|		ПО СтатусыУведомленийОбОтгрузкеМаркированныхТоваровГИСМ.ТекущееУведомлениеОбОтгрузке = ТаблицаДокументы.Ссылка
	|ГДЕ
	|	ТаблицаДокументы.Основание = &Основание
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТаблицаДокументы.Дата");
	
	Запрос.УстановитьПараметр("Основание", Основание);
	
	ТаблицаДокументы = ТаблицаДокументы();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТаблицаДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	ПоследовательностьОпераций = Новый Массив;
	ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
	ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПолучениеПодтверждения);
	ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПолучениеЗакрытияЗаявки);
	
	ЗаполнитьПоДокументу(ТаблицаДокументы, ПоследовательностьОпераций, Неопределено, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДокументу(ТаблицаДокументы, ПоследовательностьОпераций, ПоследовательностьОперацийОбработкиЭмитентом, ОтображатьСИерархией = Ложь)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВременнаяТаблицаДокументы.Ссылка             КАК Ссылка,
	|	ВременнаяТаблицаДокументы.Статус             КАК Статус,
	|	ВременнаяТаблицаДокументы.ДальнейшееДействие КАК ДальнейшееДействие
	|ПОМЕСТИТЬ ВременнаяТаблицаДокументы
	|ИЗ
	|	&ТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ГИСМПрисоединенныеФайлы.ВладелецФайла                     КАК Документ,
	|	ГИСМПрисоединенныеФайлы.Ссылка                            КАК Ссылка,
	|	ГИСМПрисоединенныеФайлы.ТипСообщения                      КАК ТипСообщения,
	|	ГИСМПрисоединенныеФайлы.Операция                          КАК Операция,
	|	ГИСМПрисоединенныеФайлы.СообщениеОснование                КАК СообщениеОснование,
	|	ГИСМПрисоединенныеФайлы.СообщениеОснованиеСтатусОбработки КАК СообщениеОснованиеСтатусОбработки,
	|	ГИСМПрисоединенныеФайлы.ДатаСоздания                      КАК ДатаСоздания,
	|	ГИСМПрисоединенныеФайлы.Версия                            КАК Версия,
	|	ГИСМПрисоединенныеФайлы.СтатусОбработкиЭмитентом          КАК СтатусОбработкиЭмитентом
	|ПОМЕСТИТЬ Сообщения
	|ИЗ
	|	Справочник.ГИСМПрисоединенныеФайлы КАК ГИСМПрисоединенныеФайлы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|		ПО ГИСМПрисоединенныеФайлы.ВладелецФайла = ВременнаяТаблицаДокументы.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сообщения.Документ     КАК Документ,
	|	Сообщения.Ссылка       КАК Ссылка,
	|	Сообщения.ДатаСоздания КАК ДатаСоздания
	|ПОМЕСТИТЬ ИсходящиеСообщения
	|ИЗ
	|	Сообщения КАК Сообщения
	|ГДЕ
	|	Сообщения.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|	И Сообщения.Операция В (&МассивОперацииПередачиДанных)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПередачаДанных.Документ КАК Документ,
	|
	|	ПередачаДанных.Ссылка                                                       КАК Запрос,
	|	ПередачаДанных.ДатаСоздания                                                 КАК ЗапросДатаСоздания,
	|
	|	ЕСТЬNULL(ОтветНаПередачуДанных.Ссылка, &ПустаяСсылка)                           КАК ОтветНаЗапрос,
	|	ЕСТЬNULL(ОтветНаПередачуДанных.ДатаСоздания, ДатаВремя(1,1,1))                  КАК ОтветНаЗапросДатаСоздания,
	|	ЕСТЬNULL(ОтветНаПередачуДанных.СообщениеОснованиеСтатусОбработки, Неопределено) КАК ОтветНаЗапросСостояниеОбработки,
	|
	|	ЕСТЬNULL(ЗапросКвитанция.Ссылка, &ПустаяСсылка)                             КАК ЗапросКвитанции,
	|	ЕСТЬNULL(ЗапросКвитанция.ДатаСоздания, &ПустаяСсылка)                       КАК ЗапросКвитанцииДатаСоздания,
	|
	|	ЕСТЬNULL(ОтветКвитанция.Ссылка, &ПустаяСсылка)                              КАК ОтветНаЗапросКвитанции,
	|	ЕСТЬNULL(ОтветКвитанция.ДатаСоздания, &ПустаяСсылка)                        КАК ОтветНаЗапросКвитанцииДатаСоздания,
	|	ЕСТЬNULL(ОтветКвитанция.СообщениеОснованиеСтатусОбработки, Неопределено) КАК ОтветНаЗапросКвитанцииСостояниеОбработки
	|ИЗ
	|	ИсходящиеСообщения КАК ПередачаДанных
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК ОтветНаПередачуДанных
	|		ПО ПередачаДанных.Ссылка = ОтветНаПередачуДанных.СообщениеОснование
	|			И (ОтветНаПередачуДанных.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Входящее))
	|	
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК ЗапросКвитанция
	|		ПО ОтветНаПередачуДанных.Ссылка = ЗапросКвитанция.СообщениеОснование
	|			И (ЗапросКвитанция.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее))
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК ОтветКвитанция
	|		ПО ЗапросКвитанция.Ссылка = ОтветКвитанция.СообщениеОснование
	|			И (ОтветКвитанция.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Входящее))
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПередачаДанных.ДатаСоздания ВОЗР,
	|	ЕСТЬNULL(ОтветНаПередачуДанных.ДатаСоздания, ДатаВремя(1,1,1)) УБЫВ, // ОтветНаЗапросДатаСоздания
	|	ЕСТЬNULL(ЗапросКвитанция.ДатаСоздания, &ПустаяСсылка) УБЫВ,          // ЗапросКвитанцииДатаСоздания
	|	ЕСТЬNULL(ОтветКвитанция.ДатаСоздания, &ПустаяСсылка) УБЫВ            // ОтветНаЗапросКвитанцииДатаСоздания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВременнаяТаблицаДокументы.Ссылка                                                    КАК Документ,
	|	ВременнаяТаблицаДокументы.ДальнейшееДействие                                        КАК ДальнейшееДействие,
	|	ЕСТЬNULL(Запрос.Ссылка, ЗНАЧЕНИЕ(Справочник.ГИСМПрисоединенныеФайлы.ПустаяСсылка))  КАК Ссылка,
	|	ЕСТЬNULL(Запрос.Операция, &ПерваяОперация)                                          КАК Операция,
	|	ЕСТЬNULL(Запрос.ДатаСоздания, ДатаВремя(1,1,1))                                     КАК ДатаСоздания,
	|	ЕСТЬNULL(Запрос.Версия, 1)                                                          КАК Версия,
	|	ЕСТЬNULL(ОтветНаЗапрос.СтатусОбработкиЭмитентом, ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиЭмитентомКиЗГИСМ.ПустаяСсылка)) КАК СтатусОбработкиЭмитентом
	|ИЗ
	|	ВременнаяТаблицаДокументы КАК ВременнаяТаблицаДокументы
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК Запрос
	|		ПО Запрос.Документ = ВременнаяТаблицаДокументы.Ссылка
	|		И Запрос.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Исходящее)
	|		И Запрос.СообщениеОснование = ЗНАЧЕНИЕ(Справочник.ГИСМПрисоединенныеФайлы.ПустаяСсылка)
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ Сообщения КАК ОтветНаЗапрос
	|		ПО Запрос.Ссылка = ОтветНаЗапрос.СообщениеОснование
	|			И (ОтветНаЗапрос.ТипСообщения = ЗНАЧЕНИЕ(Перечисление.ТипыСообщенийГИСМ.Входящее))
	|УПОРЯДОЧИТЬ ПО
	|	Запрос.ДатаСоздания
	|ИТОГИ
	|	МАКСИМУМ(ЕСТЬNULL(Запрос.ДатаСоздания, ДатаВремя(1,1,1))) КАК ДатаСоздания
	|ПО
	|	ВременнаяТаблицаДокументы.Ссылка
	|");
	
	Запрос.УстановитьПараметр("ТаблицаДокументы",             ТаблицаДокументы);
	Запрос.УстановитьПараметр("ПустаяСсылка",                 Справочники.ГИСМПрисоединенныеФайлы.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПерваяОперация",               ПоследовательностьОпераций[0]);
	Запрос.УстановитьПараметр("МассивОперацииПередачиДанных", ИнтеграцияГИСМ.ОперацииПередачиДанных());
	
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаПоЗаявкамНаВыпускКиЗ = Результат[4].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПередачаДанных                       = Результат[3].Выгрузить();
	
	Пока ВыборкаПоЗаявкамНаВыпускКиЗ.Следующий() Цикл
		
		Если ОтображатьСИерархией Тогда
			СтрокаПервогоУровня = ДеревоФайлов.ПолучитьЭлементы().Добавить();
			СтрокаПервогоУровня.Документ = ВыборкаПоЗаявкамНаВыпускКиЗ.Документ;
			СтрокаПервогоУровня.Представление = ВыборкаПоЗаявкамНаВыпускКиЗ.Документ;
			СтрокаПервогоУровня.ИндексКартинки = 5;
		Иначе
			СтрокаПервогоУровня = ДеревоФайлов;
		КонецЕсли;
		
		ПоследняяОперация                 = Неопределено;
		ПоследнееСтатусОбработкиЭмитентом = Неопределено;
		
		ВыборкаПоФайлам = ВыборкаПоЗаявкамНаВыпускКиЗ.Выбрать();
		Пока ВыборкаПоФайлам.Следующий() Цикл
			
			ПоследняяОперация                 = ВыборкаПоФайлам.Операция;
			ПоследнееСтатусОбработкиЭмитентом = ВыборкаПоФайлам.СтатусОбработкиЭмитентом;
			
			СтрокаВторогоУровня = СтрокаПервогоУровня.ПолучитьЭлементы().Добавить();
			СтрокаВторогоУровня.Документ       = ВыборкаПоФайлам.Документ;
			СтрокаВторогоУровня.Файл           = ВыборкаПоФайлам.Ссылка;
			СтрокаВторогоУровня.Операция       = ВыборкаПоФайлам.Операция;
			СтрокаВторогоУровня.Дата           = ВыборкаПоФайлам.ДатаСоздания;
			СтрокаВторогоУровня.Представление  = ПредставлениеОперации(ВыборкаПоФайлам.Операция, ВыборкаПоФайлам.Документ, ВыборкаПоФайлам);
			СтрокаВторогоУровня.ИндексКартинки = ИндексКартинки(ВыборкаПоФайлам.Операция);
			
			ОбработатьПередачуДанных(ВыборкаПоФайлам, СтрокаВторогоУровня, ПередачаДанных);
			
		КонецЦикла;
		
		Если ПоследняяОперация = Перечисления.ОперацииОбменаГИСМ.ПолучениеНовогоСтатуса
			И ПоследовательностьОперацийОбработкиЭмитентом <> Неопределено Тогда
			
			Индекс = ПоследовательностьОперацийОбработкиЭмитентом.Найти(ПоследнееСтатусОбработкиЭмитентом);
			Если Индекс <> Неопределено Тогда
				
				Для Итератор = Индекс + 1 По ПоследовательностьОперацийОбработкиЭмитентом.Количество() - 1 Цикл
					
					СтатусОбработкиЭмитентом = ПоследовательностьОперацийОбработкиЭмитентом.Получить(Итератор);
					
					СтрокаВторогоУровня = СтрокаПервогоУровня.ПолучитьЭлементы().Добавить();
					СтрокаВторогоУровня.Документ                 = ВыборкаПоЗаявкамНаВыпускКиЗ.Документ;
					СтрокаВторогоУровня.Операция                 = ПоследняяОперация;
					СтрокаВторогоУровня.СтатусОбработкиЭмитентом = СтатусОбработкиЭмитентом;
					СтрокаВторогоУровня.УсловноеОформление       = "УсловноеОформлениеСерый";
					СтрокаВторогоУровня.Представление            = ПредставлениеОперации(СтрокаВторогоУровня.Операция, СтрокаВторогоУровня.Документ, СтрокаВторогоУровня);
					СтрокаВторогоУровня.ИндексКартинки           = ИндексКартинки(Перечисления.ОперацииОбменаГИСМ.ПолучениеНовогоСтатуса, Истина);
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
		ТребуетсяДальнейшееДействие = Истина;
		КоличествоДокументов = ТаблицаДокументы.Количество();
		Если КоличествоДокументов > 0 Тогда
			
			СтрокаТЧПоследнийДокумент = ТаблицаДокументы[ТаблицаДокументы.Количество() - 1];
			ДальнейшееДействиеПоследнегоДокумента = СтрокаТЧПоследнийДокумент.ДальнейшееДействие;
			
			Если ДальнейшееДействиеПоследнегоДокумента = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется Тогда
				ТребуетсяДальнейшееДействие = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		СтрокаПервогоУровняЗаполнена = Ложь;
		Если ОтображатьСИерархией Тогда
			КоллекцияСтрок = СтрокаПервогоУровня.ПолучитьЭлементы();
			Если КоллекцияСтрок.Количество() > 0 Тогда
				
				СтрокаВторогоУровня = СтрокаПервогоУровня.ПолучитьЭлементы()[КоллекцияСтрок.Количество() - 1];
				СтрокаПервогоУровня.Операция = СтрокаВторогоУровня.Операция;
				
				Если Не ЗначениеЗаполнено(СтрокаВторогоУровня.Файл) Тогда
					СтрокаПервогоУровняЗаполнена = Истина;
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
		Если ТребуетсяДальнейшееДействие Тогда
			
			ОперацияПередачаДанных = Перечисления.ОперацииОбменаГИСМ.ПередачаДанных;
			Если ПоследовательностьОпераций.Найти(ОперацияПередачаДанных) <> Неопределено
				И ИнтеграцияГИСМ.ОперацииДетальнойПередачиДанных().Найти(ПоследняяОперация) <> Неопределено Тогда
				ПоследняяОперация = ОперацияПередачаДанных;
			КонецЕсли;
			
			Индекс = ПоследовательностьОпераций.Найти(ПоследняяОперация);
			Если Индекс = Неопределено Тогда
				Индекс = -1;
			КонецЕсли;
			
			Для Итератор = Индекс + 1 По ПоследовательностьОпераций.Количество() - 1 Цикл
				
				Операция = ПоследовательностьОпераций.Получить(Итератор);
				
				Если Операция = Перечисления.ОперацииОбменаГИСМ.ПолучениеНовогоСтатуса
					И ПоследовательностьОперацийОбработкиЭмитентом <> Неопределено Тогда
					
					Для Каждого СтатусОбработкиЭмитентом Из ПоследовательностьОперацийОбработкиЭмитентом Цикл
					
						СтрокаВторогоУровня = СтрокаПервогоУровня.ПолучитьЭлементы().Добавить();
						СтрокаВторогоУровня.Документ           = ВыборкаПоЗаявкамНаВыпускКиЗ.Документ;
						СтрокаВторогоУровня.Представление      = СтатусОбработкиЭмитентом;
						СтрокаВторогоУровня.Операция           = Операция;
						СтрокаВторогоУровня.СтатусОбработкиЭмитентом = СтатусОбработкиЭмитентом;
						СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеСерый";
						СтрокаВторогоУровня.Представление      = ПредставлениеОперации(СтрокаВторогоУровня.Операция, СтрокаВторогоУровня.Документ, СтрокаВторогоУровня);
						СтрокаВторогоУровня.ИндексКартинки     = ИндексКартинки(Перечисления.ОперацииОбменаГИСМ.ПолучениеНовогоСтатуса, Истина);
						
					КонецЦикла;
					
				Иначе
					
					СтрокаВторогоУровня = СтрокаПервогоУровня.ПолучитьЭлементы().Добавить();
					СтрокаВторогоУровня.Документ           = ВыборкаПоЗаявкамНаВыпускКиЗ.Документ;
					СтрокаВторогоУровня.Представление      = Операция;
					СтрокаВторогоУровня.Операция           = Операция;
					СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеСерый";
					СтрокаВторогоУровня.Представление      = ПредставлениеОперации(СтрокаВторогоУровня.Операция, СтрокаВторогоУровня.Документ, Неопределено);
					СтрокаВторогоУровня.ИндексКартинки     = ИндексКартинки(Операция, Истина);
					
				КонецЕсли;
				
				Если Не СтрокаПервогоУровняЗаполнена И ОтображатьСИерархией Тогда
					СтрокаПервогоУровня.Операция = СтрокаВторогоУровня.Операция;
					СтрокаПервогоУровняЗаполнена = Истина;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	КоличествоДокументов = ТаблицаДокументы.Количество();
	Если КоличествоДокументов > 0 Тогда
		
		СтрокаТЧПоследнийДокумент = ТаблицаДокументы[ТаблицаДокументы.Количество() - 1];
		
		ПоследнийДокумент                     = СтрокаТЧПоследнийДокумент.Ссылка;
		СтатусПоследнегоДокумента             = СтрокаТЧПоследнийДокумент.Статус;
		ДальнейшееДействиеПоследнегоДокумента = СтрокаТЧПоследнийДокумент.ДальнейшееДействие;
		
	КонецЕсли;
	
	НастроитьДоступностьКоманд(
		ПоследнийДокумент,
		СтатусПоследнегоДокумента,
		ДальнейшееДействиеПоследнегоДокумента);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоФайлов()
	
	ДеревоФайлов.ПолучитьЭлементы().Очистить();
	
	ТипДокумента = ТипЗнч(Документ);
	
	//ГИСМБП
	// Исключена обработка документов:
	// - ЗаявкаНаВыпускКиЗГИСМ
	// - ПеремаркировкаТоваровГИСМ
	//Конец ГИСМБП
	
	Если (Метаданные.Документы.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ.Реквизиты.Основание.Тип.Типы().Найти(ТипДокумента) <> Неопределено
		  Или Метаданные.Документы.УведомлениеОбИмпортеМаркированныхТоваровГИСМ.Реквизиты.Основание.Тип.Типы().Найти(ТипДокумента) <> Неопределено)
		  И (ТипДокумента <> Тип("ДокументСсылка.УведомлениеОВвозеМаркированныхТоваровИзЕАЭСГИСМ")
		   И ТипДокумента <> Тип("ДокументСсылка.УведомлениеОбИмпортеМаркированныхТоваровГИСМ")) Тогда
		
		НастроитьВидимостьКоманд(
			Истина,  // ПередатьДанные
			Ложь,    // ПодтвердитьПолучение
			Ложь,    // Аннулировать
			Ложь);   // ЗакрытьЗаявку
		
		ЗаполнитьПоОснованиюДокументовИмпорта(Документ);
		
	ИначеЕсли Метаданные.Документы.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ.Реквизиты.Основание.Тип.Типы().Найти(ТипДокумента) <> Неопределено
		И ТипДокумента <> Тип("ДокументСсылка.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ") Тогда
		
		НастроитьВидимостьКоманд(
			Истина,  // ПередатьДанные
			Ложь,    // ПодтвердитьПолучение
			Ложь,    // Аннулировать
			Ложь);   // ЗакрытьЗаявку
		
		ЗаполнитьПоОснованиюДокументаУведомлениеОбОтгрузке(Документ);
		
	ИначеЕсли Метаданные.Документы.УведомлениеОСписанииКиЗГИСМ.Реквизиты.Основание.Тип.Типы().Найти(ТипДокумента) <> Неопределено
		И ТипДокумента <> Тип("ДокументСсылка.УведомлениеОСписанииКиЗГИСМ") Тогда
		
		НастроитьВидимостьКоманд(
			Истина,  // ПередатьДанные
			Ложь,    // ПодтвердитьПолучение
			Ложь,    // Аннулировать
			Ложь);   // ЗакрытьЗаявку
		
		ЗаполнитьПоОснованиюДокументаУведомлениеОСписанииКиЗ(Документ);
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.УведомлениеОбОтгрузкеМаркированныхТоваровГИСМ") Тогда
		
		НастроитьВидимостьКоманд(
			Истина,  // ПередатьДанные
			Ложь,  // ПодтвердитьПолучение
			Ложь,  // Аннулировать
			Ложь); // ЗакрытьЗаявку
		
		ПоследовательностьОпераций = Новый Массив;
		ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
		ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПолучениеПодтверждения);
		ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПолучениеЗакрытияЗаявки);
		
		ЗаполнитьПоДокументу(ТаблицаДокументы(Документ), ПоследовательностьОпераций, Неопределено);
		
	ИначеЕсли ТипДокумента = Тип("ДокументСсылка.УведомлениеОПоступленииМаркированныхТоваровГИСМ") Тогда
		
		НастроитьВидимостьКоманд(
			Ложь,  // ПередатьДанные
			Истина,  // ПодтвердитьПолучение
			Истина,  // Аннулировать
			Истина); // ЗакрытьЗаявку
		
		ПоследовательностьОпераций = Новый Массив;
		ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПолучениеТоваров);
		ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения);
		ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки);
		
		ЗаполнитьПоДокументу(ТаблицаДокументы(Документ), ПоследовательностьОпераций, Неопределено);
		
	Иначе
		
		НастроитьВидимостьКоманд(
			Истина,  // ПередатьДанные
			Ложь,  // ПодтвердитьПолучение
			Ложь,  // Аннулировать
			Ложь); // ЗакрытьЗаявку
		
		ПоследовательностьОпераций = Новый Массив;
		ПоследовательностьОпераций.Добавить(Перечисления.ОперацииОбменаГИСМ.ПередачаДанных);
		
		ЗаполнитьПоДокументу(ТаблицаДокументы(Документ), ПоследовательностьОпераций, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ОбработатьПередачуДанных(ВыборкаПоФайлам, СтрокаВторогоУровня, ПередачаДанных)
	
	Если ИнтеграцияГИСМ.ОперацииПередачиДанных().Найти(ВыборкаПоФайлам.Операция) <> Неопределено Тогда
		
		СтрокаТЧ = ПередачаДанных.Найти(ВыборкаПоФайлам.Ссылка, "Запрос");
		
		Если СтрокаТЧ <> Неопределено И ЗначениеЗаполнено(СтрокаТЧ.ОтветНаЗапрос) Тогда
			
			Если ЗначениеЗаполнено(СтрокаТЧ.ОтветНаЗапросКвитанции) Тогда
				
				Если СтрокаТЧ.ОтветНаЗапросСостояниеОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
					
					СтатусЗапросаКвитанции = СтрокаТЧ.ОтветНаЗапросКвитанцииСостояниеОбработки;
					Если СтатусЗапросаКвитанции = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
						
						СтрокаВторогоУровня.Состояние = НСтр("ru = 'Квитанция получена: Документ принят в обработку'");
						
					ИначеЕсли СтатусЗапросаКвитанции = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено Тогда
						
						СтрокаВторогоУровня.Состояние = НСтр("ru = 'Квитанция получена: Документ отклонен'");
						СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеОшибка";
						СтрокаВторогоУровня.ИндексКартинки = 4;
						
					ИначеЕсли СтатусЗапросаКвитанции = Перечисления.СтатусыОбработкиСообщенийГИСМ.Обрабатывается Тогда
						
						СтрокаВторогоУровня.Состояние = НСтр("ru = 'Ожидается получение квитанции'");
						СтрокаВторогоУровня.ИндексКартинки = 3;
						
					ИначеЕсли СтатусЗапросаКвитанции = Перечисления.СтатусыОбработкиСообщенийГИСМ.НаМодерации Тогда
						
						СтрокаВторогоУровня.Состояние = НСтр("ru = 'Ожидается утверждение в ФНС'");
						СтрокаВторогоУровня.ИндексКартинки = 3;
						
					Иначе
						
						СтрокаВторогоУровня.Состояние = НСтр("ru = 'Ошибка обработки'");
						СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеОшибка";
						СтрокаВторогоУровня.ИндексКартинки = 6;
						
					КонецЕсли;
					
				ИначеЕсли СтрокаТЧ.ОтветНаЗапросСостояниеОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено Тогда
					
					СтрокаВторогоУровня.Состояние = НСтр("ru = 'Документ отклонен'");
					СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеОшибка";
					СтрокаВторогоУровня.ИндексКартинки = 4;
					
				Иначе
					
					СтрокаВторогоУровня.Состояние = НСтр("ru = 'Ошибка обработки'");
					СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеОшибка";
					СтрокаВторогоУровня.ИндексКартинки = 6;
					
				КонецЕсли;
				
			Иначе
				
				СтрокаВторогоУровня.Состояние = НСтр("ru = 'Ожидается получение квитанции'");
				СтрокаВторогоУровня.ИндексКартинки = 3;
				
			КонецЕсли;
			
		ИначеЕсли ЗначениеЗаполнено(ВыборкаПоФайлам.Ссылка) Тогда
			
			СтрокаВторогоУровня.Состояние = НСтр("ru = 'Ожидается передача данных'");
			СтрокаВторогоУровня.ИндексКартинки = 3;
			
		Иначе
			
			СтрокаВторогоУровня.Состояние = НСтр("ru = 'Ожидается передача данных'");
			СтрокаВторогоУровня.УсловноеОформление = "УсловноеОформлениеСерый";
			СтрокаВторогоУровня.ИндексКартинки = 7;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИндексКартинки(Операция, Серый = Ложь)
	
	ИндексКартинки = 0;
	
	Смещение = 0;
	Если Серый Тогда
		Смещение = 6;
	КонецЕсли;
	
	Если ИнтеграцияГИСМ.ОперацииПередачиДанных().Найти(Операция) <> Неопределено Тогда
		ИндексКартинки = 1 + Смещение;
	ИначеЕсли ИнтеграцияГИСМ.ОперацииПолученияДанных().Найти(Операция) <> Неопределено Тогда
		ИндексКартинки = 2 + Смещение;
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПустаяСсылка() Тогда
		ИндексКартинки = 5;
	КонецЕсли;
	
	Возврат ИндексКартинки;
	
КонецФункции

&НаСервере
Процедура НастроитьВидимостьКоманд(ПередатьДанные, ПодтвердитьПолучение, Аннулировать, ЗакрытьЗаявку)
	
	Элементы.СписокПередатьДанные.Видимость = ПередатьДанные;
	Элементы.ДеревоФайловКонтекстноеМенюПередатьДанные.Видимость = ПередатьДанные;
	
	Элементы.СписокПодтвердитьПолучение.Видимость = ПодтвердитьПолучение;
	Элементы.ДеревоФайловКонтекстноеМенюПодтвердитьПолучение.Видимость = ПодтвердитьПолучение;
	
	Элементы.СписокАннулировать.Видимость = Аннулировать;
	Элементы.ДеревоФайловКонтекстноеМенюАннулировать.Видимость = Аннулировать;
	
	Элементы.ДеревоФайловКонтекстноеМенюЗакрытьЗаявку.Видимость = ЗакрытьЗаявку;
	Элементы.СписокЗакрытьЗаявку.Видимость = ЗакрытьЗаявку;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьКоманд(ПоследнийДокумент, Статус, ДальнейшееДействие)
	
	ПередатьДанные       = (    ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные
	                        ИЛИ ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ
	                        ИЛИ ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеМаркировкаТоваров
	                        ИЛИ ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеПеремаркировкаТоваров);
	
	ПодтвердитьПолучение = (ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПодтвердитеПолучение);
	Аннулировать         = (ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.Аннулируйте);
	ЗакрытьЗаявку        = (ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ЗакройтеЗаявку);
	
	Элементы.СписокПередатьДанные.Доступность                      = ПередатьДанные;
	Элементы.ДеревоФайловКонтекстноеМенюПередатьДанные.Доступность = ПередатьДанные;
	
	Элементы.СписокПодтвердитьПолучение.Доступность                      = ПодтвердитьПолучение;
	Элементы.ДеревоФайловКонтекстноеМенюПодтвердитьПолучение.Доступность = ПодтвердитьПолучение;
	
	Элементы.СписокАннулировать.Доступность                      = Аннулировать;
	Элементы.ДеревоФайловКонтекстноеМенюАннулировать.Доступность = Аннулировать;
	
	Элементы.ДеревоФайловКонтекстноеМенюЗакрытьЗаявку.Доступность = ЗакрытьЗаявку;
	Элементы.СписокЗакрытьЗаявку.Доступность                      = ЗакрытьЗаявку;
	
КонецПроцедуры

#КонецОбласти
