﻿
	
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.Компоновщик = Параметры.Компоновщик;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьОбновить(Команда)
	
	ПараметрыНастроек = Новый Структура;
	ПараметрыНастроек.Вставить("Компоновщик", Объект.Компоновщик);
	
	Закрыть(ПараметрыНастроек);
	
КонецПроцедуры

#КонецОбласти




