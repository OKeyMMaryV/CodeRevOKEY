﻿#Область ПрограммныйИнтерфейс

// Возвращает срок уплаты налога за переданный квартал.
//
// Параметры:
//  Период - Дата - дата в квартале, за который требуется срок оплаты.
//                  Для сокращения объема кэшируемых данных рекомендуется приводить к началу квартала.
//  Организация - СправочникСсылка.Организации - организация, по которой уплачивается налог.
//
// Возвращаемое значение:
//   Дата - крайний срок уплаты налога.
//
Функция СрокУплатыНалогаЗаПериод(Знач Период, Знач Организация) Экспорт
	
	Возврат УчетУСН.СрокУплатыНалогаЗаПериод(Период, Организация);
	
КонецФункции

#КонецОбласти