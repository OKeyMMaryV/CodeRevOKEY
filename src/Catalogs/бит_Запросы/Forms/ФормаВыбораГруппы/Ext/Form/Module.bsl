﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.Справочники.бит_Запросы;
	
	// Вызов механизма защиты
	 	
	бит_РаботаСДиалогамиСервер.ФормаВыбораПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);
	
	Если фОтказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
		Возврат;	
	КонецЕсли;
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти
