﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	МетаданныеОбъекта = Метаданные.Обработки.бит_ЗаполнитьПланСчетовПоПлануСчетов;
	
	// Вызов механизма защиты
	 	
	Если фОтказ Тогда	
		Возврат;    	
	КонецЕсли; 
	    	
	Объект.ПланСчетовПриемник = Параметры.ПланСчетовПриемник;
	Если Не ЗначениеЗаполнено(Объект.ПланСчетовПриемник) Тогда    				
		фОтказ = Истина;
		Возврат;			
	КонецЕсли;
	
	МетаданныеПланаСчетовПриемник = Метаданные.ПланыСчетов[Объект.ПланСчетовПриемник];
	Если МетаданныеПланаСчетовПриемник = Неопределено Тогда
		фОтсуствуетПланСчетовПриемник = Истина;
		фОтказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Синоним плана счетов приемник
	ПредставлениеПланСчетовПриемник = бит_ПраваДоступа.ПолучитьСинонимОбъектаСистемы(МетаданныеПланаСчетовПриемник);
	
	ЗаполнитьКэшЗначений();
		
	ЗакрыватьПриВыборе = Ложь;
	
	УстановитьСписокПлановСчетовДляВыбора(Объект.ПланСчетовПриемник);
		
	УстановитьВидимостьДоступность();
	
	фВыполнятьВТранзакции = Истина;
	фВыбиратьПодчиненные  = Истина;
	
	ИнинциализироватьСКД();
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	фРежимОтображенияСписка = СтрЗаменить(ТРег(Элементы.ПланСчетовСписок.Отображение), " ", "");
	Настройки.Вставить("фРежимОтображенияСписка", фРежимОтображенияСписка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Если фРежимОтображенияСписка <> Неопределено И фРежимОтображенияСписка <> "" Тогда
		Элементы.ПланСчетовСписок.Отображение = ОтображениеТаблицы[фРежимОтображенияСписка];
	КонецЕсли;
					
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	Если фОтказ Тогда
		
		Если Не ЗначениеЗаполнено(Объект.ПланСчетовПриемник) Тогда				
			ТекстОшибокПриОткрытии = Нстр("ru = 'Не указан ""План счетов приемник""! Данная обработка вызывается из других процедур конфигурации. Вручную ее вызывать запрещено.'");
	        бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстОшибокПриОткрытии);
		КонецЕсли;
		
		Если фОтсуствуетПланСчетовПриемник Тогда 			
			ТекстОшибокПриОткрытии = Нстр("ru = 'В системе не обнаружен план счетов %1%!'");
			ТекстОшибокПриОткрытии = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстОшибокПриОткрытии, Объект.ПланСчетовПриемник);
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстОшибокПриОткрытии);			
		КонецЕсли;
		
		Отказ = Истина;
		Возврат;	
		
	КонецЕсли;
	
	// Установим заголовок формы.
	УстановитьЗаголовокФормы(); 
	
	Элементы.ПланСчетовСписокВыполнятьВТранзакции.Пометка = фВыполнятьВТранзакции;
	Элементы.ПланСчетовСписокВыбиратьПодчиненные.Пометка  = фВыбиратьПодчиненные;
	
	// МТекущийПланСчетовИсточник   = "";
	
КонецПроцедуры // ПриОткрытии()

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ЭтаФорма.СохраняемыеВНастройкахДанныеМодифицированы = Истина;
	
КонецПроцедуры // ПередЗакрытием()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПланСчетовИсточникПриИзменении(Элемент)
	
	ИзменениеПланаСчетовИсточникСервер();
	бит_РаботаСДиалогамиКлиент.РазвернутьДеревоПолностью(Элементы.ПланСчетовСписок, ПланСчетовСписок.ПолучитьЭлементы(), Истина);
	
	// Установим заголовок формы.
	УстановитьЗаголовокФормы();
	
	// Видимость и доступность элементо формы
	УстановитьВидимостьДоступность();
	
КонецПроцедуры // ПредставлениеПланСчетовИсточникПриИзменении()

&НаКлиенте
Процедура ПредставлениеПланСчетовИсточникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Объект.ПланСчетовИсточник = ВыбранноеЗначение;
		
