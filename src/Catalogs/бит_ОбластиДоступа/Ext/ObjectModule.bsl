﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
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

#Область СлужебныйПрограммныйИнтерфейс

// Процедура сохраняет отбор в хранилище значения. 
// 
// Параметры:
//  Настройки - Структура.
// 
Процедура СохранитьНастройкиПостроителя(Настройки) Экспорт 

	НастройкиПостроителя = Новый ХранилищеЗначения(Настройки);

КонецПроцедуры // СохранитьНастройкиПостроителя()

// Функция извлекает из хранилища значения настройки отбора.
// 
// 
// Возвращаемое значение:
//  РезНастройки - Структура.
// 
Функция ПолучитьНастройкиПостроителя() Экспорт

	РезНастройки = НастройкиПостроителя.Получить();

	Возврат РезНастройки;
	
КонецФункции // ПолучитьНастройкиПостроителя()

#КонецОбласти

#КонецЕсли
