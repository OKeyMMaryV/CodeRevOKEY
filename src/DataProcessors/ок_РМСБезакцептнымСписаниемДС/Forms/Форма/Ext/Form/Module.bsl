
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	 
	
	ОбновитьНастройкиНаСервере();
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МакетОтборов = ОбработкаОбъект.ПолучитьМакет("СКД_ДанныеДляЗаполнения");
	
	НастройкиОтборов = МакетОтборов.НастройкиПоУмолчанию;
  
    АдресСхемы = ПоместитьВоВременноеХранилище(МакетОтборов, УникальныйИдентификатор);
    Объект.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	Объект.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтборов);
	
	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(НастройкиОтборов);
	Объект.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроекКомпоновкиДанных.ПользовательскиеНастройки);
	
	УстановитьНастройкиПоУмолчанию();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ДанныеДляОбработкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ИмяПоля = СтрЗаменить(НРег(Поле.Имя), НРег("ДанныеДляОбработки"),"");
	
	Если ИмяПоля = НРег("Выбран")
		ИЛИ ИмяПоля = НРег("комментарийпоисполнительномулисту")
		ИЛИ ИмяПоля = НРег("отработанобухгалтером")
		ИЛИ ИмяПоля = НРег("ДокументРасчетов")
		ИЛИ ИмяПоля = НРег("ФВБ") Тогда
	
		Возврат;
	
	КонецЕсли; 
	
	Попытка
		
		ДанныеСтроки = Объект.ДанныеДляОбработки.НайтиПоИдентификатору(ВыбраннаяСтрока);
		ПоказатьЗначение(, ДанныеСтроки[ИмяПоля]);
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляОбработкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеДляОбработкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.ДанныеДляОбработки.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные.СтрокаИзменена = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.ДанныеДляОбработки.Количество() > 0 Тогда
	
		Режим = РежимДиалогаВопрос.ДаНет;
		Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса_Заполнить", ЭтаФорма, Параметры);
		ПоказатьВопрос(Оповещение, "Табличная части будут перезаполнены. Продолжить выполнение операции?", Режим, 0);
		
	Иначе
		
		ЗаполнитьНаСервере();
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса_Заполнить(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;

	ЗаполнитьНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	
	ОчиститьСообщения();
	Сообщить("(" + ТекущаяДата() + ") Обработка запущена.", СтатусСообщения.Внимание);
	СформироватьНаСервере();
	Сообщить("(" + ТекущаяДата() + ") Обработка завершена.", СтатусСообщения.Внимание);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиПоУмолчанию()
	
	// Получим настройку по - умолчанию и последнюю использованную.
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТипНастройки"			  , Перечисления.бит_ТипыСохраненныхНастроек.Обработки);
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-02-20 (#3670)
	//СтруктураПараметров.Вставить("НастраиваемыйОбъект"    , "Обработка.ок_РабочееМестоОбработкиДокументовСсРС");
	СтруктураПараметров.Вставить("НастраиваемыйОбъект"    , "Обработка.ок_РМСБезакцептнымСписаниемДС");
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-02-20 (#3670)
	СтруктураПараметров.Вставить("ИспользоватьПриОткрытии", Истина);
	СохрНастройка = Справочники.бит_СохраненныеНастройки.ПолучитьНастройкуПоУмолчанию(СтруктураПараметров);
	
	Если ЗначениеЗаполнено(СохрНастройка) Тогда
		
		ПрименитьНастройкиЗавершениеНаСервере(СохрНастройка);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)

	ПараметрыФормы     = Новый Структура;
	ПараметрыФормы.Вставить("СтруктураНастройки" , ПолучитьНастройкиКД(Объект.КомпоновщикНастроек));
	ПараметрыФормы.Вставить("ТипНастройки"		 , ПредопределенноеЗначение("Перечисление.бит_ТипыСохраненныхНастроек.Обработки"));
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-02-20 (#3670)
	//ПараметрыФормы.Вставить("НастраиваемыйОбъект", "Обработка.ок_РабочееМестоОбработкиДокументовСсРС");
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", "Обработка.ок_РМСБезакцептнымСписаниемДС");
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-02-20 (#3670)
	
	ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаСохранения",ПараметрыФормы,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);	
	
	ОбновитьНастройкиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьНастройки(Команда)

	ПараметрыФормы     = Новый Структура;
	ПараметрыФормы.Вставить("ТипНастройки"		 , ПредопределенноеЗначение("Перечисление.бит_ТипыСохраненныхНастроек.Обработки"));
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-02-20 (#3670)
	//ПараметрыФормы.Вставить("НастраиваемыйОбъект", "Обработка.ок_РабочееМестоОбработкиДокументовСсРС");
	ПараметрыФормы.Вставить("НастраиваемыйОбъект", "Обработка.ок_РМСБезакцептнымСписаниемДС");
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-02-20 (#3670)
    
    Оповещение = Новый ОписаниеОповещения("ПрименитьНастройкиЗавершение", ЭтаФорма);
    ОткрытьФорму("ХранилищеНастроек.бит_ХранилищеНастроек.ФормаЗагрузки",ПараметрыФормы,ЭтаФорма,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
КонецПроцедуры

&НаКлиенте 
Процедура ПрименитьНастройкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда        
		
		ПрименитьНастройкиЗавершениеНаСервере(Результат);
		
	КонецЕсли;	
	
	ОбновитьНастройкиНаСервере();
	
КонецПроцедуры

&НаСервере 
Процедура ПрименитьНастройкиЗавершениеНаСервере(Результат) Экспорт
	
	СтруктураНастроек = Результат.ХранилищеНастроек.Получить();
	
	Если ТипЗнч(СтруктураНастроек) = Тип("НастройкиКомпоновкиДанных") Тогда
		
		КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
		КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(СтруктураНастроек);
		Объект.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроекКомпоновкиДанных.ПользовательскиеНастройки);
				
	КонецЕсли;	
	
КонецПроцедуры

&НаСервереБезКонтекста 
Процедура СкопироватьОтборКомпоновщика(Источник, Приемник)
	
	Для Каждого ЭлементОтбора Из Источник Цикл
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
            ЗаполнитьЗначенияСвойств(Приемник.Добавить(Тип("ЭлементОтбораКомпоновкиДанных")), ЭлементОтбора);        
        Иначе
            НоваяГруппа = Приемник.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
            ЗаполнитьЗначенияСвойств(НоваяГруппа, ЭлементОтбора);
            СкопироватьОтборКомпоновщика(ЭлементОтбора.Элементы, НоваяГруппа.Элементы);
		КонецЕсли;
		
    КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиПоУмолчанию(Команда)
	
	НастройкиПоУмолчаниюНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НастройкиПоУмолчаниюНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	МакетОтборов = ОбработкаОбъект.ПолучитьМакет("СКД_ДанныеДляЗаполнения");
													 
	НастройкиОтборов = МакетОтборов.НастройкиПоУмолчанию;
  
    АдресСхемы = ПоместитьВоВременноеХранилище(МакетОтборов, УникальныйИдентификатор);
    Объект.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	Объект.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтборов);
	      
	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекКомпоновкиДанных.ЗагрузитьНастройки(НастройкиОтборов);
	Объект.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроекКомпоновкиДанных.ПользовательскиеНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьНастройкиНаСервере()
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	СхемаКомпоновкиДанных = ОбработкаОбъект.ПолучитьМакет("СКД_ДанныеДляЗаполнения");
	
	Настройки = Объект.КомпоновщикНастроек.ПолучитьНастройки(); 
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(
		СхемаКомпоновкиДанных,
		Настройки,,,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));	
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Результат = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ОбработатьРезультат(Результат);
	
	ОбновитьНастройкиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультат(Результат);

	Объект.ДанныеДляОбработки.Загрузить(Результат);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	СтруктураПараметровЗаполнения = Новый Структура();
	
	ОбработатьДанныеДляОбработки(Объект.ДанныеДляОбработки, СтруктураПараметровЗаполнения);
	
	ОбновитьНастройкиНаСервере();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбработатьДанныеДляОбработки(ДанныеДляОбработки, СтруктураПараметровЗаполнения)
	
	Для каждого ТекущиеДанныеДляОбработки Из ДанныеДляОбработки Цикл
		
		Если НЕ ТекущиеДанныеДляОбработки.СтрокаИзменена Тогда
			Продолжить;
		КонецЕсли;
		
		НачатьТранзакцию();
		
		ПВХ_NЗаявки = ПланыВидовХарактеристик.бит_ВидыДополнительныхАналитик.НайтиПоКоду("NЗаявки");
		Если ПВХ_NЗаявки <> Неопределено Тогда
			ЗаписьДопАналитик = РегистрыСведений.бит_ДополнительныеАналитики.СоздатьМенеджерЗаписи();
			ЗаписьДопАналитик.Объект			= ТекущиеДанныеДляОбработки.Документ;
			ЗаписьДопАналитик.Аналитика 		= ПВХ_NЗаявки;
			ЗаписьДопАналитик.ЗначениеАналитики = ТекущиеДанныеДляОбработки.ФВБ;
			ЗаписьДопАналитик.Записать();
		КонецЕсли; 
		
		ЗаписьДопАналитик = РегистрыСведений.бит_ДополнительныеАналитики.СоздатьМенеджерЗаписи();
		ЗаписьДопАналитик.Объект			= ТекущиеДанныеДляОбработки.Документ;
		ЗаписьДопАналитик.Аналитика 		= ПредопределенноеЗначение("ПланВидовХарактеристик.бит_ВидыДополнительныхАналитик.ок_ОтработаноБухгалтером");
		ЗаписьДопАналитик.ЗначениеАналитики = ТекущиеДанныеДляОбработки.ОтработаноБухгалтером;
		ЗаписьДопАналитик.Записать();
		
		ЗаписьДопАналитик = РегистрыСведений.бит_ДополнительныеАналитики.СоздатьМенеджерЗаписи();
		ЗаписьДопАналитик.Объект			= ТекущиеДанныеДляОбработки.Документ;
		ЗаписьДопАналитик.Аналитика 		= ПредопределенноеЗначение("ПланВидовХарактеристик.бит_ВидыДополнительныхАналитик.ок_КомментарийПоИсполнительномуЛисту");
		ЗаписьДопАналитик.ЗначениеАналитики = ТекущиеДанныеДляОбработки.КомментарийПоИсполнительномуЛисту;
		ЗаписьДопАналитик.Записать();
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-18 (#3816)
			//|	бит_ОборотыПоБюджетам.ЦФО КАК бит_ЦФО,
			//|	бит_ОборотыПоБюджетам.СтатьяОборотов КАК ок_СтатьяОборотовБДР,
			//|	бит_ОборотыПоБюджетам.Проект КАК бит_Проект,
			//|	бит_ОборотыПоБюджетам.НоменклатурнаяГруппа КАК бит_НоменклатурнаяГруппа,
			//|	бит_ОборотыПоБюджетам.БанковскийСчет КАК БанковскийСчет,
			//|	бит_ОборотыПоБюджетам.Аналитика_1 КАК бит_Аналитика_1,
			//|	бит_ОборотыПоБюджетам.Аналитика_2 КАК бит_Аналитика_2,
			//|	бит_ОборотыПоБюджетам.Аналитика_3 КАК бит_Аналитика_3,
			//|	бит_ОборотыПоБюджетам.Аналитика_4 КАК бит_Аналитика_4,
			//|	бит_ОборотыПоБюджетам.Аналитика_5 КАК бит_Аналитика_5,
			//|	бит_ОборотыПоБюджетам.Аналитика_6 КАК бит_Аналитика_6,
			//|	бит_ОборотыПоБюджетам.Аналитика_7 КАК бит_Аналитика_7,
			//|	бит_ОборотыПоБюджетам.СуммаСНДСРегл КАК СуммаПлатежа,
			//|	бит_ОборотыПоБюджетам.СуммаСНДСРегл - бит_ОборотыПоБюджетам.СуммаРегл КАК СуммаНДС,
			//|	бит_ОборотыПоБюджетам.Сумма КАК Сумма,
			//|	бит_ОборотыПоБюджетам.СуммаРегл КАК СуммаРегл,
			//|	бит_ОборотыПоБюджетам.СуммаУпр КАК СуммаУпр,
			//|	бит_ОборотыПоБюджетам.СуммаСценарий КАК СуммаСценарий,
			//|	бит_ОборотыПоБюджетам.СуммаСНДС КАК СуммаСНДС,
			//|	бит_ОборотыПоБюджетам.СуммаСНДСУпр КАК СуммаСНДСУпр,
			//|	бит_ОборотыПоБюджетам.СуммаСНДССценарий КАК СуммаСНДССценарий,
			//|	бит_ОборотыПоБюджетам.НомерСтроки КАК НомерСтроки
			|	бит_ОборотыПоБюджетам.ЦФО КАК ЦФО,
			|	бит_ОборотыПоБюджетам.СтатьяОборотов КАК ок_СтатьяОборотовБДР,
			|	бит_ОборотыПоБюджетам.Проект КАК Проект,
			|	бит_ОборотыПоБюджетам.НоменклатурнаяГруппа КАК НоменклатурнаяГруппа,
			|	бит_ОборотыПоБюджетам.БанковскийСчет КАК БанковскийСчет,
			|	бит_ОборотыПоБюджетам.Аналитика_1 КАК Аналитика_1,
			|	бит_ОборотыПоБюджетам.Аналитика_2 КАК Аналитика_2,
			|	бит_ОборотыПоБюджетам.Аналитика_3 КАК Аналитика_3,
			|	бит_ОборотыПоБюджетам.Аналитика_4 КАК Аналитика_4,
			|	бит_ОборотыПоБюджетам.Аналитика_5 КАК Аналитика_5,
			|	бит_ОборотыПоБюджетам.Аналитика_6 КАК Аналитика_6,
			|	бит_ОборотыПоБюджетам.Аналитика_7 КАК Аналитика_7,
			|	бит_ОборотыПоБюджетам.Регистратор,
			|	СУММА(бит_ОборотыПоБюджетам.СуммаСНДСРегл) КАК СуммаПлатежа,
			|	СУММА(бит_ОборотыПоБюджетам.СуммаСНДСРегл - бит_ОборотыПоБюджетам.СуммаРегл) КАК СуммаНДС,
			|	СУММА(бит_ОборотыПоБюджетам.Сумма) КАК Сумма,
			|	СУММА(бит_ОборотыПоБюджетам.СуммаРегл) КАК СуммаРегл,
			|	СУММА(бит_ОборотыПоБюджетам.СуммаУпр) КАК СуммаУпр,
			|	СУММА(бит_ОборотыПоБюджетам.СуммаСценарий) КАК СуммаСценарий,
			|	СУММА(бит_ОборотыПоБюджетам.СуммаСНДС) КАК СуммаСНДС,
			|	СУММА(бит_ОборотыПоБюджетам.СуммаСНДСУпр) КАК СуммаСНДСУпр,
			|	СУММА(бит_ОборотыПоБюджетам.СуммаСНДССценарий) КАК СуммаСНДССценарий
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-18 (#3816)
			|ИЗ
			|	РегистрНакопления.бит_ОборотыПоБюджетам КАК бит_ОборотыПоБюджетам
			|ГДЕ
			|	бит_ОборотыПоБюджетам.Регистратор = &Регистратор
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-18 (#3816)
			|СГРУППИРОВАТЬ ПО
			|	бит_ОборотыПоБюджетам.Регистратор,
			|	бит_ОборотыПоБюджетам.ЦФО,
			|	бит_ОборотыПоБюджетам.Проект,
			|	бит_ОборотыПоБюджетам.СтатьяОборотов,
			|	бит_ОборотыПоБюджетам.НоменклатурнаяГруппа,
			|	бит_ОборотыПоБюджетам.БанковскийСчет,
			|	бит_ОборотыПоБюджетам.Аналитика_1,
			|	бит_ОборотыПоБюджетам.Аналитика_2,
			|	бит_ОборотыПоБюджетам.Аналитика_3,
			|	бит_ОборотыПоБюджетам.Аналитика_4,
			|	бит_ОборотыПоБюджетам.Аналитика_5,
			|	бит_ОборотыПоБюджетам.Аналитика_6,
			|	бит_ОборотыПоБюджетам.Аналитика_7
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-18 (#3816)
			|ИТОГИ
			|	СУММА(СуммаПлатежа),
			|	СУММА(СуммаНДС)
			|ПО
			|	бит_ОборотыПоБюджетам.Регистратор";
		
		Запрос.УстановитьПараметр("Регистратор", ТекущиеДанныеДляОбработки.ДокументРасчетов);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			ДокументОбъект = ТекущиеДанныеДляОбработки.Документ.ПолучитьОбъект();
			
			ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
			Если ДокументОбъект.ВалютаДокумента <> ВалютаРегламентированногоУчета Тогда
				СтруктураКурса = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ДокументОбъект.ВалютаДокумента, ДокументОбъект.Дата);
				КурсДокумента      = СтруктураКурса.Курс;
				КратностьДокумента = СтруктураКурса.Кратность;
			Иначе
				КурсДокумента      = 1;
				КратностьДокумента = 1;
			КонецЕсли;
			
			ПерваяСтрока = Истина;
			СтруктураПервойСтроки = Новый Структура();
			
			Если ДокументОбъект.РасшифровкаПлатежа.Количество() > 0 
				И ПерваяСтрока Тогда
			
				СтруктураПервойСтроки.Вставить("ДоговорКонтрагента", 			 ДокументОбъект.РасшифровкаПлатежа[0].ДоговорКонтрагента);
				СтруктураПервойСтроки.Вставить("СпособПогашенияЗадолженности",	 ДокументОбъект.РасшифровкаПлатежа[0].СпособПогашенияЗадолженности);
				СтруктураПервойСтроки.Вставить("Сделка", 						 ДокументОбъект.РасшифровкаПлатежа[0].Сделка);
				СтруктураПервойСтроки.Вставить("СтатьяДвиженияДенежныхСредств",  ДокументОбъект.РасшифровкаПлатежа[0].СтатьяДвиженияДенежныхСредств);
				СтруктураПервойСтроки.Вставить("СчетУчетаРасчетовСКонтрагентом", ДокументОбъект.РасшифровкаПлатежа[0].СчетУчетаРасчетовСКонтрагентом);
				СтруктураПервойСтроки.Вставить("СтавкаНДС", 					 ДокументОбъект.РасшифровкаПлатежа[0].СтавкаНДС);
				
				СтруктураПервойСтроки.Вставить("КурсВзаиморасчетов",			 ДокументОбъект.РасшифровкаПлатежа[0].КурсВзаиморасчетов);
				СтруктураПервойСтроки.Вставить("КратностьВзаиморасчетов",		 ДокументОбъект.РасшифровкаПлатежа[0].КратностьВзаиморасчетов);
				СтруктураПервойСтроки.Вставить("СчетУчетаРасчетовПоАвансам", 	 ДокументОбъект.РасшифровкаПлатежа[0].СчетУчетаРасчетовПоАвансам);
				
				ПерваяСтрока = Ложь;
				
			КонецЕсли; 
			
			ДокументОбъект.РасшифровкаПлатежа.Очистить();
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-18 (#3816)
			ДокументОбъект.бит_РаспределениеБюджета.Очистить();
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-18 (#3816)
			
			ВыборкаРегистратор = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаРегистратор.Следующий() Цикл
				
				пСуммаПлатежа = ВыборкаРегистратор.СуммаПлатежа;
				пСуммаНДС = ВыборкаРегистратор.СуммаНДС;
				
				Если пСуммаПлатежа = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				КоэффициентРаспределения = ДокументОбъект.СуммаДокумента / пСуммаПлатежа;
				
				ВыборкаДетальныеЗаписи = ВыборкаРегистратор.Выбрать();
				Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
					
					НоваяСтрока = ДокументОбъект.РасшифровкаПлатежа.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
					
					Если ПерваяСтрока Тогда
					
						СтруктураПервойСтроки.Вставить("ДоговорКонтрагента", 			 ДокументОбъект.РасшифровкаПлатежа[0].ДоговорКонтрагента);
						СтруктураПервойСтроки.Вставить("СпособПогашенияЗадолженности",	 ДокументОбъект.РасшифровкаПлатежа[0].СпособПогашенияЗадолженности);
						СтруктураПервойСтроки.Вставить("Сделка", 						 ДокументОбъект.РасшифровкаПлатежа[0].Сделка);
						СтруктураПервойСтроки.Вставить("СтатьяДвиженияДенежныхСредств",  ДокументОбъект.РасшифровкаПлатежа[0].СтатьяДвиженияДенежныхСредств);
						СтруктураПервойСтроки.Вставить("СчетУчетаРасчетовСКонтрагентом", ДокументОбъект.РасшифровкаПлатежа[0].СчетУчетаРасчетовСКонтрагентом);
						СтруктураПервойСтроки.Вставить("СтавкаНДС", 					 ДокументОбъект.РасшифровкаПлатежа[0].СтавкаНДС);
						
						СтруктураПервойСтроки.Вставить("КурсВзаиморасчетов",			 ДокументОбъект.РасшифровкаПлатежа[0].КурсВзаиморасчетов);
						СтруктураПервойСтроки.Вставить("КратностьВзаиморасчетов",		 ДокументОбъект.РасшифровкаПлатежа[0].КратностьВзаиморасчетов);
						СтруктураПервойСтроки.Вставить("СчетУчетаРасчетовПоАвансам", 	 ДокументОбъект.РасшифровкаПлатежа[0].СчетУчетаРасчетовПоАвансам);
						
						ПерваяСтрока = Ложь;
						
					КонецЕсли;
					
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПервойСтроки);
					
					//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-18 (#3816)
					//Если ЗначениеЗаполнено(НоваяСтрока.СтатьяДвиженияДенежныхСредств) Тогда
					//	МассивСтатейОборотов = бит_Бюджетирование.СвязанныеСтатьиОборотовИСтатьиРегл(НоваяСтрока.СтатьяДвиженияДенежныхСредств);
					//	Если МассивСтатейОборотов.Количество() Тогда
					//		НоваяСтрока.бит_СтатьяОборотов = МассивСтатейОборотов[0];
					//	КонецЕсли;			
					//КонецЕсли;
					//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-18 (#3816)
						
					//НоваяСтрока.бит_СтатьяОборотов = РегистрыСведений.бит_СоответствияАналитик.ПолучитьПравуюАналитику(ПредопределенноеЗначение("Справочник.бит_ВидыСоответствийАналитик.СтатьиОборотовБДР_СтатьиОборотовБДДС"), НоваяСтрока.ок_СтатьяОборотовБДР);
					НоваяСтрока.СуммаПлатежа = Окр(НоваяСтрока.СуммаПлатежа * КоэффициентРаспределения, 2);
					НоваяСтрока.СуммаНДС = Окр(НоваяСтрока.СуммаНДС * КоэффициентРаспределения, 2);
					
					НоваяСтрока.СуммаВзаиморасчетов = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
															НоваяСтрока.СуммаПлатежа,
															ДокументОбъект.ВалютаДокумента, НоваяСтрока.ДоговорКонтрагента.ВалютаВзаиморасчетов,
															КурсДокумента, НоваяСтрока.КурсВзаиморасчетов,
															КратностьДокумента, НоваяСтрока.КратностьВзаиморасчетов);
															
					//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-18 (#3816)
					НоваяСтрока.бит_КлючСтроки = Строка(Новый УникальныйИдентификатор());
					
					НоваяСтрока_РаспределениеБюджета = ДокументОбъект.бит_РаспределениеБюджета.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока_РаспределениеБюджета, ВыборкаДетальныеЗаписи);
					ЗаполнитьЗначенияСвойств(НоваяСтрока_РаспределениеБюджета, НоваяСтрока);
					
					Если ЗначениеЗаполнено(НоваяСтрока.СтатьяДвиженияДенежныхСредств) Тогда
						МассивСтатейОборотов = бит_Бюджетирование.СвязанныеСтатьиОборотовИСтатьиРегл(НоваяСтрока.СтатьяДвиженияДенежныхСредств);
						Если МассивСтатейОборотов.Количество() Тогда
							НоваяСтрока_РаспределениеБюджета.СтатьяОборотов = МассивСтатейОборотов[0];
						КонецЕсли;			
					КонецЕсли;
					//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-18 (#3816)
				
				КонецЦикла;
				
				Итог_СуммаПлатежа = ДокументОбъект.РасшифровкаПлатежа.Итог("СуммаПлатежа");
				
				Если Итог_СуммаПлатежа <> ДокументОбъект.СуммаДокумента Тогда
				
					ПоследняяСтрока 					= ДокументОбъект.РасшифровкаПлатежа[(ДокументОбъект.РасшифровкаПлатежа.Количество() - 1)];
					ПоследняяСтрока.СуммаПлатежа 		= ПоследняяСтрока.СуммаПлатежа + (ДокументОбъект.СуммаДокумента - Итог_СуммаПлатежа);
					
					ЗначениеСтавкиНДС 					= УчетНДСВызовСервераПовтИсп.ПолучитьСтавкуНДС(ПоследняяСтрока.СтавкаНДС);
					ПоследняяСтрока.СуммаНДС 			= ПоследняяСтрока.СуммаПлатежа * ЗначениеСтавкиНДС / (100 + ЗначениеСтавкиНДС);
					ПоследняяСтрока.СуммаВзаиморасчетов = РаботаСКурсамиВалютБПКлиентСервер.ПересчитатьИзВалютыВВалюту(
															НоваяСтрока.СуммаПлатежа,
															ДокументОбъект.ВалютаДокумента, НоваяСтрока.ДоговорКонтрагента.ВалютаВзаиморасчетов,
															КурсДокумента, НоваяСтрока.КурсВзаиморасчетов,
															КратностьДокумента, НоваяСтрока.КратностьВзаиморасчетов);
															
					//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-18 (#3816)
					НайденныеСтроки = ДокументОбъект.бит_РаспределениеБюджета.НайтиСтроки(Новый Структура("бит_КлючСтроки", ПоследняяСтрока.бит_КлючСтроки));
					Если НайденныеСтроки.Количество() > 0 Тогда
						ЗаполнитьЗначенияСвойств(НайденныеСтроки[0], ПоследняяСтрока);
					КонецЕсли; 
					//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-18 (#3816)
					
				КонецЕсли; 
				
			КонецЦикла;
			
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-18 (#3816)
			//ДокументОбъект.РасшифровкаПлатежа.Свернуть("ДоговорКонтрагента,
			//											|СпособПогашенияЗадолженности,
			//											|Сделка,
			//											|КурсВзаиморасчетов,
			//											|СтавкаНДС,
			//											|СтатьяДвиженияДенежныхСредств,
			//											|СчетУчетаРасчетовСКонтрагентом,
			//											|СчетУчетаРасчетовПоАвансам,
			//											|КратностьВзаиморасчетов,
			//											|РаспределятьРасходыУСН,
			//											|СчетНаОплату,
			//											|бит_ЦФО,
			//											|бит_СтатьяОборотов,
			//											|бит_Проект,
			//											|бит_НоменклатурнаяГруппа,
			//											|бит_Аналитика_1,
			//											|бит_Аналитика_2,
			//											|бит_Аналитика_3,
			//											|бит_Аналитика_4,
			//											|бит_Аналитика_5,
			//											|бит_Аналитика_6,
			//											|бит_Аналитика_7,
			//											|бит_ПлатежнаяПозиция,
			//											|ВидПлатежаПоКредитамЗаймам,
			//											|ПорядокОтраженияДохода,
			//											|ок_СтатьяОборотовБДР",
			//												"СуммаПлатежа,
			//												|СуммаВзаиморасчетов,
			//												|СуммаНДС,
			//												|РасходыУСН,
			//												|НДСУСН");
			//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-18 (#3816)
			
			Попытка			
				
				ДокументОбъект.ОбменДанными.Загрузка = Истина;
				
				ДокументОбъект.Записать();
				
				Отказ = Ложь;
				пТекстОшибок1 = "";
				пТекстОшибок2 = "";
				СценарийЗНРДС = ДокументОбъект.ПолучитьСценарийЗаявкиОснования();
				Если 
					(ЗначениеЗаполнено(СценарийЗНРДС) 
						И (СценарийЗНРДС = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("ок_ОперационныйСценарийПланирования") 
							ИЛИ СценарийЗНРДС = СБ_КазначействоПовтИсп.ПолучитьЗначениеКонстанты("ок_ИнвестиционныйСценарийПланирования"))
						ИЛИ ДокументОбъект.ок_ПоИсполнительнымЛистам)
					//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-18 (#3816)
					//И ПроверитьЗаполненностьПолейТЧНеобходимыхДляПроведенияПоБК(ДокументОбъект.РасшифровкаПлатежа,Отказ)
					И ПроверитьЗаполненностьПолейТЧНеобходимыхДляПроведенияПоБК(ДокументОбъект.бит_РаспределениеБюджета, Отказ)
					//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-18 (#3816)
				Тогда
				
					ДокументОбъект.ПроверитьСоответствиеСтатейБДРИБДДСТЧ(Отказ, Ложь, пТекстОшибок1);
					ДокументОбъект.ПроверитьСоответствиеСтатейОборотовДДСИСтатейДДС(Отказ, Ложь, пТекстОшибок2);
					
				КонецЕсли;
				
				Если (пТекстОшибок1 <> ""
						ИЛИ пТекстОшибок2 <> "") Тогда
					пТекстОшибки = НСтр("ru = 'Строка(%1): %2%3%4.'");
					пТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(пТекстОшибки, ТекущиеДанныеДляОбработки.НомерСтроки, пТекстОшибок1, ?(пТекстОшибок1 <> "", Символы.ПС, ""), пТекстОшибок2);
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = '" + пТекстОшибки + "'"));
				КонецЕсли;
				
				ДокументОбъект.Движения.бит_КонтрольныеЗначенияБюджетов.ОбменДанными.Загрузка 	= Истина;
				ДокументОбъект.Движения.бит_ОборотыПоБюджетам.ОбменДанными.Загрузка 			= Истина;
				ДокументОбъект.Движения.бит_СоответствиеЗаписейТрансляции.ОбменДанными.Загрузка = Истина;
				
				ПараметрыПроведения = Документы.СписаниеСРасчетногоСчета.ПодготовитьПараметрыПроведения(ДокументОбъект.Ссылка, Ложь);
				ДокументОбъект.ДвиженияПоРегистрамБК(ПараметрыПроведения);
				
				ДокументОбъект.Движения.бит_КонтрольныеЗначенияБюджетов.Записать();
				ДокументОбъект.Движения.бит_ОборотыПоБюджетам.Записать();
				ДокументОбъект.Движения.бит_СоответствиеЗаписейТрансляции.Записать();
				
			Исключение
				
				пТекстОшибки = НСтр("ru = 'Строка(%1): Документ %2 не обработан по причине:
											|%3'");
				пТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(пТекстОшибки, ТекущиеДанныеДляОбработки.НомерСтроки, ДокументОбъект.Ссылка, ОписаниеОшибки());
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = '" + пТекстОшибки + "'"));
				//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-02-20 (#3670)
				//ЗаписьЖурналаРегистрации(НСтр("ru = 'Рабочее место обработки документов СсРС'"), УровеньЖурналаРегистрации.Ошибка, Метаданные.Обработки.ок_РабочееМестоОбработкиДокументовСсРС, , пТекстОшибки);
				ЗаписьЖурналаРегистрации(НСтр("ru = 'РМ с безакцептным списанием ДС'"), УровеньЖурналаРегистрации.Ошибка, Метаданные.Обработки.ок_РМСБезакцептнымСписаниемДС, , пТекстОшибки);
				//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-02-20 (#3670)
				
				Если ТранзакцияАктивна() Тогда
					ОтменитьТранзакцию();
				КонецЕсли; 
				Продолжить;
				
			КонецПопытки;
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		ТекущиеДанныеДляОбработки.СтрокаИзменена = Ложь;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНастройкиКД(КомпоновщикНастроек)
	
	Возврат КомпоновщикНастроек.ПолучитьНастройки();
	
КонецФункции

&НаКлиенте
Процедура ДанныеДляОбработкиДокументРасчетовПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДанныеДляОбработки.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.ДокументРасчетов) Тогда
	
		ТекущиеДанные.ФВБ = ПолучитьФВБПоДокументуРасчетов(ТекущиеДанные.ДокументРасчетов);
	
	КонецЕсли; 
	
КонецПроцедуры

Функция ПолучитьФВБПоДокументуРасчетов(ДокументРасчетов)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	бит_ДополнительныеАналитики_NЗаявки.ЗначениеАналитики КАК ФВБ
		|ИЗ
		|	РегистрСведений.бит_ДополнительныеАналитики КАК бит_ДополнительныеАналитики_NЗаявки
		|ГДЕ
		|	бит_ДополнительныеАналитики_NЗаявки.Объект = &ДокументРасчетов
		|	И бит_ДополнительныеАналитики_NЗаявки.Аналитика.Код = ""NЗаявки""
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДополнительныеДанныеПоОперациямАксапты.НомерЗаявки
		|ИЗ
		|	РегистрСведений.бит_ДополнительныеДанныеПоОперациямАксапты КАК ДополнительныеДанныеПоОперациямАксапты
		|ГДЕ
		|	ДополнительныеДанныеПоОперациямАксапты.Документ = &ДокументРасчетов";
	
	Запрос.УстановитьПараметр("ДокументРасчетов", ДокументРасчетов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ФВБ) Тогда
			Возврат ВыборкаДетальныеЗаписи.ФВБ;
		КонецЕсли; 
		
	КонецЦикла;

	Возврат Неопределено;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПроверитьЗаполненностьПолейТЧНеобходимыхДляПроведенияПоБК(ТаблицаДанных,Отказ)

	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      //ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-18 (#3816)
						  //|	ТаблицаДанных.бит_СтатьяОборотов КАК бит_СтатьяОборотов,
						  //|	ТаблицаДанных.НомерСтроки КАК НомерСтроки,
						  //|	ТаблицаДанных.бит_Аналитика_1 КАК бит_Аналитика_1
						  |	ТаблицаДанных.СтатьяОборотов КАК бит_СтатьяОборотов,
	                      |	ТаблицаДанных.НомерСтроки КАК НомерСтроки,
	                      |	ТаблицаДанных.Аналитика_1 КАК бит_Аналитика_1
						  //ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-18 (#3816)
	                      |ПОМЕСТИТЬ ВТ_ТаблицаДанных
	                      |ИЗ
	                      |	&ТаблицаДанных КАК ТаблицаДанных
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	                      |	ТЧ_НезаполненныеЗначения.НомерСтроки КАК НомерСтроки,
	                      |	ВЫБОР
	                      |		КОГДА бит_ФормаВводаБюджета.Ссылка ЕСТЬ NULL
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК Аналитика1НеЗаполнена,
	                      |	ВЫБОР
	                      |		КОГДА ТЧ_НезаполненныеЗначения.бит_СтатьяОборотов = ЗНАЧЕНИЕ(Справочник.бит_СтатьиОборотов.ПустаяСсылка)
	                      |			ТОГДА ИСТИНА
	                      |		ИНАЧЕ ЛОЖЬ
	                      |	КОНЕЦ КАК СтатьяБДДСНеЗаполнена
	                      |ИЗ
	                      |	ВТ_ТаблицаДанных КАК ТЧ_НезаполненныеЗначения
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.бит_ФормаВводаБюджета КАК бит_ФормаВводаБюджета
	                      |		ПО ТЧ_НезаполненныеЗначения.бит_Аналитика_1 = бит_ФормаВводаБюджета.Ссылка
	                      |ГДЕ
	                      |	(бит_ФормаВводаБюджета.Ссылка ЕСТЬ NULL
	                      |			ИЛИ ТЧ_НезаполненныеЗначения.бит_СтатьяОборотов = ЗНАЧЕНИЕ(Справочник.бит_СтатьиОборотов.ПустаяСсылка))
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	НомерСтроки");
	
	Запрос.УстановитьПараметр("ТаблицаДанных", ТаблицаДанных);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru = 'В строке %1'");
		Если ВыборкаДетальныеЗаписи.Аналитика1НеЗаполнена И
			 ВыборкаДетальныеЗаписи.СтатьяБДДСНеЗаполнена
		Тогда 
			ДопТекстОшибки = НСтр("ru = 'не заполнены реквизиты № заявки и статья БДДС!'");
		ИначеЕсли ВыборкаДетальныеЗаписи.Аналитика1НеЗаполнена Тогда 
			ДопТекстОшибки = НСтр("ru = 'не заполнен реквизит № заявки!'");
		ИначеЕсли ВыборкаДетальныеЗаписи.СтатьяБДДСНеЗаполнена Тогда 
			ДопТекстОшибки = НСтр("ru = 'не заполнен реквизит статья БДДС!'");
		КонецЕсли;
		
		ДопТекстОшибки = "" + ВыборкаДетальныеЗаписи.НомерСтроки + " " + ДопТекстОшибки;
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДопТекстОшибки);
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
		Отказ = Истина;
		
	КонецЦикла;
	
	Возврат Не Отказ;
	
КонецФункции

#КонецОбласти


