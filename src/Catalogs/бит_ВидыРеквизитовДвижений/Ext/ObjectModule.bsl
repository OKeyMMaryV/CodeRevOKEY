﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПередЗаписью(Отказ);
	
	Если НЕ Отказ Тогда
		бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ЭтотОбъект.ДополнительныеСвойства);
	КонецЕсли; 
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда			
		Возврат;			
	КонецЕсли;
	
	Если НЕ Отказ Тогда
		бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ЭтотОбъект.ДополнительныеСвойства, Метаданные().ПолноеИмя());
	КонецЕсли; 	
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПередЗаписью(Отказ)
	
	Если НЕ ЭтоГруппа и НЕ ЗначениеЗаполнено(Родитель) Тогда
		// Нельзя создавать новые элементы в корне справочника.
		ТекстСообщения = Нстр("ru = 'На первом уровне иерархии распологаются группы (описание регистров).'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,Ссылка,,,Отказ);
	КонецЕсли;	
	
	// Проверим, нет ли реквизита с таким именем, или группы реквизитов с таким именем.
	Если ЭтоГруппа Тогда
		ПроверитьДубли(Ложь, Отказ);
	Иначе
		// Необходимо проверить дубль для текущего родителя.
		ПроверитьДубли(Истина, Отказ)			
	КонецЕсли;
	
	// Запретим перенос элементов между группами.
	Если НЕ Ссылка.Пустая() И Родитель <> Ссылка.Родитель Тогда
		ТекстСообщения = Нстр("ru = 'Перенос элементов между группами справочника запрещен'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,Ссылка,"Родитель",,Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДубли(ИскатьВГруппе, Отказ)
	
	Если ИскатьВГруппе Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	бит_ВидыРеквизитовДвижений.Ссылка
		|ИЗ
		|	Справочник.бит_ВидыРеквизитовДвижений КАК бит_ВидыРеквизитовДвижений
		|ГДЕ
		|	бит_ВидыРеквизитовДвижений.Наименование = &Наименование
		|	И бит_ВидыРеквизитовДвижений.Родитель В ИЕРАРХИИ(&Родитель)
		|	И бит_ВидыРеквизитовДвижений.Ссылка <> &Ссылка";
		
		ТекстСообщения = Нстр("ru = 'Для регистра ""%1"" реквизит с таким наименованием уже задан'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Родитель);  				   
	Иначе
		ТекстЗапроса =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	бит_ВидыРеквизитовДвижений.Ссылка
		|ИЗ
		|	Справочник.бит_ВидыРеквизитовДвижений КАК бит_ВидыРеквизитовДвижений
		|ГДЕ
		|	бит_ВидыРеквизитовДвижений.Наименование = &Наименование
		|	И бит_ВидыРеквизитовДвижений.Ссылка <> &Ссылка
		|	И ЭтоГруппа";
		
		ТекстСообщения = Нстр("ru = 'Группа с таким нименованием существует'");
	КонецЕсли; 
	
	Запрос = Новый Запрос(); 
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Наименование", Наименование);
	Запрос.УстановитьПараметр("Родитель",     Родитель);
	Запрос.УстановитьПараметр("Ссылка",       Ссылка);
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		// Сообщим о том, что операция невозможна
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("ПОЛЕ"
													,"КОРРЕКТНОСТЬ"
													,"Наименование"
													,
													,
													,ТекстСообщения);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Ссылка, "Наименование",,Отказ);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
