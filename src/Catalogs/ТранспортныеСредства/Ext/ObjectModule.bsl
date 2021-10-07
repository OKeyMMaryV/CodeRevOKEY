﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) Тогда
		
		Наименование = СтрШаблон(НСтр("ru = '%1 (%2)'"), Марка, РегистрационныйЗнак);
		
	Иначе
		
		ПредыдущиеЗначения = Неопределено;
		Если ДополнительныеСвойства.Свойство("ПредыдущиеЗначения", ПредыдущиеЗначения)
			И ТипЗнч(ПредыдущиеЗначения) = Тип("Структура") Тогда
			
			Наименование = СтрЗаменить(Наименование, ПредыдущиеЗначения.Марка, Марка);
			Наименование = СтрЗаменить(Наименование, ПредыдущиеЗначения.РегистрационныйЗнак, РегистрационныйЗнак);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Наименование = "";
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Наименование");
	
	Если ДополнительныеСвойства.Свойство("ПроверятьТопливо") И Не ДополнительныеСвойства.ПроверятьТопливо Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("Топливо");
		МассивНепроверяемыхРеквизитов.Добавить("НормаРасхода");
		
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	// Создание элемента на основании введенных данных из поле ввода
	Если ДанныеЗаполнения = Неопределено И Не ПустаяСтрока(ТекстЗаполнения) Тогда
		Марка = ТекстЗаполнения;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Собственник) Тогда
		Собственник = Справочники.Организации.ОрганизацияПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
