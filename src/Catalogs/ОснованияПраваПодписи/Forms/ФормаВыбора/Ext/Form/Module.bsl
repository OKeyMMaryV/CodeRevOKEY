#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Дата") тогда
		ДатаОтбора =  Параметры.Отбор.Дата;
	иначе
		ДатаОтбора =  ТекущаяДатаСеанса();
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			Список, "ОтборПоДате", ДатаОтбора);
	
	УстановитьОтбор(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказыватьНеАктуальныеОснованияПриИзменении(Элемент)
	
	УстановитьОтбор(ЭтотОбъект, НЕ ПоказыватьНеактуальныеОснования);
	
КонецПроцедуры

#КонецОбласти

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтбор(Форма, Использование = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Форма.Список, "ЗаписьАктуальна", Истина, ВидСравненияКомпоновкиДанных.Равно,, Использование);
	
КонецПроцедуры
