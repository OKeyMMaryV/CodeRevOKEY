﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Удаленное администрирование".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс
    
// Заполняет структуру массивами поддерживаемых версий всех подлежащих версионированию подсистем,
// используя в качестве ключей названия подсистем.
// Обеспечивает функциональность Web-сервиса InterfaceVersion.
// При внедрении надо поменять тело процедуры так, чтобы она возвращала актуальные наборы версий (см. пример.ниже).
//
// Параметры:
//  СтруктураПоддерживаемыхВерсий - Структура - структура поддерживаемых версий:
//	  * Ключи - Строка - название подсистеы. 
//	  * Значения - Массив - названия поддерживаемых версий.
//
// Пример реализации:
//
//	// СервисПередачиФайлов
//	МассивВерсий = Новый Массив;
//	МассивВерсий.Добавить("1.0.1.1");	
//	МассивВерсий.Добавить("1.0.2.1"); 
//	СтруктураПоддерживаемыхВерсий.Вставить("СервисПередачиФайлов", МассивВерсий);
//	// Конец СервисПередачиФайлов
//
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.0.1");
	СтруктураПоддерживаемыхВерсий.Вставить("ManagedApplication", МассивВерсий);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныйПрограммныйИнтерфейс

// Проверяет принадлежность сеанса текущей области данных.
//
// Параметры:
//  НомерСеанса - Число - номер сеанса, принадлежность которого проверяется.
//
// Возвращаемое значение:
//  Булево - признак принадлежности сеанса текущей области данных.
//
Функция ПроверитьПринадлежностьСеансаТекущейОбластиДанных(Знач НомерСеанса) Экспорт
	
	СеансыОбласти = ПолучитьСеансыИнформационнойБазы();
	Для Каждого СеансОбласти Из СеансыОбласти Цикл
		Если СеансОбласти.НомерСеанса = НомерСеанса Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Завершает сеанс пользователя области данных.
//
// Параметры:
//  НомераСеансов - Массив - массив номеров сеансов,
//  ПарольПользователя - Строка - пароль текущего пользователя области данных.
//
Процедура ЗавершитьСеансыОбластиДанных(Знач НомераСеансов, Знач ПарольПользователя) Экспорт
	
	ВерсияСервисаУправляющегоПриложения = ИспользуемаяВерсияСервисаУправляющегоПриложения(ПарольПользователя);
	
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияСервисаУправляющегоПриложения, "1.0.3.3") = 0 Тогда
		
		ИнформацияОбОшибке = Неопределено;
		
		Прокси = ПроксиСервисаУправляющегоПриложения(ПарольПользователя);
		
		УстановитьПривилегированныйРежим(Истина);
		ТекущаяОбластьДанных = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		КлючТекущийОбластиДанных = Константы.КлючОбластиДанных.Получить();
		УстановитьПривилегированныйРежим(Ложь);
		
		Для Каждого НомерСеанса Из НомераСеансов Цикл
			
			Прокси.TerminateSession(
				ТекущаяОбластьДанных,
				КлючТекущийОбластиДанных,
				НомерСеанса,
				ИнформацияОбОшибке
			);
			
			РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(
				ИнформацияОбОшибке,
				Метаданные.Подсистемы.ТехнологияСервиса.Подсистемы.УдаленноеАдминистрирование,
				ИнтерфейсСервисаУправляющегоПриложения(),
				"TerminateSession");
			
		КонецЦикла;
		
	ИначеЕсли ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияСервисаУправляющегоПриложения, "1.0.3.4") >= 0 Тогда
		
		ИнформацияОбОшибке = Неопределено;
		
		Прокси = ПроксиСервисаУправляющегоПриложения(ПарольПользователя);
		
		УстановитьПривилегированныйРежим(Истина);
		ТекущаяОбластьДанных = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		КлючТекущийОбластиДанных = Константы.КлючОбластиДанных.Получить();
		УстановитьПривилегированныйРежим(Ложь);
		
		ИнформацияОНомерахСеанса = ПривестиНомераСеансов(НомераСеансов, Прокси.ФабрикаXDTO);
		
		Прокси.TerminateSessions(
			ТекущаяОбластьДанных,
			КлючТекущийОбластиДанных,
			ИнформацияОНомерахСеанса,
			ИнформацияОбОшибке
		);
		
		РаботаВМоделиСервиса.ОбработатьИнформациюОбОшибкеWebСервиса(
			ИнформацияОбОшибке,
			Метаданные.Подсистемы.ТехнологияСервиса.Подсистемы.УдаленноеАдминистрирование,
			ИнтерфейсСервисаУправляющегоПриложения(),
			"TerminateSessions");
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Текущая версия управляющего приложения не поддерживает завершение сеанса из приложений. Необходимо обновить управляющее приложение.'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает используемую версию сервиса управляющего приложения.
//
// Параметры:
//  ПарольПользователя - Строка - пароль пользователя.
//
// Возвращаемое значение:
//  Строка - максимальная версия сервиса управляющего приложения, которая может быть использована текущей информационной базой.
//
Функция ИспользуемаяВерсияСервисаУправляющегоПриложения(Знач ПарольПользователя = "")
	
	ИмяИнтерфейса = "ManageApplication"; // Не локализуется
	ИспользуемаяВерсия = "1.0.3.4";
	
	ПараметрыПодключения = Новый Структура;
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыПодключения.Вставить("URL", РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса());
	ПараметрыПодключения.Вставить("UserName", РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса());
	ПараметрыПодключения.Вставить("Password", РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса());
	УстановитьПривилегированныйРежим(Ложь);
	
	ПоддерживаемыеВерсии = ОбщегоНазначения.ПолучитьВерсииИнтерфейса(ПараметрыПодключения, ИмяИнтерфейса);
	
	Если ПоддерживаемыеВерсии.Найти(ИспользуемаяВерсия) = Неопределено Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Корреспондент %1 не поддерживает интерфейс %2!'"),
			ПараметрыПодключения.URL,
			ИмяИнтерфейса
		);

	КонецЕсли;
	
	Возврат ИспользуемаяВерсия;
	
