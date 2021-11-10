﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;
	КонецЕсли;
	
    СтруктураИзмерений = Новый Структура;
    СтруктураИзмерений.Вставить("ИмяРегистра"          , "бит_ЦФО_Организаций");
    СтруктураИзмерений.Вставить("ИмяИзмерения_Объект"  , "Организация");
    СтруктураИзмерений.Вставить("ИмяИзмерения_Значения", "ЦФО");
    
    // Проверим уникальность набора записей.
    бит_Бюджетирование.ПроверитьУникальностьСопоставленныхЗначений_ОбъектамВНабореЗаписей(ЭтотОбъект, СтруктураИзмерений, Отказ);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
