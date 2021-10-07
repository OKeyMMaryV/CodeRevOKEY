﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мВалютаМеждУчета Экспорт; // Хранит валюту международного учета.

#КонецОбласти

#Область ОбработчикиСобытий

 // Процедура - обработчик события "ОбработкаПроведения".
// 
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = бит_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Проверка ручной корректировки
	Если бит_ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект, Ложь) Тогда
		Возврат
	КонецЕсли;
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	СтруктураТаблиц = ПодготовитьТаблицыДокумента();	
	
	ПроверкаТаблицыНМА(СтруктураТаблиц.НМА,СтруктураШапкиДокумента,Отказ,Заголовок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	
	Если НЕ Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента,СтруктураТаблиц,Отказ,Заголовок);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
// 
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	бит_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);

КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью".
// 
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
 
	
	// Выполним синхронизацию пометки на удаление объекта и дополнительных файлов.
	бит_ХранениеДополнительнойИнформации.СинхронизацияПометкиНаУдалениеУДополнительныхФайлов(ЭтотОбъект);
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	 
	
КонецПроцедуры // ПриЗаписи()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьШапкуДокумента();
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнитьШапкуДокумента(ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	// Проверим заполнение таб.части НематериальныеАктивы.
	
	ОбязательныеПоляАмортизации = Новый Структура;
	
	ОбязательныеПоляАмортизации.Вставить("МетодНачисленияАмортизации", НСтр("ru='Метод начисления амортизации'"));
	ОбязательныеПоляАмортизации.Вставить("СпособОтраженияРасходовПоАмортизации", НСтр("ru='Способ отражения расходов по амортизации'"));
	
	Для Каждого ТекущаяСтрока Из НематериальныеАктивы Цикл
		
		Ном = ТекущаяСтрока.НомерСтроки-1;
		
		Если ТекущаяСтрока.НачислятьАмортизацию Тогда
			
			Для Каждого ТекущееПоле Из ОбязательныеПоляАмортизации Цикл
				
				Если Не ЗначениеЗаполнено(ТекущаяСтрока[ТекущееПоле.Ключ]) Тогда
					ТекстСообщения = НСтр("ru='Не заполнено значение реквизита ""%1%""!'");
					ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекущееПоле.Значение);
					бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,ЭтотОбъект,"НематериальныеАктивы["+Ном+"]."+ТекущееПоле.Ключ,Отказ);
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Проверим наличие дублей в табличной части "НематериальныеАктивы".	
	СтруктураОбязательныхПолей = Новый Структура("НематериальныйАктив");
	бит_ОбщегоНазначения.ПроверитьДублированиеЗначенийВТабличнойЧасти(ЭтотОбъект
	                                                                  , "НематериальныеАктивы"
																	  , СтруктураОбязательныхПолей
																	  , Отказ);
																	  
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Функция готовит таблицы документа для проведения.
// 
// Возвращаемое значение:
//   СтруктураТаблиц   - Структура.
// 
Функция ПодготовитьТаблицыДокумента() Экспорт
	
	СтруктураТаблиц = Новый Структура;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка"             ,Ссылка);
	Запрос.УстановитьПараметр("ПустоеСсылочноеЗначение",Перечисления.бит_му_МетодыНачисленияАмортизации.ПустаяСсылка());
	Запрос.УстановитьПараметр("СостояниеПринято"   ,Перечисления.бит_му_СостоянияНМА.ПринятоКУчету);
	Запрос.УстановитьПараметр("СостояниеВыбыло"    ,Перечисления.бит_му_СостоянияНМА.СнятоСУчета);
	
	Запрос.Текст =  "ВЫБРАТЬ
	                |	ТабЧасть.НематериальныйАктив,
	                |	ТабЧасть.НомерСтроки,
	                |	Принятые.ДатаСостояния КАК ДатаПринятия,
	                |	Выбывшие.ДатаСостояния КАК ДатаВыбытия,
	                |	ВЫБОР
	                |		КОГДА ТабЧасть.СрокПолезногоИспользования_Старый <> ТабЧасть.СрокПолезногоИспользования
	                |			ТОГДА ТабЧасть.СрокПолезногоИспользования
	                |		ИНАЧЕ &ПустоеСсылочноеЗначение
	                |	КОНЕЦ КАК СрокПолезногоИспользования,
	                |	ВЫБОР
	                |		КОГДА ТабЧасть.НачислятьАмортизацию_Старый <> ТабЧасть.НачислятьАмортизацию
	                |			ТОГДА ТабЧасть.НачислятьАмортизацию
	                |		ИНАЧЕ &ПустоеСсылочноеЗначение
	                |	КОНЕЦ КАК НачислятьАмортизацию,
	                |	ВЫБОР
	                |		КОГДА ТабЧасть.МетодНачисленияАмортизации_Старый <> ТабЧасть.МетодНачисленияАмортизации
	                |			ТОГДА ТабЧасть.МетодНачисленияАмортизации
	                |		ИНАЧЕ &ПустоеСсылочноеЗначение
	                |	КОНЕЦ КАК МетодНачисленияАмортизации,
	                |	ВЫБОР
	                |		КОГДА ТабЧасть.ПредполагаемыйОбъемПродукции_Старый <> ТабЧасть.ПредполагаемыйОбъемПродукции
	                |			ТОГДА ТабЧасть.ПредполагаемыйОбъемПродукции
	                |		ИНАЧЕ &ПустоеСсылочноеЗначение
	                |	КОНЕЦ КАК ПредполагаемыйОбъемПродукции,
	                |	ВЫБОР
	                |		КОГДА ТабЧасть.ЕдиницаИзмеренияОбъемаПродукции_Старый <> ТабЧасть.ЕдиницаИзмеренияОбъемаПродукции
	                |			ТОГДА ТабЧасть.ЕдиницаИзмеренияОбъемаПродукции
	                |		ИНАЧЕ &ПустоеСсылочноеЗначение
	                |	КОНЕЦ КАК ЕдиницаИзмеренияОбъемаПродукции,
	                |	ВЫБОР
	                |		КОГДА ТабЧасть.КоэффициентУскорения_Старый <> ТабЧасть.КоэффициентУскорения
	                |			ТОГДА ТабЧасть.КоэффициентУскорения
	                |		ИНАЧЕ &ПустоеСсылочноеЗначение
	                |	КОНЕЦ КАК КоэффициентУскорения,
	                |	ВЫБОР
	                |		КОГДА ТабЧасть.СпособОтраженияРасходовПоАмортизации_Старый <> ТабЧасть.СпособОтраженияРасходовПоАмортизации
	                |			ТОГДА ТабЧасть.СпособОтраженияРасходовПоАмортизации
	                |		ИНАЧЕ &ПустоеСсылочноеЗначение
	                |	КОНЕЦ КАК СпособОтраженияРасходовПоАмортизации
	                |ИЗ
	                |	Документ.бит_му_ИзменениеПараметровУчетаНМА.НематериальныеАктивы КАК ТабЧасть
	                |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СостоянияНМА КАК Принятые
	                |		ПО ТабЧасть.НематериальныйАктив = Принятые.НематериальныйАктив
	                |			И ТабЧасть.Ссылка.Организация = Принятые.Организация
	                |			И (Принятые.Состояние = &СостояниеПринято)
	                |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.бит_му_СостоянияНМА КАК Выбывшие
	                |		ПО ТабЧасть.НематериальныйАктив = Выбывшие.НематериальныйАктив
	                |			И ТабЧасть.Ссылка.Организация = Выбывшие.Организация
	                |			И (Выбывшие.Состояние = &СостояниеВыбыло)
	                |ГДЕ
	                |	ТабЧасть.Ссылка = &Ссылка
	                |	И (ТабЧасть.СрокПолезногоИспользования_Старый <> ТабЧасть.СрокПолезногоИспользования
	                |			ИЛИ ТабЧасть.НачислятьАмортизацию_Старый <> ТабЧасть.НачислятьАмортизацию
	                |			ИЛИ ТабЧасть.МетодНачисленияАмортизации_Старый <> ТабЧасть.МетодНачисленияАмортизации
	                |			ИЛИ ТабЧасть.ПредполагаемыйОбъемПродукции_Старый <> ТабЧасть.ПредполагаемыйОбъемПродукции
	                |			ИЛИ ТабЧасть.ЕдиницаИзмеренияОбъемаПродукции_Старый <> ТабЧасть.ЕдиницаИзмеренияОбъемаПродукции
	                |			ИЛИ ТабЧасть.КоэффициентУскорения_Старый <> ТабЧасть.КоэффициентУскорения
	                |			ИЛИ ТабЧасть.СпособОтраженияРасходовПоАмортизации_Старый <> ТабЧасть.СпособОтраженияРасходовПоАмортизации)";
					
	РезТаблица = Запрос.Выполнить().Выгрузить();
	
	СтруктураТаблиц.Вставить("НМА",РезТаблица);
	
	Возврат СтруктураТаблиц;
	
