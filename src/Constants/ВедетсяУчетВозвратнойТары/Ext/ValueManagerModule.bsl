﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
    	Возврат;
    КонецЕсли;
	
	Если Значение Тогда
		Справочники.ВидыНоменклатуры.СоздатьЭлементыВозвратнаяТара();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
