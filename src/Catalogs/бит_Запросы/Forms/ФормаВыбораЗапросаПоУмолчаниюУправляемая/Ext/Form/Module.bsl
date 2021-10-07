﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗначениеВРеквизитФормы(Параметры.ХранилищеДереваВыбора.Получить(), "ДеревоВыбора");
	НомерТекущейСтроки = Параметры.НомерТекущейСтроки;
	
	Параметры.Свойство("Режим", Режим);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ДеревоВыбора.ТекущаяСтрока = НомерТекущейСтроки;	
	
КонецПроцедуры // ПриОткрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДеревоВыбораПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И ТекущиеДанные.Уровень = 2 Тогда
		
		Если Режим = "HTTP" Тогда
			
			ВыбранноеЗначение = ТекущиеДанные.Значение;
			
		Иначе	
			
			ПолноеИмяРегистра = ТекущиеДанные.ПолучитьРодителя().Значение;
			ПолноеИмяРегистра = СтрЗаменить(ПолноеИмяРегистра, "Регистры", "Регистр");
			
			ВариантЗапр       = ТекущиеДанные.Значение;
			ВыбранноеЗначение = ПолноеИмяРегистра + ?(ЗначениеЗаполнено(ВариантЗапр), "." + ВариантЗапр, "");
			
		КонецЕсли; 
		
	Иначе
		
		ВыбранноеЗначение = "";
		
	КонецЕсли;
	
КонецПроцедуры // ДеревоВыбораПриАктивизацииСтроки()

&НаКлиенте
Процедура ДеревоВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОбработкаВыбораЗначения();
	
КонецПроцедуры // ДеревоВыбораВыбор()

&НаКлиенте
Процедура ДеревоВыбораСтрокаВыбораОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры // ДеревоВыбораСтрокаВыбораОчистка()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОбработкаВыбораЗначения();	
	
КонецПроцедуры // ОК()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура обрабатывает выбор значения.
// 
&НаКлиенте
Процедура ОбработкаВыбораЗначения()
	
	Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		
		Закрыть(ВыбранноеЗначение);
		
	Иначе
		
		ТекстСообщения = Нстр("ru = 'Вариант запроса не выбран.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаВыбораЗначения()

#КонецОбласти
