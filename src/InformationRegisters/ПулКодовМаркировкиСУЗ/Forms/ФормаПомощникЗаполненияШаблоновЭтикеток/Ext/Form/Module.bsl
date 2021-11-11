﻿

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтображатьЛогистическуюЭтикетку = Параметры.ОтображатьЛогистическуюЭтикетку;

	Если НЕ ОтображатьЛогистическуюЭтикетку Тогда
		ЗаполнятьШаблонПотребительскойУпаковки = Истина;
	КонецЕсли;
	
	СобытияФормИСМППереопределяемый.УстановитьПараметрыВыбораШаблонаЭтикетки(
		ЭтотОбъект,
		Элементы.ШаблонПотребительскойЭтикетки.Имя);
	
	СобытияФормИСМППереопределяемый.УстановитьПараметрыВыбораШаблонаЭтикетки(
		ЭтотОбъект,
		Элементы.ШаблонЛогистическойЭтикетки.Имя);
	
	СобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Вставить("ШаблонЛогистическойЭтикетки", ШаблонЛогистическойЭтикетки);
	Настройки.Вставить("ШаблонПотребительскойЭтикетки", ШаблонПотребительскойЭтикетки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	ШаблонЛогистическойЭтикетки = Настройки.Получить("ШаблонЛогистическойЭтикетки");
	ШаблонПотребительскойЭтикетки = Настройки.Получить("ШаблонПотребительскойЭтикетки");	
	
	УправлениеЭлементамиФормы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	Закрыть(ПараметрыЗакрытияФормы());
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ЗаполнятьКоличествоЭкземпляровПриИзменении(Элемент)
	УправлениеЭлементамиФормы(ЭтаФорма);
	Если ЗаполнятьКоличествоЭкземпляров Тогда
		КоличествоЭкземпляровЛогистическойЭтикетки = 1;
	Иначе
		КоличествоЭкземпляровЛогистическойЭтикетки = 0;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнятьШаблонПотребительскойУпаковкиПриИзменении(Элемент)
	УправлениеЭлементамиФормы(ЭтаФорма);
	Если Не ЗаполнятьШаблонПотребительскойУпаковки Тогда
		ШаблонПотребительскойЭтикетки = Неопределено;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ЗаполнятьШаблонЛогистическойУпаковкиПриИзменении(Элемент)
	УправлениеЭлементамиФормы(ЭтаФорма);
	Если Не ЗаполнятьШаблонЛогистическойУпаковки Тогда
		ШаблонЛогистическойЭтикетки = Неопределено;
	КонецЕсли;
КонецПроцедуры 

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиФормы(Форма)
	
	Форма.Элементы.ГруппаЛогистическаяЭтикетка.Видимость = Форма.ОтображатьЛогистическуюЭтикетку;
	Форма.Элементы.ГруппаКоличествоЭкземпляров.Видимость = Форма.ОтображатьЛогистическуюЭтикетку;
	
	Форма.Элементы.ШаблонПотребительскойЭтикетки.Доступность = Форма.ЗаполнятьШаблонПотребительскойУпаковки;
	Форма.Элементы.ШаблонЛогистическойЭтикетки.Доступность = Форма.ЗаполнятьШаблонЛогистическойУпаковки;
	Форма.Элементы.КоличествоЭкземпляровЛогистическойЭтикетки.Доступность = Форма.ЗаполнятьКоличествоЭкземпляров;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЗакрытияФормы()
	
	СтруктураРезультат = Новый Структура();
	Если ЗаполнятьШаблонПотребительскойУпаковки Тогда
		СтруктураРезультат.Вставить("ШаблонПотребительскойЭтикетки", ШаблонПотребительскойЭтикетки);
	КонецЕсли;
	Если ЗаполнятьШаблонЛогистическойУпаковки Тогда
		СтруктураРезультат.Вставить("ШаблонЛогистическойЭтикетки", ШаблонЛогистическойЭтикетки);
	КонецЕсли;
	Если ЗаполнятьКоличествоЭкземпляров Тогда
		СтруктураРезультат.Вставить("КоличествоЭкземпляров", КоличествоЭкземпляровЛогистическойЭтикетки);
	КонецЕсли;
	
	Возврат СтруктураРезультат;
	
КонецФункции

#КонецОбласти