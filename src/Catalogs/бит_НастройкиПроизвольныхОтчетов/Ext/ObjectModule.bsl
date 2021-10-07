﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	Если Не ЭтоГруппа Тогда
		
		бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"));
		
		ТипОтчета = Перечисления.бит_ТипыПроизвольныхОтчетов.ПроизвольныйОтчет;   		  		
		
		ФорматЧисел = "ЧЦ=15; ЧДЦ=2"; 
		Префикс     = "П";
		ДлинаИмени  = 4;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;
	КонецЕсли; 	
	
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ДополнительныеСвойства); 
	
	Если Не ЭтоНовый() И Не ПометкаУдаления = Ссылка.ПометкаУдаления Тогда
		// В случае установки или снятия пометки удаления не производить проверку.
		Возврат;
	КонецЕсли;	
	
	// Проверка дублей в настройке использования аналитик.
	Заголовок = "Проверка заполнения элемента справочника """ + Метаданные().Синоним + """ ";

	СтруктураОбязательныхПолей = Новый Структура;
	СтруктураОбязательныхПолей.Вставить("ИмяАналитики");
	бит_ОбщегоНазначения.ПроверитьДублированиеЗначенийВТабличнойЧасти(ЭтотОбъект
	                                                                    , "ИспользованиеАналитики"
																		, СтруктураОбязательныхПолей
																		, Отказ
																		, Заголовок);
																		
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ДополнительныеСвойства, Метаданные().ПолноеИмя());
		
КонецПроцедуры // ПриЗаписи()

Процедура ПриКопировании(ОбъектКопирования)
	
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"), ОбъектКопирования);
		
КонецПроцедуры // ПриКопировании()

#КонецОбласти

#КонецЕсли
