﻿#Область СлужебныйПрограммныйИнтерфейс

// Проверяет результат обработки штрихкода на необходимость интерактивного уточнения данных у пользователя.
// 
// Параметры:
//  РезультатОбработки - (См. ШтрихкодированиеИСМП.ИнициализироватьРезультатОбработкиШтрихкода).
// Возвращаемое значение:
//  Булево - Истина, если необходимо уточнить данные у пользователя.
Функция ТребуетсяУточнениеДанныхУПользователя(РезультатОбработки) Экспорт
	
	Возврат РезультатОбработки.ТребуетсяАвторизацияМОТП Или РезультатОбработки.ТребуетсяУточнениеДанных;
	
КонецФункции

// Выполняет анализ результат обработки штрихкода, на основании которого выполняет необходимые действия.
// 
// Параметры:
//  ПараметрыЗавершенияВводаШтрихкода - (См. ШтрихкодированиеКлиент.ПараметрыЗавершенияОбработкиВводаШтрихкода).
Функция ЗавершитьОбработкуВводаШтрихкода(ПараметрыЗавершенияВводаШтрихкода, ВыполнятьОбработчикОповещения = Истина) Экспорт

	ПараметрыСканирования       = ПараметрыЗавершенияВводаШтрихкода.ПараметрыСканирования;
	РезультатОбработкиШтрихкода = ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода;
	Форма                       = ПараметрыЗавершенияВводаШтрихкода.Форма;
	ВидПродукции                = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табачная");
	
	Если РезультатОбработкиШтрихкода.ТребуетсяАвторизацияМОТП Тогда
	
		ОписаниеОповещения = Новый ОписаниеОповещения("АвторизацияПользователяЗавершение",
			ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода);

		ИнтерфейсАвторизацииИСМПКлиент.ЗапроситьКлючСессии(
			ИнтерфейсМОТПКлиентСервер.ПараметрыЗапросаКлючаСессии(ПараметрыСканирования.Организация),
			ОписаниеОповещения);
		Возврат Истина;
		
	КонецЕсли;
	
	Если РезультатОбработкиШтрихкода.ЕстьОшибкиВДеревеУпаковок Тогда

		ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного(ВидПродукции);
		ПараметрыОткрытияФормы.АдресДереваУпаковок = РезультатОбработкиШтрихкода.АдресДереваУпаковок;
		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы);
		Возврат Истина;
		
	КонецЕсли;

	Если РезультатОбработкиШтрихкода.ЕстьОшибки
		Или ЗначениеЗаполнено(РезультатОбработкиШтрихкода.ТекстОшибки) Тогда
		
		ПредставлениеНоменклатуры = НСтр("ru = '<Неизвестная табачная продукция>'");
		Если ЭтоАдресВременногоХранилища(РезультатОбработкиШтрихкода.АдресДанныхШтрихкода) Тогда
			ДанныеШтрихкода = ПолучитьИзВременногоХранилища(РезультатОбработкиШтрихкода.АдресДанныхШтрихкода);
			ПредставлениеНоменклатуры = Строка(ДанныеШтрихкода.Номенклатура);
		КонецЕсли;

		ПараметрыОткрытияФормы = ШтрихкодированиеИСКлиент.ПараметрыОткрытияФормыНевозможностиДобавленияОтсканированного(ВидПродукции);
		ПараметрыОткрытияФормы.Штрихкод                  = РезультатОбработкиШтрихкода.Штрихкод;
		ПараметрыОткрытияФормы.ТекстОшибки               = РезультатОбработкиШтрихкода.ТекстОшибки;
		ПараметрыОткрытияФормы.ТипШтрихкода              = РезультатОбработкиШтрихкода.ТипШтрихкода;
		ПараметрыОткрытияФормы.ПредставлениеНоменклатуры = ПредставлениеНоменклатуры;

		ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы);
		Возврат Истина;
		
	КонецЕсли;
	
	Если РезультатОбработкиШтрихкода.ТребуетсяУточнениеДанных Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"УточненияДанныхЗавершение", ЭтотОбъект, ПараметрыЗавершенияВводаШтрихкода);
		ШтрихкодированиеИСКлиент.ОткрытьФормуУточненияДанных(
			Форма, РезультатОбработкиШтрихкода.ПараметрыУточненияДанных, ОписаниеОповещения);
		Возврат Истина;
		
	КонецЕсли;
		
	Если ВыполнятьОбработчикОповещения И Не (ПараметрыЗавершенияВводаШтрихкода.ОповещениеПриЗавершении = Неопределено) Тогда
		
		ВыполнитьОбработкуОповещения(ПараметрыЗавершенияВводаШтрихкода.ОповещениеПриЗавершении, РезультатОбработкиШтрихкода);
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Процедура УточненияДанныхЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении);
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если Не ЗначениеЗаполнено(РезультатВыбора) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указана серия'"));
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении);
		Возврат;
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.Свойство("ВызовИзФормыДокумента") Тогда
		
		Если ДополнительныеПараметры.ВызовИзФормыДокумента Тогда
			
			Действие = "ОбработатьВыборСерии";
			РезультатОбработкиШтрихкода = Форма.Подключаемый_ВыполнитьДействие(
				Действие,
				РезультатВыбора,
				ДополнительныеПараметры.РезультатОбработкиШтрихкода,
				ДополнительныеПараметры.КэшированныеЗначения);
			
			ПараметрыЗавершенияВводаШтрихкода = ШтрихкодированиеИСКлиент.ПараметрыЗавершенияОбработкиВводаШтрихкода();
			ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода = РезультатОбработкиШтрихкода;
			ПараметрыЗавершенияВводаШтрихкода.КэшированныеЗначения        = ДополнительныеПараметры.КэшированныеЗначения;
			ПараметрыЗавершенияВводаШтрихкода.Форма                       = Форма;
			ДополнительныеПараметры.Свойство("ОповещениеПриЗавершении", ПараметрыЗавершенияВводаШтрихкода.ОповещениеПриЗавершении);
			
			ЗавершитьОбработкуВводаШтрихкода(ПараметрыЗавершенияВводаШтрихкода);
			
		Иначе
			
			ДанныеШтрихкода = ШтрихкодированиеИСВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораСерии(
				ДополнительныеПараметры.РезультатОбработкиШтрихкода, РезультатВыбора);
			
			ШтрихкодированиеИСМПКлиентСервер.ОбработатьСохраненныйВыборДанныхПоМаркируемойПродукции(Форма, ДанныеШтрихкода);
			
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
			
		КонецЕсли;
		
	Иначе
		
		РезультатУточнения = Новый Структура;
		РезультатУточнения.Вставить("РезультатВыбора",             РезультатВыбора);
		РезультатУточнения.Вставить("КэшированныеЗначения",        ДополнительныеПараметры.КэшированныеЗначения);
		РезультатУточнения.Вставить("ПараметрыСканирования",       ДополнительныеПараметры.ПараметрыСканирования);
		РезультатУточнения.Вставить("Действие",                    "ОбработатьУточнениеДанных");
		РезультатУточнения.Вставить("РезультатОбработкиШтрихкода", ДополнительныеПараметры.РезультатОбработкиШтрихкода);
		РезультатУточнения.Вставить("ИсходныеДанные",              ДополнительныеПараметры.ДанныеШтрихкода);
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеВыполнитьДействие, РезультатУточнения);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыборНоменклатурыЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Форма = ДополнительныеПараметры.Форма;
	
	Если Не ЗначениеЗаполнено(РезультатВыбора.Номенклатура) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не указана номенклатура'"));
		
		Возврат;
		
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОповещениеПриЗавершении = Неопределено Тогда
		Действие = "ОбработатьВыборНоменклатуры";
		РезультатОбработкиШтрихкода = Форма.Подключаемый_ВыполнитьДействие(
			Действие,
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода,
			ДополнительныеПараметры.КэшированныеЗначения);
		
		ПараметрыЗавершенияВводаШтрихкода = ШтрихкодированиеИСКлиент.ПараметрыЗавершенияОбработкиВводаШтрихкода();
		ПараметрыЗавершенияВводаШтрихкода.РезультатОбработкиШтрихкода = РезультатОбработкиШтрихкода;
		ПараметрыЗавершенияВводаШтрихкода.КэшированныеЗначения        = ДополнительныеПараметры.КэшированныеЗначения;
		ПараметрыЗавершенияВводаШтрихкода.Форма                       = Форма;

		ЗавершитьОбработкуВводаШтрихкода(ПараметрыЗавершенияВводаШтрихкода);
		
	Иначе
		
		ДанныеШтрихкода = АкцизныеМаркиВызовСервера.ОбработатьДанныеШтрихкодаПослеВыбораНоменклатуры(
			РезультатВыбора,
			ДополнительныеПараметры.РезультатОбработкиШтрихкода);
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеПриЗавершении, ДанныеШтрихкода);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура АвторизацияПользователяЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;
	
	Организация = ДополнительныеПараметры.ПараметрыСканирования.Организация;
	
	АвторизацияПрошлаУспешно = Результат[Организация] = Истина;
	
	Если АвторизацияПрошлаУспешно Тогда
		
		Если ДополнительныеПараметры.Свойство("ВызовИзФормыДокумента") Тогда
			
			Если ДополнительныеПараметры.ВызовИзФормыДокумента Тогда
				
				Форма                = ДополнительныеПараметры.Форма;
				ДанныеШтрихкода      = ДополнительныеПараметры.ДанныеШтрихкода;
				КэшированныеЗначения = ДополнительныеПараметры.КэшированныеЗначения;
				
				ШтрихкодированиеИСКлиент.ОбработатьВводШтрихкода(Форма, ДанныеШтрихкода, КэшированныеЗначения);
				
			Иначе
				
				Форма                   = ДополнительныеПараметры.Форма;
				ОповещениеПриЗавершении = ДополнительныеПараметры.ОповещениеПриЗавершении;
				ДанныеШтрихкода         = ДополнительныеПараметры.ДанныеШтрихкода;
				ПараметрыСканирования   = ДополнительныеПараметры.ПараметрыСканирования;
				
				ШтрихкодированиеИСКлиент.ОбработатьДанныеШтрихкода(ОповещениеПриЗавершении, Форма, ДанныеШтрихкода, ПараметрыСканирования);
				
			КонецЕсли;
			
		Иначе
			
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОбработкиШтрихкода, ДополнительныеПараметры.ДанныеШтрихкода);
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(Результат[Организация]) = Тип("Строка") Тогда
		
		ПараметрыОткрытияФормы = Новый Структура("ТекстОшибки", Результат[Организация]);
		ОткрытьФорму("ОбщаяФорма.ИнформацияОНевозможностиДобавленияОтсканированного", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуНевозможностиДобавленияОтсканированного(Форма, ПараметрыОткрытияФормы, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	ОткрытьФорму(
		"Обработка.ПроверкаИПодборТабачнойПродукцииМОТП.Форма.ИнформацияОНевозможностиДобавленияОтсканированного",
		ПараметрыОткрытияФормы, Форма,,,, ОповещениеОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура СохранитьДанныеВыбораСерии(Форма, ДанныеШтрихкода) Экспорт
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = ДанныеШтрихкода.ДополнительныеПараметры;
	
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура")
		И ДополнительныеПараметры.Свойство("ЗапомнитьВыбор") 
		И ДополнительныеПараметры.ЗапомнитьВыбор Тогда
		
		Если ДополнительныеПараметры.Свойство("ДанныеВыбора")
			И ТипЗнч(ДополнительныеПараметры.ДанныеВыбора) = Тип("Структура") 
			И ДополнительныеПараметры.ДанныеВыбора.Количество() > 0 Тогда
		
			Форма.ДанныеВыбораПоМаркируемойПродукции  = ДополнительныеПараметры.ДанныеВыбора;
			Форма.СохраненВыборПоМаркируемойПродукции = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти