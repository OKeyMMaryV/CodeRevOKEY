﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
КонецПроцедуры // Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Функция - Получить состояние
//
// Параметры:
//  Ссылка	 - СправочникСсылка.бит_ПаспортаСделок	 - Исследуемый объект.
//  Дата	 - Дата	 - Период среза последних. 
// 
// Возвращаемое значение:
//  Состояние - Значение перечисления.
//
Функция ПолучитьСостояние(Знач Ссылка, Знач Дата = Неопределено) Экспорт
	
	Состояние = Перечисления.бит_СостоянияПаспортовСделок.Черновик;
	
	Если Дата = Неопределено Тогда
		Дата = '20990101';
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", Дата);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СостоянияСрезПоследних.Состояние
	|ИЗ
	|	РегистрСведений.бит_СостоянияПаспортовСделок.СрезПоследних(&Дата, ПаспортСделки = &Ссылка) КАК СостоянияСрезПоследних";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Состояние = Выборка.Состояние;
	КонецЕсли;
	
	Возврат Состояние;
	
КонецФункции

// Процедура - Установить состояние
//
// Параметры:
//  ПаспортСделки	 - СправочникСсылка.бит_ПаспортаСделок	 - Исследуемый объект.
//  Дата	 - Дата	 - Период
//  Состояние	 - Перечисление.бит_СостоянияПаспортовСделок	 - новое состояние.
//
Процедура УстановитьСостояние(ПаспортСделки, Дата, Состояние) Экспорт
	
	НаборЗаписей = РегистрыСведений.бит_СостоянияПаспортовСделок.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ПаспортСделки.Установить(ПаспортСделки); 
	НаборЗаписей.Отбор.Период.Установить(Дата); 
	
	НоваяЗапись             	= НаборЗаписей.Добавить();
	НоваяЗапись.ПаспортСделки 	= ПаспортСделки;
	НоваяЗапись.Состояние		= Состояние;
	НоваяЗапись.Период  		= Дата;
	НаборЗаписей.Записать();
	
КонецПроцедуры

// Процедура - Заполнить объект по договору контрагента.
//
// Параметры:
//  Объект	 - СправочникСсылкабит_ПаспортаСделок - объект заполнения.
//
Процедура ЗаполнитьОбъектПоДоговоруКонтрагента(Объект) Экспорт 

	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
	
		СтрРеквизитов = бит_ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДоговорКонтрагента, "ВалютаВзаиморасчетов, бит_СуммаДоговора");
		
		Объект.ВалютаДоговора 	= СтрРеквизитов.ВалютаВзаиморасчетов;
		Объект.Сумма 			= ?(СтрРеквизитов.бит_СуммаДоговора > 0, СтрРеквизитов.бит_СуммаДоговора, Объект.Сумма);
		
	Иначе	
		Объект.ВалютаДоговора 	= Справочники.Валюты.ПустаяСсылка();
		Объект.Сумма 			= 0;
	КонецЕсли; 

КонецПроцедуры // ПроверитьИзменениеКонтрагента()

// Заполнение реквизита при обновлении. 
Процедура ЗаполнитьВидРегистрацииДоговора() Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_ПаспортаСделок.Ссылка КАК Ссылка,
	|	бит_ПаспортаСделок.ВидРегистрацииДоговора КАК ВидРегистрацииДоговора
	|ИЗ
	|	Справочник.бит_ПаспортаСделок КАК бит_ПаспортаСделок
	|ГДЕ
	|	бит_ПаспортаСделок.ВидРегистрацииДоговора = ЗНАЧЕНИЕ(Перечисление.бит_ВидыРегистрацийДоговоров.ПустаяСсылка)";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СпрОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СпрОбъект.ВидРегистрацииДоговора = Перечисления.бит_ВидыРегистрацийДоговоров.ПаспортСделки;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(СпрОбъект, Истина, Ложь);
	КонецЦикла;

КонецПроцедуры

#КонецОбласти
 
#КонецЕсли  
