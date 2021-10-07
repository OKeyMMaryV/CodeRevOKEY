﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение Тогда
		
		КлассификаторыДоходовРасходов.ОбеспечитьФункциональность(
			Справочники.СтатьиЗатрат,
			"ОсуществляетсяЗакупкаТоваровУслугЧерезКомиссионеров");
		
		Если Не Константы.ВестиУчетПоДоговорам.Получить() Тогда
			Константы.ВестиУчетПоДоговорам.Установить(Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
