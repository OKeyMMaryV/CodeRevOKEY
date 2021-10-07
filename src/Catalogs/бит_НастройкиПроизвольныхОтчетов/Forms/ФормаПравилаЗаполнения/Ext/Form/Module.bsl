﻿	 
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Справочник объект бит_НастройкиПроизвольныхОтчетов.
	СпрОб = ДанныеФормыВЗначение(Параметры.СправочникОбъект, Тип("СправочникОбъект.бит_НастройкиПроизвольныхОтчетов"));
	ЗначениеВДанныеФормы(СпрОб, СправочникОбъект);
	
	// Последнее выбранное имя параметра
	фИмяПараметраПоследнее 		 = Параметры.ИмяПараметраПоследнее;
	
	СпособКомпоновки 			 = Параметры.СпособКомпоновки;
  	ИмяОбласти 				 	 = Параметры.ИмяОбласти;
	ВидЯчейки				  	 = Параметры.ВидЯчейки;
  	ЭлементДанных 				 = Параметры.ЭлементДанных;
	ИмяРесурса 					 = Параметры.ИмяРесурса;
	Формула 					 = Параметры.Формула;
	ФорматЧисел 				 = Параметры.ФорматЧисел;
	Шаблон 						 = Параметры.Шаблон;
	ФормироватьДвиженияПоБюджету = Параметры.ФормироватьДвиженияПоБюджету;
	ПериодДанных 				 = Параметры.ПериодДанных;  
	КолонкаТаблицыОтчета         = Параметры.КолонкаТаблицыОтчета;
	СтрокаТаблицыОтчета          = Параметры.СтрокаТаблицыОтчета;
	РежимОбразца          		 = Параметры.РежимОбразца;
	ТипОтчета 					 = Параметры.ТипОтчета;
	
	// Список ресурсов
	СписокРесурсов = бит_МеханизмПолученияДанных.ПолучитьСписокПолейДляСпособаКомпоновки(СпособКомпоновки, "Ресурс", "СписокЗначений");
	Элементы.ИмяРесурса.СписокВыбора.ЗагрузитьЗначения(СписокРесурсов.ВыгрузитьЗначения());
	
	// Значения по умолчанию
	Для каждого ЭлементСписка Из Параметры.ЗначенияПоУмолчанию Цикл 	
		СтрокаЗнач = ЗначенияПоУмолчанию.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЗнач, ЭлементСписка.Значение);	
	КонецЦикла;
	
	ЗагрузитьСписокПараметров();	
	
	// Таблица обласей для вывода формулы
	ТаблицаСтрок_Тз = ДанныеФормыВЗначение(Параметры.ПравилаЗаполнения, Тип("ТаблицаЗначений"));
	НайденнаяСтрока = ТаблицаСтрок_Тз.Найти(ИмяОбласти, "ИмяОбласти");
	Если НайденнаяСтрока <> Неопределено Тогда
		ТаблицаСтрок_Тз.Удалить(НайденнаяСтрока);
	КонецЕсли;
	ЗначениеВДанныеФормы(ТаблицаСтрок_Тз.Скопировать( ,"ИмяОбласти, ВидЯчейки, Формула, ЭлементДанных, ИмяРесурса"), ТаблицаОбластей);
		
	ЗаполнитьКэшЗначений();
	
	УстановитьВидимостьДоступность();
	
	// Текущая страница
	Если Параметры.Свойство("ТекущаяСтраница") И ЗначениеЗаполнено(Параметры.ТекущаяСтраница) Тогда
		Элементы.ПанельОсновная.ТекущаяСтраница = Элементы["Страница" + Параметры.ТекущаяСтраница];		
	КонецЕсли;
	
	// Список выбора аналитик
	Для каждого КиЗ Из фКэшЗначений.НастройкиАналитик Цикл  		
		Настройка = КиЗ.Значение;
		Элементы.ЗначенияПоУмолчаниюАналитика.СписокВыбора.Добавить(КиЗ.Ключ, Настройка.Синоним);
	КонецЦикла;      	
	
	ПодготовитьИзмененныеДанные(ИзмененныеДанные);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидЯчейки = Перечисления.бит_ВидыЯчеекПроизвольногоОтчета.Значение Тогда
		
		Если ЗначениеЗаполнено(СпособКомпоновки) И НЕ РежимОбразца Тогда
			
			ПроверяемыеРеквизиты.Добавить("ЭлементДанных");		
			ПроверяемыеРеквизиты.Добавить("ИмяРесурса");
			
		КонецЕсли; 
		
	ИначеЕсли ВидЯчейки = Перечисления.бит_ВидыЯчеекПроизвольногоОтчета.Формула И НЕ РежимОбразца Тогда
		
		ПроверяемыеРеквизиты.Добавить("Формула");
		
	КонецЕсли;
	
	Если РежимОбразца Тогда
		ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ИмяОбласти"));
		//ПроверяемыеРеквизиты.Удалить(ПроверяемыеРеквизиты.Найти("ВидЯчейки"));
	КонецЕсли;  
	
КонецПроцедуры // ОбработкаПроверкиЗаполненияНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяОбластиПриИзменении(Элемент)
	
	ПроверитьИмяОбласти();
	СпецСимволы = " ,;:[]{}'""/\?!@#$%^&*+=<>~`|()";		
	ИмяОбласти  = бит_ОбщегоНазначенияКлиентСервер.ПроверитьСпецСимволы(ИмяОбласти, СпецСимволы, "Имя области");
	
КонецПроцедуры // ИмяОбластиПриИзменении()

&НаКлиенте
Процедура ВидЯчейкиПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	ОтметитьИзменения("ВидЯчейки", ИзмененныеДанные);
	
КонецПроцедуры // ВидЯчейкиПриИзменении()

&НаКлиенте
Процедура ФорматЧиселНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(ФорматЧисел) Или ВидЯчейки = фКэшЗначений.Перечисления.бит_ВидыЯчеекПроизвольногоОтчета.Шаблон Тогда
		КонструкторФормата = Новый КонструкторФорматнойСтроки(ФорматЧисел);     	
	Иначе                                    		
		КонструкторФормата = Новый КонструкторФорматнойСтроки(СправочникОбъект.ФорматЧисел); 		
	КонецЕсли; 
	КонструкторФормата.ДоступныеТипы = Новый ОписаниеТипов("Число",
											 Новый КвалификаторыЧисла(15, 2, ДопустимыйЗнак.Любой));
	ОписаниеОповещения = Новый ОписаниеОповещения("ФорматЧиселНачалоВыбораЗавершение", ЭтотОбъект, КонструкторФормата);
	КонструкторФормата.Показать(ОписаниеОповещения);
	
КонецПроцедуры // ФорматЧиселНачалоВыбора()

// Процедура обработчик оповещения "ФорматЧиселНачалоВыбораЗавершение".
// 
// Параметры:
// Результат - Структура.
// КонструкторФормата - КонструкторФорматнойСтроки.
// 
&НаКлиенте
Процедура ФорматЧиселНачалоВыбораЗавершение(Результат, КонструкторФормата) Экспорт
	
	Если Результат <> Неопределено Тогда
		ФорматЧисел = КонструкторФормата.Текст;
		Модифицированность = Истина;
		ОтметитьИзменения("ФорматЧисел", ИзмененныеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлементДанныхПриИзменении(Элемент)
	
	СписокРесурсов = Элементы.ИмяРесурса.СписокВыбора;	
	Если ЗначениеЗаполнено(СписокРесурсов) И СписокРесурсов.Количество() = 1  Тогда	
		 ИмяРесурса = СписокРесурсов[0].Значение;  	
	КонецЕсли;
	ОтметитьИзменения("ЭлементДанных", ИзмененныеДанные);
	
КонецПроцедуры // ЭлементДанныхПриИзменении()

&НаКлиенте
Процедура ФормулаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТаблицаОбластей", ТаблицаОбластей);
	ПараметрыФормы.Вставить("Текст"   	     , Формула);
	
	Обработчик = Новый ОписаниеОповещения("ФормулаНачалоВыбораЗавершение", ЭтотОбъект);
    Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
    ОткрытьФорму("ОбщаяФорма.бит_ФормаВводаФормулыУправляемая",ПараметрыФормы,ЭтотОбъект,,,, Обработчик, Режим);

КонецПроцедуры // ФормулаНачалоВыбора()

// Процедура обработчик оповещения "ФормулаНачалоВыбораЗавершение".
// 
// Параметры:
// Результат - Строка.
// Параметры - Структура.
// 
&НаКлиенте
Процедура ФормулаНачалоВыбораЗавершение(Результат, Параметры) Экспорт
  
	Если ТипЗнч(Результат) = Тип("Строка") Тогда
	 	Формула = Результат;
		ОтметитьИзменения("Формула", ИзмененныеДанные);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ШаблонПриИзменении(Элемент)
	ОтметитьИзменения("Шаблон", ИзмененныеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ФормироватьДвиженияПоБюджетуПриИзменении(Элемент)
	ОтметитьИзменения("ФормироватьДвиженияПоБюджету", ИзмененныеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ПериодДанныхПриИзменении(Элемент)
	ОтметитьИзменения("ПериодДанных", ИзмененныеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПоУмолчаниюПриИзменении(Элемент)
	ОтметитьИзменения("ЗначенияПоУмолчанию", ИзмененныеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ИмяРесурсаПриИзменении(Элемент)
	ОтметитьИзменения("ИмяРесурса", ИзмененныеДанные);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗначенияПоУмолчанию

&НаКлиенте
Процедура ЗначенияПоУмолчаниюАналитикаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Строка") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекущиеДанные = Элементы.ЗначенияПоУмолчанию.ТекущиеДанные;		
		ИмяАналитики = ВыбранноеЗначение;
		
		ТекНастройка = фКэшЗначений.НастройкиАналитик[ИмяАналитики];
		Если ТекНастройка = Неопределено Тогда
			
			ТекущиеДанные.ИмяАналитики 	    = "";
			ТекущиеДанные.ЗначениеАналитики = Неопределено;
			
		Иначе
			
			ТекущиеДанные.ИмяАналитики 	    = ИмяАналитики;
			ТекущиеДанные.Аналитика         = ТекНастройка.Аналитика;
			ТекущиеДанные.ЗначениеАналитики = ТекНастройка.ЗначениеПоУмолчанию;
			
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПоУмолчаниюЗначениеАналитикиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ЗначенияПоУмолчанию.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	ИмяЭлемента  = "ЗначениеАналитики";	
	
	ТекНастройка = фКэшЗначений.НастройкиАналитик[ТекущиеДанные.ИмяАналитики];
	Если ТекНастройка = Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		
	Иначе
				
		СтрНастройки = Новый Структура(ИмяЭлемента, ТекНастройка); 				
		бит_МеханизмДопИзмеренийКлиент.ВыбратьТипСоставнойАналитики(ЭтотОбъект
															  , Элемент
															  , ТекущиеДанные
															  , ИмяЭлемента
															  , СтандартнаяОбработка
															  , СтрНастройки);
		
	КонецЕсли; 

КонецПроцедуры // ЗначенияПоУмолчаниюЗначениеАналитикиНачалоВыбора()

&НаКлиенте
Процедура ЗначенияПоУмолчаниюЗначениеАналитикиОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ЗначенияПоУмолчанию.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;	
	КонецЕсли;
	
	ИмяЭлемента  = "ЗначениеАналитики";	
	
	ТекНастройка = фКэшЗначений.НастройкиАналитик[ТекущиеДанные.ИмяАналитики];
	Если ТекНастройка <> Неопределено Тогда
	
		СтрНастройки = Новый Структура(ИмяЭлемента, ТекНастройка);
		бит_МеханизмДопИзмеренийКлиент.ОбработкаОчисткиДополнительногоИзмерения(Элемент
																			, ТекущиеДанные
																			, ИмяЭлемента
																			, СтандартнаяОбработка
																			, СтрНастройки);
	КонецЕсли;

КонецПроцедуры // ЗначенияПоУмолчаниюЗначениеАналитикиОчистка()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ШаблонДобавить(Команда)
	
	ИмяПараметраНач = СтрЗаменить(Шаблон		 , "[", "");
	ИмяПараметраНач = СтрЗаменить(ИмяПараметраНач, "]", "");	
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяПараметраПоследнее", фИмяПараметраПоследнее);
	ПараметрыФормы.Вставить("СпособКомпоновки"     , СправочникОбъект.СпособКомпоновки);
	ПараметрыФормы.Вставить("Тч_Параметры"		   , СправочникОбъект.Параметры);
	ПараметрыФормы.Вставить("СписокПараметров"	   , СписокПараметров);
	ПараметрыФормы.Вставить("ТипОтчета",			 ТипОтчета);
	
	Обработчик = Новый ОписаниеОповещения("ШаблонДобавитьЗавершение", ЭтотОбъект);
    Режим = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
    ОткрытьФорму("Справочник.бит_НастройкиПроизвольныхОтчетов.Форма.ФормаВыбораПараметров",ПараметрыФормы,ЭтотОбъект,,,, Обработчик, Режим);
	
КонецПроцедуры // ШаблонДобавить()

// Процедура обработчик оповещения "ШаблонДобавитьЗавершение".
// 
// Параметры:
// ВыбЗначение - Структура.
// Параметры - Структура.
// 
&НаКлиенте
Процедура ШаблонДобавитьЗавершение(ВыбЗначение, Параметры) Экспорт
   
	Если ТипЗнч(ВыбЗначение) = Тип("Структура")  Тогда
		
		фИмяПараметраПоследнее = ВыбЗначение.ИмяПараметра;
		Шаблон = Шаблон + "[" + фИмяПараметраПоследнее + "]"; 		
		ОтметитьИзменения("Шаблон", ИзмененныеДанные);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Если ЭтотОбъект.ПроверитьЗаполнение() Тогда
		
		ОчиститьНеиспользуемыеДанные();
		
		// Структура - результат
		РезСтруктура = Новый Структура;
		РезСтруктура.Вставить("ИмяОбласти",					 ИмяОбласти);
		РезСтруктура.Вставить("ВидЯчейки",				 	 ВидЯчейки);
		РезСтруктура.Вставить("ЭлементДанных",				 ЭлементДанных);
		РезСтруктура.Вставить("ИмяРесурса",					 ИмяРесурса);
		РезСтруктура.Вставить("Формула",					 Формула);
		РезСтруктура.Вставить("ФорматЧисел",				 ФорматЧисел);
		РезСтруктура.Вставить("Шаблон",						 Шаблон);
		РезСтруктура.Вставить("ФормироватьДвиженияПоБюджету",ФормироватьДвиженияПоБюджету);
		РезСтруктура.Вставить("ПериодДанных",				 ПериодДанных);
		
		СписокЗначенияПоУмолчанию = Новый СписокЗначений;
		Для каждого СтрокаТаблицы Из ЗначенияПоУмолчанию Цикл	
			СтрАналит = Новый Структура("ИмяАналитики, Аналитика, ЗначениеАналитики",
										СтрокаТаблицы.ИмяАналитики, 
										СтрокаТаблицы.Аналитика, 
										СтрокаТаблицы.ЗначениеАналитики);	
										
			СписокЗначенияПоУмолчанию.Добавить(СтрАналит, СтрокаТаблицы.ИмяАналитики);
		КонецЦикла;
		
		РезСтруктура.Вставить("ЗначенияПоУмолчанию",   СписокЗначенияПоУмолчанию);		
		РезСтруктура.Вставить("ИмяПараметраПоследнее", фИмяПараметраПоследнее);
		РезСтруктура.Вставить("СписокСвойств",  	   ОпределитьИзмененыеДанные(ИзмененныеДанные, РежимОбразца));
		
		Если РежимОбразца И ПустаяСтрока(РезСтруктура.СписокСвойств) Тогда
			Закрыть(Неопределено);
		Иначе	
			Закрыть(РезСтруктура);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры // ОК()

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();

КонецПроцедуры // Отмена()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет кэш значений, используемый на клиенте.
// 
&НаСервере
Процедура ЗаполнитьКэшЗначений()
	
	фКэшЗначений = Новый Структура;
	
	СпрОб = ДанныеФормыВЗначение(СправочникОбъект, Тип("СправочникОбъект.бит_НастройкиПроизвольныхОтчетов"));
	фКэшЗначений.Вставить("НастройкиАналитик", Справочники.бит_НастройкиПроизвольныхОтчетов.ПолучитьНастройкуАналитик(СпрОб));
	
	фКэшЗначений.Вставить("ПустойЭлементДанных", Справочники.бит_ЭлементыДанных.ПустаяСсылка());
               	
	КэшПеречислений = Новый Структура;
	КэшПеречислений.Вставить("бит_ВидыЯчеекПроизвольногоОтчета", бит_ОбщегоНазначения.КэшироватьЗначенияПеречисления(Перечисления.бит_ВидыЯчеекПроизвольногоОтчета));
	фКэшЗначений.Вставить("Перечисления", КэшПеречислений);
				  
КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура управляет видомостью/доступностью элементов формы.
// 
&НаСервере
Процедура УстановитьВидимостьДоступность()

	ВидыЯчеек  = Перечисления.бит_ВидыЯчеекПроизвольногоОтчета;
	ЭтоШаблон  = ВидЯчейки = ВидыЯчеек.Шаблон;
	ЭтоФормула = ВидЯчейки = ВидыЯчеек.Формула;
	ЭтоМСФО    = ТипОтчета = Перечисления.бит_ТипыПроизвольныхОтчетов.ОтчетностьМСФО;
		
	Элементы.ФормироватьДвиженияПоБюджету.Видимость = Не ЭтоШаблон И Не ЭтоМСФО;
	Элементы.ИмяОбласти.Видимость 	   = НЕ РежимОбразца;
	Элементы.ВидЯчейки.ТолькоПросмотр  = РежимОбразца;
	
	Элементы.СтраницаЗначенияПоУмолчанию.Видимость  = НЕ ЭтоМСФО;
	Если ЭтоМСФО Тогда
		Элементы.ПанельОсновная.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Элементы.ГруппаСтруктура.Видимость		   = Ложь;
	Иначе
		Элементы.ПанельОсновная.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		Если РежимОбразца Тогда
			Элементы.ГруппаСтруктура.Видимость = Ложь;
		Иначе	
			Элементы.ГруппаСтруктура.Видимость = Истина;
		КонецЕсли; 
	КонецЕсли; 
	
	Элементы.СтраницаЗначение.Видимость = ЗначениеЗаполнено(СпособКомпоновки);
	Элементы.СтраницаФормула.Видимость  = ЭтоФормула;
	Элементы.СтраницаШаблон.Видимость   = ЭтоШаблон;
	
	Если ВидЯчейки = ВидыЯчеек.Значение Тогда
		
		Элементы.ПанельЭлементаДанных.ТекущаяСтраница = Элементы.СтраницаЗначение;
		Элементы.ГруппаЭлементДанных.Заголовок 		  =  НСтр("ru = 'Заполнение'");
		
	ИначеЕсли ВидЯчейки = ВидыЯчеек.Формула Тогда
		
		Элементы.ПанельЭлементаДанных.ТекущаяСтраница = Элементы.СтраницаФормула;
		Элементы.ГруппаЭлементДанных.Заголовок 		  =  НСтр("ru = 'Формула'");
		
	ИначеЕсли ВидЯчейки = ВидыЯчеек.Шаблон Тогда
		
		Элементы.ПанельЭлементаДанных.ТекущаяСтраница = Элементы.СтраницаШаблон;
		Элементы.ГруппаЭлементДанных.Заголовок 		  =  НСтр("ru = 'Параметр'");
	КонецЕсли; 
	
КонецПроцедуры // УстановитьВидимостьДоступность()

// Процедура проверяет имя области.
// 
&НаСервере
Процедура ПроверитьИмяОбласти()
	
	СпецСимволы = " ,;:[]{}'""/\?!@#$%^&*+=<>~`|()";		
	ИмяОбласти  = бит_ОбщегоНазначенияКлиентСервер.ПроверитьСпецСимволы(ИмяОбласти, СпецСимволы, "Имя области");
	
КонецПроцедуры // ПроверитьИмяОбласти()

&НаСервереБезКонтекста
Процедура ПодготовитьИзмененныеДанные(ИзмененныеДанные)
	
	Массив = Новый Массив(); 
	Массив.Добавить("ВидЯчейки");
	Массив.Добавить("ЭлементДанных");
	Массив.Добавить("ИмяРесурса");
	Массив.Добавить("Формула");
	Массив.Добавить("ФорматЧисел");
	Массив.Добавить("Шаблон");
	Массив.Добавить("ФормироватьДвиженияПоБюджету");
	Массив.Добавить("ПериодДанных");
	Массив.Добавить("ЗначенияПоУмолчанию");
	
	Для каждого Элемент Из Массив Цикл
		НоваяСтрока = ИзмененныеДанные.Добавить();
		НоваяСтрока.ИмяРеквизита = Элемент;	
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтметитьИзменения(ИмяРеквизита, ИзмененныеДанные)

	СтрокиТаблицы = ИзмененныеДанные.НайтиСтроки(Новый Структура("ИмяРеквизита", ИмяРеквизита)); 
	СтрокиТаблицы[0].Пометка = Истина;
	
КонецПроцедуры // ОтметитьИзменения()

&НаКлиентеНаСервереБезКонтекста
Функция ОпределитьИзмененыеДанные(ИзмененныеДанные, РежимОбразца)
	
	Ключи = "";
	Если РежимОбразца Тогда
		Для каждого СтрокаТаблицы Из ИзмененныеДанные Цикл
			Если СтрокаТаблицы.Пометка Тогда
				Ключи = "," + СтрокаТаблицы.ИмяРеквизита + Ключи; 
			КонецЕсли; 
		КонецЦикла;   
		Ключи = Сред(Ключи,2);
	Иначе
		Ключи = "ИмяОбласти ,ВидЯчейки ,ЭлементДанных ,ИмяРесурса ,"
			  + "Формула ,ФорматЧисел ,Шаблон ,ФормироватьДвиженияПоБюджету ,"
			  + "ПериодДанных, ЗначенияПоУмолчанию";
	КонецЕсли; 

	Возврат Ключи;
	
КонецФункции // ОпределитьИзмененыеДанные()

&НаКлиенте
Процедура ОчиститьНеиспользуемыеДанные()

	Если ВидЯчейки = ПредопределенноеЗначение("Перечисление.бит_ВидыЯчеекПроизвольногоОтчета.Значение") Тогда
		
		Формула = "";		
		Шаблон  = ""; 
		ОтметитьИзменения("Формула", ИзмененныеДанные);
		ОтметитьИзменения("Шаблон",  ИзмененныеДанные);
		
	ИначеЕсли ВидЯчейки = ПредопределенноеЗначение("Перечисление.бит_ВидыЯчеекПроизвольногоОтчета.Формула") Тогда
		
		ЭлементДанных = ПредопределенноеЗначение("Справочник.бит_ЭлементыДанных.ПустаяСсылка");
		ИмяРесурса    = "";
		Шаблон   	  = "";
		ОтметитьИзменения("ЭлементДанных", ИзмененныеДанные);
		ОтметитьИзменения("ИмяРесурса",    ИзмененныеДанные);
		ОтметитьИзменения("Шаблон",   	   ИзмененныеДанные);
		
	ИначеЕсли ВидЯчейки = ПредопределенноеЗначение("Перечисление.бит_ВидыЯчеекПроизвольногоОтчета.Шаблон") Тогда
		
		ЭлементДанных = ПредопределенноеЗначение("Справочник.бит_ЭлементыДанных.ПустаяСсылка");
		ИмяРесурса    = "";
		Формула 	  = "";
		ОтметитьИзменения("ЭлементДанных", ИзмененныеДанные);
		ОтметитьИзменения("ИмяРесурса",    ИзмененныеДанные);
		ОтметитьИзменения("Формула",       ИзмененныеДанные);
		
	КонецЕсли;
	
КонецПроцедуры // ОчиститьНеиспользуемыеДанные()

&НаСервере
Процедура ЗагрузитьСписокПараметров()
	
	ТЗ = Параметры.СписокПараметров.Выгрузить();
	СоздатьРеквизитыФормы(ТЗ.Колонки);
	СписокПараметров.Загрузить(ТЗ);
	
КонецПроцедуры // ЗагрузитьСписокПараметров()
 
&НаСервере
Процедура СоздатьРеквизитыФормы(КолонкиСпискаПараметров)

	ДобавляемыеРеквизиты = Новый Массив(); 
	Для каждого Колонка  Из КолонкиСпискаПараметров Цикл
		Имя   = Колонка.Имя;
		Тип   = ОбщегоНазначения.ОписаниеТипаСтрока(0);
		Путь  = "СписокПараметров";
		ДобавляемыеРеквизиты.Добавить(Новый РеквизитФормы(Имя,Тип,Путь));
	КонецЦикла; 	

	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
КонецПроцедуры // ОбновитьРеквизитыФормы()

#КонецОбласти

