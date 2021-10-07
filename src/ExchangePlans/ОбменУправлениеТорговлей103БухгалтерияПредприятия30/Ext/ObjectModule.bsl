﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	Если НЕ ИспользоватьОтборПоОрганизациям Тогда
		Организации.Очистить();
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю) Тогда
		ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю = Перечисления.ВыгрузкаДокументовЗаказПокупателяСчетНаОплатуПокупателю.НеВыгружать;
	КонецЕсли;
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	Если НЕ ЗначениеЗаполнено(РежимВыгрузкиОбъектов) тогда
		РежимВыгрузкиОбъектов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьОбъект(ДанныеЗаполнения);
	
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьОбъект(ДанныеЗаполнения)
	
	Если Не ДанныеЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РежимВыгрузкиПриНеобходимости = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли