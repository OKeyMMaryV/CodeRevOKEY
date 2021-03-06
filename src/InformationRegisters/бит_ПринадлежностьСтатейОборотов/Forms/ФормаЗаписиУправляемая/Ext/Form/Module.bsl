
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СтатьяОборотов") Тогда
		Запись.СтатьяОборотов = Параметры.СтатьяОборотов;
		Элементы.СтатьяОборотов.ТолькоПросмотр = Истина;
	КонецЕсли;
    
    Если Параметры.Свойство("ЦФО") Тогда
		Запись.ЦФО = Параметры.ЦФО;
		Элементы.ЦФО.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