КонецПроцедуры // ПредставлениеПланСчетовИсточникОбработкаВыбора()

&НаКлиенте
Процедура ПредставлениеПланСчетовИсточникОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры // ПредставлениеПланСчетовИсточникОчистка()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПлансчетовсписокИЕеЭлементов

&НаКлиенте
Процедура ПланСчетовСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение( , Элемент.ТекущиеДанные.Ссылка);	
	КонецЕсли;
	
КонецПроцедуры // ПланСчетовСписокВыбор()

&НаКлиенте
Процедура ПланСчетовСписокВыбратьПриИзменении(Элемент)
	
	Если Не фВыбиратьПодчиненные Тогда
	 	Возврат;	
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ПланСчетовСписок.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда	
		Возврат;	
	КонецЕсли;
	
	ПроставитьФлажкиДляПодчиненныхСчетов(ТекущиеДанные.ПолучитьИдентификатор());	
	
КонецПроцедуры // ПланСчетовСписокВыбратьПриИзменении()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСписокСчетов(Команда)
	
	ОбновитьСписокСчетовСервер();
	бит_РаботаСДиалогамиКлиент.РазвернутьДеревоПолностью(Элементы.ПланСчетовСписок, ПланСчетовСписок.ПолучитьЭлементы(), Истина);
	
КонецПроцедуры // ОбновитьСписокСчетов()

&НаКлиенте
Процедура ДобавитьСчета(Кнопка)
	
	ТекстВопроса = Нстр("ru = 'Будет выполнено добавление счетов из ""%1%"" в ""%2%"". Продолжить?'");
	ТекстВопроса = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстВопроса
					, Элементы.ПредставлениеПланСчетовИсточник.СписокВыбора.НайтиПоЗначению(ПредставлениеПланСчетовИсточник).Представление
					, ПредставлениеПланСчетовПриемник);  			
	Оповещение = Новый ОписаниеОповещения("ВопросОДобавленииСчетовЗавершение", ЭтотОбъект); 
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет);
		
КонецПроцедуры // ДобавитьСчета()

