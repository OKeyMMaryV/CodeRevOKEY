﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение И ВариантыПриложений.ЭтоБазоваяВерсия() Тогда
		Значение = Ложь;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РежимТакси = Константы.ИнтерфейсТакси.Получить();
	
	Если РежимТакси И Не Значение И Справочники.Организации.КоличествоОрганизаций() > 1 Тогда
		СообщениеОбОшибке = 
			НСтр("ru = 'Невозможно отключить учет по организациям. В справочнике организаций присутствует несколько элементов.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	Константы.НеВестиУчетПоОрганизациям.Установить(РежимТакси И Не ЭтотОбъект.Значение);
	
	Если Не Значение И ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций") Тогда
		Константы.ИспользоватьНесколькоОрганизаций.Установить(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
