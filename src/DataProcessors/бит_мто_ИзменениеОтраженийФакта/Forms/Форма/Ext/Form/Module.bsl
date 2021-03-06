
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// стандартные действия при создании на сервере
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	ОбрОб = РеквизитФормыВЗначение("Объект");
	МетаОбъект = ОбрОб.Метаданные();
	
	// Вызов механизма защиты
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// инициализируем настройки компоновщика
	АдресСхемыКомпоновкиДанных = ИнициализироватьКомпоновщик(Объект.Компоновщик,УникальныйИдентификатор);
	
	Элементы.КомпоновщикПользовательскиеНастройки.РежимОтображения = РежимОтображенияНастроекКомпоновкиДанных.БыстрыйДоступ;	
	
	ЗаполнитьКэшЗначений();
	
	Объект.Период.Вариант = ВариантСтандартногоПериода.Сегодня;
	
	УстановитьЗначенияПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыАналитикиТЧ

&НаКлиенте
Процедура АналитикиТЧНачальноеЗначениеАналитикиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.АналитикиТЧ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Контейнер = Новый Соответствие;
	Контейнер.Вставить(ТекущиеДанные.ИмяАналитики, ТекущиеДанные.НачальноеЗначение);
	
	
	бит_МеханизмДопИзмеренийКлиент.ВыбратьТипСоставнойАналитики(ЭтаФорма
														  	   , Элемент
															   , Контейнер
															   , ТекущиеДанные.ИмяАналитики
															   , СтандартнаяОбработка
															   , фКэшЗначений.НастройкиАналитик);
															   
	ТекущиеДанные.НачальноеЗначение = Контейнер.Получить(ТекущиеДанные.ИмяАналитики);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикиТЧКонечноеЗначениеАналитикиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.АналитикиТЧ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Контейнер = Новый Соответствие;
	Контейнер.Вставить(ТекущиеДанные.ИмяАналитики, ТекущиеДанные.КонечноеЗначение);
	
	бит_МеханизмДопИзмеренийКлиент.ВыбратьТипСоставнойАналитики(ЭтаФорма
														  	   , Элемент
															   , Контейнер
															   , ТекущиеДанные.ИмяАналитики
															   , СтандартнаяОбработка
															   , фКэшЗначений.НастройкиАналитик);
															   
	ТекущиеДанные.КонечноеЗначение = Контейнер.Получить(ТекущиеДанные.ИмяАналитики);
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикиТЧНачальноеЗначениеАналитикиОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.АналитикиТЧ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контейнер = Новый Структура;
	Контейнер.Вставить(ТекущиеДанные.ИмяАналитики, ТекущиеДанные.НачальноеЗначение);	

	бит_МеханизмДопИзмеренийКлиент.ОбработкаОчисткиДополнительногоИзмерения(Элемент
																			, Контейнер
																		   	, ТекущиеДанные.ИмяАналитики
																		   	, СтандартнаяОбработка
																		   	, фКэшЗначений.НастройкиАналитик);
																		
	ТекущиеДанные.НачальноеЗначение = Контейнер[ТекущиеДанные.ИмяАналитики];														   
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикиТЧКонечноеЗначениеАналитикиОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.АналитикиТЧ.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контейнер = Новый Структура;
	Контейнер.Вставить(ТекущиеДанные.ИмяАналитики, ТекущиеДанные.КонечноеЗначение);	

	бит_МеханизмДопИзмеренийКлиент.ОбработкаОчисткиДополнительногоИзмерения(Элемент
																			, Контейнер
																		   	, ТекущиеДанные.ИмяАналитики
																		   	, СтандартнаяОбработка
																		   	, фКэшЗначений.НастройкиАналитик);
																		
	ТекущиеДанные.КонечноеЗначение = Контейнер[ТекущиеДанные.ИмяАналитики];														   
	
КонецПроцедуры

&НаКлиенте
Процедура АналитикиТЧБезусловноПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.АналитикиТЧ.ТекущиеДанные;
	
	
	Если ТекущиеДанные.Безусловно Тогда
	
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Контейнер = Новый Структура;
		Контейнер.Вставить(ТекущиеДанные.ИмяАналитики, ТекущиеДанные.НачальноеЗначение);	

		ОбработкаОчисткиНачальногоЗначения(Контейнер
									   	, ТекущиеДанные.ИмяАналитики
									   	, фКэшЗначений.НастройкиАналитик);
																				
		ТекущиеДанные.НачальноеЗначение = Контейнер[ТекущиеДанные.ИмяАналитики];														   
	
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновить(Команда)
	
	ПолучитьДанные();

КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.ОбрабатываемыеДокументы, "Выполнить", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНастроитьПериод(Команда)
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Объект.Период;
	
	Оповещение = Новый ОписаниеОповещения("РедактироватьПериодОкончание", ЭтотОбъект); 
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

// Процедура окончание процедуры "РедактироватьПериод".
// 
&НаКлиенте 
Процедура РедактироватьПериодОкончание(Период, ДополнительныеПараметры) Экспорт
	
	Если Период <> Неопределено Тогда
		
		Объект.Период = Период;
		
	КонецЕсли;	
	
КонецПроцедуры // РедактироватьПериодОкончание()

&НаКлиенте
Процедура КомандаИнвертироватьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.ОбрабатываемыеДокументы, "Выполнить", 2);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.ОбрабатываемыеДокументы, "Выполнить", 0);
	
 КонецПроцедуры

&НаКлиенте
Процедура КомандаВыполнить(Команда)
	
	ЗаполнитьОбрабатываемыеДокументы();	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет значения, необходимые для работы на клиенте.
//
&НаСервере
Процедура ЗаполнитьКэшЗначений()

	фКэшЗначений = Новый Структура;
	фКэшЗначений.Вставить("ИзмеренияДоп"     	, бит_Бюджетирование.ПолучитьИзмеренияБюджетирования("Дополнительные", "Синоним"));
	// настройки дополнительных измерений
	фКэшЗначений.Вставить("НастройкиИзмерений"	, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений"));
	// настройки всех дополнительных аналитик
	фКэшЗначений.Вставить("НастройкиАналитик"	, бит_МеханизмДопИзмерений.ПолучитьНастройкиДополнительныхАналитик());
	
	
	фКэшЗначений.Вставить("ТипНастройки", Перечисления.бит_ТипыСохраненныхНастроек.Обработки);
	фКэшЗначений.Вставить("НастраиваемыйОбъект", "Обработка.бит_мто_ПодборЗаявокНаЗакупку");
	
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура инициализирует компоновщик. 
//
&НаСервере
Функция ИнициализироватьКомпоновщик(Компоновщик,УникальныйИдентификатор)

	СхемаКомпоновкиДанных = Обработки.бит_мто_ИзменениеОтраженийФакта.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	// Меняем синонимы аналитик в отборе по фактическим данным
	мНастройкиИзмерений = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений");

	бит_мто.СформироватьЗаголовкиАналитикТЧФактическиеДанные(СхемаКомпоновкиДанных 
															 ,"НаборДанных1" 
															 ,мНастройкиИзмерений);	
	
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
    Компоновщик.Инициализировать(ИсточникНастроек);
	Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

	Возврат АдресСхемыКомпоновкиДанных;
	
КонецФункции // ИнициализироватьКомпоновщик()

// Процедура получает данные . 
//
&НаСервере
Процедура ПолучитьДанные()

	ОбОбъект = РеквизитФормыВЗначение("Объект");
	ОбОбъект.ОбработатьДанные();
	ЗначениеВДанныеФормы(ОбОбъект, Объект);
	
КонецПроцедуры // ПолучитьДанные()

// Процедура заполняет обрабатываемый документ.
// 
// Параметры:
//  ИдСтроки - число.
//  
&НаСервере
Процедура ЗаполнитьОбрабатываемыеДокументы()

	Для каждого Док Из Объект.ОбрабатываемыеДокументы Цикл
		
		Если Док.Выполнить Тогда
			
			ДокОб = Док.Документ.ПолучитьОбъект();	
			ЗаполнитьДокумент(ДокОб);
			
			// Запись измененного документа и проведение по регистрам бит_.
			ЗаписьУспешна = бит_ОбщегоНазначения.ЗаписатьПровестиДокумент(ДокОб, РежимЗаписиДокумента.Запись); 
			
			Если ЗаписьУспешна И Док.Документ.ДокументОснование.Проведен Тогда 
				
				ДокОб.ПровестиОтражениеФактаЗакупки(ДокОб.Ссылка, Ложь);
				
			КонецЕсли;
		
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры // ЗаполнитьОбрабатываемыеДокументы()

// Процедура заполняет шапку и табличную часть документа отражение факта ДДС. 
//
&НаСервере
Процедура ЗаполнитьДокумент(ДокОб)

	Для каждого ТекСтрокаТЧ Из Объект.АналитикиТЧ Цикл
		
		Если ЗначениеЗаполнено(ТекСтрокаТЧ.НачальноеЗначение) 
			ИЛИ ЗначениеЗаполнено(ТекСтрокаТЧ.КонечноеЗначение) Тогда 
		
			Для каждого Аналит Из ДокОб.ФактическиеДанные Цикл
			
				Если Аналит[ТекСтрокаТЧ.Ключ] = ТекСтрокаТЧ.НачальноеЗначение Тогда	
					
					Аналит[ТекСтрокаТЧ.Ключ] = ТекСтрокаТЧ.КонечноеЗначение; 
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если ТекСтрокаТЧ.Безусловно Тогда
		
			Для каждого Аналит Из ДокОб.ФактическиеДанные Цикл
			
				Аналит[ТекСтрокаТЧ.Ключ] = ТекСтрокаТЧ.КонечноеЗначение; 
				
			КонецЦикла;
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	ДокОб.НеСинхронизировать = Истина;
	
КонецПроцедуры // ЗаполнитьДокумент()

// Процедура устанавливает заголовок формы на клиенте.
//
&НаКлиенте
Процедура УстановитьЗаголовокФормы()
	
	Если ЗначениеЗаполнено(ТекущаяНастройка) Тогда
		
		ЭтаФорма.Заголовок = "Изменение отражений факта ("+ТекущаяНастройка+")";
		
		
	Иначе	
		
		ЭтаФорма.Заголовок = "Изменение отражений факта";
		
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьЗаголовокФормы()

// Процедура устанавливает заголовок формы.
//
&НаСервере
Процедура УстановитьЗаголовокФормыСервер()

	Если ЗначениеЗаполнено(ТекущаяНастройка) Тогда
		
		ЭтаФорма.Заголовок = "Изменение отражений факта ("+ТекущаяНастройка+")";
		
		
	Иначе	
		
		ЭтаФорма.Заголовок = "Изменение отражений факта";
		
		
	КонецЕсли; 

КонецПроцедуры // УстановитьЗаголовокФормы()

// Процедура 
//
//  Параметры:
//  Контейнер - СтрокаТабличнойЧасти,ДокументОбъект.
//  ИмяПоля   - Строка.
//  НастройкиИзмерений - Соответствие.
//
 &НаСервере
 Процедура ОбработкаОчисткиНачальногоЗначения(Контейнер, ИмяПоля, НастройкиИзмерений)
 
	Если Контейнер = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли; 
	
	Если НастройкиИзмерений[ИмяПоля] <> Неопределено Тогда
		
		Если НастройкиИзмерений[ИмяПоля].ЭтоСоставнойТип Тогда
			Контейнер[ИмяПоля]   = Неопределено;
		Иначе	
			Контейнер[ИмяПоля]   = НастройкиИзмерений[ИмяПоля].ЗначениеПоУмолчанию;
		КонецЕсли; 
		
	КонецЕсли; 
	
 КонецПроцедуры // ОбработкаОчисткиНачальногоЗначения()

// Процедура - действие команды "КомандаСохранитьНастройки".
//
&НаКлиенте
Процедура КомандаСохранитьНастройки(Команда)
	
	ПараметрыФормы     = Новый Структура;
	СтруктураНастройки = УпаковатьНастройкиВСтруктуру();
	ПараметрыФормы.Вставить("СтруктураНастройки" , СтруктураНастройки);
	ПараметрыФормы.Вставить("ТипНастройки"		 , фКэшЗначений.ТипНастройки);
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", фКэшЗначений.НастраиваемыйОбъект);
	
	Если ЗначениеЗаполнено(ТекущаяНастройка) Тогда
	
		ПараметрыФормы.Вставить("СохраненнаяНастройка",ТекущаяНастройка);
	
	КонецЕсли; 
		
	Оповещение = Новый ОписаниеОповещения("СохранитьНастройки",ЭтаФорма);
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаСохранения", ПараметрыФормы, ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры //КомандаСохранитьНастройки()

// Процедура - обработчик оповещения о закрытии формы сохранения настроек. 
// 
&НаКлиенте
Процедура СохранитьНастройки(СохрНастройка, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(СохрНастройка) Тогда
		
		ТекущаяНастройка = СохрНастройка;
		УстановитьЗаголовокФормы();
		
	КонецЕсли;
	
КонецПроцедуры // СохранитьНастройки()

// Процедура - действие команды "КомандаВосстановитьНастройки".
//
&НаКлиенте
Процедура КомандаВосстановитьНастройки(Команда)
	
	ПараметрыФормы     = Новый Структура;
	ПараметрыФормы.Вставить("ТипНастройки"		 , фКэшЗначений.ТипНастройки);
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", фКэшЗначений.НастраиваемыйОбъект);
	
	Оповещение = Новый ОписаниеОповещения("ПрименениеНастроек",ЭтаФорма);
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаЗагрузки", ПараметрыФормы, ЭтаФорма,,,,Оповещение,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры // КомандаВосстановитьНастройки()

// Процедура - обработчик оповещения о закрытии формы применения настроек. 
// 
&НаКлиенте 
Процедура ПрименениеНастроек(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда        
		
		ПрименитьНастройки(Результат);
		
	КонецЕсли;	
	
КонецПроцедуры // ПрименениеНастроек

// Функция готовит стуктуру с настройками для сохранения.
//
// Возвращаемое значение:
//   СтруктураНастройки   - Структура.
//
&НаСервере
Функция УпаковатьНастройкиВСтруктуру()

	СтруктураНастройки = Новый Структура;
	
	СтруктураНастройки.Вставить("СтандартныйПериод" , Объект.Период);
	
	СтруктураНастройки.Вставить("ПользовательскиеНастройки", Новый ХранилищеЗначения(Объект.Компоновщик.ПользовательскиеНастройки));
	
	Возврат СтруктураНастройки;
	
КонецФункции // УпаковатьНастройкиВСтруктуру()

// Функция применяет сохраненные настройки.
//
// Параметры:
//  ВыбНастройка  - СправочникСсылка.бит_СохраненныеНастройки.
//
&НаСервере
Функция ПрименитьНастройки(ВыбНастройка)

	Если ЗначениеЗаполнено(ВыбНастройка) Тогда
		
		СтруктураНастроек = ВыбНастройка.ХранилищеНастроек.Получить();
		
		Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
			
			ПользовательскиеНастройки = СтруктураНастроек.ПользовательскиеНастройки.Получить();
			
			Объект.Компоновщик.ЗагрузитьПользовательскиеНастройки(ПользовательскиеНастройки);
			Объект.Период = СтруктураНастроек.СтандартныйПериод;
			
			ТекущаяНастройка = ВыбНастройка;
			УстановитьЗаголовокФормыСервер();				
				
		КонецЕсли;	 
		
	КонецЕсли; 
	
КонецФункции // ПрименитьНастройки()

// Процедура устанавливает настройку либо из последних использованных, 
//	либо из настройки по умолчанию.
//
&НаСервере
Процедура УстановитьЗначенияПоУмолчанию()
	
	// Получим настройку по - умолчанию и последнюю использованную.
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТипНастройки"			  , Перечисления.бит_ТипыСохраненныхНастроек.Обработки);
	СтруктураПараметров.Вставить("НастраиваемыйОбъект"    , фКэшЗначений.НастраиваемыйОбъект);
	СтруктураПараметров.Вставить("ИспользоватьПриОткрытии", Истина);
	СохрНастройка = Справочники.бит_СохраненныеНастройки.ПолучитьНастройкуПоУмолчанию(СтруктураПараметров);
	
	Если ЗначениеЗаполнено(СохрНастройка) Тогда
		
		ПрименитьНастройки(СохрНастройка);
		
	КонецЕсли; 
	
КонецПроцедуры // УстановитьЗначенияПоУмолчанию()

#КонецОбласти

