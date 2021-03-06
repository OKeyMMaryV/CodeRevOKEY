#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры
 
#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс
 
Функция ПодготовитьТаблицуЗаполнения(ОбъектСтруктура, ЭтоДанные, СтрЗаполненияАналитик = Неопределено) Экспорт

	Если ЭтоДанные Тогда
		ДатаНачала = ОбъектСтруктура.Данные_ДатаНачала;
		ДатаОкончания = ОбъектСтруктура.Данные_ДатаОкончания;
		Источник = ОбъектСтруктура.НастройкаРаспределения.ИсточникДанные;
	Иначе	
		ДатаНачала = ОбъектСтруктура.База_ДатаНачала;
		ДатаОкончания = ОбъектСтруктура.База_ДатаОкончания;
		Источник = ОбъектСтруктура.НастройкаРаспределения.ИсточникБаза;
	КонецЕсли; 
	
	Если ОбъектСтруктура.НастройкаРаспределения.ВидНастройки = Перечисления.бит_ВидыНастроекРаспределенияБюджета.Простая Тогда
		
		ПараметрыСКД = НовыеПараметрыПолученияДанных();
		ПараметрыСКД.Вставить("НачалоПериода"	  , ДатаНачала);
		ПараметрыСКД.Вставить("КонецПериода"	  , КонецДня(ДатаОкончания));
		ПараметрыСКД.Вставить("ДатаДокумента"	  , ОбъектСтруктура.Дата);
		ПараметрыСКД.Вставить("ВалютаДокумента"   , ОбъектСтруктура.ВалютаДокумента);
		ПараметрыСКД.Вставить("КурсДокумента"	  , ОбъектСтруктура.КурсДокумента);
		ПараметрыСКД.Вставить("КратностьДокумента", ОбъектСтруктура.КратностьДокумента);
		ПараметрыСКД.Вставить("Регистратор", 		ОбъектСтруктура.Ссылка);
		ПараметрыСКД.Вставить("Периодичность", ПолучитьНомерПериодичности(ОбъектСтруктура.Сценарий.бит_Периодичность));
		
		ТаблицаРезультат = ТаблицаОборотыПоБюджету(ОбъектСтруктура.НастройкаРаспределения, ПараметрыСКД, ЭтоДанные, СтрЗаполненияАналитик);
		
	ИначеЕсли ОбъектСтруктура.НастройкаРаспределения.ВидНастройки = Перечисления.бит_ВидыНастроекРаспределенияБюджета.ИсточникиДанных Тогда
		
		ГраницаНач = ДатаНачала;
		ГраницаКон = Новый Граница(КонецДня(ДатаОкончания), ВидГраницы.Включая);
		
		Параметры = Новый Структура;		
		Параметры.Вставить("ДатаДокумента"	   , ОбъектСтруктура.Дата);
		Параметры.Вставить("ВалютаДокумента"   , ОбъектСтруктура.ВалютаДокумента);
		Параметры.Вставить("КурсДокумента"	   , ОбъектСтруктура.КурсДокумента);
		Параметры.Вставить("КратностьДокумента", ОбъектСтруктура.КратностьДокумента);
		Параметры.Вставить("Сценарий"          , ОбъектСтруктура.Сценарий);
		
		СтрПар = бит_МеханизмПолученияДанных.КонструкторПараметры_ПолучитьДанныеПоИсточнику();
		СтрПар.Параметры = Параметры;		
		
		ТаблицаРезультат = бит_МеханизмПолученияДанных.ПолучитьДанныеПоИсточнику(Источник
																		, ГраницаНач
																		, ГраницаКон
																		, СтрПар);
	            		
	КонецЕсли; 

	Возврат ТаблицаРезультат;
	
КонецФункции // ЗаполнитьДанные()

Функция НовыеПараметрыРаспределения() Экспорт

	ПараметрыРаспределения = Новый Структура("Данные, База, НастройкаРаспределения"); 	
	Возврат ПараметрыРаспределения;
	
КонецФункции
 
