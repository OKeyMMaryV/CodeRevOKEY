﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.бит_ЦФО_Организаций;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаполнитьИЗакрыть(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Структура = Новый Структура;
	
	Структура.Вставить("ЦФО"		, ЦФО);
	Структура.Вставить("Организация", Организация);
	
	Закрыть(Структура);
	
КонецПроцедуры

#КонецОбласти
