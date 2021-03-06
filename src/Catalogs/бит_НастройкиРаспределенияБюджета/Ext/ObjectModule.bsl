#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоГруппа Тогда
		Возврат;	
	КонецЕсли; 
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ВидНастройки) Тогда
		ВидНастройки = Перечисления.бит_ВидыНастроекРаспределенияБюджета.Простая;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(СпособРаспределения) Тогда
		СпособРаспределения = Перечисления.бит_СпособыРаспределенияРесурсовБюджета.Независимо;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
