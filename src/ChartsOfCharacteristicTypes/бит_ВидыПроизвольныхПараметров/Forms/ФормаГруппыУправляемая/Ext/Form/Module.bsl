
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
// 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	// Вызов механизма защиты
    	
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

