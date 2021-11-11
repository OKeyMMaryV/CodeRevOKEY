﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеВИБ(ПараметрыВыгрузки, АдресХранилища) Экспорт
	
	СписокОшибок = Новый СписокЗначений;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанныеФайла = ПараметрыВыгрузки.ДвоичныеДанныеФайла;
	ДвоичныеДанныеФайла.Записать(ИмяВременногоФайла);
	
	ФайлОбмена = Новый ЧтениеXML();
	ФайлОбмена.ОткрытьФайл(ИмяВременногоФайла);
	
	Попытка
		ФайлОбмена.Прочитать();		
	Исключение
		ТекстСообщения = НСтр("ru = 'Загрузка из файлов данного типа не поддерживается.'");		
		ПоместитьВоВременноеХранилище(ТекстСообщения, АдресХранилища);
		Возврат;
	КонецПопытки;
		
	ОбработкаОбмена = Обработки.УниверсальныйОбменДаннымиXML.Создать();
	ОбработкаОбмена.РежимОбмена = "Загрузка";
	ОбработкаОбмена.ИмяФайлаОбмена = ИмяВременногоФайла;
	ОбработкаОбмена.РежимОтладкиАлгоритмов = 3;
	ОбработкаОбмена.ФлагРежимОтладкиОбработчиков = Истина;
	ОбработкаОбмена.ФлагРежимОтладки = Истина;
	ОбработкаОбмена.ИмяФайлаВнешнейОбработкиОбработчиковСобытий = "ОбработчикиЗагрузкиИзТиС";
	ОбработкаОбмена.ИмяФайлаПротоколаОбмена = ПолучитьИмяВременногоФайла("txt");
	
	ОбработкаОбмена.ВыполнитьЗагрузку();
	
	ЗагруженыДокументы = ОбработкаОбмена.Параметры.Свойство("Организация");
	
	Если ОбработкаОбмена.ФлагОшибки Тогда		
		ТекстСообщения = НСтр("ru = 'При загрузке данных произошла ошибка.'");
		РезультатВыполнения = Новый Структура("ТекстСообщения, Ошибка, СписокОшибок", ТекстСообщения, Истина, СписокОшибок);
	Иначе		
		
		
		ТекстСообщения =  НСтр("ru = 'Загрузка данных завершена.'");	
		
		Если ЗагруженыДокументы Тогда
		
			РезультатВыполнения = Новый Структура("ТекстСообщения, Организация,  
		                                       |НачалоПериодаВыгрузки, ОкончаниеПериодаВыгрузки, 
											   |Ошибка, СписокОшибок", 
											   ТекстСообщения, ОбработкаОбмена.Параметры.Организация,
											   ОбработкаОбмена.ДатаНачала, ОбработкаОбмена.ДатаОкончания,  
											   Ложь, СписокОшибок);
		Иначе
			РезультатВыполнения = Новый Структура("ТекстСообщения, Ошибка, СписокОшибок", ТекстСообщения, Ложь, СписокОшибок);								   
		КонецЕсли;
											   
	КонецЕсли;

	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
		
КонецПроцедуры

#КонецЕсли