// Процедура - обработчик оповещения "ВопросОДобавленииСчетовЗавершение".
// 
&НаКлиенте
Процедура ВопросОДобавленииСчетовЗавершение(Ответ, ДополнительныеДанные) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		КоличествоДобавленных = 0;
		ДобавитьСчетаСервер(КоличествоДобавленных);
		
		Если КоличествоДобавленных = 0 Тогда
			
			ТекстСообщения = Нстр("ru = 'Не выбранны счета для добавления!'");
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
						
		Иначе
			
			ТекстСообщения = Нстр("ru = 'Заполнение завершено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			ПроставитьФлажкиДляВсехСчетов(Ложь);
			
			ОповеститьОбИзменении(Тип("ПланСчетовСсылка." + Объект.ПланСчетовПриемник));
			
		КонецЕсли;
		
	КонецЕсли;     
	
КонецПроцедуры // ВопросОДобавленииСчетовЗавершение()
 
&НаКлиенте
Процедура ВыполнятьВТранзакции(Команда)
	
	фВыполнятьВТранзакции = Не фВыполнятьВТранзакции;
	Элементы.ПланСчетовСписокВыполнятьВТранзакции.Пометка = фВыполнятьВТранзакции;
	
КонецПроцедуры // ВыполнятьВТранзакции()

&НаКлиенте
Процедура ВыбиратьПодчиненные(Команда)
	
	фВыбиратьПодчиненные = Не фВыбиратьПодчиненные;
	Элементы.ПланСчетовСписокВыбиратьПодчиненные.Пометка = фВыбиратьПодчиненные;
	
КонецПроцедуры // ВыбиратьПодчиненные()
                      
&НаКлиенте
Процедура ПланСчетовСписок_СнятьВсе(Команда)
	
	ПроставитьФлажкиДляВсехСчетов(Ложь);
	
КонецПроцедуры // ПланСчетовСписок_СнятьВсе()

&НаКлиенте
Процедура ПланСчетовСписок_УстановитьВсе(Команда)
	
	ПроставитьФлажкиДляВсехСчетов(Истина);
	
КонецПроцедуры // ПланСчетовСписок_УстановитьВсе()

&НаКлиенте
Процедура ПланСчетовСписок_Инвертировать(Команда)
	
	ПроставитьФлажкиДляВсехСчетов();
	
КонецПроцедуры // ПланСчетовСписок_Инвертировать()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СерверныеПроцедурыИФункцииОбщегоНазначения

&НаСервере
Процедура ЗаполнитьКэшЗначений()

	ФКэшЗначений = Новый Структура;
	
	фКэшЗначений.Вставить("СоответствиеВидовСубконтоПриемника", СформироватьСоответствиеВидовСубконто());	

КонецПроцедуры // ЗаполнитьКэшЗначений()

// Процедура формирует список планов счетов доступных для выбора.
// 
// Параметры:
//  ПланСчетовПриемник - Строка
// 
&НаСервере
Процедура УстановитьСписокПлановСчетовДляВыбора(ПланСчетовПриемник) Экспорт
	
	ПланыСчетовМенеджер = Метаданные.ПланыСчетов;
	КартинкаПланСчетов  = БиблиотекаКартинок.ПланСчетовОбъект;
	
	Для Каждого ТекМетаданныеПланаСчетов Из ПланыСчетовМенеджер Цикл
		
		Если Не ТекМетаданныеПланаСчетов.Имя = ПланСчетовПриемник Тогда
			
			// Получим синоним плана счетов.
			СинонимПланаСчетов = бит_ПраваДоступа.ПолучитьСинонимОбъектаСистемы(ТекМетаданныеПланаСчетов);
			Элементы.ПредставлениеПланСчетовИсточник.СписокВыбора.Добавить(ТекМетаданныеПланаСчетов.Имя, СинонимПланаСчетов,, КартинкаПланСчетов);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.ПредставлениеПланСчетовИсточник.СписокВыбора.СортироватьПоПредставлению();
	
КонецПроцедуры // УстановитьСписокПлановСчетовДляВыбора()

// Процедура осуществляет управление видимостью/доступностью элементов управления формы.
// 
// Параметры:
//  Нет.
// 
&НаСервере
Процедура УстановитьВидимостьДоступность()

	ИсточникУказан = ЗначениеЗаполнено(Объект.ПланСчетовИсточник);
	
	Элементы.ФормаОбновитьСписокСчетов.Доступность   		  = ИсточникУказан;
	Элементы.ПланСчетовСписокОбновитьСписокСчетов.Доступность = ИсточникУказан;
	  	
	Элементы.ПланСчетовСписок.Доступность 					  = ИсточникУказан;
	Элементы.ПланСчетовСписокКоманднаяПанель.Доступность      = ИсточникУказан;
	
	Элементы.КомпоновщикПользовательскиеНастройки.Доступность 				 = ИсточникУказан;
	Элементы.КомпоновщикПользовательскиеНастройкиКоманднаяПанель.Доступность = ИсточникУказан;
			
КонецПроцедуры // УстановитьВидимость()

// ----------------------------------------------------------------------

&НаСервере
Функция СформироватьСоответствиеВидовСубконто()

	СоответствиеВидовСубконтоПриемника = Новый Соответствие;
	
	МетаданныеПланаСчетовПриемник = Метаданные.ПланыСчетов[Объект.ПланСчетовПриемник];
	
	ВидыСубконтоПриемникМенеджер = ПланыВидовХарактеристик[МетаданныеПланаСчетовПриемник.ВидыСубконто.Имя];
	ВыборкаВидыСубконтоПриемник  = ВидыСубконтоПриемникМенеджер.Выбрать();
			
	Пока ВыборкаВидыСубконтоПриемник.Следующий() Цикл
		
		ТекСсылка 	   = ВыборкаВидыСубконтоПриемник.Ссылка;
		ТипЗнчСубконто = ВыборкаВидыСубконтоПриемник.ТипЗначения;
		
		ВидСубконтоПриемника = СоответствиеВидовСубконтоПриемника.Получить(ТипЗнчСубконто);
		Если ВидСубконтоПриемника = Неопределено Тогда
			
			СоответствиеВидовСубконтоПриемника.Вставить(ТипЗнчСубконто, ТекСсылка);
			
		ИначеЕсли ТипЗнч(ВидСубконтоПриемника) = Тип("Массив") Тогда
			
			ВидСубконтоПриемника.Добавить(ТекСсылка);
			СоответствиеВидовСубконтоПриемника.Вставить(ТипЗнчСубконто, ВидСубконтоПриемника);
			
		Иначе
			
			НовМассивВидов = Новый Массив;
			НовМассивВидов.Добавить(ВидСубконтоПриемника);
			НовМассивВидов.Добавить(ТекСсылка);
			СоответствиеВидовСубконтоПриемника.Вставить(ТипЗнчСубконто, НовМассивВидов); 
		
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СоответствиеВидовСубконтоПриемника;	

КонецФункции // СформироватьСоответствиеВидовСубконто()

// Процедура проставляет флажки у подчиненных счетов.
// 
// Параметры:
//  ЗначениеФлага - Булево
//  Ид 			  - Число
// 
&НаСервере
Процедура ПроставитьФлажкиДляПодчиненныхСтрокДерева(ЗначениеФлага, ТекущиеДанные)
	
	ЗначениеФлагаЗаполнено = ЗначениеЗаполнено(ЗначениеФлага); 
	
	Для каждого СтрокаСчет Из ТекущиеДанные.ПолучитьЭлементы() Цикл
	 	СтрокаСчет.Выбрать = ?(ЗначениеФлагаЗаполнено, ЗначениеФлага, Не СтрокаСчет.Выбрать); 
		ПроставитьФлажкиДляПодчиненныхСтрокДерева(ЗначениеФлага, СтрокаСчет);	
	КонецЦикла;

КонецПроцедуры // ПроставитьФлажкиДляПодчиненных()

// Процедура проставляет флажки у подчиненных счетов.
// 
// Параметры:
//  Ид - Число
// 
&НаСервере
Процедура ПроставитьФлажкиДляПодчиненныхСчетов(Ид = Неопределено)

	ТекущиеДанные = ?(Ид = Неопределено, ПланСчетовСписок, ПланСчетовСписок.НайтиПоИдентификатору(Ид));
	ПроставитьФлажкиДляПодчиненныхСтрокДерева(ТекущиеДанные.Выбрать, ТекущиеДанные);

КонецПроцедуры // ПроставитьФлажкиДляПодчиненных()

// Процедура проставляет флажки у подчиненных счетов.
// 
// Параметры:
//  ЗначениеФлага - Булево Или Неопределено (По умолчанию = Неопределено).
// 
&НаСервере
Процедура ПроставитьФлажкиДляВсехСчетов(ЗначениеФлага = Неопределено)

	ПроставитьФлажкиДляПодчиненныхСтрокДерева(ЗначениеФлага, ПланСчетовСписок);

КонецПроцедуры // ПроставитьФлажкиДляВсехСчетов()

// ----------------------------------------------------------------------

// Процедура обрабатывает изменение плана счетов источник.
// 
&НаСервере
Процедура ИзменениеПланаСчетовИсточникСервер()
	
	ИнинциализироватьСКД();
	
	ОбновитьСписокСчетовСервер();

КонецПроцедуры // ИзменениеПланаСчетовИсточникСервер()

// Процедура ОПИСАНИЕ
// 
// Параметры:
//  Параметр1  - Тип_описание
//  Параметр2  - Тип_описание
// 
&НаСервере
Процедура ДобавитьСчетаВСписок(ВерхнийУровеньВыборки, УзелДерева)

	ВыборкаЗапроса = ВерхнийУровеньВыборки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		
	Пока ВыборкаЗапроса.Следующий() Цикл
		
		НоваяСтрока = УзелДерева.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаЗапроса);
		НоваяСтрока.Картинка = БиблиотекаКартинок.ПланСчетовОбъект;// ?(ВыборкаЗапроса.Предопределенный, , );
		
		ДобавитьСчетаВСписок(ВыборкаЗапроса, НоваяСтрока.ПолучитьЭлементы());
		
	КонецЦикла;	

