﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПередЗаписью" НабораЗаписей.
// 
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;
	КонецЕсли; 
			
КонецПроцедуры // ПередЗаписью()

#КонецОбласти

#КонецЕсли