КонецФункции

// Возвращает прокси web-сервиса для синхронизации административных действий в сервисе.
//
// Возвращаемое значение:
//   WSПрокси - прокси менеджера сервиса.
//
Функция ПроксиСервисаУправляющегоПриложения(Знач ПарольПользователя = "")
	
	ИспользуемаяВерсия = ИспользуемаяВерсияСервисаУправляющегоПриложения(ПарольПользователя);
	
	ПараметрыАвторизации = Новый Структура;
	УстановитьПривилегированныйРежим(Истина);
	ПараметрыАвторизации.Вставить("URL", РаботаВМоделиСервиса.ВнутреннийАдресМенеджераСервиса());
	УстановитьПривилегированныйРежим(Ложь);
	
	Если ЗначениеЗаполнено(ПарольПользователя) Тогда
		ПараметрыАвторизации.Вставить("UserName", ИмяПользователя());
		ПараметрыАвторизации.Вставить("Password", ПарольПользователя);
	Иначе
		ПараметрыАвторизации.Вставить("UserName", РаботаВМоделиСервиса.ИмяСлужебногоПользователяМенеджераСервиса());
		ПараметрыАвторизации.Вставить("Password", РаботаВМоделиСервиса.ПарольСлужебногоПользователяМенеджераСервиса());
	КонецЕсли;
	
	ПараметрыПодключения = ОбщегоНазначения.ПараметрыПодключенияWSПрокси();
	ПараметрыПодключения.АдресWSDL = ПараметрыАвторизации.URL + "/ws/ManageApplication_" + СтрЗаменить(ИспользуемаяВерсия, ".", "_") + "?wsdl";
	ПараметрыПодключения.URIПространстваИмен = "http://www.1c.ru/SaaS/ManageApplication/" + ИспользуемаяВерсия;
	ПараметрыПодключения.ИмяСервиса = "ManageApplication_" + СтрЗаменить(ИспользуемаяВерсия, ".", "_");
	ПараметрыПодключения.ИмяТочкиПодключения = "";
	ПараметрыПодключения.ИмяПользователя = ПараметрыАвторизации.UserName;
	ПараметрыПодключения.Пароль = ПараметрыАвторизации.Password;
	ПараметрыПодключения.Таймаут = 60;
	
	Возврат ОбщегоНазначения.СоздатьWSПрокси(ПараметрыПодключения);
	
КонецФункции

// Возвращает название интерфейса управляющего приложения.
//
// Возвращаемое значение - Строка - имя интерфейса.
//
Функция ИнтерфейсСервисаУправляющегоПриложения() Экспорт
	
	Возврат "ManageApplication"; // Не локализуется
	
КонецФункции

// Приводит массив номеров сеансов к ОбъектуXDTO.
//
// Параметры:
//  НомераСеансов - Массив из Число - массив номеров сеансов.
//  Фабрика - ФабрикаXDTO - фабрика XDTO.
//
// Возвращаемое значение:
//  ОбъектXDTO - список номеров сеансов.
//
Функция ПривестиНомераСеансов(Знач НомераСеансов, Знач Фабрика) Экспорт
	
	ТипСпискаНомеровСеансов = Фабрика.Тип("http://www.1c.ru/1cFresh/ManageApplication/1.0.3.4", "SessionNumberList");
	СписокНомеровСеансов = Фабрика.Создать(ТипСпискаНомеровСеансов);
	
	Для Каждого НомерСеанса Из НомераСеансов Цикл
		СписокНомеровСеансов.SessionNumbers.Добавить(НомерСеанса);
	КонецЦикла;
	
	Возврат СписокНомеровСеансов;
	
КонецФункции

#КонецОбласти