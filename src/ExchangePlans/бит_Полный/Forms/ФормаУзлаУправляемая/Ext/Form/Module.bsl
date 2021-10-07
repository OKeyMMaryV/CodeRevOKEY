﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// В УПП и КА удалим кнопку команды,т.к. отстутствует нужный регистр.
	НайденныйЭлемент = Элементы.Найти("ФормаОбщаяКомандабит_НастроитьПараметрыТранспортаСообщенийОбмена");
	Если НЕ НайденныйЭлемент = Неопределено Тогда
		НайденныйЭлемент.Видимость = бит_ОбщегоНазначения.ЭтоСемействоБП();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти