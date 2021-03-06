

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура НастройкаПериода(Команда)
	
	бит_РаботаСДиалогамиКлиент.НастроитьПериодПоДатам(Объект.ДатаНачала, Объект.ДатаОкончания);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьПереченьОбъектов();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.ПереченьОбъектов, "Выполнять", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	бит_РаботаСДиалогамиКлиент.ОбработатьФлагиТаблицы(Объект.ПереченьОбъектов, "Выполнять", 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОбъектыВДокумент(Команда)
	
	РезСтруктура = ПолучитьСтруктуруВыбора("Добавить");
	
	
	ОповеститьОВыборе(РезСтруктура);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбъектыВДокумент(Команда)
	
	РезСтруктура = ПолучитьСтруктуруВыбора("Загрузить");
	
	ОповеститьОВыборе(РезСтруктура);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ "ПереченьОбъектов"

&НаКлиенте
Процедура ПереченьОбъектовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элементы.ПереченьОбъектов.ТекущиеДанные;
	
	Если ТекущаяСтрока.Выполнять Тогда
		
		РезСтруктура = ПолучитьСтруктуруВыбора("Добавить", ТекущаяСтрока.ПолучитьИдентификатор());
		
		ОповеститьОВыборе(РезСтруктура);
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

////////////////////////////////////////////////////////////////////////////////
// СЕРВЕРНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// бит_DFedotov Процедура добавляет быстрые отборы для пользователя
//
&НаСервере
Процедура ДобавитьПользовательскиеОтборы()
	
	СКД = ПолучитьИзВременногоХранилища(АдресСКД);
	
	СтруктураОтбора = Новый Структура;
	
	СтруктураОтбора.Вставить("Организация"		, Новый Структура("Использование, Значение", Истина, Объект.Организация));
	СтруктураОтбора.Вставить("Проведен"			, Новый Структура("Использование, Значение", Истина, Истина));
	СтруктураОтбора.Вставить("МОЛ"				, Новый Структура("Использование, Значение", ЗначениеЗаполнено(Объект.МОЛ), Объект.МОЛ));
	СтруктураОтбора.Вставить("Местонахождение"	, Новый Структура("Использование, Значение", ЗначениеЗаполнено(Объект.Местонахождение), Объект.Местонахождение));
	
	//БИТ Тртилек 28.06.2012
	Если (Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПринятиеКУчетуОС 
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.МодернизацияОС
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.бит_КомплектацияОС)
		// BIT Avseenkov 15052014 /Доработка функцонала по уастку основных средств {
		И НЕ Подбор07_0804 Тогда
		//}
		СтруктураОтбора.Вставить("ОбъектСтроительства", Новый Структура("Использование, Значение",ЗначениеЗаполнено(Объект.ОбъектСтроительства), Объект.ОбъектСтроительства));	
	ИначеЕсли  (Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПринятиеКУчетуОС 
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.МодернизацияОС)
		// BIT Avseenkov 15052014 /Доработка функцонала по уастку основных средств {
		И  Подбор07_0804 Тогда
		СтруктураОтбора.Вставить("Склад", Новый Структура("Использование, Значение",ЗначениеЗаполнено(Объект.Склад), Объект.Склад));	
	КонецЕсли;
	///БИТ Тртилек
	
	Если Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.МодернизацияОС 
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.НачислениеАмортизацииОС
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ОбесценениеОС
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПереоценкаОС
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыбытиеОС Тогда
		
		СтруктураОтбора.Вставить("ВидКласса", Новый Структура("Использование, Значение",ЗначениеЗаполнено(Объект.ВидКласса), Объект.ВидКласса));
	КонецЕсли;
	
	Если Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыработкаОС
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыработкаНМА Тогда
		
		СтруктураОтбора.Вставить("МетодНачисленияАмортизации", Новый Структура("Использование, Значение",ЗначениеЗаполнено(Объект.МетодНачисленияАмортизации), Объект.МетодНачисленияАмортизации));
	КонецЕсли;
	
	Если Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.НачислениеАмортизацииОС 
		 ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.НачислениеАмортизацииНМА  Тогда
		
		СтруктураОтбора.Вставить("НачислятьАмортизацию", Новый Структура("Использование, Значение", Истина, Истина));
	КонецЕсли; 
	
	Если Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ОбесценениеОС
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПереоценкаОС
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПереоценкаНМА
		ИЛИ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ОбесценениеНМА Тогда
		
		СтруктураОтбора.Вставить("МодельУчета", Новый Структура("Использование, Значение",ЗначениеЗаполнено(Объект.МодельУчета), Объект.МодельУчета));
	КонецЕсли;
	
	Если НЕ Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.бит_КомплектацияОС Тогда
		Элементы.ПереченьОбъектов.ИзменятьСоставСтрок = Ложь;
	Иначе
		Элементы.ПереченьОбъектовДокументБУ.ТолькоПросмотр = ЛОЖЬ;
		Элементы.ПереченьОбъектовСумма.ТолькоПросмотр = ЛОЖЬ;
	КонецЕсли;
	
	Отбор = Объект.Компоновщик.Настройки.Отбор;
	
	Для Каждого ЭлементОтбора Из СтруктураОтбора Цикл
		
		НастройкаЭлемента = ЭлементОтбора.Значение;
		
		ПолеОтбора = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Ключ);
		ДоступноеПоле = Отбор.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора);
		
		Если НЕ НастройкаЭлемента.Использование
			ИЛИ ДоступноеПоле = Неопределено Тогда
			
			Продолжить;
		КонецЕсли;
		
		Если ЭлементОтбора.Ключ = "ОбъектСтроительства" Тогда
			бит_ОбщегоНазначенияКлиентСервер.УстановитьОтборУСписка(Отбор, ПолеОтбора, НастройкаЭлемента.Значение, ВидСравненияКомпоновкиДанных.ВИерархии);	
		Иначе
			бит_ОбщегоНазначенияКлиентСервер.УстановитьОтборУСписка(Отбор, ПолеОтбора, НастройкаЭлемента.Значение);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ДобавитьПользовательскиеОтборы()

// бит_DFedotov Процедура заполняет табличную часть ПереченьОбъектов
//
&НаСервере
Процедура ОбновитьПереченьОбъектов()

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Организация"	, Объект.Организация);
	СтруктураПараметров.Вставить("ДатаНачала"	, Объект.ДатаНачала);
	СтруктураПараметров.Вставить("ДатаОкончания", Объект.ДатаОкончания);
	СтруктураПараметров.Вставить("Режим"		, Объект.Режим);
	СтруктураПараметров.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
	
	ТаблицаОбъектов = Обработки.бит_му_ПодборВНАПринятиеМодернизация.ПолучитьПереченьОбъектов(АдресСКД, Объект.Компоновщик, СтруктураПараметров);
	
	Объект.ПереченьОбъектов.Загрузить(ТаблицаОбъектов);
	
КонецПроцедуры // ОбновитьПереченьОбъектов()

&НаСервере
Процедура УстановитьВидимость()
	
	ЭтоПринятиеОС     = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПринятиеКУчетуОС		  , Истина, Ложь);
	ЭтоМодернизацияОС = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.МодернизацияОС   	  	  , Истина, Ложь);	
	ЭтоПеремещениеОС  = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПеремещениеОС   		  , Истина, Ложь);	
	ЭтоАмортизацияОС  = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.НачислениеАмортизацииОС , Истина, Ложь);
	ЭтоПереоценкаОС   = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПереоценкаОС 			  , Истина, Ложь);
	ЭтоВыработкаОС    = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыработкаОС  			  , Истина, Ложь);
	ЭтоОбесценениеОС  = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ОбесценениеОС			  , Истина, Ложь);
	ЭтоВыбытиеОС  	  = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыбытиеОС    			  , Истина, Ложь);
	ЭтоКомплектацияОС = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.бит_КомплектацияОС  	  , Истина, Ложь);
	ЭтоПринятиеНМА    = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПринятиеКУчетуНМА		  , Истина, Ложь);
	ЭтоАмортизацияНМА = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.НачислениеАмортизацииНМА, Истина, Ложь);	
	ЭтоПереоценкаНМА  = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПереоценкаНМА			  , Истина, Ложь);
	ЭтоВыработкаНМА   = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыработкаНМА  		  , Истина, Ложь);	
	ЭтоОбесценениеНМА = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ОбесценениеНМА		  , Истина, Ложь);	
	ЭтоВыбытиеНМА  	  = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ВыбытиеНМА   			  , Истина, Ложь);
	
	// бит_ASuleymanov изменение кода. Начало. 05.02.2014{{
	ЭтоПереводОСВСоставИнвестиционнойСобственности = ?(Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.ПереводОСВСоставИнвестиционнойСобственности, Истина, Ложь);
	// бит_ASuleymanov изменение кода. Начало. 05.02.2014{{
	
	ЭтоПродажа = ?(Объект.ВидДвижения = Перечисления.бит_му_ВидыДвиженияВыбытия.Продажа
						 ИЛИ Объект.ВидДвижения = Перечисления.бит_му_ВидыОперацийВыбытиеНМА.Продажа, Истина, Ложь);
						 
    ЭтоНМА = ЭтоПринятиеНМА 
	         ИЛИ ЭтоВыбытиеНМА 
			 ИЛИ ЭтоАмортизацияНМА 
			 ИЛИ ЭтоВыработкаНМА 
			 ИЛИ ЭтоОбесценениеНМА 
			 ИЛИ ЭтоПереоценкаНМА;						 
	
	Элементы.ПереченьОбъектовИнвентарныйНомер.Видимость 		= НЕ ЭтоНМА И НЕ ЭтоКомплектацияОС;
	Элементы.ПереченьОбъектовПервоначальнаяСтоимость.Видимость	= ЭтоПринятиеОС ИЛИ ЭтоПринятиеНМА;
	Элементы.ПереченьОбъектовДатаПринятияКУчету.Видимость      	= ЭтоПринятиеОС ИЛИ ЭтоАмортизацияОС ИЛИ ЭтоПринятиеНМА;
	//Элементы.ПереченьОбъектовГруппаМодернизация.Видимость      	= ЭтоМодернизацияОС;
	//Элементы.ПереченьОбъектовОбъектСтроительства.Видимость		= ЭтоМодернизацияОС;
	Элементы.ПереченьОбъектовМестонахождение.Видимость 			= НЕ ЭтоНМА И НЕ ЭтоКомплектацияОС;;
	Элементы.ПереченьОбъектовМОЛ.Видимость 						= НЕ ЭтоНМА И НЕ ЭтоКомплектацияОС;;
	Элементы.ПереченьОбъектовСумма.Видимость        = ЭтоПринятиеОС ИЛИ ЭтоПринятиеНМА ИЛИ ((ЭтоВыбытиеОС ИЛИ ЭтоВыбытиеНМА) И ЭтоПродажа) ИЛИ ЭтоМодернизацияОС ИЛИ ЭтоКомплектацияОС;
	Элементы.ПереченьОбъектовСуммаНДС.Видимость		= ((ЭтоВыбытиеОС ИЛИ ЭтоВыбытиеНМА) И ЭтоПродажа);
	Элементы.ПереченьОбъектовДокументБУ.Видимость   = Не ЭтоАмортизацияОС 
	                                                И НЕ ЭтоВыработкаОС 
												    И НЕ ЭтоОбесценениеОС 
												    И НЕ ЭтоПереоценкаОС 
												    И НЕ ЭтоПереоценкаНМА 
												    И НЕ ЭтоВыработкаНМА
												    И НЕ ЭтоАмортизацияНМА
												    И НЕ ЭтоОбесценениеНМА
													// бит_ASuleymanov изменение кода. Начало. 05.02.2014{{
													И НЕ ЭтоПереводОСВСоставИнвестиционнойСобственности;
													// бит_ASuleymanov изменение кода. Конец. 05.02.2014}}
	Элементы.ПереченьОбъектовВидКласса.Видимость = ЭтоАмортизацияОС 
	                                           ИЛИ ЭтоОбесценениеОС 
											   ИЛИ ЭтоПереоценкаОС 
											   ИЛИ ЭтоВыбытиеОС
											   // бит_ASuleymanov изменение кода. Начало. 05.02.2014{{
											   ИЛИ ЭтоПереводОСВСоставИнвестиционнойСобственности;
											   // бит_ASuleymanov изменение кода. Конец. 05.02.2014}}
	Элементы.ПереченьОбъектовМетодНачисленияАмортизации.Видимость = ЭтоВыработкаОС ИЛИ ЭтоВыработкаНМА ИЛИ ЭтоАмортизацияНМА;
	Элементы.ПереченьОбъектовМодельУчета.Видимость = ЭтоОбесценениеОС 
	                                             ИЛИ ЭтоПереоценкаОС 
												 ИЛИ ЭтоПереоценкаНМА 
												 ИЛИ ЭтоОбесценениеНМА
												 // бит_ASuleymanov изменение кода. Начало. 05.02.2014{{
												 ИЛИ ЭтоПереводОСВСоставИнвестиционнойСобственности;
												 // бит_ASuleymanov изменение кода. Конец. 05.02.2014}}
	Элементы.ПереченьОбъектовНачислятьАмортизацию.Видимость = ЭтоАмортизацияОС 
	                                                      ИЛИ ЭтоВыработкаОС 
														  ИЛИ ЭтоВыработкаНМА 
														  ИЛИ ЭтоАмортизацияНМА;
														  
	//Элементы.ПереченьОбъектовСуммаНачисленнойАмортизации.Видимость = ЭтоПринятиеНМА;
	
	Элементы.ПереченьОбъектовВНА.Видимость = НЕ ЭтоКомплектацияОС;
	
	Элементы.ПереченьОбъектовДокументБУ.КнопкаВыбора = ЭтоКомплектацияОС;
	
	////БИТ Тртилек 16.08.2012
	//Если НЕ ЭтоКомплектацияОС Тогда
	//	//Убрать доступность кнопок изменения состава строк
	//	КнопкаДобавить = ЭлементыФормы.КоманднаяПанельПереченьОбъектов.Кнопки.Найти("Действие");
	//	КнопкаДобавить.Доступность = ЛОЖЬ;
	//	КнопкаКопировать = ЭлементыФормы.КоманднаяПанельПереченьОбъектов.Кнопки.Найти("Действие1");
	//	КнопкаКопировать.Доступность = ЛОЖЬ;
	//	КнопкаРедактировать = ЭлементыФормы.КоманднаяПанельПереченьОбъектов.Кнопки.Найти("Действие2");
	//	КнопкаРедактировать.Доступность = ЛОЖЬ;
	//	КнопкаУдалить = ЭлементыФормы.КоманднаяПанельПереченьОбъектов.Кнопки.Найти("Действие3");
	//	КнопкаУдалить.Доступность = ЛОЖЬ;
	//	
	//КонецЕсли;
	/////БИТ Тртилек
	
КонецПроцедуры // УстановитьВидимость()

// бит_DFedotov Функция формирует структуру данных для добавления их в таб.часть документа владельца
//
&НаСервере
Функция ПолучитьСтруктуруВыбора(ДействиеВыбора="Добавить", ИДСтроки=Неопределено)
		
	Если ИДСтроки = Неопределено Тогда
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Выполнять", Истина);
		
		РезТаблица = Объект.ПереченьОбъектов.Выгрузить(СтруктураОтбора);
	Иначе
		РезТаблица = Объект.ПереченьОбъектов.Выгрузить();
		РезТаблица.Очистить();
		
		ТекущаяСтрока = Объект.ПереченьОбъектов.НайтиПоИдентификатору(ИДСтроки);
		
		НоваяСтрока = РезТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,ТекущаяСтрока);
	КонецЕсли;
	
	СтруктураТаблиц = Новый Структура;
	
	УпаковатьТаблицу(РезТаблица,СтруктураТаблиц);
	
	РезСтруктура = Новый Структура;
	РезСтруктура.Вставить("Действие", ДействиеВыбора);
	РезСтруктура.Вставить("Данные"  , РезТаблица);
	РезСтруктура.Вставить("Данные"  , СтруктураТаблиц);
	// BIT Avseenkov 15052014 /Доработка функцонала по уастку основных средств {
    РезСтруктура.Вставить("Подбор07_0804",Подбор07_0804);
	//}
	
	Возврат РезСтруктура;
	
