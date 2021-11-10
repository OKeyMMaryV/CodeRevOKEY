﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыФормы = ПараметрыФормы();
	ПараметрыФормы.Вставить("КонтекстныйВызов", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗначениеЗаполнено(Запись.ИмяФормы) Тогда
		Если Запись.ИмяФормы = "Подключить1СОтчетность" Тогда
			ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ПоказатьФормуПредложениеОформитьЗаявлениеНаПодключение(Запись.Организация);
		Иначе
			ОткрытьФорму(Запись.ИмяФормы, ПараметрыФормы, , , , , , РежимОткрытияОкнаФормы.Независимый);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПараметрыФормы()
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормыРеквизитов = РегистрыСведений.ПубликуемыеНавигационныеСсылки.ПараметрыПубликации();
	ЗаполнитьЗначенияСвойств(ПараметрыФормыРеквизитов, Запись);
	ДополнитьПараметрыФормы(ПараметрыФормы, ПараметрыФормыРеквизитов);
	
	ДополнительныеПараметрыФормы = ДополнительныеПараметрыФормы();
	Если ЗначениеЗаполнено(ДополнительныеПараметрыФормы)
		И ТипЗнч(ДополнительныеПараметрыФормы) = Тип("Структура") Тогда
		ДополнитьПараметрыФормы(ПараметрыФормы, ДополнительныеПараметрыФормы);
	КонецЕсли;
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаСервере
Функция ДополнительныеПараметрыФормы()
	
	Запрос = Новый Запрос();
	Запрос.Параметры.Вставить("Идентификатор", Запись.Идентификатор);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПубликуемыеНавигационныеСсылки.ПараметрыФормы КАК ПараметрыФормы
	|ИЗ
	|	РегистрСведений.ПубликуемыеНавигационныеСсылки КАК ПубликуемыеНавигационныеСсылки
	|ГДЕ
	|	ПубликуемыеНавигационныеСсылки.Идентификатор = &Идентификатор";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ПараметрыФормы.Получить();
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Процедура ДополнитьПараметрыФормы(ПараметрыФормы, СтруктураДополнения)
	
	Для Каждого КлючЗначение Из СтруктураДополнения Цикл
		ДобавитьНепустойПараметрФормы(ПараметрыФормы, КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНепустойПараметрФормы(ПараметрыФормы, Ключ, Значение)
	
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыФормы.Свойство(Ключ) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы.Вставить(Ключ, Значение);
	
КонецПроцедуры

#КонецОбласти