Процедура РаспределитьБюджет(ПараметрыРаспределения, АдресРезультата) Экспорт
	
	ТаблицаДанные  		   = ПараметрыРаспределения.Данные;
	ТаблицаБаза    		   = ПараметрыРаспределения.База;
	НастройкаРаспределения = ПараметрыРаспределения.НастройкаРаспределения;
	РезультатРаспределения = НоваяТаблицаРаспределения();	
	
	РеквизитыНастройки	 = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаРаспределения, 
								"СпособРаспределения, УсловияРаспределения, ПравилаЗаполнения");
	УсловияРаспределения = РеквизитыНастройки.УсловияРаспределения.Выгрузить();
	ПравилаЗаполнения    = РеквизитыНастройки.ПравилаЗаполнения.Выгрузить();
	
	ТекстЗапроса = ТекстЗапросаВременныеТаблицы(ПравилаЗаполнения)
				 + ТекстЗапросаСоединениеТаблиц(УсловияРаспределения, ПравилаЗаполнения);
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Данные", ТаблицаДанные);
	Запрос.УстановитьПараметр("База", 	ТаблицаБаза);
	
	Для каждого СтрокаТаблицы Из ПравилаЗаполнения Цикл
		Если СтрокаТаблицы.ПравилоЗаполнения = "УказаноЯвно" Тогда
			Запрос.УстановитьПараметр(СтрокаТаблицы.ИмяПоля, СтрокаТаблицы.Значение);
		КонецЕсли; 
	КонецЦикла; 
	
	Пакет = Запрос.ВыполнитьПакет();
	
	ВыборкаРазделитель = Пакет[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	ТаблицаСоединения  = НоваяТаблицаСоединенияТаблиц(Пакет[2]);
	
	СвязанныеКолонки	 = Новый Структура;
	СпособыРаспределения = Перечисления.бит_СпособыРаспределенияРесурсовБюджета; 
	
	Если РеквизитыНастройки.СпособРаспределения = СпособыРаспределения.Независимо Тогда
		СвязанныеКолонки.Вставить("Количество", "КоэфКоличество");
		СвязанныеКолонки.Вставить("Сумма", 		"КоэфСумма");
	ИначеЕсли РеквизитыНастройки.СпособРаспределения = СпособыРаспределения.ПоКоличеству Тогда
		СвязанныеКолонки.Вставить("Количество", "КоэфКоличество");
		СвязанныеКолонки.Вставить("Сумма", 		"КоэфКоличество");
	ИначеЕсли РеквизитыНастройки.СпособРаспределения = СпособыРаспределения.ПоСумме Тогда
		СвязанныеКолонки.Вставить("Количество", "КоэфСумма");
		СвязанныеКолонки.Вставить("Сумма", 		"КоэфСумма");
	КонецЕсли;

	Пока ВыборкаРазделитель.Следующий() Цикл
		ДетальныеЗаписи = ВыборкаРазделитель.Выбрать();
		РезультатСоединения = ТаблицаСоединения.СкопироватьКолонки();
		Пока ДетальныеЗаписи.Следующий() Цикл
			ЗаполнитьЗначенияСвойств(РезультатСоединения.Добавить(), ДетальныеЗаписи);
		КонецЦикла; 
		
		Для каждого ПараКолонок Из СвязанныеКолонки Цикл
			Точность 				  = ?(ПараКолонок.Ключ = "Сумма", 2, 3);
			РаспределяемаяСумма 	  = РезультатСоединения[0][ПараКолонок.Ключ];
			КоэффициентыРаспределения = РезультатСоединения.ВыгрузитьКолонку(ПараКолонок.Значение);
			
			// Коэф. распределения (сумма или количество) могут иметь разные знаки,
			// используемый функционал не поддерживает такого. 
			// Поэтому требуется получить коэффициенты по модулю.
			Индекс = КоэффициентыРаспределения.ВГраница();
			Пока Индекс >= 0 Цикл
				Элемент = КоэффициентыРаспределения[Индекс];
				КоэффициентыРаспределения[Индекс] = Макс(Элемент, - Элемент);
				Индекс = Индекс - 1;
			КонецЦикла; 
			
			РаспределенноеЗначение = ОбщегоНазначенияКлиентСервер.РаспределитьСуммуПропорциональноКоэффициентам(
											РаспределяемаяСумма, КоэффициентыРаспределения, Точность);
			Если РаспределенноеЗначение = Неопределено Тогда
				РезультатСоединения.ЗаполнитьЗначения(РаспределяемаяСумма, ПараКолонок.Ключ)
			Иначе
				РезультатСоединения.ЗагрузитьКолонку(РаспределенноеЗначение, ПараКолонок.Ключ);
			КонецЕсли; 
		КонецЦикла; 
		
		Для каждого СтрокаТаблицы Из РезультатСоединения Цикл
			ЗаполнитьЗначенияСвойств(РезультатРаспределения.Добавить(), СтрокаТаблицы);
		КонецЦикла; 

	КонецЦикла; 
	
	Если РезультатРаспределения.Количество() > 99999 Тогда
		Ошибка = СтрШаблон(НСтр("ru = 'Количество строк в результате распределения (%1) превышает возможности программы (%2).
									  |Рекомендуем использовать отборы в настройке распределения, данных и базе.'"),
										Формат(РезультатРаспределения.Количество(), "Л=ru_RU; ЧЦ=15; ЧДЦ=0"),
										Формат(99999, "Л=ru_RU; ЧЦ=15; ЧДЦ=0"));
		ВызватьИсключение Ошибка;								
	КонецЕсли;
	
	РезультатОбновления = Новый Структура(); 
	РезультатОбновления.Вставить("РезультатРаспределения", РезультатРаспределения);
	
	ПоместитьВоВременноеХранилище(РезультатОбновления, АдресРезультата);

КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

Функция ТаблицаОборотыПоБюджету(НастройкаРаспределения, ПараметрыПолученияДанных, ЭтоДанные = Истина, ДополнительныйОтбор = Неопределено)

	Если НЕ ЗначениеЗаполнено(НастройкаРаспределения) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнена настройка распределения.'");
	КонецЕсли;
	
	СписокРеквизитовНастройки = "ХранилищеНастроекДанные, ХранилищеНастроекБаза";
	РеквизитыНастройки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НастройкаРаспределения, СписокРеквизитовНастройки);

	Если ЭтоДанные Тогда
		НастройкиПользователя = РеквизитыНастройки.ХранилищеНастроекДанные.Получить();
	Иначе	
	    НастройкиПользователя = РеквизитыНастройки.ХранилищеНастроекБаза.Получить();
	КонецЕсли;   
	
	ПараметрыЗаполнены = Истина;
	ТаблицаРезультат = Новый ТаблицаЗначений;
	
	ПараметрыПолученияДанных.Вставить("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	СКД = Справочники.бит_НастройкиРаспределенияБюджета.ПолучитьМакет("СхемаКомпоновкиДанных");
	
	Если ДополнительныйОтбор <> Неопределено Тогда
		Для каждого ЭлементОтбора Из ДополнительныйОтбор Цикл
			Если ЭлементОтбора.Значение.Использовать Тогда
				Элемент = НастройкиПользователя.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				Элемент.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ЭлементОтбора.Ключ);
				Элемент.ПравоеЗначение = ЭлементОтбора.Значение.Значение;
				Элемент.Использование  = ЭлементОтбора.Значение.Использовать;
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли; 
	
	// Скопируем отборы пользователя в настройки по умолчанию СКД.
	Если НастройкиПользователя <> Неопределено Тогда
		ДобавитьЭлементыНастроекСКД(СКД, НастройкиПользователя);
	КонецЕсли;
	
	// Заполним параметры в СКД
	Для каждого Параметр Из СКД.Параметры Цикл
		Если НЕ ПараметрыПолученияДанных.Свойство(Параметр.Имя, Параметр.Значение) Тогда
			ВызватьИсключение СтрШаблон(НСтр("ru = 'Не задано значение параметра: %1'"), Параметр.Заголовок);
		КонецЕсли;
	КонецЦикла;
	
	// Инициализация настроек	
	АдресСкд 	 = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор);
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСкд);
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	ОтключенныеПоляГруппировок = Новый Массив;
	Если НастройкиПользователя <> Неопределено Тогда
		Для каждого ПолеВыбора Из НастройкиПользователя.Выбор.Элементы Цикл
			Если НЕ ПолеВыбора.Использование Тогда
				ОтключенныеПоляГруппировок.Добавить(ПолеВыбора.Поле);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ОтключенныеПоляГруппировок.Количество() > 0 Тогда
		Для каждого ПолеВыбора Из КомпоновщикНастроек.Настройки.Выбор.Элементы Цикл
			Если ОтключенныеПоляГруппировок.Найти(ПолеВыбора.Поле) <> Неопределено Тогда
				ПолеВыбора.Использование = Ложь;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	// Передаем в макет компоновки схему, настройки и данные расшифровки.
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, КомпоновщикНастроек.ПолучитьНастройки(), , ,
	Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	// Выполним компоновку с помощью процессора компоновки.
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	// Вывод таблицы.
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТаблицаРезультат); 	
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	// Группировка по указанным полям группировок.
	ТипРесурса = Тип("Число");
	СтрокаПолей = ""; СтрокаРесурсов = "";
	Для каждого КолонкаТаблицы Из ТаблицаРезультат.Колонки Цикл
		Если КолонкаТаблицы.ТипЗначения.СодержитТип(ТипРесурса) Тогда
			СтрокаРесурсов = ?(СтрокаРесурсов = "", КолонкаТаблицы.Имя, СтрокаРесурсов + ", " + КолонкаТаблицы.Имя);	
		Иначе	
			СтрокаПолей = ?(СтрокаПолей = "", КолонкаТаблицы.Имя, СтрокаПолей + ", " + КолонкаТаблицы.Имя);
		КонецЕсли;   	
	КонецЦикла;
	ТаблицаРезультат.Свернуть(СтрокаПолей, СтрокаРесурсов);
		
	Возврат ТаблицаРезультат;
	
