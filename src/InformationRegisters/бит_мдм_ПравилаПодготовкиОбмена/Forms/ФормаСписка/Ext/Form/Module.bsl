﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиСервер.ФормаСпискаРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервереБезКонтекста
Процедура КомандаВыполнитьПодготовкуНаСервере()
	
	бит_мдм.ВыполнитьПодготовкуОбмена();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыполнитьПодготовкуОбмена(Команда)
	
	Состояние(НСтр("ru = 'Выполняется подготовка обмена...'"));
	КомандаВыполнитьПодготовкуНаСервере();
	
КонецПроцедуры

#КонецОбласти
