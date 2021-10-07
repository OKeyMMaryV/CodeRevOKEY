﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда			
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ЭтотОбъект.ДополнительныеСвойства);
	
	Если не ТолькоРучныеИзменения Тогда
		// Необходимо компилировать комплект
		бит_МеханизмХозяйственныхОперацийСервер.ИнтерпретироватьКомплект(ЭтотОбъект);
	КонецЕсли;	
	
	УникальныйИД = бит_МеханизмХозяйственныхОперацийСервер.ПолучитьИдентификаторКомплекта(ЭтотОбъект);
	
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
	
// Функция возвращает наименование версии по умолчанию.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  СтрокаНаименование - Строка.
// 
Функция СформироватьНаименованиеВерсии() Экспорт
	
	Если ВидДокумента.Пустая() Тогда
		Возврат "";
	КонецЕсли;	
	
	СтрокаНаименование = ВидДокумента.Наименование + " Комплект №" + Код;
	
	Возврат СтрокаНаименование;
	
КонецФункции

#КонецОбласти

#КонецЕсли
