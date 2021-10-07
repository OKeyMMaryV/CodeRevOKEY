﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ)
	
		
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;		
	
	Если Значение Тогда
		
		Если Константы.ИспользоватьНачислениеЗарплаты.Получить() Тогда
			
			Если НЕ РасчетЗарплатыДляНебольшихОрганизаций.РасчетЗарплатыДляНебольшихОрганизацийВозможен() Тогда
				
				ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					РасчетЗарплатыДляНебольшихОрганизацийПереопределяемый.ТекстСообщенияОПревышенииМаксимальноДопустимогоКоличестваРаботающихСотрудников(),
					РасчетЗарплатыДляНебольшихОрганизаций.ПорогЗапрета());
					
				ВызватьИсключение ТекстИсключения;
				
			КонецЕсли;
			
		Иначе
			ВызватьИсключение НСтр("ru = 'Включать режим расчета зарплаты для небольшой организации можно только при использовании начисления зарплаты'");
		КонецЕсли; 
			
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли