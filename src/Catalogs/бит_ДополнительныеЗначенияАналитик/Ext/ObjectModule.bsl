﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий
		    	
// Процедура - обработчик события "ПередЗаписью" формы.
// 
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;
	КонецЕсли;
	
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ЭтотОбъект.ДополнительныеСвойства);
	
	Если Не ЭтоНовый() И Не ПометкаУдаления=Ссылка.ПометкаУдаления Тогда
		// В случае установки или снятия пометки удаления не производить проверку.
		Возврат;
	КонецЕсли;	
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда			
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ЭтотОбъект.ДополнительныеСвойства, Метаданные().ПолноеИмя());
		
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#КонецЕсли
