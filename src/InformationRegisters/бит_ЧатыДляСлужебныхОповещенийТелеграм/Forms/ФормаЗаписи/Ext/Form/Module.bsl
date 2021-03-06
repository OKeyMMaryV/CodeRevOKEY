
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Параметры.ЧатТелеграм) Тогда
	
		Запись.Чат = Параметры.ЧатТелеграм;
	
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(Параметры.БотТелеграм) Тогда
	
		Запись.Бот = Параметры.БотТелеграм;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Запись.Бот) Тогда 
		Запись.Бот = Константы.бит_БотДляОповещенийТелеграм.Получить();
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти