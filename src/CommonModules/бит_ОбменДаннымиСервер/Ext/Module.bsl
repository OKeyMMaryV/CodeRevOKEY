﻿
#Область СлужебныйПрограммныйИнтерфейс

// Процедура обработчик подписки на события бит_ПолныйРегистрацияПередЗаписью.
// 
// Параметры:
// 	Источник
// 	Отказ
// 
Процедура бит_ПолныйРегистрацияПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
    	Возврат;
	КонецЕсли;
	
	Если бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_ЭтоЧужойПодчиненныйУзел") = Истина Тогда
	    // Функционал БФ может работать только в узлах, созданных с помощью ПО бит_Полный.
		Возврат;
	КонецЕсли; 			
	
	Если бит_ОбщегоНазначения.ЭтоСемействоБП() 
		ИЛИ бит_ОбщегоНазначения.ЭтоУТ() Тогда
		ИмяПланаОбмена = "бит_Полный";
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСобытия");
		Модуль.МеханизмРегистрацииОбъектовПередЗаписью(ИмяПланаОбмена, Источник, Отказ);                
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработчик подписки на события бит_ПолныйРегистрацияДокументаПередЗаписью.
// 
// Параметры:
// 	Источник
// 	Отказ
// 	РежимЗаписи
// 	РежимПроведения
// 
Процедура бит_ПолныйРегистрацияДокументаПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
    	Возврат;
	КонецЕсли;
	
	Если бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_ЭтоЧужойПодчиненныйУзел") = Истина Тогда
	    // Функционал БФ может работать только в узлах, созданных с помощью ПО бит_Полный.
		Возврат;
	КонецЕсли; 			
	
	Если бит_ОбщегоНазначения.ЭтоСемействоБП() 
		ИЛИ бит_ОбщегоНазначения.ЭтоУТ() Тогда	
		ИмяПланаОбмена = "бит_Полный";
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСобытия");
		Модуль.МеханизмРегистрацииОбъектовПередЗаписьюДокумента(ИмяПланаОбмена, Источник, Отказ, РежимЗаписи, РежимПроведения);                
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработчик подписки на события бит_ПолныйРегистрацияКонстантыПередЗаписью.
// 
// Параметры:
// 	Источник
// 	Отказ
// 
Процедура бит_ПолныйРегистрацияКонстантыПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
    	Возврат;
	КонецЕсли;
	
	Если бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_ЭтоЧужойПодчиненныйУзел") = Истина Тогда
	    // Функционал БФ может работать только в узлах, созданных с помощью ПО бит_Полный.
		Возврат;
	КонецЕсли; 			
	
	Если бит_ОбщегоНазначения.ЭтоСемействоБП() 
		ИЛИ бит_ОбщегоНазначения.ЭтоУТ() Тогда	
		ИмяПланаОбмена = "бит_Полный";
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСобытия");
		Модуль.МеханизмРегистрацииОбъектовПередЗаписьюКонстанты(ИмяПланаОбмена, Источник, Отказ);                
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработчик подписки на события бит_ПолныйРегистрацияНабораЗаписейПередЗаписью.
// 
// Параметры:
// 	Источник
// 	Отказ
// 	Замещение
// 
Процедура бит_ПолныйРегистрацияНабораЗаписейПередЗаписью(Источник, Отказ, Замещение) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
    	Возврат;
	КонецЕсли;
	
	Если бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_ЭтоЧужойПодчиненныйУзел") = Истина Тогда
	    // Функционал БФ может работать только в узлах, созданных с помощью ПО бит_Полный.
		Возврат;
	КонецЕсли; 		
		
	Если бит_ОбщегоНазначения.ЭтоСемействоБП() 
		ИЛИ бит_ОбщегоНазначения.ЭтоУТ() Тогда	
		ИмяПланаОбмена = "бит_Полный";
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСобытия");
		Модуль.МеханизмРегистрацииОбъектовПередЗаписьюРегистра(ИмяПланаОбмена, Источник, Отказ, Замещение);                
	КонецЕсли;
	
КонецПроцедуры

// Процедура обработчик подписки на события бит_ПолныйРегистрацияУдаленияПередУдалением.
// 
// Параметры:
// 	Источник
// 	Отказ
// 
Процедура бит_ПолныйРегистрацияУдаленияПередУдалением(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
    	Возврат;
	КонецЕсли;
	
	Если бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_ЭтоЧужойПодчиненныйУзел") = Истина Тогда
	    // Функционал БФ может работать только в узлах, созданных с помощью ПО бит_Полный.
		Возврат;
	КонецЕсли; 		
		
	Если бит_ОбщегоНазначения.ЭтоСемействоБП()
		ИЛИ бит_ОбщегоНазначения.ЭтоУТ() Тогда
		ИмяПланаОбмена = "бит_Полный";
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСобытия");
		Модуль.МеханизмРегистрацииОбъектовПередУдалением(ИмяПланаОбмена, Источник, Отказ);                
	КонецЕсли;
	
КонецПроцедуры // бит_ПолныйЗарегистрироватьУдалениеПередУдалением()

// Процедура инициирует обновление правил регистрации в регистре сведений
// 	ПравилаДляОбменаДанными из макетов планов обмена.
// 
Процедура ВыполнитьОбновлениеПравилДляОбменаДанными() Экспорт
	
	Если бит_ОбщегоНазначения.ЭтоСемействоБП()
		ИЛИ бит_ОбщегоНазначения.ЭтоУТ() Тогда	
		Модуль = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиСервер");
		Модуль.ВыполнитьОбновлениеПравилДляОбменаДанными();                
	КонецЕсли; 	
	
КонецПроцедуры // ВыполнитьОбновлениеПравилДляОбменаДанными()

#КонецОбласти
