﻿
#Область ОбработчикиСобытийФормы

 // Процедура - обработчик события "ПриСозданииНаСервере" формы.
 // 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.бит_вго_ЗакрытиеРедактированияСверкиВГО;
	
	// Вызов механизма защиты
	
	
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти 
