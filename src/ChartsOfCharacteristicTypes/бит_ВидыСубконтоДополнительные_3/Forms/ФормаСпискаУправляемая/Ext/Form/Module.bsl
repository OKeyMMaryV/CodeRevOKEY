﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.ПланыВидовХарактеристик.бит_ВидыСубконтоДополнительные_3;
	
    // Вызов механизма защиты
    
    
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Выведем установленный заголовок.
    бит_НазначениеСинонимовОбъектов.ВывестиЗаголовокФормы(МетаданныеОбъекта
														 ,ЭтаФорма
														 ,Перечисления.бит_ВидыФормОбъекта.Списка);
														 
КонецПроцедуры

#КонецОбласти
