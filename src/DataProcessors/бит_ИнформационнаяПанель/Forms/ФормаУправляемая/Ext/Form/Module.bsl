
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	МетаданныеОбъекта = Метаданные.Обработки.бит_ИнформационнаяПанель;
	
	Если фОтказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Объект") Тогда
		Объект.Объект = Параметры.Объект;
		Элементы.Объект.Видимость = Ложь;
	КонецЕсли; 
	
	// Вызов механизма разделения прав доступа.
	// бит_ПраваДоступа.ПередОткрытиемФормыОтчета(Отказ,СтандартнаяОбработка,ЭтотОбъект,ЭтаФорма);	
    	
	ОбновитьВсеДанные();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если фОтказ Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектПриИзменении(Элемент)
	
	ОбновитьВсеДанные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДействиеФормыОбновить(Команда)
	
	ОбновитьВсеДанные();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обновляет данные табличного поля формы.
//
&НаСервере
Процедура ОбновитьВсеДанные()
 
	ОбработкаОбъект = ДанныеФормыВЗначение(Объект, Тип("ОбработкаОбъект.бит_ИнформационнаяПанель"));
	ОбработкаОбъект.ОбновитьИнформацию(ЭтаФорма.ПолеТабличногоДокументаИнформация);
	ЗначениеВДанныеФормы(ОбработкаОбъект, Объект);

КонецПроцедуры

#КонецОбласти