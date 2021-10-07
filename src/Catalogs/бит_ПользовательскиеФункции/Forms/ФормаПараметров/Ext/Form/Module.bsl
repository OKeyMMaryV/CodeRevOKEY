﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.Справочники.бит_ПользовательскиеФункции;
	
	// Вызов механизма защиты
	
	
	ПараметрыФункции = Параметры.ПараметрыФункции;
	ЗначенияПараметров = Параметры.ЗначенияПараметров;
	
	ТаблицаПараметров.Очистить();
	
	Для Каждого Параметр Из ПараметрыФункции Цикл
		
		ОписаниеТипа = Новый ОписаниеТипов(Параметр.фТипПараметра);
		
		Стр = ЗначенияПараметров.Получить(Параметр.Наименование);
		
		Если Стр = Неопределено Тогда
			
			НовСтр = ТаблицаПараметров.Добавить();
			
			НовСтр.Параметр = Параметр.Наименование;
			НовСтр.Значение = ОписаниеТипа.ПривестиЗначение();
			
		Иначе
			
			НовСтр = ТаблицаПараметров.Добавить();
			
			НовСтр.Параметр = Параметр.Наименование;
			
			МассивТиповЗначения = Новый Массив;
			МассивТиповЗначения.Добавить(ТипЗнч(Стр));
			
			ОписаниеТипаЗначения = Новый ОписаниеТипов(МассивТиповЗначения);
			
			Если ОписаниеТипа = ОписаниеТипаЗначения Тогда
				НовСтр.Значение = Стр;
			Иначе
				НовСтр.Значение = ОписаниеТипа.ПривестиЗначение();
			КонецЕсли;	
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаполнитьКэшЗначений(фКэшЗначений);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаПараметров

&НаКлиенте
Процедура ТаблицаПараметровЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицаПараметров.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	СписокВыбора = фКэшЗначений.ДоступныеТипыЗначенияПараметра;
	
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма, Элемент, ТекущиеДанные, "Значение", СписокВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПараметровЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	Элементы.ТаблицаПараметровЗначение.ВыбиратьТип = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВернутьПараметрыИЗакрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьКэшЗначений(КэшированныеЗначения)
	
	КэшированныеЗначения = Новый Структура;
	
	МассивТипов = ТаблицаПараметров.Выгрузить().Колонки.Значение.ТипЗначения.Типы();
	СписокТипов = бит_ОбщегоНазначения.ПодготовитьСписокВыбораТипа(МассивТипов);
	
	КэшированныеЗначения.Вставить("ДоступныеТипыЗначенияПараметра", СписокТипов);
	
КонецПроцедуры                                                      

&НаКлиенте
Функция ВернутьПараметрыИЗакрыть(ПараметрыФормы = Ложь)
	
	СоответствиеПараметров = Неопределено;
	
	Если Не ПараметрыФормы Тогда
		
		СоответствиеПараметров = Новый Соответствие;
		
		Для Каждого Параметр Из ТаблицаПараметров Цикл
			
			СоответствиеПараметров.Вставить(Параметр.Параметр, Параметр.Значение);
			
		КонецЦикла;	
		
	КонецЕсли;
	
	Закрыть(СоответствиеПараметров);
	
КонецФункции	

#КонецОбласти

