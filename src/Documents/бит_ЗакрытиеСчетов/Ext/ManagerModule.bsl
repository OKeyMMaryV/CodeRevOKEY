﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Функция определяет параметры регистра бухгалтерии.
// 
// Параметры:
//  РегистрБухгалтерии - СправочникСсылка.бит_ОбъектыСистемы - объект системы.
// 
// Возвращаемое значение:
//  ПараметрыРБ - Структура.
// 
Функция ПолучитьПараметрыРегистраБухгалтерии(РегистрБухгалтерии) Экспорт

	ПараметрыРБ = Новый Структура("ИмяКласса
	                               |, ИмяРегистра
								   |, ИмяПланаСчетов
								   |, ПустойСчет
								   |, МаксКоличествоСубконто
								   |, МинКоличествоСубконто
								   |, КоличествоСубконтоДокумента
								   |, ЭтоРегистрНУ
								   |, ЭтоРегистрБюдж
								   |, ЕстьПодразделение								   								   
								   |, ЕстьКоличественныйУчет
								   |, ЕстьВалютныйУчет
								   |, ЕстьДопИзмерениеОрганизация");
								   
	ПараметрыРБ.ИмяКласса = "ПараметрыРегистраБухгалтерии";
	ПараметрыРБ.ЕстьКоличественныйУчет = Ложь;
	ПараметрыРБ.ЕстьВалютныйУчет = Ложь;
	ПараметрыРБ.ЕстьПодразделение = Ложь;	
	ПараметрыРБ.ЕстьДопИзмерениеОрганизация = Ложь;
	ПараметрыРБ.КоличествоСубконтоДокумента = ПолучитьКоличествоСубконтоДокумента();
	
	Если ЗначениеЗаполнено(РегистрБухгалтерии) Тогда
		
		// Укажем имя регистра бухгалтерии.
		ПараметрыРБ.ИмяРегистра = РегистрБухгалтерии.ИмяОбъекта;
		
		// Получим метаданные плана счетов регистра бухгалтерии.
		МетаРегистр    = Метаданные.РегистрыБухгалтерии[ПараметрыРБ.ИмяРегистра];
		ПланСчетовМета = МетаРегистр.ПланСчетов;
		ПараметрыРБ.ЕстьПодразделение = ?(МетаРегистр.Измерения.Найти("Подразделение") = Неопределено, Ложь, Истина);
		
		// Параметры плана счетов.
		ПараметрыРБ.ИмяПланаСчетов = ПланСчетовМета.Имя;
		ПараметрыРБ.ПустойСчет = ПланыСчетов[ПланСчетовМета.Имя].ПустаяСсылка();
		ПараметрыРБ.МаксКоличествоСубконто = ПланСчетовМета.МаксКоличествоСубконто;
		
		ПараметрыРБ.МинКоличествоСубконто = Мин(ПараметрыРБ.МаксКоличествоСубконто, ПараметрыРБ.КоличествоСубконтоДокумента);
		
		// Проверим наличие количественного и валютного учета у плана счетов.
		ПараметрыРБ.ЕстьКоличественныйУчет = Не ПланСчетовМета.ПризнакиУчета.Найти("Количественный") = Неопределено;
		ПараметрыРБ.ЕстьВалютныйУчет 	   = Не ПланСчетовМета.ПризнакиУчета.Найти("Валютный") 	    = Неопределено;
		
		// Проверки на специальные виды регистров
		ПараметрыРБ.ЭтоРегистрНУ   = бит_РегламентныеЗакрытия.ЭтоРегистрНалоговогоУчета(ПараметрыРБ.ИмяРегистра);
		ПараметрыРБ.ЭтоРегистрБюдж = бит_РегламентныеЗакрытия.ЭтоРегистрБюджетирования(ПараметрыРБ.ИмяРегистра);
		
		Если ПараметрыРБ.ЭтоРегистрБюдж Тогда
		
			ПараметрыРБ.ЕстьДопИзмерениеОрганизация = бит_МеханизмДопИзмерений.ЕстьДопИзмерениеОрганизация();
		
		КонецЕсли; 
		
	КонецЕсли; 

	Возврат ПараметрыРБ;
	
КонецФункции // ПолучитьПараметрыРегистраБухгалтерии()

// Функция получает количество субконто документа.
// 
// Возвращаемое значение:
//  КоличествоСубконто - Число - количество субконто.
// 
Функция ПолучитьКоличествоСубконтоДокумента() Экспорт

	КоличествоСубконто = 4;

	Возврат КоличествоСубконто;
	
КонецФункции // ПолучитьКоличествоСубконтоДокумента()

// Функция получает список имен колонок для ввода реквизитов.
// 
// Возвращаемое значение:
//  СписокИмен - СписокЗначений - список имен.
// 
Функция ИменаРесурсов() Экспорт
	
	СписокИмен = Новый СписокЗначений;
	СписокИмен.Добавить("Сумма1");
	СписокИмен.Добавить("Сумма2");
	СписокИмен.Добавить("Сумма3");
	СписокИмен.Добавить("Сумма4");

	Возврат СписокИмен;
	
КонецФункции

#КонецОбласти 	
 
#КонецЕсли
