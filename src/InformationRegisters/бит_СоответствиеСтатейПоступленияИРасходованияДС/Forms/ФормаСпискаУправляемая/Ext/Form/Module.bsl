﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиСервер.ФормаСпискаРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти


