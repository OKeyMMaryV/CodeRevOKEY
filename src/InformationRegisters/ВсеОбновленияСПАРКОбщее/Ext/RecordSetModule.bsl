﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ЕстьОшибки = Ложь;

	МассивДопустимыхВидовОбновления = РегистрыСведений.ВсеОбновленияСПАРКОбщее.ПолучитьЗначенияДопустимыхВидовОбновления();

	Для каждого ТекущаяЗапись Из ЭтотОбъект Цикл
		Если МассивДопустимыхВидовОбновления.Найти(ТекущаяЗапись.ВидОбновления) = Неопределено Тогда
			ЕстьОшибки = Истина;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Недопустимое значение вида обновления: [%1]'"),
				ТекущаяЗапись.ВидОбновления);
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ТекстСообщения;
			Сообщение.Поле  = "ВидОбновления";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
		КонецЕсли;
	КонецЦикла;

	Отказ = ЕстьОшибки;

КонецПроцедуры

#КонецОбласти

#КонецЕсли