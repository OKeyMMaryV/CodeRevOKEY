#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если НЕ ЭтоГруппа Тогда
		
		РасположениеБазы = Перечисления.бит_мпд_ВидыРасположенияИнформационныхБаз.Серверная;
		Платформа        = Перечисления.бит_мпд_Платформы.V82;
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
		
	Если ОбменДанными.Загрузка Тогда			
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ЭтотОбъект.ДополнительныеСвойства);
		
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
