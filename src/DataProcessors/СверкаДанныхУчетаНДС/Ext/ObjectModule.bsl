﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// Проверка заполнения ИНН/КПП организации.
	Если ЗначениеЗаполнено(Организация) Тогда
		
		// ИНН
		РеквизитыОрганизации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "Наименование, ИНН, КПП, ЮридическоеФизическоеЛицо");
		ЭтоЮрЛицо = РеквизитыОрганизации.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		
		Если НЕ ЗначениеЗаполнено(РеквизитыОрганизации.ИНН) Тогда
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнено поле ""ИНН"" для ""%1""'"), РеквизитыОрганизации.Наименование);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Организация, , "Объект.Организация", Отказ);
		Иначе
			РезультатПроверки = ИдентификационныеНомераНалогоплательщиков.ПроверитьСоответствиеТребованиямИНН(
				РеквизитыОрганизации.ИНН, ЭтоЮрЛицо);
			Если НЕ РезультатПроверки.СоответствуетТребованиям Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверки.ОписаниеОшибки, Организация, , "Объект.Организация", Отказ);
			КонецЕсли;
		КонецЕсли;
		
		// КПП
		Если ЭтоЮрЛицо Тогда
			Если НЕ ЗначениеЗаполнено(РеквизитыОрганизации.КПП) Тогда
				ТекстСообщения = СтрШаблон(НСтр("ru = 'Не заполнено поле ""КПП"" для ""%1""'"), РеквизитыОрганизации.Наименование);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Организация, , "Объект.Организация", Отказ);
			Иначе
				РезультатПроверки = ИдентификационныеНомераНалогоплательщиков.ПроверитьСоответствиеТребованиямФорматаКПП(
					РеквизитыОрганизации.КПП, ЭтоЮрЛицо);
				Если НЕ РезультатПроверки.СоответствуетТребованиям Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезультатПроверки.ОписаниеОшибки, Организация, , "Объект.Организация", Отказ);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли