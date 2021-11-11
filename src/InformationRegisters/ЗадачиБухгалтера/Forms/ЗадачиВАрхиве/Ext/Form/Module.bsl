﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ОбщегоНазначенияБПВызовСервера.УстановитьОтборПоОсновнойОрганизации(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		ОбщегоНазначенияБПКлиент.ИзменитьОтборПоОсновнойОрганизации(Список, , Параметр);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПередЗагрузкойПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	ОбщегоНазначенияБП.ВосстановитьОтборСписка(Список, Настройки, "Организация");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыКоманды = ВыполнениеЗадачБухгалтераКлиентСервер.НовыеПараметрыКомандЗадачи();
	ЗаполнитьЗначенияСвойств(ПараметрыКоманды, Элемент.ТекущиеДанные);
	
	ОписаниеДействия = ЗадачиБухгалтераКлиентСервер.ОписаниеДействия(ПараметрыКоманды);
	ВыполнениеЗадачБухгалтераКлиент.ВыполнитьДействие(ОписаниеДействия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаУбратьИзВыполненных(Команда)
	
	КлючЗаписи = Элементы.Список.ТекущаяСтрока;
	
	Если КлючЗаписи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УбратьИзВыполненных(КлючЗаписи);
	
	ОповеститьОбИзменении(КлючЗаписи);
	
	// Оповестим форму списка задач бухгалтера. Возможно, необходимо сменить текущую страницу формы.
	// Например, если до добавления нового налога, все задачи на сегодня выполнены.
	Оповестить("СписокЗадачБухгалтера_Изменение");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.ЗеленыйЛес);
	
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Статус");
	ЭлементОтбора.ПравоеЗначение = "";
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	
	ЭлементПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементПоля.Использование = Истина;
	ЭлементПоля.Поле = Новый ПолеКомпоновкиДанных("Статус");
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УбратьИзВыполненных(КлючЗаписи)
	
	РегистрыСведений.ЗадачиБухгалтера.УстановитьСтатусВыполнено(КлючЗаписи, Ложь);
	
КонецПроцедуры

#КонецОбласти