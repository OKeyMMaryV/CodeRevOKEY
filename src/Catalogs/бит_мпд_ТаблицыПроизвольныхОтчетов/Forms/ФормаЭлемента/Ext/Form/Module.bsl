﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	
	
	// Вызов механизма защиты
	 	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	фЛевоПред = Объект.Лево;
	фВерхПред = Объект.Верх;
	фВыводитьЗаголовкиКолонокПред = Объект.ВыводитьЗаголовкиКолонок;
	фВыводитьЗаголовкиСтрокПред   = Объект.ВыводитьЗаголовкиСтрок;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Модифицированность Тогда
		
		Если ТекущийОбъект.ЭтоНовый() Тогда
			
			ТекущийОбъект.ЛевоПред = ТекущийОбъект.Лево;
			ТекущийОбъект.ВерхПред = ТекущийОбъект.Верх;
			ТекущийОбъект.ВыводитьЗаголовкиСтрокПред   = ТекущийОбъект.ВыводитьЗаголовкиСтрок;
			ТекущийОбъект.ВыводитьЗаголовкиКолонокПред = ТекущийОбъект.ВыводитьЗаголовкиКолонок;

			
		Иначе
			
			ТекущийОбъект.ЛевоПред = фЛевоПред;
			ТекущийОбъект.ВерхПред = фВерхПред;
			ТекущийОбъект.ВыводитьЗаголовкиСтрокПред   = фВыводитьЗаголовкиСтрокПред;
			ТекущийОбъект.ВыводитьЗаголовкиКолонокПред = фВыводитьЗаголовкиКолонокПред;
			
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("бит_ЗаписанЭлементСтруктурыПроизвольногоОтчета",Новый Структура("Отчет", Объект.Владелец));
	
КонецПроцедуры

#КонецОбласти