КонецПроцедуры // ДобавитьСчетаВСписок()

&НаСервере
Процедура ОбновитьСписокСчетовСервер()
	
	КореньДерева = ПланСчетовСписок.ПолучитьЭлементы();
	КореньДерева.Очистить();
	
	ЗапросСКД 		 = ПолучитьЗапросСКД(); 	
	РезультатЗапроса = ЗапросСКД.Выполнить(); 	
	
	Если РезультатЗапроса.Пустой() Тогда
		
		ТекстСообщения = НСтр("ru = 'Нет данных, удовлетворяющих отбору.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
	Иначе                              
		
		ДобавитьСчетаВСписок(РезультатЗапроса, КореньДерева);
				
	КонецЕсли;
	
	// Сортировка
	ДеревоПСС = ДанныеФормыВЗначение(ПланСчетовСписок, Тип("ДеревоЗначений"));
	СтрокиДерева = ДеревоПСС.Строки;
	Если СтрокиДерева.Количество() > 0 Тогда
		СтрокиДерева.Сортировать("Порядок", Истина);	
	КонецЕсли;
	ЗначениеВДанныеФормы(ДеревоПСС, ПланСчетовСписок);
   	
КонецПроцедуры // ОбновитьСписокСчетов()

// ----------------------------------------------------------------------
// Добвление счетов в приемник

// Функция получает структуру данных счета источника для заполнения счета приемника.
// 
// Параметры:
//  СчетИсточникСсылка 		      - ПланСчетовСсылка.
//  СтруктураПараметров			  - Структура
//  								   (ПланСчетовПриемникМенеджер	  - ПланСчетовМенеджер
//  									МетаданныеПланаСчетовПриемник - ПланСчетовМетаданные
//  									МетаданныеПланаСчетовИсточник - ПланСчетовМетаданные).
// 
// Возвращаемое значение:
//  ДанныеСчетаИсточника - Структура.
// 
&НаСервере
Функция ПолучитьСтруктуруДанныхСчетаИсточника(СчетИсточникСсылка, СтруктураПараметров)
											 
	// Получим свойства плана счетов источника из метаданных.
	РеквизитыИсточника	   = СтруктураПараметров.МетаданныеПланаСчетовИсточник.Реквизиты;
	ПризнакиУчетаИсточника = СтруктураПараметров.МетаданныеПланаСчетовИсточник.ПризнакиУчета;
	// Ищем родителя счета приемника по коду родителя счета источника.
	РодительСчетаПриемника = СтруктураПараметров.ПланСчетовПриемникМенеджер.НайтиПоКоду(СчетИсточникСсылка.Родитель.Код);
	
	ДанныеСчетаИсточника = Новый Структура;
	
	ДанныеСчетаИсточника.Вставить("Код"			   , СчетИсточникСсылка.Код);
	ДанныеСчетаИсточника.Вставить("Порядок"		   , СчетИсточникСсылка.Порядок);
	ДанныеСчетаИсточника.Вставить("Наименование"   , СчетИсточникСсылка.Наименование);
	ДанныеСчетаИсточника.Вставить("Вид"			   , СчетИсточникСсылка.Вид);
	ДанныеСчетаИсточника.Вставить("Забалансовый"   , СчетИсточникСсылка.Забалансовый);  
	ДанныеСчетаИсточника.Вставить("ПометкаУдаления", СчетИсточникСсылка.ПометкаУдаления);
	ДанныеСчетаИсточника.Вставить("Родитель"	   , РодительСчетаПриемника);
	
	Для Каждого ТекРеквизит Из РеквизитыИсточника Цикл
		ИмяТекРеквизита = ТекРеквизит.Имя;
		ДанныеСчетаИсточника.Вставить(ИмяТекРеквизита, СчетИсточникСсылка[ИмяТекРеквизита]);
	КонецЦикла;
	
	Для Каждого ТекПризнак Из ПризнакиУчетаИсточника Цикл
		ИмяТекПризнака = ТекПризнак.Имя;
		ДанныеСчетаИсточника.Вставить(ИмяТекПризнака, СчетИсточникСсылка[ИмяТекПризнака]);
	КонецЦикла;
	
	Возврат ДанныеСчетаИсточника;
	
КонецФункции // ПолучитьСтруктуруДанныхСчетаИсточника()

// Процедура добавляет счета 
// 
// Параметры:
//  УзелДерева            - ДанныеФормыЭлементКоллекции.
//  КоличествоДобавленных - Число.
//  ЕстьОшибки			  - Булево.
//  СтруктураПараметров   - Структура
//  								   (ПланСчетовПриемникМенеджер	  	 - ПланСчетовМенеджер
//  									МетаданныеПланаСчетовПриемник 	 - ПланСчетовМетаданные
//  									МетаданныеПланаСчетовИсточник 	 - ПланСчетовМетаданные
//                                      ЕстьНаименованиеПолноеУПриемника - Булево
// 										МаскаКодаИсточник  				 - Строка
// 										МаскаКодаПриемник 				 - Строка).
// 
&НаСервере
Процедура ДобавитьСчет(СтрокаДерева, КоличествоДобавленных, ЕстьОшибки, СтруктураПараметров)
	
		СчетИсточникСсылка = СтрокаДерева.Ссылка;
		
		ПланСчетовПриемникМенеджер 		 = СтруктураПараметров.ПланСчетовПриемникМенеджер;
		МаскаКодаИсточник 		   		 = СтруктураПараметров.МаскаКодаИсточник;
		МаскаКодаПриемник 		   		 = СтруктураПараметров.МаскаКодаПриемник;
		ЕстьНаименованиеПолноеУПриемника = СтруктураПараметров.ЕстьНаименованиеПолноеУПриемника;
		
		// Получим структуру данных счета источника.
		ДанныеСчетаИсточник = ПолучитьСтруктуруДанныхСчетаИсточника(СчетИсточникСсылка, СтруктураПараметров);
																   														   
		// Преобразуем данные, если маски не равны
		
		Если МаскаКодаИсточник <> МаскаКодаПриемник Тогда
			ДанныеСчетаИсточник.Вставить("РодительКод", СчетИсточникСсылка.Родитель.Код);
			РегистрыСведений.бит_МаскиКодов.ПреобразоватьДанныеПоМаскеКода(ДанныеСчетаИсточник, МаскаКодаПриемник);
			РодительСчетаПриемника = ПланСчетовПриемникМенеджер.НайтиПоКоду(ДанныеСчетаИсточник.РодительКод);
			ДанныеСчетаИсточник.Вставить("Родитель", РодительСчетаПриемника);
		КонецЕсли;
		
		// Ищем счет приемник по коду счета источника.
		СчетПриемникСсылка = ПланСчетовПриемникМенеджер.НайтиПоКоду(ДанныеСчетаИсточник.Код);
		
		Если ЗначениеЗаполнено(СчетПриемникСсылка) Тогда
			СчетПриемникОбъект = СчетПриемникСсылка.ПолучитьОбъект();
		Иначе
			СчетПриемникОбъект = ПланСчетовПриемникМенеджер.СоздатьСчет();
		КонецЕсли;
				
		// Заполним значения счета приемника.
		ЗаполнитьЗначенияСвойств(СчетПриемникОбъект, ДанныеСчетаИсточник);
		
		// Если у счета приемника есть наименование полное и оно не заполнено, тогда.
		Если ЕстьНаименованиеПолноеУПриемника И Не ЗначениеЗаполнено(СчетПриемникОбъект.НаименованиеПолное) Тогда 			
			// Заполняем из наименования.
			СчетПриемникОбъект.НаименованиеПолное = СчетПриемникОбъект.Наименование; 			
		КонецЕсли;
		
		// Заполним виды субконто счета приемника.
		СчетПриемникОбъект.ВидыСубконто.Очистить();
		
		ЗначенияВидовСубконтоИсточника = СчетИсточникСсылка.ВидыСубконто;
		
		Для Каждого ТекЗначениеВидаСубконто Из ЗначенияВидовСубконтоИсточника Цикл
			
			ТипЗнчСубконто		 = ТекЗначениеВидаСубконто.ВидСубконто.ТипЗначения;
			ВидСубконтоПриемника = фКэшЗначений.СоответствиеВидовСубконтоПриемника.Получить(ТипЗнчСубконто);
			
			Если ЗначениеЗаполнено(ВидСубконтоПриемника) Тогда
				
				Если ТипЗнч(ВидСубконтоПриемника) = Тип("Массив") Тогда
					
					Для каждого ЭлМасс Из ВидСубконтоПриемника Цикл
						Если ЭлМасс.Наименование = ТекЗначениеВидаСубконто.ВидСубконто.Наименование Тогда
						
							НовыйВидСубконто = СчетПриемникОбъект.ВидыСубконто.Добавить();
							ЗаполнитьЗначенияСвойств(НовыйВидСубконто, ТекЗначениеВидаСубконто); 
							НовыйВидСубконто.Предопределенное = ?(СчетПриемникОбъект.Предопределенный, ТекЗначениеВидаСубконто.Предопределенное, Ложь);
							НовыйВидСубконто.ВидСубконто = ЭлМасс;
							Прервать;
						
						КонецЕсли;   				
					КонецЦикла;
					
				Иначе
				
					НовыйВидСубконто = СчетПриемникОбъект.ВидыСубконто.Добавить();
					ЗаполнитьЗначенияСвойств(НовыйВидСубконто, ТекЗначениеВидаСубконто); 	
					НовыйВидСубконто.Предопределенное = ?(СчетПриемникОбъект.Предопределенный, ТекЗначениеВидаСубконто.Предопределенное, Ложь);
					НовыйВидСубконто.ВидСубконто = ВидСубконтоПриемника;
					
				КонецЕсли;
			
			КонецЕсли;
			
		КонецЦикла;

	// Запись счета.
	Если бит_ОбщегоНазначения.ЗаписатьСчет(СчетПриемникОбъект, ПредставлениеПланСчетовПриемник, , "Ошибки", Истина) Тогда
		КоличествоДобавленных = КоличествоДобавленных + 1;
	Иначе
		// Не удалось записать счет.
		ЕстьОшибки = Истина;			
	КонецЕсли;
 	
КонецПроцедуры // ДобавитьСчет()

// Процедура добавляет счета 
// 
// Параметры:
//  УзелДерева            - ДанныеФормыЭлементКоллекции.
//  КоличествоДобавленных - Число.
//  ЕстьОшибки			  - Булево.
//  СтруктураПараметров   - Структура.
// 
&НаСервере
Процедура ДобавитьВыбранныеСчета(УзелДерева, КоличествоДобавленных, ЕстьОшибки, СтруктураПараметров)
	
	Для каждого СтрокаДерева Из УзелДерева Цикл
		
		Если СтрокаДерева.Выбрать Тогда    			
			
			ДобавитьСчет(СтрокаДерева, КоличествоДобавленных, ЕстьОшибки, СтруктураПараметров);
		
		КонецЕсли;
		
		ДобавитьВыбранныеСчета(СтрокаДерева.ПолучитьЭлементы(), КоличествоДобавленных, ЕстьОшибки, СтруктураПараметров);
	
	КонецЦикла;
	
КонецПроцедуры // ДобавитьВыбранныеСчета()

// Процедура добавляет счета 
// 
// Параметры:
//  КоличествоДобавленных - Число.
// 
&НаСервере
Процедура ДобавитьСчетаСервер(КоличествоДобавленных)
	
	ЕстьОшибки = Ложь;
	
	МетаданныеПланаСчетовИсточник = Метаданные.ПланыСчетов[Объект.ПланСчетовИсточник];
	МетаданныеПланаСчетовПриемник = Метаданные.ПланыСчетов[Объект.ПланСчетовПриемник];
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("МетаданныеПланаСчетовИсточник"   , МетаданныеПланаСчетовИсточник);
	СтруктураПараметров.Вставить("МетаданныеПланаСчетовПриемник"   , МетаданныеПланаСчетовПриемник);
	СтруктураПараметров.Вставить("ПланСчетовПриемникМенеджер"      , ПланыСчетов[Объект.ПланСчетовПриемник]);
	СтруктураПараметров.Вставить("ЕстьНаименованиеПолноеУПриемника", МетаданныеПланаСчетовПриемник.Реквизиты.Найти("НаименованиеПолное") <> Неопределено);
	СтруктураПараметров.Вставить("МаскаКодаИсточник"			   , РегистрыСведений.бит_МаскиКодов.ПолучитьМаскуКодаПланаСчетов(Объект.ПланСчетовИсточник));
	СтруктураПараметров.Вставить("МаскаКодаПриемник"			   , РегистрыСведений.бит_МаскиКодов.ПолучитьМаскуКодаПланаСчетов(Объект.ПланСчетовПриемник));
	
	КореньДерева = ПланСчетовСписок.ПолучитьЭлементы();
	ДобавитьВыбранныеСчета(КореньДерева, КоличествоДобавленных, ЕстьОшибки, СтруктураПараметров);
												
КонецПроцедуры // ДобавитьСчета()

// ----------------------------------------------------------------------
// СКД

// Функция получает запрос схемы компановки данных.
// 
// Параметры:
//  Нет
// 
// Возращаемое значение:
//  Запрос
// 
&НаСервере
Функция ПолучитьЗапросСКД() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);

	// Выполняем компановку макета МакетСКД
	// (настройки берутся из схемы компановки данных и из пользовательских настроек).
	КомпоновщикМакетаКомпоновкиДанных = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетСКД = КомпоновщикМакетаКомпоновкиДанных.Выполнить(СхемаКомпоновкиДанных, Объект.Компоновщик.ПолучитьНастройки());
	
	// Получаем запрос макета компановки данных
	Запрос = Новый Запрос(МакетСКД.НаборыДанных.СписокСчетов.Запрос);
	
	// Устанавливаем параметры запроса
	ОписаниеПараметровЗапроса = Запрос.НайтиПараметры();
	Для каждого ОписаниеПараметраЗапроса из ОписаниеПараметровЗапроса Цикл
		Запрос.УстановитьПараметр(ОписаниеПараметраЗапроса.Имя, МакетСКД.ЗначенияПараметров[ОписаниеПараметраЗапроса.Имя].Значение);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Запрос;
	