КонецФункции // ПодготовитьТаблицуБДДС()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура проверят таблицу НМА на наличие не принятые либо выбывшие НМА.
// 
// Параметры:
//  ТаблицаОС  - ТаблицаЗначений,
//  СтруктураШапкиДокумента - Структура,
//  Отказ      - Булево,
//  Заголовок  - Строка.
// 
Процедура ПроверкаТаблицыНМА(ТаблицаНМА,СтруктураШапкиДокумента,Отказ,Заголовок)

	КолонкиТаблицы = ТаблицаНМА.Колонки;
	Для каждого СтрокаТаблицы Из ТаблицаНМА Цикл
		
		бит_му_ВНА.ПроверитьСтрокуТаблицыНМА(СтрокаТаблицы,КолонкиТаблицы,СтруктураШапкиДокумента,Отказ,Заголовок);
		
	КонецЦикла; 

КонецПроцедуры // ПроверкаТаблицыНМА()
 
Процедура ЗаполнитьШапкуДокумента(ОбъектКопирования=Неопределено)
	
	// Заполним шапку документа значениями по умолчанию.
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"), ОбъектКопирования);

КонецПроцедуры

// Процедура выполняет движения по регистрам.
//                
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента,СтруктураТаблиц,Отказ,Заголовок)
	
	// Движения по регистру сведений бит_му_ПараметрыОС.
	КолонкиТаблицы = СтруктураТаблиц.НМА.Колонки;
	ТаблицаДанных  = СтруктураТаблиц.НМА;
	НаборЗаписей   = Движения.бит_му_ПараметрыНМА;
	
	ВидыПараметров = бит_му_ВНА.ПолучитьВидыПараметров(ПланыВидовХарактеристик.бит_му_ВидыПараметровВНА.НематериальныеАктивы);
	бит_му_ВНА.ЗаписатьПараметрыВНА(НаборЗаписей,СтруктураШапкиДокумента,ТаблицаДанных,ВидыПараметров,"НМА");
	
	
КонецПроцедуры // ДвиженияПоРегистрам()

#КонецОбласти

#КонецЕсли
