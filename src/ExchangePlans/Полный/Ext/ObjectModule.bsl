﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиСервер.НадоВыполнитьОбработчикПослеЗагрузкиДанных(ЭтотОбъект, Ссылка) Тогда
		
		ПослеЗагрузкиДанных();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПослеЗагрузкиДанных()
	
	Если Ссылка <> ПланыОбмена.Полный.ЭтотУзел() Тогда
		
		// СтандартныеПодсистемы.ЗащитаПерсональныхДанных
		ЗащитаПерсональныхДанных.ПослеЗагрузкиДанных(ЭтотОбъект);
		// Конец СтандартныеПодсистемы.ЗащитаПерсональныхДанных
		
	КонецЕсли;
	
	Справочники.КлючиАналитикиУчетаЗатрат.ЗаменитьДублиКлючейАналитики();
	Справочники.КлючиАналитикиУчетаНДС.ЗаменитьДублиКлючейАналитики();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли