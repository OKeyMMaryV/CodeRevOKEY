﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	ВызватьИсключение Нстр("ru = 'Этот функционал более не поддерживается.'");

КонецПроцедуры

#КонецОбласти

#КонецЕсли
