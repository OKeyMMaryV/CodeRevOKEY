
// бит_DFedotov Процедура - действие команды "СоздатьДокументыЗатрат"
//
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ПараметрКоманды = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьДокументыЗатрат(ПараметрКоманды);
	
КонецПроцедуры

// бит_DFedotov Процедура вызывает необходимый метод менеджера для создания документов затрат
//
// Параметры:
//	ДокЗаявка - ДокументСсылка.бит_ЗаявкаНаЗатраты - документ, на основании расходных позиций которого создаются документы
&НаСервере
Процедура СоздатьДокументыЗатрат(ДокЗаявка)
	
	Документы.бит_ЗаявкаНаЗатраты.СоздатьДокументыЗатратПоЗаявке(ДокЗаявка);
	
КонецПроцедуры