КонецФункции // ПолучитьСтруктуруВыбора()

// бит_DFedotov Процедура преобразует реквизит таблицу значений в массив структур.
//
// Параметры:
//  СтрТаблиц  - Структура
//  ИмяТаблицы - Строка
//
&НаСервере
Процедура УпаковатьТаблицу(Таблица, СтрТаблиц)
	
	МассивРеквизитов = Таблица.Колонки;
	ИменаРеквизитов  = Новый Структура;
	Для каждого Реквизит ИЗ МассивРеквизитов Цикл 		
		ИменаРеквизитов.Вставить(Реквизит.Имя, Реквизит.ТипЗначения);		
	КонецЦикла;
	СтрТаблиц.Вставить("ПереченьОбъектов"		 , бит_ОбщегоНазначенияКлиентСервер.УпаковатьДанныеФормыКоллекция(Таблица,ИменаРеквизитов));
	СтрТаблиц.Вставить("ПереченьОбъектов_Колонки", ИменаРеквизитов);
	
КонецПроцедуры // УпаковатьТаблицу()

//БИТ Тртилек Установить отбор для комплектации при выборе документа БУ
Процедура ПереченьОбъектовДокументБУНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	//Если Режим = Перечисления.бит_му_РежимыПодбораВНА.КомплектацияОС Тогда
	//	Массив=Новый Массив(); 
	//	Массив.Добавить(ТипЗнч(Документы.ПринятиеКУчетуОС.ПустаяСсылка())); 
	//	Массив.Добавить(ТипЗнч(Документы.МодернизацияОС.ПустаяСсылка()));
	//	Элемент.ОграничениеТипа=Новый ОписаниеТипов(Массив);
	//КонецЕсли;
	
