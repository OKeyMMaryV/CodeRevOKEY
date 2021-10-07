﻿#Область СлужебныйПрограммныйИнтерфейс

// Возвращает производственный календарь организации по умолчанию.
// Если производственный календарь организации не назначался - возвращается
// производственный календарь РФ.
//
// Параметры:
//	Организация	- СправочникСсылка.Организации
//
// ВозвращаемоеЗначение:
//	СправочникСсылка.ПроизводственныеКалендари
//
Функция ПроизводственныйКалендарьОрганизации(Организация) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПроизводственныеКалендариОрганизаций.ПроизводственныйКалендарь КАК ПроизводственныйКалендарь
		|ИЗ
		|	РегистрСведений.ПроизводственныеКалендариОрганизаций КАК ПроизводственныеКалендариОрганизаций
		|ГДЕ
		|	ПроизводственныеКалендариОрганизаций.Организация = &Организация";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И ЗначениеЗаполнено(Выборка.ПроизводственныйКалендарь) Тогда
		ПроизводственныйКалендарь = Выборка.ПроизводственныйКалендарь;
	Иначе
		ПроизводственныйКалендарь = КалендарныеГрафики.ОсновнойПроизводственныйКалендарь();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ПроизводственныйКалендарь;
	
КонецФункции

#КонецОбласти