КонецФункции

Процедура ДобавитьЭлементыОтбора(Элементы, КоллекцияЭлементов)

	Для каждого Элем Из КоллекцияЭлементов Цикл
		Если Тип(Элем) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			ЭлементОтбора = Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(ЭлементОтбора, Элем);
		Иначе	
			ЭлементОтбора = Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(ЭлементОтбора, Элем);
			ДобавитьЭлементыОтбора(ЭлементОтбора.Элементы, Элем.Элементы);
		КонецЕсли;
	КонецЦикла;	

КонецПроцедуры

Процедура ДобавитьЭлементыНастроекСКД(СКД, НастройкиПользователя) 

	СКД.НастройкиПоУмолчанию.Отбор.Элементы.Очистить();
	ДобавитьЭлементыОтбора(СКД.НастройкиПоУмолчанию.Отбор.Элементы, НастройкиПользователя.Отбор.Элементы);

КонецПроцедуры

Функция ПолучитьНомерПериодичности(Периодичность)

	Если Периодичность = Перечисления.бит_ПериодичностьПланирования.Неделя Тогда
	
		НомерПериодичности = 7;
		
	ИначеЕсли Периодичность = Перечисления.бит_ПериодичностьПланирования.Декада Тогда
	
		НомерПериодичности = 8;
		
	ИначеЕсли Периодичность = Перечисления.бит_ПериодичностьПланирования.Месяц Тогда
	
		НомерПериодичности = 9;
		
	ИначеЕсли Периодичность = Перечисления.бит_ПериодичностьПланирования.Квартал Тогда
	
		НомерПериодичности = 10;
		
	ИначеЕсли Периодичность = Перечисления.бит_ПериодичностьПланирования.Полугодие Тогда
	
		НомерПериодичности = 11;
		
	ИначеЕсли Периодичность = Перечисления.бит_ПериодичностьПланирования.Год Тогда
	
		НомерПериодичности = 12;
	Иначе	
		НомерПериодичности = 6;
	КонецЕсли; 
	
	Возврат НомерПериодичности;	