КонецПроцедуры

//БИТ Тртилек 16.08.2012 заполнить сумму для комплектации
	
&НаСервере
Функция ПереченьОбъектовДокументБУПриИзмененииСервер(ЭлементЗначение)
	
	Если Объект.Режим = Перечисления.бит_му_РежимыПодбораВНА.бит_КомплектацияОС Тогда 
		Если ЗначениеЗаполнено(ЭлементЗначение) Тогда
			
			ЗапросДвижений = Новый Запрос;
			ЗапросДвижений.Текст = "ВЫБРАТЬ
			                       |	ХозрасчетныйДвиженияССубконто.Регистратор
			                       |ИЗ
			                       |	РегистрБухгалтерии.Хозрасчетный.ДвиженияССубконто(, , Регистратор = &Регистратор, , ) КАК ХозрасчетныйДвиженияССубконто
			                       |ГДЕ
			                       |	(ХозрасчетныйДвиженияССубконто.СубконтоДт1 В ИЕРАРХИИ (&ОбъектСтроительства)
			                       |			ИЛИ ХозрасчетныйДвиженияССубконто.СубконтоДт2 В ИЕРАРХИИ (&ОбъектСтроительства)
			                       |			ИЛИ ХозрасчетныйДвиженияССубконто.СубконтоДт3 В ИЕРАРХИИ (&ОбъектСтроительства)
			                       |			ИЛИ ХозрасчетныйДвиженияССубконто.СубконтоКт1 В ИЕРАРХИИ (&ОбъектСтроительства)
			                       |			ИЛИ ХозрасчетныйДвиженияССубконто.СубконтоКт2 В ИЕРАРХИИ (&ОбъектСтроительства)
			                       |			ИЛИ ХозрасчетныйДвиженияССубконто.СубконтоКт3 В ИЕРАРХИИ (&ОбъектСтроительства))";
			ЗапросДвижений.УстановитьПараметр("Регистратор", ЭлементЗначение);
			ЗапросДвижений.УстановитьПараметр("ОбъектСтроительства", Объект.ОбъектСтроительства);
			Если ЗапросДвижений.Выполнить().Пустой() Тогда
				
				Возврат Истина;
			КонецЕсли;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	ХозрасчетныйОбороты.СуммаОборотДт
			               |ИЗ
			               |	РегистрБухгалтерии.Хозрасчетный.Обороты(&ДатаНач, &ДатаКон, Регистратор, , , , , ) КАК ХозрасчетныйОбороты
			               |ГДЕ
			               |	ХозрасчетныйОбороты.Регистратор = &Регистратор";
			Запрос.УстановитьПараметр("ДатаНач", Объект.ДатаНачала);
			Запрос.УстановитьПараметр("ДатаКон", Объект.ДатаОкончания);
			Запрос.УстановитьПараметр("Регистратор", ЭлементЗначение);
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Выборка.Следующий() Тогда
				 Элементы.ПереченьОбъектов.ТекущаяСтрока.Сумма = Выборка.СуммаОборотДт;
				 Элементы.ПереченьОбъектов.ТекущаяСтрока.Выполнять = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура ПереченьОбъектовДокументБУПриИзменении(Элемент)
	
	ПустоеЗначение = ПереченьОбъектовДокументБУПриИзмененииСервер(Элемент.Значение);
	Если НЕ ПустоеЗначение Тогда
		Элемент.Значение = Неопределено;
		Сообщить("У выбранного документа не существует движений с объектом из подбора. Выберите другой.", 6);
	КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//ПриОткрытииНаСервере(Отказ);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
	Параметры.Свойство("Подбор07_0804", Подбор07_0804);
	Параметры.Свойство("Организация"	, Объект.Организация);
	Параметры.Свойство("ДатаНачала"		, Объект.ДатаНачала);
	Параметры.Свойство("ДатаОкончания"	, Объект.ДатаОкончания);
	Параметры.Свойство("Режим"			, Объект.Режим);
	Параметры.Свойство("МОЛ"			, Объект.МОЛ);
	Параметры.Свойство("Местонахождение", Объект.Местонахождение);
	Параметры.Свойство("ВидКласса"		, Объект.ВидКласса);
	Параметры.Свойство("МодельУчета"	, Объект.МодельУчета);
	Параметры.Свойство("ВидДвижения"	, Объект.ВидДвижения);
	Параметры.Свойство("ОбъектСтроительства", Объект.ОбъектСтроительства);
	Параметры.Свойство("Склад", Объект.Склад);
	Параметры.Свойство("МетодНачисленияАмортизации", Объект.МетодНачисленияАмортизации);
		Параметры.Свойство("ВалютаДокумента", Объект.ВалютаДокумента);
	
	Если НЕ ЗначениеЗаполнено(Объект.Режим) Тогда
		ТекстСообщения = НСтр("ru='Не указан режим заполнения ВНА'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения,,,Отказ);
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса = Обработки.бит_му_ПодборВНАПринятиеМодернизация.ПолучитьТекстЗапроса(Объект.Режим, Параметры, Подбор07_0804);
		
	АдресСКД = Обработки.бит_му_ПодборВНАПринятиеМодернизация.ИнициализироватьСКД(ТекстЗапроса, УникальныйИдентификатор);
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
	
	Объект.Компоновщик.Инициализировать(ИсточникНастроек);
	
	СКД = ПолучитьИзВременногоХранилища(АдресСКД);
	Объект.Компоновщик.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	ДобавитьПользовательскиеОтборы();
	
	ОбновитьПереченьОбъектов();
	
	УстановитьВидимость();
КонецПроцедуры
