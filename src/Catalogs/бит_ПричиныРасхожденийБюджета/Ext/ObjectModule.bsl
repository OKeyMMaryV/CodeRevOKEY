﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	       	
#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ДополнительныеСвойства);
		
КонецПроцедуры
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ДополнительныеСвойства, Метаданные().ПолноеИмя());
		
КонецПроцедуры	
	
#КонецОбласти

#КонецЕсли