КонецФункции // СформироватьСоответствиеПериодичность()

Функция ТекстЗапросаВременныеТаблицы(ПравилаЗаполнения)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Данные.НомерСтроки КАК Разделитель,
	|	Данные.НомерСтроки КАК НомерСтроки,
	|	// Поля выбора
	|	Данные.Количество КАК Количество,
	|	Данные.Сумма КАК Сумма,
	|	Данные.СуммаРегл КАК СуммаРегл,
	|	Данные.СуммаУпр КАК СуммаУпр,
	|	Данные.СуммаСценарий КАК СуммаСценарий
	|ПОМЕСТИТЬ Данные
	|ИЗ
	|	&Данные КАК Данные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	База.НомерСтроки КАК НомерСтроки,
	|	База.Период КАК Период,
	|	База.ЦФО КАК ЦФО,
	|	База.СтатьяОборотов КАК СтатьяОборотов,
	|	База.Контрагент КАК Контрагент,
	|	База.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	База.Проект КАК Проект,
	|	База.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
	|	База.БанковскийСчет КАК БанковскийСчет,
	|	База.Аналитика_1 КАК Аналитика_1,
	|	База.Аналитика_2 КАК Аналитика_2,
	|	База.Аналитика_3 КАК Аналитика_3,
	|	База.Аналитика_4 КАК Аналитика_4,
	|	База.Аналитика_5 КАК Аналитика_5,
	|	База.Аналитика_6 КАК Аналитика_6,
	|	База.Аналитика_7 КАК Аналитика_7,
	|	База.Количество КАК Количество,
	|	База.Сумма КАК Сумма
	|ПОМЕСТИТЬ База
	|ИЗ
	|	&База КАК База";
	
	ШаблонПоля 		= "	Данные.%1 КАК %1," + Символы.ВК;
	ШаблонПараметра = "	&%1 КАК %1," + Символы.ВК;
	ПоляВыбора 		= "";
	Для каждого СтрокаТаблицы Из ПравилаЗаполнения Цикл
		Если СтрокаТаблицы.ПравилоЗаполнения = "УказаноЯвно" Тогда
			ПоляВыбора = ПоляВыбора + СтрШаблон(ШаблонПараметра, СтрокаТаблицы.ИмяПоля);
		Иначе	
			ПоляВыбора = ПоляВыбора + СтрШаблон(ШаблонПоля, СтрокаТаблицы.ИмяПоля);
		КонецЕсли; 
	КонецЦикла; 
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// Поля выбора", ПоляВыбора);
	
	Возврат ТекстЗапроса + ОбщегоНазначения.РазделительПакетаЗапросов();
	
