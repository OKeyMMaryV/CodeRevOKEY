﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция выполняет трансляцию произвольного XDTO-объекта 
// между версиями по зарегистрированным в системе обработчикам трансляции,
// определяя результирующую версию по пространству имен результирующего сообщения.
//
// Параметры:
//  ИсходныйОбъект - ОбъектXDTO - Транслируемый объект.
//  РезультирующаяВерсия - строка - Номер результирующей версии интерфейса, в формате РР.{П|ПП}.ЗЗ.СС.
//  ПакетИсходнойВерсии - Строка - пространство имен версии сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - результат трансляции объекта.
//
Функция ТранслироватьВВерсию(Знач ИсходныйОбъект, Знач РезультирующаяВерсия, Знач ПакетИсходнойВерсии = "") Экспорт
	
	Если ПакетИсходнойВерсии = "" Тогда
		ПакетИсходнойВерсии = ИсходныйОбъект.Тип().URIПространстваИмен;
	КонецЕсли;
	
	ОписаниеИсходнойВерсии = ТрансляцияXDTOСлужебный.СформироватьОписаниеВерсии(
		,
		ПакетИсходнойВерсии);
	ОписаниеРезультирующейВерсии = ТрансляцияXDTOСлужебный.СформироватьОписаниеВерсии(
		РезультирующаяВерсия);
	
	Возврат ТрансляцияXDTOСлужебный.ВыполнитьТрансляцию(
		ИсходныйОбъект,
		ОписаниеИсходнойВерсии,
		ОписаниеРезультирующейВерсии);
	
КонецФункции

// Функция выполняет трансляцию произвольного XDTO-объекта 
// между версиями по зарегистрированным в системе обработчикам трансляции,
// определяя результирующую версию по пространству имен результирующего сообщения.
//
// Параметры:
//  ИсходныйОбъект - ОбъектXDTO - Транслируемый объект.
//  ПакетРезультирующейВерсии - Строка - Пространство имен результирующей версии.
//  ПакетИсходнойВерсии - Строка - пространство имен версии сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - результат трансляции объекта.
//
Функция ТранслироватьВПространствоИмен(Знач ИсходныйОбъект, Знач ПакетРезультирующейВерсии, Знач ПакетИсходнойВерсии = "") Экспорт
	
	Если ИсходныйОбъект.Тип().URIПространстваИмен = ПакетРезультирующейВерсии Тогда
		Возврат ИсходныйОбъект;
	КонецЕсли;
	
	Если ПакетИсходнойВерсии = "" Тогда
		ПакетИсходнойВерсии = ИсходныйОбъект.Тип().URIПространстваИмен;
	КонецЕсли;
	
	ОписаниеИсходнойВерсии = ТрансляцияXDTOСлужебный.СформироватьОписаниеВерсии(
		,
		ПакетИсходнойВерсии);
	ОписаниеРезультирующейВерсии = ТрансляцияXDTOСлужебный.СформироватьОписаниеВерсии(
		,
		ПакетРезультирующейВерсии);
	
	Возврат ТрансляцияXDTOСлужебный.ВыполнитьТрансляцию(
		ИсходныйОбъект,
		ОписаниеИсходнойВерсии,
		ОписаниеРезультирующейВерсии);
	
КонецФункции

#КонецОбласти
