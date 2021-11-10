﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НаименованиеСокращенное = Параметры.НаименованиеСокращенное;
	НаименованиеПолное = Параметры.НаименованиеПолное;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
			Возврат;
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВопросПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеСокращенноеПриИзменении(Элемент)
	
	Префикс = НСтр("ru='ООО'");
	НаименованиеСокращенное = Префикс + " " + СокрЛП(СтрЗаменить(НаименованиеСокращенное, Префикс, ""));
	ЧислоКавычек = СтрЧислоВхождений(НаименованиеСокращенное, """");
	Если ЧислоКавычек = 0 Тогда
		НаименованиеСокращенное = Префикс + " " 
			+ """" + Сред(НаименованиеСокращенное, СтрДлина(Префикс) + 2) + """";
	КонецЕсли;
	
	Если ПустаяСтрока(НаименованиеПолное)
		ИЛИ ОрганизацииФормыКлиентСервер.ПолноеНаименованиеСоответствуетСокращенномуНаименованию(НаименованиеСокращенноеДоИзменения, НаименованиеПолное) Тогда
		НаименованиеПолное = ОрганизацииФормыКлиентСервер.ПолноеНаименованиеПоСокращенномуНаименованию(НаименованиеСокращенное);
	КонецЕсли;
	
	НаименованиеСокращенноеДоИзменения = НаименованиеСокращенное;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ОповеститьОВыбореИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВопросПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОповеститьОВыбореИЗакрыть();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОВыбореИЗакрыть()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	РезультатВыбора = Новый Структура;
	РезультатВыбора.Вставить("НаименованиеСокращенное", НаименованиеСокращенное);
	РезультатВыбора.Вставить("НаименованиеПолное", НаименованиеПолное);
	
	ОповеститьОВыборе(РезультатВыбора);
	
КонецПроцедуры

#КонецОбласти