КонецФункции

Функция ТекстЗапросаСоединениеТаблиц(УсловияРаспределения, ПравилаЗаполнения)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ 
	|	// Поля выбора
	|	Данные.НомерСтроки КАК ДанныеНомерСтроки,
	|	ISNULL(База.НомерСтроки, 0) КАК БазаНомерСтроки,
	|	Данные.Количество КАК Количество,
	|	Данные.Сумма КАК Сумма,
	|	Данные.СуммаРегл КАК СуммаРегл,
	|	Данные.СуммаУпр КАК СуммаУпр,
	|	Данные.СуммаСценарий КАК СуммаСценарий,
	|	ISNULL(База.Количество, 0) КАК КоэфКоличество,
	|	ISNULL(База.Сумма, 0) КАК КоэфСумма,
	|	Данные.Разделитель КАК Разделитель
	|ИЗ
	|	Данные КАК Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ База КАК База
	|		ПО (ИСТИНА)
	|		// Условия соединения
	|УПОРЯДОЧИТЬ ПО
	|	Разделитель
	|ИТОГИ ПО
	|	Разделитель";
	
	ПолеСтатьяОборотов = "";
	НайденнаяСтрока = ПравилаЗаполнения.Найти("СтатьяОборотов", "ИмяПоля");
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат "";	
	КонецЕсли; 
	
	Если СтрНачинаетсяС(НайденнаяСтрока.ПравилоЗаполнения, "Данные") Тогда
		ПутьКДаннымСтатьяОборотов = СтрЗаменить(НайденнаяСтрока.ПравилоЗаполнения, 
										"Данные", "Данные.");
	ИначеЕсли СтрНачинаетсяС(НайденнаяСтрока.ПравилоЗаполнения, "База") Тогда
		ПутьКДаннымСтатьяОборотов = СтрЗаменить(НайденнаяСтрока.ПравилоЗаполнения, 
										"База", "База.");
	Иначе	
		ПутьКДаннымСтатьяОборотов = "Данные.СтатьяОборотов";
	КонецЕсли; 
	
	ШаблонФиксПолей   = "	%1 КАК %2," + Символы.ВК;
	ФиксированныеПоля = "Период, ЦФО, СтатьяОборотов";

	ШаблонПоля = 
	"	ВЫБОР КОГДА ISNULL(%1.Учет_%2, ЛОЖЬ) ТОГДА 
	|		%3
	|	ИНАЧЕ
	|		НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК %4," + Символы.ВК;
	
	ПоляВыбора = "";
	Для каждого СтрокаТаблицы Из ПравилаЗаполнения Цикл
		
		Если СтрНачинаетсяС(СтрокаТаблицы.ПравилоЗаполнения, "Данные") Тогда
			ПутьКДанным = СтрЗаменить(СтрокаТаблицы.ПравилоЗаполнения, 
							"Данные", "Данные.");
		ИначеЕсли СтрНачинаетсяС(СтрокаТаблицы.ПравилоЗаполнения, "База") Тогда
			ПутьКДанным = СтрЗаменить(СтрокаТаблицы.ПравилоЗаполнения, 
							"База", "База.");
		Иначе	
			ПутьКДанным = "Данные." + СтрокаТаблицы.ИмяПоля;
		КонецЕсли; 
		
		Если СтрНайти(ФиксированныеПоля, СтрокаТаблицы.ИмяПоля) <> 0 Тогда
			ПоляВыбора = ПоляВыбора + СтрШаблон(ШаблонФиксПолей, ПутьКДанным, СтрокаТаблицы.ИмяПоля);
		Иначе	
			ПоляВыбора = ПоляВыбора + СтрШаблон(ШаблонПоля, ПутьКДаннымСтатьяОборотов, СтрокаТаблицы.ИмяПоля, 
							ПутьКДанным, СтрокаТаблицы.ИмяПоля);
		КонецЕсли; 
	КонецЦикла; 
	
	ШаблонУсловия = "	И Данные.%1 = База.%2" + Символы.ВК;
	УсловияСоединения = "";
	Для каждого СтрокаТаблицы Из УсловияРаспределения Цикл
		УсловияСоединения = УсловияСоединения 
			+ СтрШаблон(ШаблонУсловия, СтрокаТаблицы.ПолеДанных, СтрокаТаблицы.ПолеБазы);
	КонецЦикла; 
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// Поля выбора", ПоляВыбора);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "// Условия соединения", УсловияСоединения);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция НоваяТаблицаРаспределения()

	ТаблицаРаспределения = Новый ТаблицаЗначений();	
	Реквизиты = Метаданные.Документы.бит_РаспределениеБюджета.ТабличныеЧасти.РезультатРаспределения.Реквизиты;
	Для каждого Реквизит Из Реквизиты Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаРаспределения.Колонки.Добавить(), Реквизит);
	КонецЦикла; 
	
	Возврат ТаблицаРаспределения;
	
КонецФункции
 
Функция НоваяТаблицаСоединенияТаблиц(РезультатЗапроса)

	ТаблицаСоединения = Новый ТаблицаЗначений(); 
	Для каждого Колонка Из РезультатЗапроса.Колонки Цикл
		ТаблицаСоединения.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
	КонецЦикла; 

	Возврат ТаблицаСоединения;
	
КонецФункции

Функция НовыеПараметрыПолученияДанных()
	
	НовыеПараметры = Новый Структура;
	НовыеПараметры.Вставить("НачалоПериода", 	  '0001-01-01');
	НовыеПараметры.Вставить("КонецПериода", 	  '0001-01-01');
	НовыеПараметры.Вставить("ДатаДокумента", 	  '0001-01-01');
	НовыеПараметры.Вставить("ВалютаДокумента", 	  Справочники.Валюты.ПустаяСсылка());
	НовыеПараметры.Вставить("КурсДокумента", 	  1);
	НовыеПараметры.Вставить("КратностьДокумента", 1);
	НовыеПараметры.Вставить("Регистратор", 		  Неопределено);
	НовыеПараметры.Вставить("Периодичность",	  0 );
	
	Возврат НовыеПараметры;

КонецФункции
 
#КонецОбласти

#КонецЕсли
