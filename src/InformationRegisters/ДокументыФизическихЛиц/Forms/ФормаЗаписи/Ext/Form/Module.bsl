﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьВидимостьДоступность(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	Если ЯвляетсяУдостоверениемЛичности(Запись.Физлицо, Запись.ВидДокумента, Запись.Период) Тогда
		Запись.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
	КонецЕсли;
	
	СотрудникиКлиентСервер.ОбновитьГруппуФамилияИмяЛатиницей(ЭтотОбъект, "Запись");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЯвляетсяУдостоверениемЛичности(Физлицо, ВидДокумента, Дата)
	
	Возврат РегистрыСведений.ДокументыФизическихЛиц.ЯвляетсяУдостоверениемЛичности(Физлицо, ВидДокумента, Дата);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимостьДоступность(Форма)
	
	СотрудникиКлиентСервер.УстановитьВидимостьГруппыФамилияИмяЛатиницей(Форма, "Запись");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СотрудникиКлиентСервер.ПроверитьНаписаниеФИДокументаЛатинскими(ЭтотОбъект, "Запись", Отказ);
	
КонецПроцедуры

#КонецОбласти
