﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ)
		
	Если ОбменДанными.Загрузка Тогда			
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ДополнительныеСвойства);
		
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда			
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ДополнительныеСвойства, Метаданные().ПолноеИмя());
		
КонецПроцедуры // ПриЗаписи()	
	
#КонецОбласти

#КонецЕсли
