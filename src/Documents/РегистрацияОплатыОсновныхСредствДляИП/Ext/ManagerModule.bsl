﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВремяДокументаПоУмолчанию() Экспорт
	
	Возврат Новый Структура("Часы, Минуты", 20, 0);
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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

////////////////////////////////////////////////////////////////////////////////
// ПОДГОТОВКА ПАРАМЕТРОВ ПРОВЕДЕНИЯ ДОКУМЕНТА
//

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт

	ПараметрыПроведения = Новый Структура;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация
	|ИЗ
	|	Документ.РегистрацияОплатыОсновныхСредствДляИП КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка";

	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();

	Если НЕ УчетнаяПолитика.Существует(Выборка.Организация, Выборка.Период, Истина, ДокументСсылка) Тогда
		Отказ = Истина;
		Возврат ПараметрыПроведения;
	КонецЕсли;

	НомераТаблиц = Новый Структура;

	Запрос.УстановитьПараметр("Период", Выборка.Период);
	Запрос.УстановитьПараметр("Организация",Выборка.Организация);

	Запрос.Текст =
		ТекстЗапросаРеквизиты(НомераТаблиц)
		+ ТекстЗапросаТаблицаОплата(НомераТаблиц)
		+ ТекстЗапросаТаблицаОплатаНМА(НомераТаблиц);

	Результат = Запрос.ВыполнитьПакет();

	Для каждого НомерТаблицы Из НомераТаблиц Цикл
		ПараметрыПроведения.Вставить(НомерТаблицы.Ключ, Результат[НомерТаблицы.Значение].Выгрузить());
	КонецЦикла;

	Возврат ПараметрыПроведения;

КонецФункции

Функция ТекстЗапросаРеквизиты(НомераТаблиц)

	НомераТаблиц.Вставить("Реквизиты", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Реквизиты.Ссылка КАК Регистратор,
	|	Реквизиты.Дата КАК Период,
	|	Реквизиты.Организация
	|ИЗ
	|	Документ.РегистрацияОплатыОсновныхСредствДляИП КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка = &Ссылка"
	;

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаТаблицаОплата(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаОС", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.Ссылка,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.НомерСтроки КАК НомерСтроки,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.ОсновноеСредство,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.ДатаОплаты,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.СуммаОплаты,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.НомерДокументаОплаты,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.Ссылка.Дата КАК Период,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.Ссылка.Организация КАК Организация
	|ИЗ
	|	Документ.РегистрацияОплатыОсновныхСредствДляИП.Оплата КАК РегистрацияОплатыОсновныхСредствДляИПОплата
	|ГДЕ
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки"
	;

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

Функция ТекстЗапросаТаблицаОплатаНМА(НомераТаблиц)

	НомераТаблиц.Вставить("ТаблицаНМА", НомераТаблиц.Количество());

	ТекстЗапроса =
	"ВЫБРАТЬ
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.Ссылка,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.НомерСтроки КАК НомерСтроки,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.НематериальныйАктив,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.ДатаОплаты,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.СуммаОплаты,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.НомерДокументаОплаты,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.Ссылка.Дата КАК Период,
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.Ссылка.Организация КАК Организация
	|ИЗ
	|	Документ.РегистрацияОплатыОсновныхСредствДляИП.ОплатаНМА КАК РегистрацияОплатыОсновныхСредствДляИПОплата
	|ГДЕ
	|	РегистрацияОплатыОсновныхСредствДляИПОплата.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки"
	;

	Возврат ТекстЗапроса + ОбщегоНазначенияБПВызовСервера.ТекстРазделителяЗапросовПакета();

КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецЕсли