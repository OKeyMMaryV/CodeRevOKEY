﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2019-11-13 (#3393)
	Если Параметры.Свойство("ОтображениеСписка") Тогда 
		Элементы.Список.Отображение = Параметры.ОтображениеСписка;
	КонецЕсли;
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2019-11-13 (#3393)
	
КонецПроцедуры

#КонецОбласти
