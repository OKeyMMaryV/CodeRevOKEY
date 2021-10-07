﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Параметры.ИмяОтчетаРасшифровки)
		Или ПустаяСтрока(Параметры.ИмяСКД)
		Или Не ЗначениеЗаполнено(Параметры.ИДИменПоказателей) Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли; 
	
	ОтчетРасшифровка = Отчеты[Параметры.ИмяОтчетаРасшифровки].Создать();
	ОтчетРасшифровка.СформироватьОтчетРасшифровку(Параметры, РасшифровкаПоказателей);
	
	Заголовок = Параметры.ЗаголовокРасшифровки;
	
КонецПроцедуры

#КонецОбласти
