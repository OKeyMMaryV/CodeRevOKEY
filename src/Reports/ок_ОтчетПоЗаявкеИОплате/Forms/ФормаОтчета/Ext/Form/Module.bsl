
&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.Свойство("ФВБ")
	 ИЛИ НЕ ЗначениеЗаполнено(Параметры.ФВБ)
	Тогда 
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Отчет.ФВБ = Параметры.ФВБ;
	
КонецПроцедуры
