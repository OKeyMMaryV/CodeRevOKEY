////////////////////////////////////////////////////////////////////////////////
// СотрудникиКлиентСерверВнутренний: методы, обслуживающие работу формы сотрудника.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

#Область РаботаСДополнительнымиФормами

Функция ОписаниеДополнительнойФормы(ИмяОткрываемойФормы) Экспорт
	
	Возврат СотрудникиКлиентСерверБазовый.ОписаниеДополнительнойФормы(ИмяОткрываемойФормы);
	
КонецФункции

#КонецОбласти

Функция ПредставлениеСотрудникаПоДаннымФормыСотрудника(Форма) Экспорт
	
	Возврат СотрудникиКлиентСерверБазовый.ПредставлениеСотрудникаПоДаннымФормыСотрудника(Форма);
	
КонецФункции

Процедура УстановитьРежимТолькоПросмотраЛичныхДанныхВФормеСотрудника(Форма) Экспорт
	
	СотрудникиКлиентСерверБазовый.УстановитьРежимТолькоПросмотраЛичныхДанныхВФормеСотрудника(Форма);
	
КонецПроцедуры

Процедура УстановитьВидимостьГруппыФамилияИмяЛатиницей(Форма, ПутьКДанным) Экспорт
	
КонецПроцедуры

#КонецОбласти