КонецФункции // ПолучитьЗапросСКД()

// Процедура инициализирует схему компановки данных.
// 
&НаСервере
Процедура ИнинциализироватьСКД()

	УстановитьПривилегированныйРежим(Истина);
	
	СхемаКомпоновкиДанных = Обработки.бит_ЗаполнитьПланСчетовПоПлануСчетов.ПолучитьМакет("ПодборСчетов");
	
	Если ЗначениеЗаполнено(Объект.ПланСчетовИсточник) Тогда
	 	СхемаКомпоновкиДанных.НаборыДанных.СписокСчетов.Запрос = "
		|ВЫБРАТЬ
		|	ПланСчетовИсточник.Ссылка,
		|	ПланСчетовИсточник.Код,
		|	ПланСчетовИсточник.Порядок,
		|	ПланСчетовИсточник.Наименование,
		|	ПланСчетовИсточник.Предопределенный
		|{ВЫБРАТЬ
		|	Ссылка.*}
		|ИЗ
		|	ПланСчетов." + Объект.ПланСчетовИсточник + " КАК ПланСчетовИсточник
		|
		|{ГДЕ
		|	ПланСчетовИсточник.Ссылка.*}
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка ИЕРАРХИЯ УБЫВ
		|
		|";
		СхемаКомпоновкиДанных.НаборыДанных.СписокСчетов.Поля[0].ТипЗначения = Новый ОписаниеТипов("ПланСчетовСсылка." + Объект.ПланСчетовИсточник);
	Иначе
		СхемаКомпоновкиДанных.НастройкиПоУмолчанию.Отбор.Элементы.Очистить();	
	КонецЕсли;
	                 
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
	Объект.Компоновщик.Инициализировать(ИсточникНастроек);
	Объект.Компоновщик.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры // ИнинциализироватьСКД()

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоНазначения

// Процедура устанавливает заголовок формы обработки.
// 
// Параметры:
//  Нет.
// 
&НаКлиенте
Процедура УстановитьЗаголовокФормы()
	
	ТекстИсточник = ?(ЗначениеЗаполнено(Объект.ПланСчетовИсточник)
					, Элементы.ПредставлениеПланСчетовИсточник.СписокВыбора.НайтиПоЗначению(ПредставлениеПланСчетовИсточник).Представление
					, Нстр("ru = 'источник НЕ УКАЗАН'"));
	
	ЭтаФорма.Заголовок = Нстр("ru = 'Заполнение: '") + ТекстИсточник + " -> " + ПредставлениеПланСчетовПриемник;
	 		
КонецПроцедуры // УстановитьЗаголовокФормы()

#КонецОбласти

#КонецОбласти

